package vexriscv.ip.fpu

import java.io.File
import java.lang
import java.util.Scanner

import org.apache.commons.io.FileUtils
import org.scalatest.FunSuite
import spinal.core.SpinalEnumElement
import spinal.core.sim._
import spinal.core._
import spinal.lib.DoCmd
import spinal.lib.experimental.math.Floating
import spinal.lib.sim._
import spinal.sim.Backend.{isMac, isWindows}

import scala.collection.mutable
import scala.collection.mutable.ArrayBuffer
import scala.sys.process.ProcessLogger
import scala.util.Random


class FpuTest extends FunSuite{

  val b2f = lang.Float.intBitsToFloat(_)
  val f2b = lang.Float.floatToRawIntBits(_)


  test("f32f64") {
    val p = FpuParameter(
      withDouble = true,
//      withAdd = false,
//      withMul = false,
//      withDivSqrt = false,
      sim = true
    )
    testP(p)
  }
  test("f32") {
    val p = FpuParameter(
      withDouble = false,
      sim = true
    )
    testP(p)
  }

  def testP(p : FpuParameter){
    val portCount = 1

    val config = SimConfig
    config.allOptimisation
    if(p.withDouble) config.withFstWave
    config.compile(new FpuCore(portCount, p){
      for(i <- 0 until portCount) out(Bits(5 bits)).setName(s"flagAcc$i") := io.port(i).completion.flag.asBits
      setDefinitionName("FpuCore"+ (if(p.withDouble) "Double" else  ""))
    }).doSim(seed = 42){ dut =>
      dut.clockDomain.forkStimulus(10)
      dut.clockDomain.forkSimSpeedPrinter(5.0)



      class TestCase(op : String){
        def build(arg : String) = new ProcessStream(s"testfloat_gen $arg -tininessafter -forever -$op"){
          def f32_f32_f32 ={
            val s = new Scanner(next)
            val a,b,c = (s.nextLong(16).toInt)
//            if(b2f(a).isNaN ||  b2f(b).isNaN){
//              print("NAN => ")
//              if(((a >> 23) & 0xFF) == 0xFF && ((a >> 0) & 0xEFFFFF) != 0){
//                print(a.toHexString)
//                print(" " + f2b(b2f(a)).toHexString)
//              }
//              if(((b >> 23) & 0xFF) == 0xFF && ((b >> 0) & 0xEFFFFF) != 0){
//                print(b.toHexString)
//                print(" " + f2b(b2f(b)).toHexString)
//              }
//              if(((c >> 23) & 0xFF) == 0xFF && ((c >> 0) & 0xEFFFFF) != 0){
//                print(" " + c.toHexString)
//                print(" " + f2b(b2f(c)).toHexString)
//              }
//
//              print(" " + simTime())
//              println("")
//            }
            (b2f(a), b2f(b), b2f(c), s.nextInt(16))
          }

          def i32_f32 ={
            val s = new Scanner(next)
            (s.nextLong(16).toInt, b2f(s.nextLong(16).toInt), s.nextInt(16))
          }

          def f32_i32 = {
            val s = new Scanner(next)
            (b2f(s.nextLong(16).toInt), s.nextLong(16).toInt, s.nextInt(16))
          }

          def f32_f32_i32 = {
            val s = new Scanner(next)
            val a,b,c = (s.nextLong(16).toInt)
            (b2f(a), b2f(b), c, s.nextInt(16))
          }

          def f32_f32 = {
            val s = new Scanner(next)
            val a,b = (s.nextLong(16).toInt)
            (b2f(a), b2f(b), s.nextInt(16))
        }

        }
        lazy val RAW = build("")
        lazy val RNE = build("-rnear_even")
        lazy val RTZ = build("-rminMag")
        lazy val RDN = build("-rmin")
        lazy val RUP = build("-rmax")
        lazy val RMM = build("-rnear_maxMag")
        lazy val all = List(RNE, RTZ, RDN, RUP, RMM, RAW)
        def kill = all.foreach(_.kill)
        def apply(rounding : FpuRoundMode.E) = rounding match {
          case FpuRoundMode.RNE => RNE
          case FpuRoundMode.RTZ => RTZ
          case FpuRoundMode.RDN => RDN
          case FpuRoundMode.RUP => RUP
          case FpuRoundMode.RMM => RMM
        }
      }

      val f32 = new {
        val add = new TestCase("f32_add")
        val sub = new TestCase("f32_sub")
        val mul = new TestCase("f32_mul")
        val ui2f = new TestCase("ui32_to_f32")
        val i2f = new TestCase("i32_to_f32")
        val f2ui = new TestCase("f32_to_ui32 -exact")
        val f2i = new TestCase("f32_to_i32 -exact")
        val eq = new TestCase("f32_eq")
        val lt = new TestCase("f32_lt")
        val le = new TestCase("f32_le")
        val min = new TestCase("f32_le")
        val max = new TestCase("f32_lt")
        val transfer = new TestCase("f32_eq")
        val fclass = new TestCase("f32_eq")
        val sgnj = new TestCase("f32_eq")
        val sgnjn = new TestCase("f32_eq")
        val sgnjx = new TestCase("f32_eq")
        val sqrt = new TestCase("f32_sqrt")
        val div = new TestCase("f32_div")
      }

      val cpus = for(id <- 0 until portCount) yield new {
        val cmdQueue = mutable.Queue[FpuCmd => Unit]()
        val commitQueue = mutable.Queue[FpuCommit => Unit]()
        val rspQueue = mutable.Queue[FpuRsp => Unit]()

        var pendingMiaou = 0
        var flagAccumulator = 0

        def cmdAdd(body : FpuCmd => Unit): Unit ={
          pendingMiaou += 1
          cmdQueue += body
        }

        def softAssert(cond : Boolean, msg : String) = if(!cond)println(msg)
        def flagMatch(ref : Int, value : Float, report : String): Unit ={
          val patch = if(value.abs == 1.17549435E-38f) ref & ~2 else ref
          flagMatch(patch, report)
        }
        def flagMatch(ref : Int, report : String): Unit ={
          waitUntil(pendingMiaou == 0)
          assert(flagAccumulator == ref, s"Flag missmatch dut=$flagAccumulator ref=$ref $report")
          flagAccumulator = 0
        }
        def flagClear(): Unit ={
          waitUntil(pendingMiaou == 0)
          flagAccumulator = 0
        }

        val flagAggregated = dut.reflectBaseType(s"flagAcc$id").asInstanceOf[Bits]
        dut.clockDomain.onSamplings{
          val c = dut.io.port(id).completion
          pendingMiaou -= c.count.toInt
          flagAccumulator |= flagAggregated.toInt
          dut.writeback.randomSim.randomize()
        }

        StreamDriver(dut.io.port(id).cmd ,dut.clockDomain){payload =>
          if(cmdQueue.isEmpty) false else {
            cmdQueue.dequeue().apply(payload)
            true
          }
        }


        StreamMonitor(dut.io.port(id)rsp, dut.clockDomain){payload =>
          rspQueue.dequeue().apply(payload)
        }

        StreamReadyRandomizer(dut.io.port(id).rsp, dut.clockDomain)


        StreamDriver(dut.io.port(id).commit ,dut.clockDomain){payload =>
          if(commitQueue.isEmpty) false else {
            commitQueue.dequeue().apply(payload)
            true
          }
        }




        def loadRaw(rd : Int, value : BigInt, format : FpuFormat.E): Unit ={
          cmdAdd {cmd =>
            cmd.opcode #= cmd.opcode.spinalEnum.LOAD
            cmd.rs1.randomize()
            cmd.rs2.randomize()
            cmd.rs3.randomize()
            cmd.rd #= rd
            cmd.arg.randomize()
            cmd.roundMode.randomize()
            cmd.format #= format
          }
          commitQueue += {cmd =>
            cmd.write #= true
            cmd.value #= value
            cmd.sync #= true
          }
        }


        def load(rd : Int, value : Float): Unit ={
          loadRaw(rd, f2b(value).toLong & 0xFFFFFFFFl, FpuFormat.FLOAT)
        }

        def storeRaw(rs : Int, format : FpuFormat.E)(body : FpuRsp => Unit): Unit ={
          cmdAdd {cmd =>
            cmd.opcode #= cmd.opcode.spinalEnum.STORE
            cmd.rs1 #= rs
            cmd.rs2.randomize()
            cmd.rs3.randomize()
            cmd.rd.randomize()
            cmd.arg.randomize()
            cmd.roundMode.randomize()
            cmd.format #= format
          }

          rspQueue += body
//          waitUntil(rspQueue.isEmpty)
        }

        def storeFloat(rs : Int)(body : Float => Unit): Unit ={
          storeRaw(rs, FpuFormat.FLOAT){rsp => body(b2f(rsp.value.toBigInt.toInt))}
        }

        def fpuF2f(rd : Int, rs1 : Int, rs2 : Int, rs3 : Int, opcode : FpuOpcode.E, arg : Int, rounding : FpuRoundMode.E = FpuRoundMode.RNE): Unit ={
          cmdAdd {cmd =>
            cmd.opcode #= opcode
            cmd.rs1 #= rs1
            cmd.rs2 #= rs2
            cmd.rs3 #= rs3
            cmd.rd #= rd
            cmd.arg #= arg
            cmd.roundMode #= rounding
          }
          commitQueue += {cmd =>
            cmd.write #= true
            cmd.sync #= false
          }
        }

        def fpuF2i(rs1 : Int, rs2 : Int, opcode : FpuOpcode.E, arg : Int, rounding : FpuRoundMode.E = FpuRoundMode.RNE)(body : FpuRsp => Unit): Unit ={
          cmdAdd {cmd =>
            cmd.opcode #= opcode
            cmd.rs1 #= rs1
            cmd.rs2 #= rs2
            cmd.rs3.randomize()
            cmd.rd.randomize()
            cmd.arg #= arg
            cmd.roundMode #= rounding
          }
          rspQueue += body
        }


        def mul(rd : Int, rs1 : Int, rs2 : Int, rounding : FpuRoundMode.E = FpuRoundMode.RNE): Unit ={
          fpuF2f(rd, rs1, rs2, Random.nextInt(32), FpuOpcode.MUL, 0, rounding)
        }

        def add(rd : Int, rs1 : Int, rs2 : Int, rounding : FpuRoundMode.E = FpuRoundMode.RNE): Unit ={
          fpuF2f(rd, rs1, rs2, Random.nextInt(32), FpuOpcode.ADD, 0, rounding)
        }

        def sub(rd : Int, rs1 : Int, rs2 : Int, rounding : FpuRoundMode.E = FpuRoundMode.RNE): Unit ={
          fpuF2f(rd, rs1, rs2, Random.nextInt(32), FpuOpcode.ADD, 1, rounding)
        }

        def div(rd : Int, rs1 : Int, rs2 : Int, rounding : FpuRoundMode.E = FpuRoundMode.RNE): Unit ={
          fpuF2f(rd, rs1, rs2, Random.nextInt(32), FpuOpcode.DIV, Random.nextInt(4), rounding)
        }

        def sqrt(rd : Int, rs1 : Int, rounding : FpuRoundMode.E = FpuRoundMode.RNE): Unit ={
          fpuF2f(rd, rs1, Random.nextInt(32), Random.nextInt(32), FpuOpcode.SQRT, Random.nextInt(4), rounding)
        }

        def fma(rd : Int, rs1 : Int, rs2 : Int, rs3 : Int, rounding : FpuRoundMode.E = FpuRoundMode.RNE): Unit ={
          fpuF2f(rd, rs1, rs2, rs3, FpuOpcode.FMA, 0, rounding)
        }

        def sgnjRaw(rd : Int, rs1 : Int, rs2 : Int, arg : Int): Unit ={
          fpuF2f(rd, rs1, rs2, Random.nextInt(32), FpuOpcode.SGNJ, arg, FpuRoundMode.elements.randomPick())
        }

        def sgnj(rd : Int, rs1 : Int, rs2 : Int, rounding : FpuRoundMode.E = null): Unit ={
          sgnjRaw(rd, rs1, rs2, 0)
        }
        def sgnjn(rd : Int, rs1 : Int, rs2 : Int, rounding : FpuRoundMode.E = null): Unit ={
          sgnjRaw(rd, rs1, rs2, 1)
        }
        def sgnjx(rd : Int, rs1 : Int, rs2 : Int, rounding : FpuRoundMode.E = null): Unit ={
          sgnjRaw(rd, rs1, rs2, 2)
        }

        def cmp(rs1 : Int, rs2 : Int, arg : Int = 1)(body : FpuRsp => Unit): Unit ={
          fpuF2i(rs1, rs2, FpuOpcode.CMP, arg, FpuRoundMode.elements.randomPick())(body)
        }

        def f2i(rs1 : Int, signed : Boolean, rounding : FpuRoundMode.E = FpuRoundMode.RNE)(body : FpuRsp => Unit): Unit ={
          fpuF2i(rs1, Random.nextInt(32), FpuOpcode.F2I, if(signed) 1 else 0, rounding)(body)
        }

        def i2f(rd : Int, value : Int, signed : Boolean, rounding : FpuRoundMode.E): Unit ={
          cmdAdd {cmd =>
            cmd.opcode #= cmd.opcode.spinalEnum.I2F
            cmd.rs1.randomize()
            cmd.rs2.randomize()
            cmd.rs3.randomize()
            cmd.rd #= rd
            cmd.arg #= (if(signed) 1 else 0)
            cmd.roundMode #= rounding
          }
          commitQueue += {cmd =>
            cmd.write #= true
            cmd.sync #= true
            cmd.value #= value.toLong & 0xFFFFFFFFl
          }
        }

        def fmv_x_w(rs1 : Int)(body : Float => Unit): Unit ={
          cmdAdd {cmd =>
            cmd.opcode #= cmd.opcode.spinalEnum.FMV_X_W
            cmd.rs1 #= rs1
            cmd.rs2.randomize()
            cmd.rs3.randomize()
            cmd.rd.randomize()
            cmd.arg #= 0
            cmd.roundMode.randomize()
            cmd.format #= FpuFormat.FLOAT
          }
          rspQueue += {rsp => body(b2f(rsp.value.toBigInt.toInt))}
        }

        def fmv_w_x(rd : Int, value : Int): Unit ={
          cmdAdd {cmd =>
            cmd.opcode #= cmd.opcode.spinalEnum.FMV_W_X
            cmd.rs1.randomize()
            cmd.rs2.randomize()
            cmd.rs3.randomize()
            cmd.rd #= rd
            cmd.arg #= 0
            cmd.roundMode.randomize()
            cmd.format #= FpuFormat.FLOAT
          }
          commitQueue += {cmd =>
            cmd.write #= true
            cmd.sync #= true
            cmd.value #= value.toLong & 0xFFFFFFFFl
          }
        }

        def minMax(rd : Int, rs1 : Int, rs2 : Int, arg : Int = 0): Unit ={
          cmdAdd {cmd =>
            cmd.opcode #= cmd.opcode.spinalEnum.MIN_MAX
            cmd.rs1 #= rs1
            cmd.rs2 #= rs2
            cmd.rs3.randomize()
            cmd.rd #= rd
            cmd.arg #= arg
          }
          commitQueue += {cmd =>
            cmd.write #= true
            cmd.sync #= false
          }
        }



        def fclass(rs1 : Int)(body : Int => Unit) : Unit = {
          cmdAdd {cmd =>
            cmd.opcode #= FpuOpcode.FCLASS
            cmd.rs1 #= rs1
            cmd.rs2.randomize()
            cmd.rs3.randomize()
            cmd.rd.randomize()
            cmd.arg.randomize()
          }
          rspQueue += {rsp => body(rsp.value.toLong.toInt)}
        }
      }





      val stim = for(cpu <- cpus) yield fork {
        import cpu._

        class RegAllocator(){
          var value = 0

          def allocate(): Int ={
            while(true){
              val rand = Random.nextInt(32)
              val mask = 1 << rand
              if((value & mask) == 0) {
                value |= mask
                return rand
              }
            }
            0
          }
        }
        def checkFloat(ref : Float, dut : Float): Boolean ={
          if((f2b(ref) & 0x80000000) != (f2b(dut) & 0x80000000)) return  false
          if(ref == 0.0 && dut == 0.0 && f2b(ref) != f2b(dut)) return false
          if(ref.isNaN && dut.isNaN) return true
          if(ref == dut) return true
          if(ref.abs * 1.0001f + Float.MinPositiveValue >= dut.abs*0.9999f && ref.abs * 0.9999f - Float.MinPositiveValue  <= dut.abs*1.0001f) return true
//          if(ref + Float.MinPositiveValue*2.0f  === dut || dut + Float.MinPositiveValue*2.0f  === ref)
          false
        }
        def checkFloatExact(ref : Float, dut : Float): Boolean ={
          if(ref.signum != dut.signum === dut) return  false
          if(ref.isNaN && dut.isNaN) return true
          if(ref == dut) return true
          false
        }


        def randomFloat(): Float ={
          val exp = Random.nextInt(10)-5
          (Random.nextDouble() * (Math.pow(2.0, exp)) * (if(Random.nextBoolean()) -1.0 else 1.0)).toFloat
        }


        def testBinaryOp(op : (Int,Int,Int,FpuRoundMode.E) => Unit, a : Float, b : Float, ref : Float, flag : Int, rounding : FpuRoundMode.E, opName : String): Unit ={
          val rs = new RegAllocator()
          val rs1, rs2, rs3 = rs.allocate()
          val rd = Random.nextInt(32)
          load(rs1, a)
          load(rs2, b)
          op(rd,rs1,rs2, rounding)
          storeFloat(rd){v =>
            assert(f2b(v) == f2b(ref), f"## ${a}  ${opName}  $b = $v, $ref $rounding")
          }

          flagMatch(flag, ref, f"## ${opName} ${a} $b $ref $rounding")
        }



        def testTransferRaw(a : Float, iSrc : Boolean, iDst : Boolean): Unit ={
          val rd = Random.nextInt(32)

          def handle(v : Float): Unit ={
            val refUnclamped = a
            val ref = a
            assert(f2b(v) == f2b(ref), f"$a = $v, $ref")
          }

          if(iSrc) fmv_w_x(rd, f2b(a)) else load(rd, a)
          if(iDst) fmv_x_w(rd)(handle) else storeFloat(rd)(handle)

          flagMatch(0, f"$a")
        }

        def testClassRaw(a : Float) : Unit = {
          val rd = Random.nextInt(32)


          load(rd, a)
          fclass(rd){v =>
            val mantissa = f2b(a) & 0x7FFFFF
            val exp = (f2b(a) >> 23) & 0xFF
            val sign = (f2b(a) >> 31) & 0x1

            val refBit = if(a.isInfinite) (if(sign == 0) 7 else 0)
            else if(a.isNaN) (if((mantissa >> 22) != 0) 9 else 8)
            else if(exp == 0 && mantissa != 0) (if(sign == 0) 5 else 2)
            else if(exp == 0 && mantissa == 0) (if(sign == 0) 4 else 3)
            else if(sign == 0) 6 else 1

            val ref = 1 << refBit

            assert(v == ref, f"fclass $a")
          }
        }


        def testFmaRaw(a : Float, b : Float, c : Float): Unit ={
          val rs = new RegAllocator()
          val rs1, rs2, rs3 = rs.allocate()
          val rd = Random.nextInt(32)
          load(rs1, a)
          load(rs2, b)
          load(rs3, c)

          fma(rd,rs1,rs2,rs3)
          storeFloat(rd){v =>
            val ref = a.toDouble * b.toDouble + c.toDouble
            println(f"$a%.20f * $b%.20f + $c%.20f = $v%.20f, $ref%.20f")
            val mul = a.toDouble * b.toDouble
            if((mul.abs-c.abs)/mul.abs > 0.1)  assert(checkFloat(ref.toFloat, v))
          }
        }


        def testDivRaw(a : Float, b : Float): Unit ={
          val rs = new RegAllocator()
          val rs1, rs2, rs3 = rs.allocate()
          val rd = Random.nextInt(32)
          load(rs1, a)
          load(rs2, b)

          div(rd,rs1,rs2)
          storeFloat(rd){v =>
            val refUnclamped = a/b
            val refClamped = ((a)/(b))
            val ref = refClamped
            val error = Math.abs(ref-v)/ref
            println(f"$a / $b = $v, $ref $error")
            assert(checkFloat(ref, v))
          }
        }

        def testSqrtRaw(a : Float): Unit ={
          val rs = new RegAllocator()
          val rs1, rs2, rs3 = rs.allocate()
          val rd = Random.nextInt(32)
          load(rs1, a)

          sqrt(rd,rs1)
          storeFloat(rd){v =>
            val ref = Math.sqrt(a).toFloat
            val error = Math.abs(ref-v)/ref
            println(f"sqrt($a) = $v, $ref $error")
            assert(checkFloat(ref, v))
          }
        }



        def testSqrtExact(a : Float, ref : Float, flag : Int, rounding : FpuRoundMode.E): Unit ={
          val rs = new RegAllocator()
          val rs1, rs2, rs3 = rs.allocate()
          val rd = Random.nextInt(32)
          load(rs1, a)

          sqrt(rd,rs1)
          storeFloat(rd){v =>
            val error = Math.abs(ref-v)/ref
            println(f"sqrt($a) = $v, $ref $error $rounding")
            assert(checkFloat(ref, v))
          }
        }

        def testDivExact(a : Float, b : Float, ref : Float, flag : Int, rounding : FpuRoundMode.E): Unit ={
          val rs = new RegAllocator()
          val rs1, rs2, rs3 = rs.allocate()
          val rd = Random.nextInt(32)
          load(rs1, a)
          load(rs2, b)

          div(rd,rs1, rs2)
          storeFloat(rd){v =>
            val error = Math.abs(ref-v)/ref
            println(f"div($a, $b) = $v, $ref $error $rounding")
            assert(checkFloat(ref, v))
          }
        }



        def testF2iExact(a : Float, ref : Int, flag : Int, signed : Boolean, rounding : FpuRoundMode.E): Unit ={
          val rs = new RegAllocator()
          val rs1 = rs.allocate()
          val rd = Random.nextInt(32)
          load(rs1, a)
          f2i(rs1, signed, rounding){rsp =>
            if(signed) {
              val v = rsp.value.toLong.toInt
              var ref2 = ref
              if(a >= Int.MaxValue) ref2 = Int.MaxValue
              if(a <= Int.MinValue) ref2 = Int.MinValue
              if(a.isNaN) ref2 = Int.MaxValue
              assert(v == (ref2), f" <= f2i($a) = $v, $ref2, $rounding, $flag")
            } else {
              val v = rsp.value.toLong
              var ref2 = ref.toLong & 0xFFFFFFFFl
              if(a < 0) ref2 = 0
              if(a >= 0xFFFFFFFFl) ref2 = 0xFFFFFFFFl
              if(a.isNaN) ref2 = 0xFFFFFFFFl
              assert(v == ref2, f" <= f2ui($a) = $v, $ref2, $rounding $flag")
            }
          }

          flagMatch(flag, ref, f" f2${if(signed) "" else "u"}i($a) $ref $flag $rounding")
        }




        def testI2fExact(a : Int, b : Float, f : Int, signed : Boolean, rounding : FpuRoundMode.E): Unit ={
          val rs = new RegAllocator()
          val rd = Random.nextInt(32)
          i2f(rd, a, signed, rounding)
          storeFloat(rd){v =>
            val aLong = if(signed) a.toLong else a.toLong & 0xFFFFFFFFl
            val ref = b
            assert(f2b(v) == f2b(ref), f"i2f($aLong) = $v, $ref")
          }


          flagMatch(f, b, f"i2f() = $b")
        }



        def testCmpExact(a : Float, b : Float, ref : Int, flag : Int, arg : Int): Unit ={
          val rs = new RegAllocator()
          val rs1, rs2, rs3 = rs.allocate()
          val rd = Random.nextInt(32)
          load(rs1, a)
          load(rs2, b)
          cmp(rs1, rs2, arg){rsp =>
            val v = rsp.value.toLong
            assert(v === ref, f"cmp($a, $b, $arg) = $v, $ref")
          }
          flagMatch(flag,f"$a < $b $ref $flag ${f2b(a).toHexString} ${f2b(b).toHexString}")
        }
        def testLeRaw(a : Float, b : Float, ref : Int, flag : Int) = testCmpExact(a,b,ref,flag, 0)
        def testEqRaw(a : Float, b : Float, ref : Int, flag : Int) = testCmpExact(a,b,ref,flag, 2)
        def testLtRaw(a : Float, b : Float, ref : Int, flag : Int) = testCmpExact(a,b,ref,flag, 1)

//        def testFmv_x_w(a : Float): Unit ={
//          val rs = new RegAllocator()
//          val rs1, rs2, rs3 = rs.allocate()
//          val rd = Random.nextInt(32)
//          load(rs1, a)tes
//          fmv_x_w(rs1){rsp =>
//            val ref = f2b(a).toLong & 0xFFFFFFFFl
//            val v = rsp.value.toBigInt
//            println(f"fmv_x_w $a = $v, $ref")
//            assert(v === ref)
//          }
//        }

//        def testFmv_w_x(a : Int): Unit ={
//          val rs = new RegAllocator()
//          val rs1, rs2, rs3 = rs.allocate()
//          val rd = Random.nextInt(32)
//          fmv_w_x(rd, a)
//          storeFloat(rd){v =>
//            val ref = b2f(a)
//            println(f"fmv_w_x $a = $v, $ref")
//            assert(v === ref)
//          }
//        }



        def testMinMaxExact(a : Float, b : Float, arg : Int): Unit ={
          val rs = new RegAllocator()
          val rs1, rs2 = rs.allocate()
          val rd = Random.nextInt(32)
          val ref = (a,b) match {
            case _ if a.isNaN && b.isNaN => b2f(0x7FC00000)
            case _ if a.isNaN => b
            case _ if b.isNaN => a
            case _ => if(arg == 0) Math.min(a,b) else Math.max(a,b)
          }
          val flag = (a,b) match {
            case _ if a.isNaN && ((f2b(a) >> 22 ) & 1) == 0 => 16
            case _ if b.isNaN && ((f2b(b) >> 22 ) & 1) == 0 => 16
            case _ => 0
          }
          load(rs1, a)
          load(rs2, b)

          minMax(rd,rs1,rs2, arg)
          storeFloat(rd){v =>
            assert(f2b(ref) ==  f2b(v), f"minMax($a $b $arg) = $v, $ref")
          }
          flagMatch(flag, f"minmax($a $b $arg)")
        }

        def testMinExact(a : Float, b : Float) : Unit = testMinMaxExact(a,b,0)
        def testMaxExact(a : Float, b : Float) : Unit = testMinMaxExact(a,b,1)


        def testSgnjRaw(a : Float, b : Float): Unit ={
          val ref = b2f((f2b(a) & ~0x80000000) | f2b(b) & 0x80000000)
          testBinaryOp(sgnj,a,b,ref,0, null,"sgnj")
        }
        def testSgnjnRaw(a : Float, b : Float): Unit ={
          val ref = b2f((f2b(a) & ~0x80000000) | ((f2b(b) & 0x80000000) ^ 0x80000000))
          testBinaryOp(sgnjn,a,b,ref,0, null,"sgnjn")
        }
        def testSgnjxRaw(a : Float, b : Float): Unit ={
          val ref = b2f(f2b(a) ^ (f2b(b) & 0x80000000))
          testBinaryOp(sgnjx,a,b,ref,0, null,"sgnjx")
        }


        def withMinus(that : Seq[Float]) = that.flatMap(f => List(f, -f))
        val fZeros = withMinus(List(0.0f))
        val fSubnormals = withMinus(List(b2f(0x00000000+1), b2f(0x00000000+2), b2f(0x00006800), b2f(0x00800000-2), b2f(0x00800000-1)))
        val fExpSmall = withMinus(List(b2f(0x00800000), b2f(0x00800000+1), b2f(0x00800000 + 2)))
        val fExpNormal = withMinus(List(b2f(0x3f800000-2), b2f(0x3f800000-1), b2f(0x3f800000), b2f(0x3f800000+1), b2f(0x3f800000+2)))
        val fExpBig = withMinus(List(b2f(0x7f7fffff-2), b2f(0x7f7fffff-1), b2f(0x7f7fffff)))
        val fInfinity = withMinus(List(Float.PositiveInfinity))
        val fNan = List(Float.NaN, b2f(0x7f820000), b2f(0x7fc00000))
        val fAll = fZeros ++ fSubnormals ++ fExpSmall ++ fExpNormal ++ fExpBig ++ fInfinity ++ fNan

        val iSmall = (0 to 20)
        val iBigUnsigned = (0 to 20).map(e => 0xFFFFFFFF - e)
        val iBigSigned = (0 to 20).map(e => 0x7FFFFFFF - e) ++ (0 to 20).map(e => 0x80000000 + e)
        val iUnsigned = iSmall ++ iBigUnsigned
        val iSigned = iSmall ++ iSmall.map(-_) ++ iBigSigned


        val roundingModes = FpuRoundMode.elements
        def foreachRounding(body : FpuRoundMode.E => Unit): Unit ={
          for(rounding <- roundingModes){
            body(rounding)
          }
        }



//        for(i <- 0 until 64){
//          val rounding = FpuRoundMode.RMM
//          val a = 24f
//          val b = b2f(0x3f800000+i)
//          val c = Clib.math.mulF32(a, b, rounding.position)
//          val f = 0
//          testMulExact(a,b,c,f, rounding)
//        }

        val binaryOps = List[(Int,Int,Int,FpuRoundMode.E) => Unit](add, sub, mul)

//        testSqrt(0.0f)
        //        testSqrt(1.2f)
        //        for(a <- fAll) testSqrt(a)
//        for(_ <- 0 until 1000) testSqrt(randomFloat())






        def testFma() : Unit = {
          testFmaRaw(randomFloat(), randomFloat(), randomFloat())
          flagClear()
        }

        def testLe() : Unit = {
          val (a,b,i,f) = f32.le.RAW.f32_f32_i32
          testLeRaw(a,b,i, f)
        }
        def testLt() : Unit = {
          val (a,b,i,f) = f32.lt.RAW.f32_f32_i32
          testLtRaw(a,b,i, f)
        }

        def testEq() : Unit = {
          val (a,b,i,f) = f32.eq.RAW.f32_f32_i32
          testEqRaw(a,b,i, f)
        }

        def testF2ui() : Unit = {
          val rounding = FpuRoundMode.elements.randomPick()
          val (a,b,f) = f32.f2ui(rounding).f32_i32
          testF2iExact(a,b, f, false, rounding)
        }

        def testF2i() : Unit = {
          val rounding = FpuRoundMode.elements.randomPick()
          val (a,b,f) = f32.f2i(rounding).f32_i32
          testF2iExact(a,b, f, true, rounding)
        }


        def testDiv() : Unit = {
          val rounding = FpuRoundMode.elements.randomPick()
          val (a,b,r,f) = f32.div(rounding).f32_f32_f32
          testDivExact(a, b, r, f, rounding)
          flagClear()
        }

        def testSqrt() : Unit = {
          val rounding = FpuRoundMode.elements.randomPick()
          val (a,r,f) = f32.sqrt(rounding).f32_f32
          testSqrtExact(a, r, f, rounding)
          flagClear()
        }

        def testSgnj() : Unit = {
          testSgnjRaw(b2f(Random.nextInt()), b2f(Random.nextInt()))
          testSgnjnRaw(b2f(Random.nextInt()), b2f(Random.nextInt()))
          testSgnjxRaw(b2f(Random.nextInt()), b2f(Random.nextInt()))
          val (a,b,r,f) = f32.sgnj.RAW.f32_f32_i32
          testSgnjRaw(a, b)
          testSgnjnRaw(a, b)
          testSgnjxRaw(a, b)
        }

        def testTransfer() : Unit = {
          val (a,b,r,f) = f32.transfer.RAW.f32_f32_i32
          testTransferRaw(a, Random.nextBoolean(), Random.nextBoolean())
        }

        def testClass() : Unit = {
          val (a,b,r,f) = f32.fclass.RAW.f32_f32_i32
          testClassRaw(a)
        }

        def testMin() : Unit = {
          val (a,b,r,f) = f32.min.RAW.f32_f32_f32
          testMinExact(a,b)
        }
        def testMax() : Unit = {
          val (a,b,r,f) = f32.max.RAW.f32_f32_f32
          testMaxExact(a,b)
        }

        def testUI2f() : Unit = {
          val rounding = FpuRoundMode.elements.randomPick()
          val (a,b,f) = f32.i2f(rounding).i32_f32
          testI2fExact(a,b,f, true, rounding)
        }

        def testI2f() : Unit = {
          val rounding = FpuRoundMode.elements.randomPick()
          val (a,b,f) = f32.ui2f(rounding).i32_f32
          testI2fExact(a,b,f, false, rounding)
        }

        def testMul() : Unit = {
          val rounding = FpuRoundMode.elements.randomPick()
          val (a,b,c,f) = f32.mul(rounding).f32_f32_f32
          testBinaryOp(mul,a,b,c,f, rounding,"mul")
        }

        def testAdd() : Unit = {
          val rounding = FpuRoundMode.elements.randomPick()
          val (a,b,c,f) = f32.add(rounding).f32_f32_f32
          testBinaryOp(add,a,b,c,f, rounding,"add")
        }

        def testSub() : Unit = {
          val rounding = FpuRoundMode.elements.randomPick()
          val (a,b,c,f) = f32.sub(rounding).f32_f32_f32
          testBinaryOp(sub,a,b,c,f, rounding,"sub")
        }


        val f32Tests = List[() => Unit](testSub, testAdd, testMul, testI2f, testUI2f, testMin, testMax, testSgnj, testTransfer, testDiv, testSqrt, testF2i, testF2ui, testLe, testEq, testLt, testClass, testFma)





        testTransferRaw(1.0f, false, false)
        testTransferRaw(2.0f, false, false)
        testTransferRaw(2.5f, false, false)
        testTransferRaw(6.97949770801e-39f, false, false)
        testTransferRaw(8.72437213501e-40f, false, false)
        testTransferRaw(5.6E-45f, false, false)





        for(_ <- 0 until 10000) testTransfer()
        println("f32 load/store/rf transfer done")

        for(_ <- 0 until 10000) testF2ui()
        for(_ <- 0 until 10000) testF2i()
        println("f2i done")

        for(_ <- 0 until 10000) testUI2f()
        for(_ <- 0 until 10000) testI2f()
        println("i2f done")


//        waitUntil(cmdQueue.isEmpty)
//        dut.clockDomain.waitSampling(1000)
//        simSuccess()


        for(i <- 0 until 1000) testFma()
        flagClear()
        println("fma done") //TODO


        testF2iExact(-2.14748365E9f, -2147483648, 0, true, FpuRoundMode.RDN)

        testEqRaw(Float.PositiveInfinity,Float.PositiveInfinity,1, 0)
        testEqRaw(0f, 0f,1, 0)

        for(_ <- 0 until 10000) testLe()
        for(_ <- 0 until 10000) testLt()
        for(_ <- 0 until 10000) testEq()
        println("Cmp done")


        for(_ <- 0 until 10000) testDiv()
        println("f32 div done")

        for(_ <- 0 until 10000) testSqrt()
        println("f32 sqrt done")

        for(_ <- 0 until 10000) testSgnj()
        println("f32 sgnj done")


        for(_ <- 0 until 10000) testClass()
        println("f32 class done")


        for(_ <- 0 until 10000) testMin()
        for(_ <- 0 until 10000) testMax()
        println("minMax done")



        testBinaryOp(mul,1.469368E-39f, 7.9999995f, 1.17549435E-38f,3, FpuRoundMode.RUP,"mul")
        testBinaryOp(mul,1.1753509E-38f, 1.0001221f, 1.17549435E-38f ,1, FpuRoundMode.RUP,"mul")
        testBinaryOp(mul, 1.1754942E-38f, -1.0000001f, -1.17549435E-38f,1, FpuRoundMode.RNE,"mul")
        testBinaryOp(mul, 1.1754942E-38f, -1.0000001f, -1.17549435E-38f,1, FpuRoundMode.RDN,"mul")
        testBinaryOp(mul, 1.1754942E-38f, -1.0000001f, -1.17549435E-38f,1, FpuRoundMode.RMM,"mul")

        testBinaryOp(mul, 1.1754945E-38f, 0.9999998f, 1.17549435E-38f, 3, FpuRoundMode.RUP, "mul")
        testBinaryOp(mul, 1.1754945E-38f, -0.9999998f, -1.17549435E-38f, 3, FpuRoundMode.RDN, "mul")
        testBinaryOp(mul, 1.1754946E-38f, 0.9999997f, 1.17549435E-38f, 3, FpuRoundMode.RUP, "mul")
        testBinaryOp(mul, 1.1754946E-38f, -0.9999997f, -1.17549435E-38f, 3, FpuRoundMode.RDN, "mul")
        testBinaryOp(mul, 1.1754949E-38f, 0.99999946f, 1.17549435E-38f, 3, FpuRoundMode.RUP, "mul")
        testBinaryOp(mul, 1.1754949E-38f, -0.99999946f, -1.17549435E-38f, 3, FpuRoundMode.RDN, "mul")
        testBinaryOp(mul, 1.1754955E-38f, 0.999999f, 1.17549435E-38f, 3, FpuRoundMode.RUP, "mul")



        for(_ <- 0 until 10000) testMul()

        println("Mul done")



        for(_ <- 0 until 10000) testAdd()
        for(_ <- 0 until 10000) testSub()

        println("Add done")










//        waitUntil(cmdQueue.isEmpty)
//        dut.clockDomain.waitSampling(1000)
//        simSuccess()

        for(i <- 0 until 1000) f32Tests.randomPick()()
        waitUntil(cpu.rspQueue.isEmpty)
      }


      stim.foreach(_.join())
      dut.clockDomain.waitSampling(100)
    }
  }
}


