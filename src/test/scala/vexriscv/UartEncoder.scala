package vexriscv

import spinal.sim._
import spinal.core.sim._
import spinal.core.Bool

object UartEncoder {
  def apply(uartPin : Bool, baudPeriod : Long) = fork{
    uartPin #= true
    while(true) {
      if(System.in.available() != 0){
        val buffer = System.in.read()
        uartPin #= false
        sleep(baudPeriod)

        (0 to 7).suspendable.foreach{ bitId =>
          uartPin #= ((buffer >> bitId) & 1) != 0
          sleep(baudPeriod)
        }

        uartPin #= true
        sleep(baudPeriod)
      } else {
        sleep(baudPeriod * 10)
      }
    }
  }
}
