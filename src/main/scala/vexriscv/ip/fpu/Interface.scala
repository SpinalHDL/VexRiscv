package vexriscv.ip.fpu

import spinal.core._
import spinal.lib._


object Fpu{

  object Function{
    val MUL = 0
    val ADD = 1
  }

}


case class FpuFloatDecoded() extends Bundle{
  val isNan = Bool()
  val isNormal = Bool()
  val isSubnormal = Bool()
  val isZero = Bool()
  val isInfinity = Bool()
  val isQuiet = Bool()
}

object FpuFloat{
  val ZERO = 0
  val SUBNORMAL = 1
  val INFINITY = 2
  val NAN = 3
}

case class FpuFloat(exponentSize: Int,
                    mantissaSize: Int) extends Bundle {
  val mantissa = UInt(mantissaSize bits)
  val exponent = UInt(exponentSize bits)
  val sign = Bool()
  val special = Bool()

  def withInvertSign : FpuFloat ={
    val ret = FpuFloat(exponentSize,mantissaSize)
    ret.sign := !sign
    ret.exponent := exponent
    ret.mantissa := mantissa
    ret
  }


  def isZeroOrSubnormal =  special && exponent(1) === False

  def isNormal    = !special
  def isZero      =  special && exponent(1 downto 0) === 0
  //def isSubnormal =  special && exponent(1 downto 0) === 1
  def isInfinity  =  special && exponent(1 downto 0) === 2
  def isNan       =  special && exponent(1 downto 0) === 3
  def isQuiet     =  mantissa.msb

  def setNormal    =  { special := False }
  def setZero      =  { special := True; exponent(1 downto 0) := 0 }
  //def setSubnormal =  { special := True; exponent(1 downto 0) := 1 }
  def setInfinity  =  { special := True; exponent(1 downto 0) := 2 }
  def setNan       =  { special := True; exponent(1 downto 0) := 3 }
  def setNanQuiet  =  { special := True; exponent(1 downto 0) := 3; mantissa.msb := True }

  def decode() = {
    val ret = FpuFloatDecoded()
    ret.isZero      := isZero
    ret.isNormal    := isNormal
    ret.isInfinity  := isInfinity
    ret.isNan       := isNan
    ret.isQuiet     := mantissa.msb
    ret
  }

  def decodeIeee754() = {
    val ret = FpuFloatDecoded()
    val expZero = exponent === 0
    val expOne = exponent === exponent.maxValue
    val manZero = mantissa === 0
    ret.isZero := expZero && manZero
    ret.isSubnormal := expZero && !manZero
    ret.isNormal := !expOne && !expZero
    ret.isInfinity := expOne && manZero
    ret.isNan := expOne && !manZero
    ret.isQuiet := mantissa.msb
    ret
  }
}

object FpuOpcode extends SpinalEnum{
  val LOAD, STORE, MUL, ADD, FMA, I2F, F2I, CMP, DIV, SQRT, MIN_MAX, SGNJ, FMV_X_W, FMV_W_X, FCLASS = newElement()
}

object FpuFormat extends SpinalEnum{
  val FLOAT, DOUBLE = newElement()
}


case class FpuParameter( internalMantissaSize : Int,
                         withDouble : Boolean){

  val storeLoadType = HardType(Bits(if(withDouble) 64 bits else 32 bits))
  val internalExponentSize = (if(withDouble) 11 else 8) + 1
  val internalFloating = HardType(FpuFloat(exponentSize = internalExponentSize, mantissaSize = internalMantissaSize))

  val rfAddress = HardType(UInt(5 bits))

  val Opcode = FpuOpcode
  val Format = FpuFormat
  val argWidth = 2
  val Arg = HardType(Bits(2 bits))
}

case class FpuFlags() extends Bundle{
  val NX,  UF,  OF,  DZ,  NV = Bool()
}

case class FpuCompletion() extends Bundle{
  val flag = FpuFlags()
  val count = UInt(2 bits)
}

case class FpuCmd(p : FpuParameter) extends Bundle{
  val opcode = p.Opcode()
  val value = Bits(32 bits) // Int to float
  val arg = Bits(2 bits) 
  val rs1, rs2, rs3 = p.rfAddress()
  val rd = p.rfAddress()
  val format = p.Format()
}

case class FpuCommit(p : FpuParameter) extends Bundle{
  val write = Bool()
  val sync = Bool()
  val value = p.storeLoadType() // IEEE 754
}

case class FpuRsp(p : FpuParameter) extends Bundle{
  val value = p.storeLoadType() // IEEE754 store || Integer
}

case class FpuPort(p : FpuParameter) extends Bundle with IMasterSlave {
  val cmd = Stream(FpuCmd(p))
  val commit = Stream(FpuCommit(p))
  val rsp = Stream(FpuRsp(p))
  val completion = FpuCompletion()

  override def asMaster(): Unit = {
    master(cmd, commit)
    slave(rsp)
    in(completion)
  }
}
