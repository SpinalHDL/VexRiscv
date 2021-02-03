package vexriscv.ip.fpu

import java.io.File
import java.lang
import java.util.Scanner

import org.apache.commons.io.FileUtils
import org.scalatest.FunSuite
import spinal.core.SpinalEnumElement
import spinal.core.sim._
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
  val f2b = lang.Float.floatToIntBits(_)

  def clamp(f : Float) = {
   f // if(f.abs < b2f(0x00800000)) b2f(f2b(f) & 0x80000000) else f
  }

  test("directed"){
    val portCount = 1
    val p = FpuParameter(
      internalMantissaSize = 23,
      withDouble = false,
      sim = true
    )

    val config = SimConfig
//    config.withFstWave
    config.compile(new FpuCore(portCount, p)).doSim(seed = 42){ dut =>
      dut.clockDomain.forkStimulus(10)
      dut.clockDomain.forkSimSpeedPrinter(5.0)



      class TestCase(op : String){
        def build(arg : String) = new ProcessStream(s"testfloat_gen $arg -forever -$op"){
          def f32_2 ={
            val s = new Scanner(next)
            (b2f(s.nextLong(16).toInt), b2f(s.nextLong(16).toInt), b2f(s.nextLong(16).toInt), s.nextInt(16))
          }

          def i32_f32 ={
            val s = new Scanner(next)
            (s.nextLong(16).toInt, b2f(s.nextLong(16).toInt), s.nextInt(16))
          }

          def f32_i32 = {
            val s = new Scanner(next)
            (b2f(s.nextLong(16).toInt), s.nextLong(16).toInt, s.nextInt(16))
          }
        }
        val RNE = build("-rnear_even")
        val RTZ = build("-rminMag")
        val RDN = build("-rmin")
        val RUP = build("-rmax")
        val RMM = build("-rnear_maxMag")
        val all = List(RNE, RTZ, RDN, RUP, RMM)
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
        val f2ui = new TestCase("f32_to_ui32")
        val f2i = new TestCase("f32_to_i32")
      }

      val cpus = for(id <- 0 until portCount) yield new {
        val cmdQueue = mutable.Queue[FpuCmd => Unit]()
        val commitQueue = mutable.Queue[FpuCommit => Unit]()
        val rspQueue = mutable.Queue[FpuRsp => Unit]()

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


        def loadRaw(rd : Int, value : BigInt): Unit ={
          cmdQueue += {cmd =>
            cmd.opcode #= cmd.opcode.spinalEnum.LOAD
            cmd.rs1.randomize()
            cmd.rs2.randomize()
            cmd.rs3.randomize()
            cmd.rd #= rd
            cmd.arg.randomize()
          }
          commitQueue += {cmd =>
            cmd.write #= true
            cmd.value #= value
            cmd.sync #= true
          }
        }

        def load(rd : Int, value : Float): Unit ={
          loadRaw(rd, lang.Float.floatToIntBits(value).toLong & 0xFFFFFFFFl)
        }

        def storeRaw(rs : Int)(body : FpuRsp => Unit): Unit ={
          cmdQueue += {cmd =>
            cmd.opcode #= cmd.opcode.spinalEnum.STORE
            cmd.rs1 #= rs
            cmd.rs2.randomize()
            cmd.rs3.randomize()
            cmd.rd.randomize()
            cmd.arg.randomize()
          }

          rspQueue += body
          waitUntil(rspQueue.isEmpty)
        }

        def storeFloat(rs : Int)(body : Float => Unit): Unit ={
          storeRaw(rs){rsp => body(b2f(rsp.value.toLong.toInt))}
        }

        def fpuF2f(rd : Int, rs1 : Int, rs2 : Int, rs3 : Int, opcode : FpuOpcode.E, arg : Int, rounding : FpuRoundMode.E = FpuRoundMode.RNE): Unit ={
          cmdQueue += {cmd =>
            cmd.opcode #= opcode
            cmd.rs1 #= rs1
            cmd.rs2 #= rs2
            cmd.rs3.randomize()
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
          cmdQueue += {cmd =>
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


        def cmp(rs1 : Int, rs2 : Int)(body : FpuRsp => Unit): Unit ={
          fpuF2i(rs1, rs2, FpuOpcode.CMP, 1, FpuRoundMode.elements.randomPick())(body)
        }

        def f2i(rs1 : Int, signed : Boolean, rounding : FpuRoundMode.E = FpuRoundMode.RNE)(body : FpuRsp => Unit): Unit ={
          fpuF2i(rs1, Random.nextInt(32), FpuOpcode.F2I, if(signed) 1 else 0, rounding)(body)
        }

        def i2f(rd : Int, value : Int, signed : Boolean, rounding : FpuRoundMode.E = FpuRoundMode.RNE): Unit ={
          cmdQueue += {cmd =>
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

        def fmv_x_w(rs1 : Int)(body : FpuRsp => Unit): Unit ={
          cmdQueue += {cmd =>
            cmd.opcode #= cmd.opcode.spinalEnum.FMV_X_W
            cmd.rs1 #= rs1
            cmd.rs2.randomize()
            cmd.rs3.randomize()
            cmd.rd.randomize()
            cmd.arg #= 0
          }
          rspQueue += body
        }

        def fmv_w_x(rd : Int, value : Int): Unit ={
          cmdQueue += {cmd =>
            cmd.opcode #= cmd.opcode.spinalEnum.FMV_W_X
            cmd.rs1.randomize()
            cmd.rs2.randomize()
            cmd.rs3.randomize()
            cmd.rd #= rd
            cmd.arg #= 0
          }
          commitQueue += {cmd =>
            cmd.write #= true
            cmd.sync #= true
            cmd.value #= value.toLong & 0xFFFFFFFFl
          }
        }

        def min(rd : Int, rs1 : Int, rs2 : Int): Unit ={
          cmdQueue += {cmd =>
            cmd.opcode #= cmd.opcode.spinalEnum.MIN_MAX
            cmd.rs1 #= rs1
            cmd.rs2 #= rs2
            cmd.rs3.randomize()
            cmd.rd #= rd
            cmd.arg #= 0
          }
          commitQueue += {cmd =>
            cmd.write #= true
            cmd.sync #= false
          }
        }


        def sgnj(rd : Int, rs1 : Int, rs2 : Int): Unit ={
          cmdQueue += {cmd =>
            cmd.opcode #= cmd.opcode.spinalEnum.SGNJ
            cmd.rs1 #= rs1
            cmd.rs2 #= rs2
            cmd.rs3.randomize()
            cmd.rd #= rd
            cmd.arg #= 0
          }
          commitQueue += {cmd =>
            cmd.write #= true
            cmd.sync #= false
          }
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

        def testAdd(a : Float, b : Float, rounding : FpuRoundMode.E = FpuRoundMode.RNE): Unit ={
          val rs = new RegAllocator()
          val rs1, rs2, rs3 = rs.allocate()
          val rd = Random.nextInt(32)
          load(rs1, a)
          load(rs2, b)

          add(rd,rs1,rs2, rounding)
          storeFloat(rd){v =>
            val a_ = clamp(a)
            val b_ = clamp(b)
            val ref = Clib.math.addF32(a,b, rounding.position)
            println(f"${a}%.19f  + $b%.19f = $v, $ref $rounding")
            println(f"${f2b(a).toHexString}  + ${f2b(b).toHexString}")
            assert(checkFloatExact(ref, v))
          }
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
        }

        def testAddExact(a : Float, b : Float, ref : Float, flag : Int, rounding : FpuRoundMode.E): Unit ={
          val rs = new RegAllocator()
          val rs1, rs2, rs3 = rs.allocate()
          val rd = Random.nextInt(32)
          load(rs1, a)
          load(rs2, b)
          add(rd,rs1,rs2, rounding)
          storeFloat(rd){v =>
            assert(f2b(v) == f2b(ref), f"## ${a}  + $b = $v, $ref $rounding")
          }
        }


        def testMulExact(a : Float, b : Float, ref : Float, flag : Int, rounding : FpuRoundMode.E): Unit ={
          val rs = new RegAllocator()
          val rs1, rs2, rs3 = rs.allocate()
          val rd = Random.nextInt(32)
          load(rs1, a)
          load(rs2, b)
          mul(rd,rs1,rs2, rounding)
          storeFloat(rd){v =>
            assert(f2b(v) == f2b(ref), f"## ${a}  * $b = $v, $ref $rounding")
          }
        }

        def testLoadStore(a : Float): Unit ={
          val rd = Random.nextInt(32)
          load(rd, a)
          storeFloat(rd){v =>
            val refUnclamped = a
            val ref = a
            println(f"$a = $v, $ref")
            assert(f2b(v) == f2b(ref))
          }
        }
        def testMul(a : Float, b : Float): Unit ={
          val rs = new RegAllocator()
          val rs1, rs2, rs3 = rs.allocate()
          val rd = Random.nextInt(32)
          load(rs1, a)
          load(rs2, b)

          mul(rd,rs1,rs2)
          storeFloat(rd){v =>
            val refUnclamped = a*b
            val refClamped = clamp(clamp(a)*clamp(b))
            val ref = if(refClamped.isNaN) refUnclamped else refClamped
            println(f"$a * $b = $v, $ref")
            var checkIt = true
            if(v == 0.0f && ref.abs == b2f(0x00800000)) checkIt = false //Rounding
            if(checkIt) assert(checkFloat(ref, v))
          }
        }



        def testFma(a : Float, b : Float, c : Float): Unit ={
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


        def testDiv(a : Float, b : Float): Unit ={
          val rs = new RegAllocator()
          val rs1, rs2, rs3 = rs.allocate()
          val rd = Random.nextInt(32)
          load(rs1, a)
          load(rs2, b)

          div(rd,rs1,rs2)
          storeFloat(rd){v =>
            val refUnclamped = a/b
            val refClamped = clamp(clamp(a)/clamp(b))
            val ref = refClamped
            val error = Math.abs(ref-v)/ref
            println(f"$a / $b = $v, $ref $error")
            assert(checkFloat(ref, v))
          }
        }

        def testSqrt(a : Float): Unit ={
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

        def testF2i(a : Float, signed : Boolean): Unit ={
          val rs = new RegAllocator()
          val rs1, rs2, rs3 = rs.allocate()
          val rd = Random.nextInt(32)
          load(rs1, a)
          f2i(rs1, signed){rsp =>
            if(signed) {
              val ref = a.toInt
              val v = (rsp.value.toBigInt & 0xFFFFFFFFl).toInt
              println(f"f2i($a) = $v, $ref")
              if (a.abs < 1024 * 1024) assert(v == ref)
              assert(checkFloat(v, ref))
            } else {
              val ref = a.toLong.min(0xFFFFFFFFl)
              val v = (rsp.value.toBigInt & 0xFFFFFFFFl).toLong
              println(f"f2i($a) = $v, $ref")
              if (a.abs < 1024 * 1024) assert(v == ref)
              assert(checkFloat(v, ref))
            }
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
        }


        def testI2f(a : Int, signed : Boolean): Unit ={
          val rs = new RegAllocator()
          val rd = Random.nextInt(32)
          i2f(rd, a, signed)
          storeFloat(rd){v =>
            val aLong = if(signed) a.toLong else a.toLong & 0xFFFFFFFFl
            val ref = if(signed) a.toFloat else (a.toLong & 0xFFFFFFFFl).toFloat
            println(f"i2f($aLong) = $v, $ref")
            if(ref.abs < (1 << 22)) assert(v === ref)
            assert(checkFloat(v, ref))
          }
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
        }


        def testCmp(a : Float, b : Float): Unit ={
          val rs = new RegAllocator()
          val rs1, rs2, rs3 = rs.allocate()
          val rd = Random.nextInt(32)
          load(rs1, a)
          load(rs2, b)
          cmp(rs1, rs2){rsp =>
            var ref = if(a < b) 1 else 0
            if(a.isNaN || b.isNaN){
              ref = 0
            }
            val v = rsp.value.toBigInt
            println(f"$a < $b = $v, $ref")
            assert(v === ref)
          }
        }

        def testFmv_x_w(a : Float): Unit ={
          val rs = new RegAllocator()
          val rs1, rs2, rs3 = rs.allocate()
          val rd = Random.nextInt(32)
          load(rs1, a)
          fmv_x_w(rs1){rsp =>
            val ref = lang.Float.floatToIntBits(a).toLong & 0xFFFFFFFFl
            val v = rsp.value.toBigInt
            println(f"fmv_x_w $a = $v, $ref")
            assert(v === ref)
          }
        }

        def testFmv_w_x(a : Int): Unit ={
          val rs = new RegAllocator()
          val rs1, rs2, rs3 = rs.allocate()
          val rd = Random.nextInt(32)
          fmv_w_x(rd, a)
          storeFloat(rd){v =>
            val ref = b2f(a)
            println(f"fmv_w_x $a = $v, $ref")
            assert(v === ref)
          }
        }



        def testMin(a : Float, b : Float): Unit ={
          val rs = new RegAllocator()
          val rs1, rs2, rs3 = rs.allocate()
          val rd = Random.nextInt(32)
          load(rs1, a)
          load(rs2, b)

          min(rd,rs1,rs2)
          storeFloat(rd){v =>
            val ref = (a,b) match {
              case _ if a.isNaN => b
              case _ if b.isNaN => a
              case _ => Math.min(a,b)
            }
            println(f"min $a $b = $v, $ref")
            assert(f2b(ref) ==  f2b(v))
          }
        }

        def testSgnj(a : Float, b : Float): Unit ={
          val rs = new RegAllocator()
          val rs1, rs2, rs3 = rs.allocate()
          val rd = Random.nextInt(32)
          load(rs1, a)
          load(rs2, b)

          sgnj(rd,rs1,rs2)
          storeFloat(rd){v =>
            val ref = a * a.signum * b.signum
            println(f"sgnf $a $b = $v, $ref")
            assert(ref ==  v)
          }
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

        testI2f(24, false)
        testI2f(17, false)

        testLoadStore(2.5f)
        testLoadStore(3.67341984632e-40f)
        testLoadStore(5.5321021294e-40f)


        for(_ <- 0 until 100000){
          val rounding = FpuRoundMode.elements.randomPick()
          val (a,b,c,f) = f32.add(rounding).f32_2
          testBinaryOp(add,a,b,c,f, rounding,"add")
        }

        for(_ <- 0 until 100000){
          val rounding = FpuRoundMode.elements.randomPick()
          val (a,b,c,f) = f32.sub(rounding).f32_2
          testBinaryOp(sub,a,b,c,f, rounding,"sub")
        }

        println("Add done")

        for(_ <- 0 until 100000){
          val rounding = FpuRoundMode.elements.randomPick()
          val (a,b,f) = f32.i2f(rounding).i32_f32
          testI2fExact(a,b,f, true, rounding)
        }

        for(_ <- 0 until 100000){
          val rounding = FpuRoundMode.elements.randomPick()
          val (a,b,f) = f32.ui2f(rounding).i32_f32
          testI2fExact(a,b,f, false, rounding)
        }
        println("i2f done")

        for(_ <- 0 until 100000){
          val rounding = FpuRoundMode.elements.randomPick()
          val (a,b,f) = f32.f2ui(rounding).f32_i32
          testF2iExact(a,b, f, false, rounding)
        }

        for(_ <- 0 until 100000){
          val rounding = FpuRoundMode.elements.randomPick()
          val (a,b,f) = f32.f2i(rounding).f32_i32
          testF2iExact(a,b, f, true, rounding)
        }

        println("f2i done")



        for(_ <- 0 until 100000){
          val rounding = FpuRoundMode.elements.randomPick()
          val (a,b,c,f) = f32.mul(rounding).f32_2
          testBinaryOp(mul,a,b,c,f, rounding,"mul")
        }

        println("Mul done")





        waitUntil(cmdQueue.isEmpty)
        dut.clockDomain.waitSampling(1000)
        simSuccess()

        //TODO test and fix a - b rounding
        foreachRounding(testAdd(1.0f, b2f(0x3f800001), _)) //1.00001
        foreachRounding(testAdd(4.0f, b2f(0x3f800001), _)) //1.00001
        for(_ <- 0 until 10000; a = randomFloat(); b = randomFloat()) foreachRounding(testAdd(a.abs, b.abs,_)) //TODO negative


        testAdd(b2f(0x3f800000), b2f(0x3f800000-1))
        testAdd(1.1f, 2.3f)
        testAdd(1.2f, -1.2f)
        testAdd(-1.2f, 1.2f)
        testAdd(0.0f, -1.2f)
        testAdd(-0.0f, -1.2f)
        testAdd(1.2f, -0f)
        testAdd(1.2f, 0f)
        testAdd(1.1f, Float.MinPositiveValue)

        for(a <- fAll; _ <- 0 until 50) testAdd(a, randomFloat())
        for(b <- fAll; _ <- 0 until 50) testAdd(randomFloat(), b)
        for(a <- fAll; b <- fAll) testAdd(a, b)
        for(_ <- 0 until 1000) testAdd(randomFloat(), randomFloat())


        testLoadStore(1.17549435082e-38f)
        testLoadStore(1.4E-45f)
        testLoadStore(3.44383110592e-41f)

//TODO bring back those tests and test overflow / underflow (F2I)
//        testF2i(16.0f  , false)
//        testF2i(18.0f  , false)
//        testF2i(1200.0f, false)
//        testF2i(1.0f   , false)
//        testF2i(0.0f   , false)
//        testF2i(1024*1024*1024*2l   , false)
//        testF2i(1024*1024*4095l   , false)
//        testF2i(1024*1024*5000l   , false)
//
//        val f2iUnsigned = ((0l to 32l) ++ (4060 to 4095).map(_*1024*1024l)).map(_.toFloat) ++ List(-0.0f)
//        val f2iSigned = ((-32 to 32) ++ ((2030 to 2047)++(-2047 to -2030)).map(_*1024*1024)).map(_.toFloat) ++ List(-0.0f)
//        for(f <- f2iUnsigned) testF2i(f, false)
//        for(f <- f2iSigned) testF2i(f, true)
//        for(f <- fAll) testF2i(f, false)
//        for(f <- fAll) testF2i(f, true)
//        for(_ <- 0 until 1000) testF2i(Random.nextFloat(), Random.nextBoolean())







        testLoadStore(1.2f)
        testMul(1.2f, 2.5f)
        testMul(b2f(0x00400000), 16.0f)
        testMul(b2f(0x00100000), 16.0f)
        testMul(b2f(0x00180000), 16.0f)
        testMul(b2f(0x00000004), 16.0f)
        testMul(b2f(0x00000040), 16.0f)
        testMul(b2f(0x00000041), 16.0f)
        testMul(b2f(0x00000001), b2f(0x00000001))
        testMul(1.0f, b2f(0x00000001))
        testMul(0.5f, b2f(0x00000001))

        //        dut.clockDomain.waitSampling(1000)
        //        simSuccess()

        testMul(1.2f, 0f)
        for(a <- fAll; _ <- 0 until 50) testMul(a, randomFloat())
        for(b <- fAll; _ <- 0 until 50) testMul(randomFloat(), b)
        for(a <- fAll; b <- fAll) testMul(a, b)
        for(_ <- 0 until 1000) testMul(randomFloat(), randomFloat())



        testLoadStore(1.765f)
        testFmv_w_x(lang.Float.floatToIntBits(7.234f))
        testI2f(64, false)
        for(i <- iUnsigned) testI2f(i, false)
        for(i <- iSigned) testI2f(i, true)
        for(_ <- 0 until 1000) testI2f(Random.nextInt(), Random.nextBoolean())


        testCmp(0.0f, 1.2f )
        testCmp(1.2f, 0.0f )
        testCmp(0.0f, -0.0f )
        testCmp(-0.0f, 0.0f )
        for(a <- fAll; _ <- 0 until 50) testCmp(a, randomFloat())
        for(b <- fAll; _ <- 0 until 50) testCmp(randomFloat(), b)
        for(a <- fAll; b <- fAll) testCmp(a, b)
        for(_ <- 0 until 1000) testCmp(randomFloat(), randomFloat())

        testMin(0.0f, 1.2f )
        testMin(1.2f, 0.0f )
        testMin(0.0f, -0.0f )
        testMin(-0.0f, 0.0f )
        for(a <- fAll; _ <- 0 until 50) testMin(a, randomFloat())
        for(b <- fAll; _ <- 0 until 50) testMin(randomFloat(), b)
        for(a <- fAll; b <- fAll) testMin(a, b)
        for(_ <- 0 until 1000) testMin(randomFloat(), randomFloat())

        testSqrt(1.2f)
        testSqrt(0.0f)
        for(a <- fAll) testSqrt(a)
        for(_ <- 0 until 1000) testSqrt(randomFloat())


        testDiv(0.0f, 1.2f )
        testDiv(1.2f, 0.0f )
        testDiv(0.0f, 0.0f )
        for(a <- fAll; _ <- 0 until 50) testDiv(a, randomFloat())
        for(b <- fAll; _ <- 0 until 50) testDiv(randomFloat(), b)
        for(a <- fAll; b <- fAll) testDiv(a, b)
        for(_ <- 0 until 1000) testDiv(randomFloat(), randomFloat())









        //        dut.clockDomain.waitSampling(10000000)


        testFmv_x_w(1.246f)
        testFmv_w_x(lang.Float.floatToIntBits(7.234f))

        testMin(1.0f, 2.0f)
        testMin(1.5f, 2.0f)
        testMin(1.5f, 3.5f)
        testMin(1.5f, 1.5f)
        testMin(1.5f, -1.5f)
        testMin(-1.5f, 1.5f)
        testMin(-1.5f, -1.5f)
        testMin(1.5f, -3.5f)

        testSgnj(1.0f, 2.0f)
        testSgnj(1.5f, 2.0f)
        testSgnj(1.5f, 3.5f)
        testSgnj(1.5f, 1.5f)
        testSgnj(1.5f, -1.5f)
        testSgnj(-1.5f, 1.5f)
        testSgnj(-1.5f, -1.5f)
        testSgnj(1.5f, -3.5f)



        //TODO Test corner cases
        for(signed <- List(false, true)) {
          testI2f(17, signed)
          testI2f(12, signed)
          testI2f(512, signed)
          testI2f(1, signed)
        }

        testI2f(-17, true)
        testI2f(-12, true)
        testI2f(-512, true)
        testI2f(-1, true)
//        dut.clockDomain.waitSampling(1000)
//        simFailure()

        //TODO Test corner cases
        testCmp(1.0f, 2.0f)
        testCmp(1.5f, 2.0f)
        testCmp(1.5f, 3.5f)
        testCmp(1.5f, 1.5f)
        testCmp(1.5f, -1.5f)
        testCmp(-1.5f, 1.5f)
        testCmp(-1.5f, -1.5f)
        testCmp(1.5f, -3.5f)

        //TODO Test corner cases
        for(signed <- List(false, true)) {
          testF2i(16.0f, signed)
          testF2i(18.0f, signed)
          testF2i(1200.0f, signed)
          testF2i(1.0f, signed)
        }

        testF2i(-16.0f, true)
        testF2i(-18.0f, true)
        testF2i(-1200.0f, true)
        testF2i(-1.0f, true)


        testAdd(0.1f, 1.6f)

        testSqrt(1.5625f)
        testSqrt(1.5625f*2)
        testSqrt(1.8f)
        testSqrt(4.4f)
        testSqrt(0.3f)
        testSqrt(1.5625f*2)
        testSqrt(b2f(0x3f7ffffe))
        testSqrt(b2f(0x3f7fffff))
        testSqrt(b2f(0x3f800000))
        testSqrt(b2f(0x3f800001))
        testSqrt(b2f(0x3f800002))
        testSqrt(b2f(0x3f800003))



        testMul(0.1f, 1.6f)
        testFma(1.1f, 2.2f, 3.0f)
        testDiv(1.0f, 1.1f)
        testDiv(1.0f, 1.5f)
        testDiv(1.0f, 1.9f)
        testDiv(1.1f, 1.9f)
        testDiv(1.0f, b2f(0x3f7ffffe))
        testDiv(1.0f, b2f(0x3f7fffff))
        testDiv(1.0f, b2f(0x3f800000))
        testDiv(1.0f, b2f(0x3f800001))
        testDiv(1.0f, b2f(0x3f800002))


        for(i <- 0 until 1000){
          testMul(randomFloat(), randomFloat())
        }
        for(i <- 0 until 1000){
          testFma(randomFloat(), randomFloat(), randomFloat())
        }
        for(i <- 0 until 1000){
          testDiv(randomFloat(), randomFloat())
        }
        for(i <- 0 until 1000){
          testSqrt(Math.abs(randomFloat()))
        }
        for(i <- 0 until 1000){
          testCmp(randomFloat(), randomFloat())
        }
        for(i <- 0 until 1000){
          val tests = ArrayBuffer[() => Unit]()
          tests += (() =>{testAdd(randomFloat(), randomFloat())})
          tests += (() =>{testMul(randomFloat(), randomFloat())})
          tests += (() =>{testFma(randomFloat(), randomFloat(), randomFloat())})
          tests += (() =>{testDiv(randomFloat(), randomFloat())})
          tests += (() =>{testSqrt(randomFloat().abs)})
          tests += (() =>{testCmp(randomFloat(), randomFloat())})
          tests += (() =>{testFmv_x_w(randomFloat())})
          tests += (() =>{testFmv_w_x(lang.Float.floatToIntBits(randomFloat()))})
          tests += (() =>{testMin(randomFloat(), randomFloat())})
          tests += (() =>{testSgnj(randomFloat(), randomFloat())})


          tests.randomPick().apply()
        }
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

object FpuCompileSo extends App{

  val b2f = lang.Float.intBitsToFloat(_)
  for(e <- FpuRoundMode.elements) {
    println(e)
    for (i <- -2 until 50) println(i + " => " + Clib.math.addF32(b2f(0x7f000000), b2f(0x7f000000 + i), e.position))
    println("")
  }

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
