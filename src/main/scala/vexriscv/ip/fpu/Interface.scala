package vexriscv.ip.fpu

import spinal.core._
import spinal.lib._


object Fpu{

  object Function{
    val MUL = 0
    val ADD = 1
  }

}



case class FpuFloat(exponentSize: Int,
                    mantissaSize: Int) extends Bundle {
  val mantissa = UInt(mantissaSize bits)
  val exponent = UInt(exponentSize bits)
  val sign = Bool()

  def withInvertSign : FpuFloat ={
    val ret = FpuFloat(exponentSize,mantissaSize)
    ret.sign := !sign
    ret.exponent := exponent
    ret.mantissa := mantissa
    ret
  }
}

object FpuOpcode extends SpinalEnum{
  val LOAD, STORE, MUL, ADD, FMA, I2F, F2I, CMP, DIV, SQRT, MIN_MAX, SGNJ, FMV_X_W, FMV_W_X = newElement()
}

object FpuFormat extends SpinalEnum{
  val FLOAT, DOUBLE = newElement()
}


case class FpuParameter( internalMantissaSize : Int,
                         withDouble : Boolean){

  val storeLoadType = HardType(Bits(if(withDouble) 64 bits else 32 bits))
  val internalExponentSize = if(withDouble) 11 else 8
  val internalFloating = HardType(FpuFloat(exponentSize = internalExponentSize, mantissaSize = internalMantissaSize))

  val rfAddress = HardType(UInt(5 bits))

  val Opcode = FpuOpcode
  val Format = FpuFormat
}

case class FpuCmd(p : FpuParameter) extends Bundle{
  val opcode = p.Opcode()
  val value = Bits(32 bits) // Int to float
  val function = Bits(3 bits) // Int to float
  val rs1, rs2, rs3 = p.rfAddress()
  val rd = p.rfAddress()
  val format = p.Format()
}

case class FpuCommit(p : FpuParameter) extends Bundle{
  val write = Bool()
  val load = Bool()
  val value = p.storeLoadType() // IEEE 754
}

case class FpuRsp(p : FpuParameter) extends Bundle{
  val value = p.storeLoadType() // IEEE754 store || Integer
}

case class FpuPort(p : FpuParameter) extends Bundle with IMasterSlave {
  val cmd = Stream(FpuCmd(p))
  val commit = Stream(FpuCommit(p))
  val rsp = Stream(FpuRsp(p))

  override def asMaster(): Unit = {
    master(cmd, commit)
    slave(rsp)
  }
}
