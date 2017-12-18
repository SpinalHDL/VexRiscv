package vexriscv

import spinal.sim._
import spinal.core.sim._
import spinal.core.{Bool, assert}

object UartDecoder {
  def apply(uartPin : Bool, baudPeriod : Long) = fork{
    waitUntil(uartPin.toBoolean == true)

    while(true) {
      waitUntil(uartPin.toBoolean == false)
      sleep(baudPeriod/2)

      assert(uartPin.toBoolean == false)
      sleep(baudPeriod)

      var buffer = 0
      (0 to 7).suspendable.foreach{ bitId =>
        if(uartPin.toBoolean)
          buffer |= 1 << bitId
        sleep(baudPeriod)
      }

      assert(uartPin.toBoolean == true)
      print(buffer.toChar)
    }
  }
}
