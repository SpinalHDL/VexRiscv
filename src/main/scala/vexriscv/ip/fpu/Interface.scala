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
  val sign = Bool
}

case class FpuOpcode(p : FpuParameter) extends SpinalEnum{
  val LOAD, STORE, MUL, ADD, FMA, I2F, F2I, CMP, DIV, SQRT = newElement()
}

case class FpuParameter( internalMantissaSize : Int,
                         withDouble : Boolean,
                         sourceWidth : Int){

  val storeLoadType = HardType(Bits(if(withDouble) 64 bits else 32 bits))
  val internalExponentSize = if(withDouble) 11 else 8
  val internalFloating = HardType(FpuFloat(exponentSize = internalExponentSize, mantissaSize = internalMantissaSize))
//  val opcode = HardType(UInt(2 bits))
  val source = HardType(UInt(sourceWidth bits))
  val rfAddress = HardType(UInt(5 bits))

  val Opcode = new FpuOpcode(this)
  val Format = new SpinalEnum{
    val FLOAT = newElement()
    val DOUBLE = withDouble generate newElement()
  }
}

case class FpuCmd(p : FpuParameter) extends Bundle{
  val source = UInt(p.sourceWidth bits)
  val opcode = p.Opcode()
  val value = Bits(32 bits) // Int to float
  val function = Bits(3 bits) // Int to float
  val rs1, rs2, rs3 = p.rfAddress()
  val rd = p.rfAddress()
  val format = p.Format()
}

case class FpuCommit(p : FpuParameter) extends Bundle{
  val source = UInt(p.sourceWidth bits)
  val write = Bool()
  val value = p.storeLoadType() // IEEE 754 load
}

case class FpuRsp(p : FpuParameter) extends Bundle{
  val source = UInt(p.sourceWidth bits)
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
