package vexriscv
import java.awt.Graphics
import java.io.{InputStream, OutputStream}
import java.net.ServerSocket
import javax.swing.{JFrame, JPanel}

import spinal.sim._
import spinal.core._
import spinal.core.SimManagedApi._
import vexriscv.demo.{Murax, MuraxConfig}

import scala.concurrent.Future
import scala.util.Random
import scala.concurrent.ExecutionContext.Implicits.global

object MuraxSim {
  def main(args: Array[String]): Unit = {
//    val config = MuraxConfig.default.copy(onChipRamSize = 256 kB)
        val config = MuraxConfig.default.copy(onChipRamSize = 4 kB, onChipRamHexFile = "src/main/ressource/hex/muraxDemo.hex")

    SimConfig(new Murax(config)).doManagedSim{dut =>
      val mainClkPeriod = (1e12/dut.config.coreFrequency.toDouble).toLong
      val jtagClkPeriod = mainClkPeriod*4
      val uartBaudRate = 115200
      val uartBaudPeriod = (1e12/uartBaudRate).toLong

      val genClock = fork{
        dut.io.asyncReset #= true
        dut.io.mainClk #= false
        sleep(mainClkPeriod)
        dut.io.asyncReset #= false
        sleep(mainClkPeriod)

        var cycleCounter = 0l
        var lastTime = System.nanoTime()
        while(true){
          dut.io.mainClk #= false
          sleep(mainClkPeriod/2)
          dut.io.mainClk #= true
          sleep(mainClkPeriod/2)
          cycleCounter += 1
          if(cycleCounter == 100000){
            val currentTime = System.nanoTime()
//            println(f"${cycleCounter/((currentTime - lastTime)*1e-9)*1e-3}%4.0f kHz")
            lastTime = currentTime
            cycleCounter = 0
          }
        }
      }


      val jtag = fork {
        var inputStream : InputStream = null
        var outputStream : OutputStream = null

        val server = Future {
          val socket = new ServerSocket(7894)
          println("WAITING FOR TCP JTAG CONNECTION")
          while (true) {
            val connection = socket.accept()
            connection.setTcpNoDelay(true)
            outputStream = connection.getOutputStream()
            inputStream = connection.getInputStream()
            println("TCP JTAG CONNECTION")
          }
        }

        while(true) {
          sleep(mainClkPeriod * 1000)
          while(inputStream != null && inputStream.available() != 0){
            val buffer = inputStream.read()
            dut.io.jtag.tms #= (buffer & 1) != 0;
            dut.io.jtag.tdi #= (buffer & 2) != 0;
            dut.io.jtag.tck #= (buffer & 8) != 0;
            if((buffer & 4) != 0){
              outputStream.write(if(dut.io.jtag.tdo.toBoolean) 1 else 0)
            }
            sleep(jtagClkPeriod/2)
          }
        }
      }

      val uartTx = fork{
        waitUntil(dut.io.uart.txd.toBoolean == true)

        while(true) {
          waitUntil(dut.io.uart.txd.toBoolean == false)
          sleep(uartBaudPeriod/2)

          assert(dut.io.uart.txd.toBoolean == false)
          sleep(uartBaudPeriod)

          var buffer = 0
          (0 to 7).foreachSim{ bitId =>
            if(dut.io.uart.txd.toBoolean)
              buffer |= 1 << bitId
            sleep(uartBaudPeriod)
          }

          assert(dut.io.uart.txd.toBoolean == true)
          print(buffer.toChar)
        }
      }

      val uartRx = fork{
        dut.io.uart.rxd #= true
        while(true) {
          if(System.in.available() != 0){
            val buffer = System.in.read()
            dut.io.uart.rxd #= false
            sleep(uartBaudPeriod)

            (0 to 7).foreachSim{ bitId =>
              dut.io.uart.rxd #= ((buffer >> bitId) & 1) != 0
              sleep(uartBaudPeriod)
            }

            dut.io.uart.rxd #= true
            sleep(uartBaudPeriod)
          } else {
            sleep(uartBaudPeriod * 10)
          }
        }
      }


      val leds = fork{
        var ledsValue = 0l
        val ledsFrame = new JFrame{
          setContentPane(new DrawPane());
          setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
          setSize(400, 400);
          setVisible(true);

          //create a component that you can actually draw on.
          class DrawPane extends JPanel{
            override def paintComponent(g : Graphics) : Unit = {
              for(i <- 0 to 7) {
                if (((ledsValue >> i) & 1) != 0) {
                  g.fillRect(20*i, 20, 20, 20)
                }
              }
            }
          }
        }

        while(true){
          sleep(100000)
          ledsValue = dut.io.gpioA.write.toLong
          ledsFrame.repaint()
        }
      }


      genClock.join()
    }
  }
}
