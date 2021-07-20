package vexriscv.ip.fpu

import java.io.File
import java.lang
import java.util.Scanner

import org.apache.commons.io.FileUtils
import org.scalatest.funsuite.AnyFunSuite
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
import org.scalatest.funsuite.AnyFunSuite

//TODO Warning DataCache write aggregation will disable itself
class FpuTest extends AnyFunSuite{

  val b2f = lang.Float.intBitsToFloat(_)
  val b2d = lang.Double.longBitsToDouble(_)
  val f2b = lang.Float.floatToRawIntBits(_)
  val d2bOffset = BigInt("10000000000000000",16)
  def d2b(that : Double) = {
    val l = lang.Double.doubleToRawLongBits(that)
    var a = BigInt(l)
    if(l < 0) {
      a = d2bOffset + a
    }
    a
  }


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
    val portCount = 4

    val config = SimConfig
    config.allOptimisation
//    config.withFstWave
    config.compile(new FpuCore(portCount, p){
      for(i <- 0 until portCount) out(Bits(5 bits)).setName(s"flagAcc$i") := io.port(i).completion.flags.asBits
      setDefinitionName("FpuCore"+ (if(p.withDouble) "Double" else  ""))
    }).doSim(seed = 42){ dut =>
      dut.clockDomain.forkStimulus(10)
      dut.clockDomain.forkSimSpeedPrinter(5.0)


      class TestCase(op : String){
        def build(arg : String) = new ProcessStream(s"testfloat_gen $arg -tininessafter -forever -$op"){
          def f32_f32_f32 ={
            val s = new Scanner(next)
            val a,b,c = (s.nextLong(16).toInt)
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


          def nextLong(s : Scanner) : Long = java.lang.Long.parseUnsignedLong( s.next(),16)

          def f64_f64_f64 ={
            val s = new Scanner(next)
            val a,b,c = nextLong(s)
            (b2d(a), b2d(b), b2d(c), s.nextInt(16))
          }

          def i32_f64 ={
            val s = new Scanner(next)
            (s.nextLong(16).toInt, b2d(nextLong(s)), s.nextInt(16))
          }

          def f64_i32 = {
            val s = new Scanner(next)
            (b2d(nextLong(s)), s.nextLong(16).toInt, s.nextInt(16))
          }

          def f64_f64_i32 = {
            val str = next
            val s = new Scanner(str)
            val a,b = (nextLong(s))
            (b2d(a), b2d(b), s.nextInt(16), s.nextInt(16))
          }

          def f64_f64 = {
            val s = new Scanner(next)
            val a,b = nextLong(s)
            (b2d(a), b2d(b), s.nextInt(16))
          }


          def f32_f64_i32 = {
            val s = new Scanner(next)
            val a,b = nextLong(s)
            (b2f(a.toInt), b2d(b),  s.nextInt(16))
          }
          def f64_f32_i32 = {
            val s = new Scanner(next)
            val a,b = nextLong(s)
            (b2d(a), b2f(b.toInt), s.nextInt(16))
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

      class TestVector(f : String) {
        val add = new TestCase(s"${f}_add")
        val sub = new TestCase(s"${f}_sub")
        val mul = new TestCase(s"${f}_mul")
        val ui2f = new TestCase(s"ui32_to_${f}")
        val i2f = new TestCase(s"i32_to_${f}")
        val f2ui = new TestCase(s"${f}_to_ui32 -exact")
        val f2i = new TestCase(s"${f}_to_i32 -exact")
        val eq = new TestCase(s"${f}_eq")
        val lt = new TestCase(s"${f}_lt")
        val le = new TestCase(s"${f}_le")
        val min = new TestCase(s"${f}_le")
        val max = new TestCase(s"${f}_lt")
        val transfer = new TestCase(s"${f}_eq")
        val fclass = new TestCase(s"${f}_eq")
        val sgnj = new TestCase(s"${f}_eq")
        val sgnjn = new TestCase(s"${f}_eq")
        val sgnjx = new TestCase(s"${f}_eq")
        val sqrt = new TestCase(s"${f}_sqrt")
        val div = new TestCase(s"${f}_div")
      }

      val f32 = new TestVector("f32"){
        val f64 = new TestCase(s"f32_eq")
        val cvt64 = new TestCase(s"f32_to_f64")
      }
      val f64 = new TestVector("f64"){
        val f32 = new TestCase(s"f64_eq")
        val cvt32 = new TestCase(s"f64_to_f32")
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
          val patch = if(value.abs == 1.17549435E-38f && false) 0x1f & ~2 else 0x1f
          flagMatch(ref, report, patch)
        }

        def flagMatch(ref : Int, value : Double, report : String): Unit ={
          val patch = if(value.abs == b2d(1 << 52) && false) 0x1f & ~2 else 0x1f
          flagMatch(ref, report, patch)
        }

        def flagMatch(ref : Int, report : String, mask : Int = 0x1f): Unit ={
          waitUntil(pendingMiaou == 0)
          assert((flagAccumulator & mask) == (ref & mask), s"Flag missmatch dut=$flagAccumulator ref=$ref $report")
          flagAccumulator = 0
        }
        def flagClear(): Unit ={
          waitUntil(pendingMiaou == 0)
          flagAccumulator = 0
        }

        val flagAggregated = dut.reflectBaseType(s"flagAcc$id").asInstanceOf[Bits]
        dut.clockDomain.onSamplings{
          val c = dut.io.port(id).completion
          if(c.valid.toBoolean) {
            pendingMiaou -= 1
            flagAccumulator |= flagAggregated.toInt
          }
          dut.writeback.randomSim.randomize()
        }

        StreamDriver(dut.io.port(id).cmd ,dut.clockDomain){payload =>
          if(cmdQueue.isEmpty) false else {
            cmdQueue.dequeue().apply(payload)
            true
          }
        }


        StreamMonitor(dut.io.port(id)rsp, dut.clockDomain){payload =>
          pendingMiaou -= 1
          if(payload.NV.toBoolean) flagAccumulator |= 1 << 4
          if(payload.NX.toBoolean) flagAccumulator |= 1 << 0
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
            cmd.rd #= rd
            cmd.value #= value
            cmd.opcode #= cmd.opcode.spinalEnum.LOAD
          }
        }


        def load(rd : Int, value : Float): Unit ={
          loadRaw(rd, f2b(value).toLong & 0xFFFFFFFFl, FpuFormat.FLOAT)
        }

        def load(rd : Int, value : Double): Unit ={
          loadRaw(rd, d2b(value), FpuFormat.DOUBLE)
        }

        def storeRaw(rs : Int, format : FpuFormat.E)(body : FpuRsp => Unit): Unit ={
          cmdAdd {cmd =>
            cmd.opcode #= cmd.opcode.spinalEnum.STORE
            cmd.rs1.randomize()
            cmd.rs2 #= rs
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
        def store(rs : Int)(body : Double => Unit): Unit ={
          storeRaw(rs, FpuFormat.DOUBLE){rsp => body(b2d(rsp.value.toBigInt.toLong))}
        }

        def fpuF2f(rd : Int, rs1 : Int, rs2 : Int, rs3 : Int, opcode : FpuOpcode.E, arg : Int, rounding : FpuRoundMode.E, format : FpuFormat.E): Unit ={
          cmdAdd {cmd =>
            cmd.opcode #= opcode
            cmd.rs1 #= rs1
            cmd.rs2 #= rs2
            cmd.rs3 #= rs3
            cmd.rd #= rd
            cmd.arg #= arg
            cmd.roundMode #= rounding
            cmd.format #= format
          }
          commitQueue += {cmd =>
            cmd.write #= true
            cmd.rd #= rd
            cmd.opcode #= opcode
          }
        }

        def fpuF2i(rs1 : Int, rs2 : Int, opcode : FpuOpcode.E, arg : Int, rounding : FpuRoundMode.E, format : FpuFormat.E)(body : FpuRsp => Unit): Unit ={
          cmdAdd {cmd =>
            cmd.opcode #= opcode
            cmd.rs1 #= rs1
            cmd.rs2 #= rs2
            cmd.rs3.randomize()
            cmd.rd.randomize()
            cmd.arg #= arg
            cmd.roundMode #= rounding
            cmd.format #= format
          }
          rspQueue += body
        }


        def mul(rd : Int, rs1 : Int, rs2 : Int, rounding : FpuRoundMode.E, format : FpuFormat.E): Unit ={
          fpuF2f(rd, rs1, rs2, Random.nextInt(32), FpuOpcode.MUL, 0, rounding, format)
        }

        def add(rd : Int, rs1 : Int, rs2 : Int, rounding : FpuRoundMode.E = FpuRoundMode.RNE, format : FpuFormat.E): Unit ={
          fpuF2f(rd, rs1, rs2, Random.nextInt(32), FpuOpcode.ADD, 0, rounding, format)
        }

        def sub(rd : Int, rs1 : Int, rs2 : Int, rounding : FpuRoundMode.E = FpuRoundMode.RNE, format : FpuFormat.E): Unit ={
          fpuF2f(rd, rs1, rs2, Random.nextInt(32), FpuOpcode.ADD, 1, rounding, format)
        }

        def div(rd : Int, rs1 : Int, rs2 : Int, rounding : FpuRoundMode.E = FpuRoundMode.RNE, format : FpuFormat.E): Unit ={
          fpuF2f(rd, rs1, rs2, Random.nextInt(32), FpuOpcode.DIV, Random.nextInt(4), rounding, format)
        }

        def sqrt(rd : Int, rs1 : Int, rounding : FpuRoundMode.E = FpuRoundMode.RNE, format : FpuFormat.E): Unit ={
          fpuF2f(rd, rs1, Random.nextInt(32), Random.nextInt(32), FpuOpcode.SQRT, Random.nextInt(4), rounding, format)
        }

        def fma(rd : Int, rs1 : Int, rs2 : Int, rs3 : Int, rounding : FpuRoundMode.E, format : FpuFormat.E): Unit ={
          fpuF2f(rd, rs1, rs2, rs3, FpuOpcode.FMA, 0, rounding, format)
        }

        def sgnjRaw(rd : Int, rs1 : Int, rs2 : Int, arg : Int, format : FpuFormat.E): Unit ={
          fpuF2f(rd, rs1, rs2, Random.nextInt(32), FpuOpcode.SGNJ, arg, FpuRoundMode.elements.randomPick(), format)
        }

        def sgnj(rd : Int, rs1 : Int, rs2 : Int, rounding : FpuRoundMode.E = null, format : FpuFormat.E): Unit ={
          sgnjRaw(rd, rs1, rs2, 0, format)
        }
        def sgnjn(rd : Int, rs1 : Int, rs2 : Int, rounding : FpuRoundMode.E = null, format : FpuFormat.E): Unit ={
          sgnjRaw(rd, rs1, rs2, 1, format)
        }
        def sgnjx(rd : Int, rs1 : Int, rs2 : Int, rounding : FpuRoundMode.E = null, format : FpuFormat.E): Unit ={
          sgnjRaw(rd, rs1, rs2, 2, format)
        }

        def cmp(rs1 : Int, rs2 : Int, arg : Int, format : FpuFormat.E)(body : FpuRsp => Unit): Unit ={
          fpuF2i(rs1, rs2, FpuOpcode.CMP, arg, FpuRoundMode.elements.randomPick(), format)(body)
        }

        def f2i(rs1 : Int, signed : Boolean, rounding : FpuRoundMode.E, format : FpuFormat.E)(body : FpuRsp => Unit): Unit ={
          fpuF2i(rs1, Random.nextInt(32), FpuOpcode.F2I, if(signed) 1 else 0, rounding, format)(body)
        }

        def i2f(rd : Int, value : Int, signed : Boolean, rounding : FpuRoundMode.E, format : FpuFormat.E): Unit ={
          cmdAdd {cmd =>
            cmd.opcode #= cmd.opcode.spinalEnum.I2F
            cmd.rs1.randomize()
            cmd.rs2.randomize()
            cmd.rs3.randomize()
            cmd.rd #= rd
            cmd.arg #= (if(signed) 1 else 0)
            cmd.roundMode #= rounding
            cmd.format #= format
          }
          commitQueue += {cmd =>
            cmd.write #= true
            cmd.rd #= rd
            cmd.opcode #= FpuOpcode.I2F
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
            cmd.rd #= rd
            cmd.opcode #= FpuOpcode.FMV_W_X
            cmd.value #= value.toLong & 0xFFFFFFFFl
          }
        }

        def minMax(rd : Int, rs1 : Int, rs2 : Int, arg : Int, format : FpuFormat.E): Unit ={
          cmdAdd {cmd =>
            cmd.opcode #= cmd.opcode.spinalEnum.MIN_MAX
            cmd.rs1 #= rs1
            cmd.rs2 #= rs2
            cmd.rs3.randomize()
            cmd.rd #= rd
            cmd.arg #= arg
            cmd.roundMode.randomize()
            cmd.format #= format
          }
          commitQueue += {cmd =>
            cmd.write #= true
            cmd.rd #= rd
            cmd.opcode #= FpuOpcode.MIN_MAX
          }
        }



        def fclass(rs1 : Int, format : FpuFormat.E)(body : Int => Unit) : Unit = {
          cmdAdd {cmd =>
            cmd.opcode #= FpuOpcode.FCLASS
            cmd.rs1 #= rs1
            cmd.rs2.randomize()
            cmd.rs3.randomize()
            cmd.rd.randomize()
            cmd.arg.randomize()
            cmd.roundMode.randomize()
            cmd.format #= format
          }
          rspQueue += {rsp => body(rsp.value.toBigInt.toInt)}
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

        def checkDouble(ref : Double, dut : Double): Boolean ={
          if((d2b(ref) & Long.MinValue) != (d2b(dut) & Long.MinValue)) return  false
          if(ref == 0.0 && dut == 0.0 && d2b(ref) != d2b(dut)) return false
          if(ref.isNaN && dut.isNaN) return true
          if(ref == dut) return true
          if(ref.abs * 1.0001 + Float.MinPositiveValue >= dut.abs*0.9999 && ref.abs * 0.9999 - Double.MinPositiveValue  <= dut.abs*1.0001) return true
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

        def randomDouble(): Double ={
          val exp = Random.nextInt(10)-5
          (Random.nextDouble() * (Math.pow(2.0, exp)) * (if(Random.nextBoolean()) -1.0 else 1.0))
        }


        def testBinaryOp(op : (Int,Int,Int,FpuRoundMode.E, FpuFormat.E) => Unit, a : Float, b : Float, ref : Float, flag : Int, rounding : FpuRoundMode.E, opName : String): Unit ={
          val rs = new RegAllocator()
          val rs1, rs2, rs3 = rs.allocate()
          val rd = Random.nextInt(32)
          load(rs1, a)
          load(rs2, b)
          op(rd,rs1,rs2, rounding, FpuFormat.FLOAT)
          storeFloat(rd){v =>
            assert(f2b(v) == f2b(ref), f"## ${a}  ${opName}  $b = $v, $ref $rounding")
          }

          flagMatch(flag, ref, f"## ${opName} ${a} $b $ref $rounding")
        }


        def testBinaryOpF64(op : (Int,Int,Int,FpuRoundMode.E, FpuFormat.E) => Unit, a : Double, b : Double, ref : Double, flag : Int, rounding : FpuRoundMode.E, opName : String): Unit ={
          val rs = new RegAllocator()
          val rs1, rs2, rs3 = rs.allocate()
          val rd = Random.nextInt(32)
          load(rs1, a)
          load(rs2, b)
          op(rd,rs1,rs2, rounding, FpuFormat.DOUBLE)
          store(rd){v =>
            assert(d2b(v) == d2b(ref), f"## ${a}  ${opName}  $b = $v, $ref $rounding, ${d2b(a).toString(16)} ${d2b(b).toString(16)} ${d2b(ref).toString(16)}")
          }

          flagMatch(flag, ref, f"## ${opName} ${a} $b $ref $rounding")
        }


        def testTransferF32Raw(a : Float, iSrc : Boolean, iDst : Boolean): Unit ={
          val rd = Random.nextInt(32)

          def handle(v : Float): Unit ={
            val ref = a
            assert(f2b(v) == f2b(ref), f"$a = $v, $ref")
          }

          if(iSrc) fmv_w_x(rd, f2b(a)) else load(rd, a)
          if(iDst) fmv_x_w(rd)(handle) else storeFloat(rd)(handle)

          flagMatch(0, f"$a")
        }


        def testTransferF64Raw(a : Double): Unit ={
          val rd = Random.nextInt(32)

          def handle(v : Double): Unit ={
            val ref = a
            assert(d2b(v) == d2b(ref), f"$a = $v, $ref")
          }

          load(rd, a)
          store(rd)(handle)

          flagMatch(0, f"$a")
        }

        def testTransferF32F64Raw(a : Float,  iSrc : Boolean): Unit ={
          val rd = Random.nextInt(32)
          if(iSrc) fmv_w_x(rd, f2b(a)) else load(rd, a)
          storeRaw(rd, FpuFormat.DOUBLE){rsp =>
            val v = rsp.value.toBigInt.toLong
            val ref = (0xFFFFFFFFl << 32) | f2b(a)
            assert(v == ref, f"$a = $v, $ref")
          }
          flagMatch(0, f"$a")
        }

        def testTransferF64F32Raw(a : Double,  iDst : Boolean): Unit ={
          val rd = Random.nextInt(32)
          load(rd, a)
          if(iDst)fmv_x_w(rd){v_ =>
            val v = f2b(v_).toLong & 0xFFFFFFFFl
            val ref = d2b(a) & 0xFFFFFFFFl
            assert(v == ref, f"$a = $v, $ref")
          }
          else storeRaw(rd, FpuFormat.FLOAT){rsp =>
            val v = rsp.value.toBigInt.toLong & 0xFFFFFFFFl
            val ref = d2b(a) & 0xFFFFFFFFl
            assert(v == ref, f"$a = $v, $ref")
          }
          flagMatch(0, f"$a")
        }


        def testCvtF32F64Raw(a : Float, ref : Double, flag : Int, rounding : FpuRoundMode.E): Unit ={
          val rs, rd = Random.nextInt(32)
          load(rs, a)
          fpuF2f(rd, rs, Random.nextInt(32), Random.nextInt(32), FpuOpcode.FCVT_X_X, Random.nextInt(3), rounding, FpuFormat.FLOAT)
          store(rd){v =>
            assert(d2b(v) == d2b(ref), f"testCvtF32F64Raw $a $ref $rounding")
          }
          flagMatch(flag,ref, f"testCvtF32F64Raw $a $ref $rounding")
        }

        def testCvtF64F32Raw(a : Double, ref : Float, flag : Int, rounding : FpuRoundMode.E): Unit ={
          val rs, rd = Random.nextInt(32)
          load(rs, a)
          fpuF2f(rd, rs, Random.nextInt(32), Random.nextInt(32), FpuOpcode.FCVT_X_X, Random.nextInt(3), rounding, FpuFormat.DOUBLE)
          storeFloat(rd){v =>
            assert(d2b(v) == d2b(ref), f"testCvtF64F32Raw $a $ref $rounding")
          }
          flagMatch(flag, ref, f"testCvtF64F32Raw $a $ref $rounding")
        }


        def testClassRaw(a : Float) : Unit = {
          val rd = Random.nextInt(32)


          load(rd, a)
          fclass(rd, FpuFormat.FLOAT){v =>
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


        def testClassF64Raw(a : Double) : Unit = {
          val rd = Random.nextInt(32)


          load(rd, a)
          fclass(rd, FpuFormat.DOUBLE){v =>
            val mantissa = d2b(a) & 0x000FFFFFFFFFFFFFl
            val exp = (d2b(a) >> 52) & 0x7FF
            val sign = (d2b(a) >> 63) & 0x1

            val refBit = if(a.isInfinite) (if(sign == 0) 7 else 0)
            else if(a.isNaN) (if((mantissa >> 51) != 0) 9 else 8)
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

          fma(rd,rs1,rs2,rs3, FpuRoundMode.RNE, FpuFormat.FLOAT)
          storeFloat(rd){v =>
            val ref = a.toDouble * b.toDouble + c.toDouble
            val mul = a.toDouble * b.toDouble
            if((mul.abs-c.abs)/mul.abs > 0.1)  assert(checkFloat(ref.toFloat, v), f"$a%.20f * $b%.20f + $c%.20f = $v%.20f, $ref%.20f")
          }
        }



        def testFmaF64Raw(a : Double, b : Double, c : Double): Unit ={
          val rs = new RegAllocator()
          val rs1, rs2, rs3 = rs.allocate()
          val rd = Random.nextInt(32)
          load(rs1, a)
          load(rs2, b)
          load(rs3, c)

          fma(rd,rs1,rs2,rs3, FpuRoundMode.RNE, FpuFormat.DOUBLE)
          store(rd){v =>
            val ref = a.toDouble * b.toDouble + c.toDouble
            val mul = a.toDouble * b.toDouble
            if((mul.abs-c.abs)/mul.abs > 0.1)  assert(checkDouble(ref, v), f"$a%.20f * $b%.20f + $c%.20f = $v%.20f, $ref%.20f")
          }
        }

        def testSqrtF64Exact(a : Double, ref : Double, flag : Int, rounding : FpuRoundMode.E): Unit ={
          val rs = new RegAllocator()
          val rs1, rs2, rs3 = rs.allocate()
          val rd = Random.nextInt(32)
          load(rs1, a)

          sqrt(rd,rs1,  rounding, FpuFormat.DOUBLE)

          store(rd){v =>
            assert(d2b(v) == d2b(ref), f"## sqrt${a}   = $v, $ref $rounding, ${d2b(a).toString(16)} ${d2b(ref).toString(16)}")
          }

          flagMatch(flag, ref, f"## sqrt${a} $ref $rounding")
        }

        def testSqrtExact(a : Float, ref : Float, flag : Int, rounding : FpuRoundMode.E): Unit ={
          val rs = new RegAllocator()
          val rs1, rs2, rs3 = rs.allocate()
          val rd = Random.nextInt(32)
          load(rs1, a)

          sqrt(rd,rs1,  rounding, FpuFormat.FLOAT)

          storeFloat(rd){v =>
            assert(d2b(v) == d2b(ref), f"## sqrt${a}   = $v, $ref $rounding, ${f2b(a).toString()} ${f2b(ref).toString()}")
          }

          flagMatch(flag, ref, f"## sqrt${a} $ref $rounding")
        }


        def testF2iExact(a : Float, ref : Int, flag : Int, signed : Boolean, rounding : FpuRoundMode.E): Unit ={
          val rs = new RegAllocator()
          val rs1 = rs.allocate()
          val rd = Random.nextInt(32)
          load(rs1, a)
          f2i(rs1, signed, rounding, FpuFormat.FLOAT){rsp =>
            if(signed) {
              val v = rsp.value.toBigInt.toInt
              var ref2 = ref
              if(a >= Int.MaxValue) ref2 = Int.MaxValue
              if(a <= Int.MinValue) ref2 = Int.MinValue
              if(a.isNaN) ref2 = Int.MaxValue
              assert(v == (ref2), f" <= f2i($a) = $v, $ref2, $rounding, $flag")
            } else {
              val v = rsp.value.toBigInt.toLong & 0xFFFFFFFFl
              var ref2 = ref.toLong & 0xFFFFFFFFl
              if(a < 0) ref2 = 0
              if(a >= 0xFFFFFFFFl) ref2 = 0xFFFFFFFFl
              if(a.isNaN) ref2 = 0xFFFFFFFFl
              assert(v == ref2, f" <= f2ui($a) = $v, $ref2, $rounding $flag")
            }
          }

          flagMatch(flag, ref, f" f2${if(signed) "" else "u"}i($a) $ref $flag $rounding")
        }



        def testF642iExact(a : Double, ref : Int, flag : Int, signed : Boolean, rounding : FpuRoundMode.E): Unit ={
          val rs = new RegAllocator()
          val rs1 = rs.allocate()
          val rd = Random.nextInt(32)
          load(rs1, a)
          f2i(rs1, signed, rounding, FpuFormat.DOUBLE){rsp =>
            if(signed) {
              val v = rsp.value.toBigInt.toInt
              var ref2 = ref
              if(a >= Int.MaxValue) ref2 = Int.MaxValue
              if(a <= Int.MinValue) ref2 = Int.MinValue
              if(a.isNaN) ref2 = Int.MaxValue
              assert(v == (ref2), f" <= f2i($a) = $v, $ref2, $rounding, $flag")
            } else {
              val v = rsp.value.toBigInt.toLong & 0xFFFFFFFFl
              var ref2 = ref.toLong & 0xFFFFFFFFl
              if(a < 0) ref2 = 0
              if(a >= 0xFFFFFFFFl) ref2 = 0xFFFFFFFFl
              if(a.isNaN) ref2 = 0xFFFFFFFFl
              assert(v == ref2, f" <= f2ui($a) = $v, $ref2, $rounding $flag")
            }
          }

          flagMatch(flag, ref, f" f2${if(signed) "" else "u"}i($a) $ref $flag $rounding")
        }



        def testI2fExact(a : Int, ref : Float, f : Int, signed : Boolean, rounding : FpuRoundMode.E): Unit ={
          val rs = new RegAllocator()
          val rd = Random.nextInt(32)
          i2f(rd, a, signed, rounding, FpuFormat.FLOAT)
          storeFloat(rd){v =>
            val aLong = if(signed) a.toLong else a.toLong & 0xFFFFFFFFl
            assert(f2b(v) == f2b(ref), f"i2f($aLong) = $v, $ref $rounding")
          }


          flagMatch(f, ref, f"i2f($a) = $ref")
        }



        def testI2f64Exact(a : Int, ref : Double, f : Int, signed : Boolean, rounding : FpuRoundMode.E): Unit ={
          val rs = new RegAllocator()
          val rd = Random.nextInt(32)
          i2f(rd, a, signed, rounding, FpuFormat.DOUBLE)
          store(rd){v =>
            val aLong = if(signed) a.toLong else a.toLong & 0xFFFFFFFFl
            assert(d2b(v) == d2b(ref), f"i2f($aLong) = $v, $ref $rounding")
          }


          flagMatch(f, ref, f"i2f($a) = $ref")
        }


        def testCmpExact(a : Float, b : Float, ref : Int, flag : Int, arg : Int): Unit ={
          val rs = new RegAllocator()
          val rs1, rs2, rs3 = rs.allocate()
          val rd = Random.nextInt(32)
          load(rs1, a)
          load(rs2, b)
          cmp(rs1, rs2, arg, FpuFormat.FLOAT){rsp =>
            val v = rsp.value.toBigInt.toInt
            assert(v === ref, f"cmp($a, $b, $arg) = $v, $ref")
          }
          flagMatch(flag,f"$a < $b $ref $flag ${f2b(a).toHexString} ${f2b(b).toHexString}")
        }
        def testLeRaw(a : Float, b : Float, ref : Int, flag : Int) = testCmpExact(a,b,ref,flag, 0)
        def testEqRaw(a : Float, b : Float, ref : Int, flag : Int) = testCmpExact(a,b,ref,flag, 2)
        def testLtRaw(a : Float, b : Float, ref : Int, flag : Int) = testCmpExact(a,b,ref,flag, 1)


        def testCmpF64Exact(a : Double, b : Double, ref : Int, flag : Int, arg : Int): Unit ={
          val rs = new RegAllocator()
          val rs1, rs2, rs3 = rs.allocate()
          val rd = Random.nextInt(32)
          load(rs1, a)
          load(rs2, b)
          cmp(rs1, rs2, arg, FpuFormat.DOUBLE){rsp =>
            val v = rsp.value.toBigInt.toInt
            assert(v === ref, f"cmp($a, $b, $arg) = $v, $ref")
          }
          flagMatch(flag,f"$a < $b $ref $flag ${d2b(a)} ${d2b(b)}")
        }
        def testLeF64Raw(a : Double, b : Double, ref : Int, flag : Int) = testCmpF64Exact(a,b,ref,flag, 0)
        def testEqF64Raw(a : Double, b : Double, ref : Int, flag : Int) = testCmpF64Exact(a,b,ref,flag, 2)
        def testLtF64Raw(a : Double, b : Double, ref : Int, flag : Int) = testCmpF64Exact(a,b,ref,flag, 1)

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

          minMax(rd,rs1,rs2, arg, FpuFormat.FLOAT)
          storeFloat(rd){v =>
            assert(f2b(ref) ==  f2b(v), f"minMax($a $b $arg) = $v, $ref")
          }
          flagMatch(flag, f"minmax($a $b $arg)")
        }

        def testMinExact(a : Float, b : Float) : Unit = testMinMaxExact(a,b,0)
        def testMaxExact(a : Float, b : Float) : Unit = testMinMaxExact(a,b,1)


        def testMinMaxF64Exact(a : Double, b : Double, arg : Int): Unit ={
          val rs = new RegAllocator()
          val rs1, rs2 = rs.allocate()
          val rd = Random.nextInt(32)
          val ref = (a,b) match {
            case _ if a.isNaN && b.isNaN => b2d(0x7ff8000000000000l)
            case _ if a.isNaN => b
            case _ if b.isNaN => a
            case _ => if(arg == 0) Math.min(a,b) else Math.max(a,b)
          }
          val flag = (a,b) match {
            case _ if a.isNaN && ((d2b(a) >> 51 ) & 1) == 0 => 16
            case _ if b.isNaN && ((d2b(b) >> 51 ) & 1) == 0 => 16
            case _ => 0
          }
          load(rs1, a)
          load(rs2, b)

          minMax(rd,rs1,rs2, arg, FpuFormat.DOUBLE)
          store(rd){v =>
            assert(d2b(ref) ==  d2b(v), f"minMax($a $b $arg) = $v, $ref")
          }
          flagMatch(flag, f"minmax($a $b $arg)")
        }

        def testMinF64Exact(a : Double, b : Double) : Unit = testMinMaxF64Exact(a,b,0)
        def testMaxF64Exact(a : Double, b : Double) : Unit = testMinMaxF64Exact(a,b,1)


        def testSgnjRaw(a : Float, b : Float): Unit ={
          var ref = b2f((f2b(a) & ~0x80000000) | f2b(b) & 0x80000000)
          if(a.isNaN) ref = a
          testBinaryOp(sgnj,a,b,ref,0, null,"sgnj")
        }
        def testSgnjnRaw(a : Float, b : Float): Unit ={
          var ref = b2f((f2b(a) & ~0x80000000) | ((f2b(b) & 0x80000000) ^ 0x80000000))
          if(a.isNaN) ref = a
          testBinaryOp(sgnjn,a,b,ref,0, null,"sgnjn")
        }
        def testSgnjxRaw(a : Float, b : Float): Unit ={
          var ref = b2f(f2b(a) ^ (f2b(b) & 0x80000000))
          if(a.isNaN) ref = a
          testBinaryOp(sgnjx,a,b,ref,0, null,"sgnjx")
        }

        val f64SignMask = 1l << 63
        def testSgnjF64Raw(a : Double, b : Double): Unit ={
          var ref = b2d((d2b(a).toLong & ~f64SignMask) | d2b(b).toLong & f64SignMask)
          if(a.isNaN) ref = a
          testBinaryOpF64(sgnj,a,b,ref,0, null,"sgnj")
        }
        def testSgnjnF64Raw(a : Double, b : Double): Unit ={
          var ref = b2d((d2b(a).toLong & ~f64SignMask) | ((d2b(b).toLong & f64SignMask) ^ f64SignMask))
          if(a.isNaN) ref = a
          testBinaryOpF64(sgnjn,a,b,ref,0, null,"sgnjn")
        }
        def testSgnjxF64Raw(a : Double, b : Double): Unit ={
          var ref = b2d(d2b(a).toLong ^ (d2b(b).toLong & f64SignMask))
          if(a.isNaN) ref = a
          testBinaryOpF64(sgnjx,a,b,ref,0, null,"sgnjx")
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

        def testFmaF32() : Unit = {
          testFmaRaw(randomFloat(), randomFloat(), randomFloat())
          flagClear()
        }


        def testFmaF64() : Unit = {
          testFmaF64Raw(randomDouble(), randomDouble(), randomDouble())
          flagClear()
        }

        def testLeF32() : Unit = {
          val (a,b,i,f) = f32.le.RAW.f32_f32_i32
          testLeRaw(a,b,i, f)
        }
        def testLtF32() : Unit = {
          val (a,b,i,f) = f32.lt.RAW.f32_f32_i32
          testLtRaw(a,b,i, f)
        }

        def testEqF32() : Unit = {
          val (a,b,i,f) = f32.eq.RAW.f32_f32_i32
          testEqRaw(a,b,i, f)
        }

        def testLeF64() : Unit = {
          val (a,b,i,f) = f64.le.RAW.f64_f64_i32
          testLeF64Raw(a,b,i, f)
        }
        def testLtF64() : Unit = {
          val (a,b,i,f) = f64.lt.RAW.f64_f64_i32
          testLtF64Raw(a,b,i, f)
        }

        def testEqF64() : Unit = {
          val (a,b,i,f) = f64.eq.RAW.f64_f64_i32
          testEqF64Raw(a,b,i, f)
        }


        def testF2uiF32() : Unit = {
          val rounding = FpuRoundMode.elements.randomPick()
          val (a,b,f) = f32.f2ui(rounding).f32_i32
          testF2iExact(a,b, f, false, rounding)
        }

        def testF2iF32() : Unit = {
          val rounding = FpuRoundMode.elements.randomPick()
          val (a,b,f) = f32.f2i(rounding).f32_i32
          testF2iExact(a,b, f, true, rounding)
        }

        def testF2uiF64() : Unit = {
          val rounding = FpuRoundMode.elements.randomPick()
          val (a,b,f) = f64.f2ui(rounding).f64_i32
          testF642iExact(a,b, f, false, rounding)
        }

        def testF2iF64() : Unit = {
          val rounding = FpuRoundMode.elements.randomPick()
          val (a,b,f) = f64.f2i(rounding).f64_i32
          testF642iExact(a,b, f, true, rounding)
        }


        def testDiv() : Unit = {
          val rounding = FpuRoundMode.elements.randomPick()
          val (a,b,r,f) = f32.div(rounding).f32_f32_f32
          testBinaryOp(div, a, b, r, f, rounding, "div")
        }

        def testSqrt() : Unit = {
          val rounding = FpuRoundMode.elements.randomPick()
          val (a,r,f) = f32.sqrt(rounding).f32_f32
          testSqrtExact(a, r, f, rounding)
          flagClear()
        }

        def testSgnjF32() : Unit = {
          testSgnjRaw(b2f(Random.nextInt()), b2f(Random.nextInt()))
          testSgnjnRaw(b2f(Random.nextInt()), b2f(Random.nextInt()))
          testSgnjxRaw(b2f(Random.nextInt()), b2f(Random.nextInt()))
          val (a,b,r,f) = f32.sgnj.RAW.f32_f32_i32
          testSgnjRaw(a, b)
          testSgnjnRaw(a, b)
          testSgnjxRaw(a, b)
        }

        def testDivF64() : Unit = {
          val rounding = FpuRoundMode.elements.randomPick()
          val (a,b,r,f) = f64.div(rounding).f64_f64_f64
         // testDivF64Exact(a, b, r, f, rounding)
          testBinaryOpF64(div, a, b, r, f,rounding, "div")
          flagClear()
        }

        def testSqrtF64() : Unit = {
          val rounding = FpuRoundMode.elements.randomPick()
          val (a,r,f) = f64.sqrt(rounding).f64_f64
          testSqrtF64Exact(a, r, f, rounding)
          flagClear()
        }

        def testSgnjF64() : Unit = {
          testSgnjF64Raw(b2d(Random.nextLong()), b2d(Random.nextLong()))
          testSgnjnF64Raw(b2d(Random.nextLong()), b2d(Random.nextLong()))
          testSgnjxF64Raw(b2d(Random.nextLong()), b2d(Random.nextLong()))
          val (a,b,r,f) = f64.sgnj.RAW.f64_f64_i32
          testSgnjF64Raw(a, b)
          testSgnjnF64Raw(a, b)
          testSgnjxF64Raw(a, b)
        }


        def testTransferF32() : Unit = {
          val (a,b,r,f) = f32.transfer.RAW.f32_f32_i32
          testTransferF32Raw(a, Random.nextBoolean(), Random.nextBoolean())
        }

        def testTransferF64() : Unit = {
          val (a,b,r,f) = f64.transfer.RAW.f64_f64_i32
          testTransferF64Raw(a)
        }

        def testTransferF64F32() : Unit = {
          val (a,b,r,f) = f64.f32.RAW.f64_f64_i32
          testTransferF64F32Raw(a, Random.nextBoolean())
        }
        def testTransferF32F64() : Unit = {
          val (a,b,r,f) = f32.f64.RAW.f32_f32_i32
          testTransferF32F64Raw(a, Random.nextBoolean())
        }

        def testCvtF32F64() : Unit = {
          val rounding = FpuRoundMode.elements.randomPick()
          val (a,r,f) = f32.cvt64(rounding).f32_f64_i32
          testCvtF32F64Raw(a, r, f, rounding)
        }
        def testCvtF64F32() : Unit = {
          val rounding = FpuRoundMode.elements.randomPick()
          val (a,r,f) = f64.cvt32(rounding).f64_f32_i32
          testCvtF64F32Raw(a, r, f, rounding)
        }

        def testClassF32() : Unit = {
          val (a,b,r,f) = f32.fclass.RAW.f32_f32_i32
          testClassRaw(a)
        }

        def testMinF32() : Unit = {
          val (a,b,r,f) = f32.min.RAW.f32_f32_f32
          testMinExact(a,b)
        }
        def testMaxF32() : Unit = {
          val (a,b,r,f) = f32.max.RAW.f32_f32_f32
          testMaxExact(a,b)
        }

        def testClassF64() : Unit = {
          val (a,b,r,f) = f64.fclass.RAW.f64_f64_i32
          testClassF64Raw(a)
        }

        def testMinF64() : Unit = {
          val (a,b,r,f) = f64.min.RAW.f64_f64_f64
          testMinF64Exact(a,b)
        }
        def testMaxF64() : Unit = {
          val (a,b,r,f) = f64.max.RAW.f64_f64_f64
          testMaxF64Exact(a,b)
        }


        def testUI2f32() : Unit = {
          val rounding = FpuRoundMode.elements.randomPick()
          val (a,b,f) = f32.i2f(rounding).i32_f32
          testI2fExact(a,b,f, true, rounding)
        }

        def testI2f32() : Unit = {
          val rounding = FpuRoundMode.elements.randomPick()
          val (a,b,f) = f32.ui2f(rounding).i32_f32
          testI2fExact(a,b,f, false, rounding)
        }

        def testUI2f64() : Unit = {
          val rounding = FpuRoundMode.elements.randomPick()
          val (a,b,f) = f64.i2f(rounding).i32_f64
          testI2f64Exact(a,b,f, true, rounding)
        }

        def testI2f64() : Unit = {
          val rounding = FpuRoundMode.elements.randomPick()
          val (a,b,f) = f64.ui2f(rounding).i32_f64
          testI2f64Exact(a,b,f, false, rounding)
        }

        def testMulF32() : Unit = {
          val rounding = FpuRoundMode.elements.randomPick()
          val (a,b,c,f) = f32.mul(rounding).f32_f32_f32
          testBinaryOp(mul,a,b,c,f, rounding,"mul")
        }

        def testAddF32() : Unit = {
          val rounding = FpuRoundMode.elements.randomPick()
          val (a,b,c,f) = f32.add(rounding).f32_f32_f32
          testBinaryOp(add,a,b,c,f, rounding,"add")
        }

        def testSubF32() : Unit = {
          val rounding = FpuRoundMode.elements.randomPick()
          val (a,b,c,f) = f32.sub(rounding).f32_f32_f32
          testBinaryOp(sub,a,b,c,f, rounding,"sub")
        }


        def testMulF64() : Unit = {
          val rounding = FpuRoundMode.elements.randomPick()
          val (a,b,c,f) = f64.mul(rounding).f64_f64_f64
          testBinaryOpF64(mul,a,b,c,f, rounding,"mul")
        }

        def testAddF64() : Unit = {
          val rounding = FpuRoundMode.elements.randomPick()
          val (a,b,c,f) = f64.add(rounding).f64_f64_f64
          testBinaryOpF64(add,a,b,c,f, rounding,"add")
        }

        def testSubF64() : Unit = {
          val rounding = FpuRoundMode.elements.randomPick()
          val (a,b,c,f) = f64.sub(rounding).f64_f64_f64
          testBinaryOpF64(sub,a,b,c,f, rounding,"sub")
        }


        val f32Tests = List[() => Unit](testSubF32, testAddF32, testMulF32, testI2f32, testUI2f32, testMinF32, testMaxF32, testSgnjF32, testTransferF32, testDiv, testSqrt, testF2iF32, testF2uiF32, testLeF32, testEqF32, testLtF32, testClassF32, testFmaF32)
        val f64Tests = List[() => Unit](testSubF64, testAddF64, testMulF64, testI2f64, testUI2f64, testMinF64, testMaxF64, testSgnjF64, testTransferF64, testDiv, testSqrt, testF2iF64, testF2uiF64, testLeF64, testEqF64, testLtF64, testClassF64, testFmaF64, testCvtF32F64, testCvtF64F32)

        var fxxTests = f32Tests
        if(p.withDouble) fxxTests ++= f64Tests

//5071920 5225560
//        for(v <- List(-1.17549435082e-38f, 1.17549435082e-38f);
//            rounding <- FpuRoundMode.elements) {
//          for (i <- 0 until 2048) {
//            val b = d2b(v)// 0x0010000000000000l //d2b(1.17549435082e-38)
//            val s = (b - (i.toLong << 21)).toLong
//            val d = b2d(s)
////            val rounding = FpuRoundMode.RNE
//            testCvtF64F32Raw(d, Clib.math.d2f(d, rounding.position), Clib.math.d2fFlag(d, rounding.position), rounding)
//          }
//        }
//
//
//        testCvtF64F32Raw(-1.1754943508051483E-38, -1.17549435E-38f, 1, FpuRoundMode.RNE)
//        testCvtF64F32Raw( 1.1754943157898258E-38, 1.17549435E-38f , 3, FpuRoundMode.RMM)
//        testCvtF64F32Raw( 1.1754942807573643E-38, 1.17549435E-38f , 3, FpuRoundMode.RMM)
//        testCvtF64F32Raw(-1.1754943508051483E-38, -1.17549435E-38f, 1, FpuRoundMode.RMM)

        //-1.1754943508051483E-38 -1.17549435E-38 1 RNE @ 592770
        // 1.1754943157898258E-38 1.17549435E-38 3 RMM  @ 2697440
        // 1.1754942807573643E-38 1.17549435E-38 3 RMM
//        for(_ <- 0 until 1000000) testCvtF64F32() // 1 did not equal 3 Flag missmatch dut=1 ref=3 testCvtF64F32Raw 1.1754942807573643E-38 1.17549435E-38 RMM
//        println("FCVT_D_S done")

//        testBinaryOpF64(div, -2.2250738564511294E-308, 4.294967296003891E9,  -5.180654E-318, 1, FpuRoundMode.RDN,"div") // ??? wtf

//        testBinaryOp(add,b2f(0x7F800000),b2f(0x1FD << 23),b2f(0x7F800000),0, FpuRoundMode.RNE,"add")



//        testBinaryOp(mul,1.1753509E-38f, 1.0001221f ,1.17549435E-38f,1, FpuRoundMode.RNE,"mul")
//
//        for(i <- 0 until 10000000){
//          val rounding = FpuRoundMode.elements.randomPick()
//          val (a,b,c,f) = f32.mul(rounding).f32_f32_f32
//          testBinaryOp(mul,a,b,c,f, rounding,"mul")
//        }
//
//        testBinaryOpF64(mul,2.781342323134002E-309, 7.999999999999999, 2.2250738585072014E-308, 3, FpuRoundMode.RNE,"mul")
////        for(i <- 0 until 10000000){
////          val rounding = FpuRoundMode.RNE
////          val (a,b,c,f) = f64.mul(rounding).f64_f64_f64
////          testBinaryOpF64(mul,a,b,c,f, rounding,"mul")
////        }
//        for(_ <- 0 until 100000000) testMulF64()
//        println("f64 Mul done")
//
//        for(_ <- 0 until 10000) testDivF64()
//        println("f64 div done")
//
//
//        for(_ <- 0 until 10000) testDiv()
//        println("f32 div done")
//
//        for(_ <- 0 until 10000) testAddF32()
//        for(_ <- 0 until 10000) testSubF32()
//
//        println("Add done")
//
//
//        for(_ <- 0 until 10000) testSqrt()
//        println("f32 sqrt done")






        //TODO test boxing
        //TODO double <-> simple convertions
        if(p.withDouble) {

          testSqrtF64Exact(1.25*1.25, 1.25, 0, FpuRoundMode.RNE)
          testSqrtF64Exact(1.5*1.5, 1.5, 0, FpuRoundMode.RNE)

          for(_ <- 0 until 10000) testSqrtF64()
          println("f64 sqrt done")

//          testDivF64Exact(1.0, 8.0, 0.125, 0, FpuRoundMode.RNE)
//          testDivF64Exact(4.0, 8.0, 0.5, 0, FpuRoundMode.RNE)
//          testDivF64Exact(8.0, 8.0, 1.0, 0, FpuRoundMode.RNE)
//          testDivF64Exact(1.5, 2.0, 0.75, 0, FpuRoundMode.RNE)
//          testDivF64Exact(1.875, 1.5, 1.25, 0, FpuRoundMode.RNE)

          for(_ <- 0 until 10000) testDivF64()
          println("f64 div done")

          for(_ <- 0 until 10000) testSgnjF64()
          println("f64 sgnj done")

          for(_ <- 0 until 10000) testSgnjF32()
          println("f32 sgnj done")

          //380000000001ffef 5fffffffffff9ff 8000000000100000
//          testBinaryOpF64(mul,-5.877471754282472E-39, 8.814425663400984E-280, -5.180654E-318 ,1, FpuRoundMode.RMM,"mul")
//          5.877471754282472E-39 8.814425663400984E-280 -5.180654E-318 RMM

          for(_ <- 0 until 10000) testCvtF64F32() // 1 did not equal 3 Flag missmatch dut=1 ref=3 testCvtF64F32Raw 1.1754942807573643E-38 1.17549435E-38 RMM
          println("FCVT_D_S done")
          for(_ <- 0 until 10000) testCvtF32F64()
          println("FCVT_S_D done")

          for(_ <- 0 until 10000) testF2iF64()
          println("f64 f2i done")
          for(_ <- 0 until 10000) testF2uiF64()
          println("f64 f2ui done")





          for(_ <- 0 until 10000) testMinF64()
          for(_ <- 0 until 10000) testMaxF64()
          println("f64 minMax done")



          for(i <- 0 until 1000) testFmaF64()
          flagClear()
          println("f64 fma done") //TODO


          for(_ <- 0 until 10000) testLeF64()
          for(_ <- 0 until 10000) testLtF64()
          for(_ <- 0 until 10000) testEqF64()
          println("f64 Cmp done")


          for(_ <- 0 until 10000) testClassF64()
          println("f64 class done")
//








          for(_ <- 0 until 10000) testAddF64()
          for(_ <- 0 until 10000) testSubF64()
          println("f64 Add done")


          //          testI2f64Exact(0x7FFFFFF5, 0x7FFFFFF5, 0, true, FpuRoundMode.RNE)
          for(_ <- 0 until 10000) testUI2f64()
          for(_ <- 0 until 10000) testI2f64()
          println("f64 i2f done")



//          testF2iExact(1.0f,1, 0, false, FpuRoundMode.RTZ)
//          testF2iExact(2.0f,2, 0, false, FpuRoundMode.RTZ)
//          testF2iExact(2.5f,2, 1, false, FpuRoundMode.RTZ)




          testBinaryOpF64(mul,1.0, 1.0, 1.0,0 , FpuRoundMode.RNE,"mul")
          testBinaryOpF64(mul,1.0, 2.0, 2.0,0 , FpuRoundMode.RNE,"mul")
          testBinaryOpF64(mul,2.5, 2.0, 5.0,0 , FpuRoundMode.RNE,"mul")

          for(_ <- 0 until 10000) testMulF64()
          println("f64 Mul done")

          testTransferF64Raw(1.0)
          testTransferF64Raw(2.0)
          testTransferF64Raw(2.5)
          testTransferF64Raw(6.97949770801e-39)
          testTransferF64Raw(8.72437213501e-40)
          testTransferF64Raw(5.6E-45)

          testTransferF32F64Raw(b2f(0xFFFF1234), false)
          testTransferF64F32Raw(b2d(0xFFF123498765463l << 4), false)
          testTransferF32F64Raw(b2f(0xFFFF1234), true)
          testTransferF64F32Raw(b2d(0xFFF123498765463l << 4), true)

          for (_ <- 0 until 10000) testTransferF64()
          println("f64 load/store/rf transfer done")

          for (_ <- 0 until 10000) testTransferF64F32()
          println("f64 -> f32 load/store/rf transfer done")

          for (_ <- 0 until 10000) testTransferF32F64()
          println("f32 -> f64 load/store/rf transfer done")

        }

        for(_ <- 0 until 10000) testTransferF32()
        println("f32 load/store/rf transfer done")

        for(_ <- 0 until 10000) testMulF32()
        println("Mul done")


        for(_ <- 0 until 10000) testUI2f32()
        for(_ <- 0 until 10000) testI2f32()
        println("i2f done")


        testF2iExact(1.0f,1, 0, false, FpuRoundMode.RTZ)
        testF2iExact(2.0f,2, 0, false, FpuRoundMode.RTZ)
        testF2iExact(2.5f,2, 1, false, FpuRoundMode.RTZ)





        for(_ <- 0 until 10000) testF2uiF32()
        for(_ <- 0 until 10000) testF2iF32()
        println("f2i done")



//        waitUntil(cmdQueue.isEmpty)
//        dut.clockDomain.waitSampling(1000)
//        simSuccess()



        for(i <- 0 until 1000) testFmaF32()
        flagClear()
        println("fma done") //TODO


        testF2iExact(-2.14748365E9f, -2147483648, 0, true, FpuRoundMode.RDN)

        testEqRaw(Float.PositiveInfinity,Float.PositiveInfinity,1, 0)
        testEqRaw(0f, 0f,1, 0)

        for(_ <- 0 until 10000) testLeF32()
        for(_ <- 0 until 10000) testLtF32()
        for(_ <- 0 until 10000) testEqF32()
        println("Cmp done")


        for(_ <- 0 until 10000) testDiv()
        println("f32 div done")

        for(_ <- 0 until 10000) testSqrt()
        println("f32 sqrt done")

        for(_ <- 0 until 10000) testSgnjF32()
        println("f32 sgnj done")


        for(_ <- 0 until 10000) testClassF32()
        println("f32 class done")


        for(_ <- 0 until 10000) testMinF32()
        for(_ <- 0 until 10000) testMaxF32()
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






        for(_ <- 0 until 10000) testAddF32()
        for(_ <- 0 until 10000) testSubF32()

        println("Add done")










//        waitUntil(cmdQueue.isEmpty)
//        dut.clockDomain.waitSampling(1000)
//        simSuccess()

        for(i <- 0 until 100000) fxxTests.randomPick()()
        waitUntil(cpu.rspQueue.isEmpty)
      }




      stim.foreach(_.join())
      dut.clockDomain.waitSampling(100)
    }
  }
}


//object Clib {
//  val java_home = System.getProperty("java.home")
//  assert(java_home != "" && java_home != null, "JAVA_HOME need to be set")
//  val jdk = java_home.replace("/jre","").replace("\\jre","")
//  val jdkIncludes = jdk + "/include"
//  val flags   = List("-fPIC", "-m64", "-shared", "-Wno-attributes") //-Wl,--whole-archive
//  val os = new File("/media/data/open/SaxonSoc/berkeley-softfloat-3/build/Linux-x86_64-GCC").listFiles().map(_.getAbsolutePath).filter(_.toString.endsWith(".o"))
//  val cmd = s"gcc -I/media/data/open/SaxonSoc/berkeley-softfloat-3/source/include -I$jdkIncludes  -I$jdkIncludes/linux ${flags.mkString(" ")} -o src/test/cpp/fpu/math/fpu_math.so src/test/cpp/fpu/math/fpu_math.c src/test/cpp/fpu/math/softfloat.a" // src/test/cpp/fpu/math/softfloat.a
//  DoCmd.doCmd(cmd)
//  val math = new FpuMath
//}
// cd /media/data/open/SaxonSoc/testFloatBuild/berkeley-softfloat-3/build/Linux-x86_64-GCC
// make clean && SPECIALIZE_TYPE=RISCV make -j$(nproc) && cp softfloat.a /media/data/open/SaxonSoc/artyA7SmpUpdate/SaxonSoc/ext/VexRiscv/src/test/cpp/fpu/math
//object FpuCompileSo extends App{
//
////  val b2f = lang.Float.intBitsToFloat(_)
////  for(e <- FpuRoundMode.elements) {
////    println(e)
////    for (i <- -2 until 50) println(i + " => " + Clib.math.addF32(b2f(0x7f000000), b2f(0x7f000000 + i), e.position))
////    println("")
////  }
//  //1 did not equal 3 Flag missmatch dut=1 ref=3 ## mul 0.9994812 -1.1754988E-38 -1.174889E-38 RMM
//  //  println(Clib.math.mulF32(0.9994812f, -1.1754988E-38f, FpuRoundMode.RMM.position))
////  miaou ffffffff 7fffffe0 7f
////  miaou 0 3ffffff0 70 = 0
//
//  val b2f = lang.Float.intBitsToFloat(_)
//  val b2d = lang.Double.longBitsToDouble(_)
//  val f2b = lang.Float.floatToRawIntBits(_)
//  val d2bOffset = BigInt("10000000000000000",16)
//  def d2b(that : Double) = {
//    val l = lang.Double.doubleToRawLongBits(that)
//    var a = BigInt(l)
//    if(l < 0) {
//      a = d2bOffset + a
//    }
//    a
//  }
//  val builder =new  StringBuilder()
//  for(i <- 0 until 256){
////    builder ++= (Clib.math.mulF32(1.17548538251e-38f, b2f(f2b(1.0f)+i),0)).toString + "\n"
//    val b = d2b(1.17549435082e-38)
//    val s = (b-(i.toLong << 25)).toLong
//    val d = b2d(s)
//    builder ++= f"$b $s $d => "
//    builder ++= f"${d2b(d)}%x   " + (Clib.math.d2fFlag(d,0)).toString + " " + d + " => " + (Clib.math.d2f(d,FpuRoundMode.RMM.position)).toString + "\n"
//  }
//
//  Thread.sleep(400)
//  println(builder.toString)
//    println(Clib.math.mulF32( 1.1753509E-38f, 1.0001221f, FpuRoundMode.RUP.position))
//    println(Clib.math.mulF32( 1.1754945E-38f, 0.9999998f, FpuRoundMode.RUP.position))
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
//}

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

