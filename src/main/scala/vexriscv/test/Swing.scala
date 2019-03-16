package vexriscv.test

import java.awt.event.{MouseEvent, MouseListener}
import java.awt.{Color, Dimension, Graphics}
import javax.swing.JPanel

abstract class JLedArray(ledCount : Int,ledDiameter : Int = 20, blackThickness : Int = 2) extends JPanel{
  def getValue() : BigInt

  override def paintComponent(g : Graphics) : Unit = {
    val value = getValue()
    for(i <- 0 to ledCount-1) {
      g.setColor(Color.BLACK)
      val x = i*ledDiameter + 1
      g.fillOval(x,1,ledDiameter,ledDiameter)
      if (((value >> (ledCount-1-i)) & 1) != 0) {
        g.setColor(Color.GREEN.darker())
        g.fillOval(x+blackThickness,3,ledDiameter-blackThickness*2,ledDiameter-blackThickness*2);
      }
    }
    g.setColor(Color.BLACK)
  }
  this.setPreferredSize(new Dimension(ledDiameter*ledCount+2, ledDiameter+2))
}

class JSwitchArray(ledCount : Int,switchDiameter : Int = 20, blackThickness : Int = 2) extends JPanel{
  var value = BigInt(0)
  def getValue() = value
  addMouseListener(new MouseListener {
    override def mouseExited(mouseEvent: MouseEvent): Unit = {}
    override def mousePressed(mouseEvent: MouseEvent): Unit = {}
    override def mouseReleased(mouseEvent: MouseEvent): Unit = {}
    override def mouseEntered(mouseEvent: MouseEvent): Unit = {}
    override def mouseClicked(mouseEvent: MouseEvent): Unit = {
      val idx = ledCount-1-(mouseEvent.getX-2)/switchDiameter
      value ^= BigInt(1) << idx
    }
  })
  override def paintComponent(g : Graphics) : Unit = {
    for(i <- 0 to ledCount-1) {
      g.setColor(Color.GRAY.darker())
      val x = i*switchDiameter + 1
      g.fillRect(x,1,switchDiameter,switchDiameter)
      if (((value >> (ledCount-1-i)) & 1) != 0) {
        g.setColor(Color.GRAY)
      }else{
        g.setColor(Color.GRAY.brighter())
      }
      g.fillRect(x+blackThickness,3,switchDiameter-blackThickness*2,switchDiameter-blackThickness*2);

    }
    g.setColor(Color.BLACK)
  }
  this.setPreferredSize(new Dimension(switchDiameter*ledCount+2, switchDiameter+2))
}