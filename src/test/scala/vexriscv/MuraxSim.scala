package vexriscv

import java.awt
import java.awt.event.{ActionEvent, ActionListener}

import spinal.sim._
import spinal.core._
import spinal.core.sim._
import vexriscv.demo.{Murax, MuraxConfig}
import java.awt.{Color, Dimension, Graphics, GridLayout}
import javax.annotation.processing.SupportedSourceVersion
import javax.swing.{BoxLayout, JButton, JFrame, JPanel}

import spinal.lib.com.jtag.sim.JtagTcp
import spinal.lib.com.uart.sim.{UartDecoder, UartEncoder}

import scala.collection.mutable



object MuraxSim {
  def main(args: Array[String]): Unit = {
//    def config = MuraxConfig.default.copy(onChipRamSize = 256 kB)
    def config = MuraxConfig.default.copy(onChipRamSize = 4 kB, onChipRamHexFile = "src/main/ressource/hex/muraxDemo.hex")

    SimConfig.allOptimisation.compile(new Murax(config)).doSimUntilVoid{dut =>
      val mainClkPeriod = (1e12/dut.config.coreFrequency.toDouble).toLong
      val jtagClkPeriod = mainClkPeriod*4
      val uartBaudRate = 115200
      val uartBaudPeriod = (1e12/uartBaudRate).toLong

      val clockDomain = ClockDomain(dut.io.mainClk, dut.io.asyncReset)
      clockDomain.forkStimulus(mainClkPeriod)
//      clockDomain.forkSimSpeedPrinter(2)

      val tcpJtag = JtagTcp(
        jtag = dut.io.jtag,
        jtagClkPeriod = jtagClkPeriod
      )

      val uartTx = UartDecoder(
        uartPin = dut.io.uart.txd,
        baudPeriod = uartBaudPeriod
      )

      val uartRx = UartEncoder(
        uartPin = dut.io.uart.rxd,
        baudPeriod = uartBaudPeriod
      )


      val guiThread = fork{
        val guiToSim = mutable.Queue[Any]()

        var ledsValue = 0l
        val ledsFrame = new JFrame{
          setLayout(new BoxLayout(getContentPane, BoxLayout.Y_AXIS))
          add(new JPanel{
            val ledDiameter = 20
            val blackThickness = 2
            override def paintComponent(g : Graphics) : Unit = {
              for(i <- 0 to 7) {
                g.setColor(Color.BLACK)
                val x = i*ledDiameter + 1
                g.fillOval(x,1,ledDiameter,ledDiameter);
                if (((ledsValue >> (7-i)) & 1) != 0) {
                  g.setColor(Color.GREEN.darker())
                  g.fillOval(x+blackThickness,3,ledDiameter-blackThickness*2,ledDiameter-blackThickness*2);
                }
              }
              g.setColor(Color.BLACK)
            }
            this.setPreferredSize(new Dimension(ledDiameter*8+2, ledDiameter+2))
          })
          add(new JButton("Reset"){
            addActionListener(new ActionListener {
              override def actionPerformed(actionEvent: ActionEvent): Unit = {
                println("ASYNC RESET")
                guiToSim.enqueue("asyncReset")
              }
            })
            setAlignmentX(awt.Component.CENTER_ALIGNMENT)
          })
          setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE)
          pack()
          setVisible(true)

        }

        while(true){
          sleep(mainClkPeriod*50000)

          val dummy = if(guiToSim.nonEmpty){
            val request = guiToSim.dequeue()
            if(request == "asyncReset"){
              dut.io.asyncReset #= true
              sleep(mainClkPeriod*32)
              dut.io.asyncReset #= false
            }
          }

          ledsValue = dut.io.gpioA.write.toLong
          ledsFrame.repaint()
        }
      }
    }
  }
}
