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


  test("directed"){
    val p = FpuParameter(
      internalMantissaSize = 23,
      withDouble = false,
      sourceWidth = 0
    )

    SimConfig.withFstWave.compile(new FpuCore(p)).doSim(seed = 42){ dut =>
      dut.clockDomain.forkStimulus(10)




      val cpus = for(id <- 0 until 1 << p.sourceWidth) yield new {
        val cmdQueue = mutable.Queue[FpuCmd => Unit]()
        val commitQueue = mutable.Queue[FpuCommit => Unit]()
        val rspQueue = mutable.Queue[FpuRsp => Unit]()

        def loadRaw(rd : Int, value : BigInt): Unit ={
          cmdQueue += {cmd =>
            cmd.source #= id
            cmd.opcode #= cmd.opcode.spinalEnum.LOAD
            cmd.value.randomize()
            cmd.rs1.randomize()
            cmd.rs2.randomize()
            cmd.rs3.randomize()
            cmd.rd #= rd
          }
          commitQueue += {cmd =>
            cmd.source #= id
            cmd.write #= true
            cmd.value #= value
          }
        }

        def load(rd : Int, value : Float): Unit ={
          loadRaw(rd, lang.Float.floatToIntBits(value).toLong & 0xFFFFFFFFl)
        }

        def storeRaw(rs : Int)(body : FpuRsp => Unit): Unit ={
          cmdQueue += {cmd =>
            cmd.source #= id
            cmd.opcode #= cmd.opcode.spinalEnum.STORE
            cmd.value.randomize()
            cmd.rs1.randomize()
            cmd.rs2 #= rs
            cmd.rs3.randomize()
            cmd.rd.randomize()
          }

          rspQueue += body
        }

        def storeFloat(rs : Int)(body : Float => Unit): Unit ={
          storeRaw(rs){rsp => body(lang.Float.intBitsToFloat(rsp.value.toLong.toInt))}
        }

        def mul(rd : Int, rs1 : Int, rs2 : Int): Unit ={
          cmdQueue += {cmd =>
            cmd.source #= id
            cmd.opcode #= cmd.opcode.spinalEnum.MUL
            cmd.value.randomize()
            cmd.rs1 #= rs1
            cmd.rs2 #= rs2
            cmd.rs3.randomize()
            cmd.rd #= rd
          }
        }

        def add(rd : Int, rs1 : Int, rs2 : Int): Unit ={
          cmdQueue += {cmd =>
            cmd.source #= id
            cmd.opcode #= cmd.opcode.spinalEnum.ADD
            cmd.value.randomize()
            cmd.rs1 #= rs1
            cmd.rs2 #= rs2
            cmd.rs3.randomize()
            cmd.rd #= rd
          }
        }

        def div(rd : Int, rs1 : Int, rs2 : Int): Unit ={
          cmdQueue += {cmd =>
            cmd.source #= id
            cmd.opcode #= cmd.opcode.spinalEnum.DIV
            cmd.value.randomize()
            cmd.rs1 #= rs1
            cmd.rs2 #= rs2
            cmd.rs3.randomize()
            cmd.rd #= rd
          }
        }

        def sqrt(rd : Int, rs1 : Int): Unit ={
          cmdQueue += {cmd =>
            cmd.source #= id
            cmd.opcode #= cmd.opcode.spinalEnum.SQRT
            cmd.value.randomize()
            cmd.rs1 #= rs1
            cmd.rs2.randomize()
            cmd.rs3.randomize()
            cmd.rd #= rd
          }
        }

        def fma(rd : Int, rs1 : Int, rs2 : Int, rs3 : Int): Unit ={
          cmdQueue += {cmd =>
            cmd.source #= id
            cmd.opcode #= cmd.opcode.spinalEnum.FMA
            cmd.value.randomize()
            cmd.rs1 #= rs1
            cmd.rs2 #= rs2
            cmd.rs3 #= rs3
            cmd.rd #= rd
          }
        }
      }

      StreamDriver(dut.io.port.cmd ,dut.clockDomain){payload =>
        cpus.map(_.cmdQueue).filter(_.nonEmpty).toSeq match {
          case Nil => false
          case l => {
            l.randomPick().dequeue().apply(payload)
            true
          }
        }
      }

      StreamDriver(dut.io.port.commit ,dut.clockDomain){payload =>
        cpus.map(_.commitQueue).filter(_.nonEmpty).toSeq match {
          case Nil => false
          case l => {
            l.randomPick().dequeue().apply(payload)
            true
          }
        }
      }


      StreamMonitor(dut.io.port.rsp, dut.clockDomain){payload =>
        cpus(payload.source.toInt).rspQueue.dequeue().apply(payload)
      }

      StreamReadyRandomizer(dut.io.port.rsp, dut.clockDomain)





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
          ref.abs * 1.0001 > dut.abs && ref.abs * 0.9999 < dut.abs && ref.signum == dut.signum
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
            val ref = a+b
            println(f"$a + $b = $v, $ref")
            assert(checkFloat(ref, v))
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
            val ref = a*b
            println(f"$a * $b = $v, $ref")
            assert(checkFloat(ref, v))
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
            assert(checkFloat(ref.toFloat, v))
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
            val ref = a/b
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

        val b2f = lang.Float.intBitsToFloat(_)


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

        //        dut.clockDomain.waitSampling(1000)
//        simFailure()

        testAdd(0.1f, 1.6f)
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
          testAdd(randomFloat(), randomFloat())
        }
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
          testSqrt(Math.abs(randomFloat())) //TODO
        }
        for(i <- 0 until 1000){
          val tests = ArrayBuffer[() => Unit]()
          tests += (() =>{testAdd(randomFloat(), randomFloat())})
          tests += (() =>{testMul(randomFloat(), randomFloat())})
          tests += (() =>{testFma(randomFloat(), randomFloat(), randomFloat())})
          tests += (() =>{testDiv(randomFloat(), randomFloat())})
          tests += (() =>{testSqrt(randomFloat().abs)})
          tests.randomPick().apply()
        }
        waitUntil(cpu.rspQueue.isEmpty)
      }


      stim.foreach(_.join())
      dut.clockDomain.waitSampling(100)
    }
  }
}