object Clib {
  val java_home = System.getProperty("java.home")
  assert(java_home != "" && java_home != null, "JAVA_HOME need to be set")
  val jdk = java_home.replace("/jre","").replace("\\jre","")
  val jdkIncludes = jdk + "/include"
  val flags   = List("-fPIC", "-m64", "-shared", "-Wno-attributes") //-Wl,--whole-archive
  val os = new File("/media/data/open/SaxonSoc/berkeley-softfloat-3/build/Linux-x86_64-GCC").listFiles().map(_.getAbsolutePath).filter(_.toString.endsWith(".o"))
  val cmd = s"gcc -I/media/data/open/SaxonSoc/berkeley-softfloat-3/source/include -I$jdkIncludes  -I$jdkIncludes/linux ${flags.mkString(" ")} -o src/test/cpp/fpu/math/fpu_math.so src/test/cpp/fpu/math/fpu_math.c src/test/cpp/fpu/math/softfloat.a" // src/test/cpp/fpu/math/softfloat.a
  DoCmd.doCmd(cmd)
  val math = new FpuMath
}
// cd /media/data/open/SaxonSoc/testFloatBuild/berkeley-softfloat-3/build/Linux-x86_64-GCC
// make clean && SPECIALIZE_TYPE=RISCV make -j$(nproc) && cp softfloat.a /media/data/open/SaxonSoc/artyA7SmpUpdate/SaxonSoc/ext/VexRiscv/src/test/cpp/fpu/math
object FpuCompileSo extends App{

//  val b2f = lang.Float.intBitsToFloat(_)
//  for(e <- FpuRoundMode.elements) {
//    println(e)
//    for (i <- -2 until 50) println(i + " => " + Clib.math.addF32(b2f(0x7f000000), b2f(0x7f000000 + i), e.position))
//    println("")
//  }
  //1 did not equal 3 Flag missmatch dut=1 ref=3 ## mul 0.9994812 -1.1754988E-38 -1.174889E-38 RMM
  //  println(Clib.math.mulF32(0.9994812f, -1.1754988E-38f, FpuRoundMode.RMM.position))
//  miaou ffffffff 7fffffe0 7f
//  miaou 0 3ffffff0 70 = 0


