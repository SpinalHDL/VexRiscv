package vexriscv.ip.fpu

import java.lang

import org.scalatest.FunSuite
import spinal.core.SpinalEnumElement
import spinal.core.sim._
import spinal.lib.experimental.math.Floating
import spinal.lib.sim._

import scala.collection.mutable
import scala.collection.mutable.ArrayBuffer
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
      withDouble = false
    )

    SimConfig.withFstWave.compile(new FpuCore(portCount, p)).doSim(seed = 42){ dut =>
      dut.clockDomain.forkStimulus(10)




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
            cmd.value.randomize()
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
            cmd.value.randomize()
            cmd.rs1 #= rs
            cmd.rs2.randomize()
            cmd.rs3.randomize()
            cmd.rd.randomize()
            cmd.arg.randomize()
          }

          rspQueue += body
        }

        def storeFloat(rs : Int)(body : Float => Unit): Unit ={
          storeRaw(rs){rsp => body(b2f(rsp.value.toLong.toInt))}
        }

        def mul(rd : Int, rs1 : Int, rs2 : Int): Unit ={
          cmdQueue += {cmd =>
            cmd.opcode #= cmd.opcode.spinalEnum.MUL
            cmd.value.randomize()
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

        def add(rd : Int, rs1 : Int, rs2 : Int): Unit ={
          cmdQueue += {cmd =>
            cmd.opcode #= cmd.opcode.spinalEnum.ADD
            cmd.value.randomize()
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

        def div(rd : Int, rs1 : Int, rs2 : Int): Unit ={
          cmdQueue += {cmd =>
            cmd.opcode #= cmd.opcode.spinalEnum.DIV
            cmd.value.randomize()
            cmd.rs1 #= rs1
            cmd.rs2 #= rs2
            cmd.rs3.randomize()
            cmd.rd #= rd
            cmd.arg.randomize()
          }
          commitQueue += {cmd =>
            cmd.write #= true
            cmd.sync #= false
          }
        }

        def sqrt(rd : Int, rs1 : Int): Unit ={
          cmdQueue += {cmd =>
            cmd.opcode #= cmd.opcode.spinalEnum.SQRT
            cmd.value.randomize()
            cmd.rs1 #= rs1
            cmd.rs2.randomize()
            cmd.rs3.randomize()
            cmd.rd #= rd
            cmd.arg.randomize()
          }
          commitQueue += {cmd =>
            cmd.write #= true
            cmd.sync #= false
          }
        }

        def fma(rd : Int, rs1 : Int, rs2 : Int, rs3 : Int): Unit ={
          cmdQueue += {cmd =>
            cmd.opcode #= cmd.opcode.spinalEnum.FMA
            cmd.value.randomize()
            cmd.rs1 #= rs1
            cmd.rs2 #= rs2
            cmd.rs3 #= rs3
            cmd.rd #= rd
            cmd.arg #= 0
          }
          commitQueue += {cmd =>
            cmd.write #= true
            cmd.sync #= false
          }
        }


        def cmp(rs1 : Int, rs2 : Int)(body : FpuRsp => Unit): Unit ={
          cmdQueue += {cmd =>
            cmd.opcode #= cmd.opcode.spinalEnum.CMP
            cmd.value.randomize()
            cmd.rs1 #= rs1
            cmd.rs2 #= rs2
            cmd.rs3.randomize()
            cmd.rd.randomize()
            cmd.arg #= 1
          }
          rspQueue += body
        }

        def f2i(rs1 : Int, signed : Boolean)(body : FpuRsp => Unit): Unit ={
          cmdQueue += {cmd =>
            cmd.opcode #= cmd.opcode.spinalEnum.F2I
            cmd.value.randomize()
            cmd.rs1 #= rs1
            cmd.rs2.randomize()
            cmd.rs3.randomize()
            cmd.rd.randomize()
            cmd.arg #= (if(signed) 1 else 0)
          }
          rspQueue += body
        }

        def i2f(rd : Int, value : Int, signed : Boolean): Unit ={
          cmdQueue += {cmd =>
            cmd.opcode #= cmd.opcode.spinalEnum.I2F
            cmd.value #= value.toLong & 0xFFFFFFFFl
            cmd.rs1.randomize()
            cmd.rs2.randomize()
            cmd.rs3.randomize()
            cmd.rd #= rd
            cmd.arg #= (if(signed) 1 else 0)
          }
          commitQueue += {cmd =>
            cmd.write #= true
            cmd.sync #= false
          }
        }

        def fmv_x_w(rs1 : Int)(body : FpuRsp => Unit): Unit ={
          cmdQueue += {cmd =>
            cmd.opcode #= cmd.opcode.spinalEnum.FMV_X_W
            cmd.value.randomize()
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
            cmd.value.randomize()
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
            cmd.value.randomize()
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
            cmd.value.randomize()
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

        def testAdd(a : Float, b : Float): Unit ={
          val rs = new RegAllocator()
          val rs1, rs2, rs3 = rs.allocate()
          val rd = Random.nextInt(32)
          load(rs1, a)
          load(rs2, b)

          add(rd,rs1,rs2)
          storeFloat(rd){v =>
            val a_ = clamp(a)
            val b_ = clamp(b)
            val ref = clamp(a_ + b_)
            println(f"$a + $b = $v, $ref")
            assert(checkFloat(ref, v))
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
            val ref = a.toInt
            val v = (rsp.value.toBigInt & 0xFFFFFFFF).toInt
            println(f"f2i($a) = $v, $ref")
            assert(v === ref)
          }
        }

        def testI2f(a : Int, signed : Boolean): Unit ={
          val rs = new RegAllocator()
          val rd = Random.nextInt(32)
          i2f(rd, a, signed)
          storeFloat(rd){v =>
            val ref = a.toInt
            println(f"i2f($a) = $v, $ref")
            assert(v === ref)
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
