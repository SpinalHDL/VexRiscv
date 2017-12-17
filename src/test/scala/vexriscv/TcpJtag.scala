package vexriscv

import java.io.{InputStream, OutputStream}
import java.net.ServerSocket

import spinal.core.SimManagedApi._
import spinal.lib.com.jtag.Jtag

import scala.concurrent.Future
import scala.concurrent.ExecutionContext.Implicits.global

object TcpJtag {
  def apply(jtag: Jtag, jtagClkPeriod: Long) = fork {
    var inputStream: InputStream = null
    var outputStream: OutputStream = null

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

    while (true) {
      sleep(jtagClkPeriod * 200)
      while (inputStream != null && inputStream.available() != 0) {
        val buffer = inputStream.read()
        jtag.tms #= (buffer & 1) != 0;
        jtag.tdi #= (buffer & 2) != 0;
        jtag.tck #= (buffer & 8) != 0;
        if ((buffer & 4) != 0) {
          outputStream.write(if (jtag.tdo.toBoolean) 1 else 0)
        }
        sleep(jtagClkPeriod / 2)
      }
    }
  }
}