    println(Clib.math.mulF32( 1.1753509E-38f, 1.0001221f, FpuRoundMode.RUP.position))
    println(Clib.math.mulF32( 1.1754945E-38f, 0.9999998f, FpuRoundMode.RUP.position))
//  testBinaryOp(mul, 1.1753509E-38f, 1.0001221f, 1.17549435E-38f ,1, FpuRoundMode.RUP,"mul")
//  testBinaryOp(mul, 1.1754945E-38f, 0.9999998f, 1.17549435E-38f, 3, FpuRoundMode.RUP, "mul")
//  miaou ffffffff 7fffffe0 7f
//  miaou 0 3ffffff0 70 = 0
//  miaou ffffffff 7fffff7e 7f
//  miaou 1 3fffffbf 3f = 1

//  println(Clib.math.mulF32( 1.1753509E-38f, 1.0001221f, FpuRoundMode.RUP.position))
//  println(Clib.math.mulF32( 1.469368E-39f, 7.9999995f, FpuRoundMode.RUP.position))
//  println(Clib.math.mulF32( 1.40129846432e-45f, 7.9999995f, FpuRoundMode.RUP.position))
//  println(Clib.math.mulF32( 2.93873587706e-39f, 7.9999995f, FpuRoundMode.RUP.position))
//  println(Clib.math.mulF32( 1f, 7.9999995f, FpuRoundMode.RUP.position))


//  println(Clib.math.addF32(1.00000011921f, 4.0f, FpuRoundMode.RNE.position))
//  println(Clib.math.addF32(1.00000011921f, 4.0f, FpuRoundMode.RTZ.position))
//  println(Clib.math.addF32(1.00000011921f, 4.0f, FpuRoundMode.RDN.position))
//  println(Clib.math.addF32(1.00000011921f, 4.0f, FpuRoundMode.RUP.position))
}

class ProcessStream(cmd : String){
  import sys.process._

  val buf = mutable.Queue[() => String]()
  val p = Process(cmd).run(new ProcessLogger {
    override def out(s: => String): Unit = {
      while(buf.size > 10000) Thread.sleep(10)
      buf.enqueue(() => s)
    }
    override def err(s: => String): Unit = {}
    override def buffer[T](f: => T): T = f
  })

  def kill = p.destroy()
  def next = {
    while(buf.isEmpty) { Thread.sleep(10) }
    buf.dequeue()()
  }
}

object TestSoftFloat extends App{
  val p = new ProcessStream("testfloat_gen -forever f32_add")
  Thread.sleep(1000)
  println(p.next)
  println(p.next)
  println(p.next)
  println(p.next)
  println(p.next)
  Thread.sleep(1000)
  println(p.next)
  while(true) {
    Thread.sleep(10)
    println(p.next)
  }
}
