package spinal.lib.misc

import spinal.core._

object HexTools{
  def readHexFile(path : String, callback : (Int, Int) => Unit, hexOffset : Int = 0): Unit ={
    import scala.io.Source
    def hToI(that : String, start : Int, size : Int) = Integer.parseInt(that.substring(start,start + size), 16)

    var offset = 0
    for (line <- Source.fromFile(path).getLines) {
      if (line.charAt(0) == ':'){
        val byteCount = hToI(line, 1, 2)
        val nextAddr = hToI(line, 3, 4) + offset
        val key = hToI(line, 7, 2)
        key match {
          case 0 =>
            for(i <- 0 until byteCount){
              callback(nextAddr + i - hexOffset, hToI(line, 9 + i * 2, 2))
            }
          case 2 =>
            offset = hToI(line, 9, 4) << 4
          case 4 =>
            offset = hToI(line, 9, 4) << 16
          case 3 =>
          case 5 =>
          case 1 =>
        }
      }
    }
  }

  def initRam[T <: Data](ram : Mem[T], onChipRamHexFile : String, hexOffset : BigInt): Unit ={
    val initContent = Array.fill[BigInt](ram.wordCount)(0)
    HexTools.readHexFile(onChipRamHexFile,(address,data) => {
      val addressWithoutOffset = (address - hexOffset).toInt
      initContent(addressWithoutOffset >> 2) |= BigInt(data) << ((addressWithoutOffset & 3)*8)
    })
    ram.initBigInt(initContent)
  }
}