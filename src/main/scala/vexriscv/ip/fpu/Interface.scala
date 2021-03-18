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
  val INFINITY = 1
  val NAN = 2
  val NAN_CANONICAL_BIT = 2
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

  def isNormal    = !special
  def isZero      =  special && exponent(1 downto 0) === FpuFloat.ZERO
  def isInfinity  =  special && exponent(1 downto 0) === FpuFloat.INFINITY
  def isNan       =  special && exponent(1 downto 0) === FpuFloat.NAN
  def isQuiet     =  mantissa.msb
  def isNanSignaling  = special && exponent(1 downto 0) === FpuFloat.NAN && !isQuiet
  def isCanonical = exponent(FpuFloat.NAN_CANONICAL_BIT)

  def setNormal    =  { special := False }
  def setZero      =  { special := True; exponent(1 downto 0) := FpuFloat.ZERO }
  def setInfinity  =  { special := True; exponent(1 downto 0) := FpuFloat.INFINITY }
  def setNan       =  { special := True; exponent(1 downto 0) := FpuFloat.NAN; exponent(FpuFloat.NAN_CANONICAL_BIT) := False}
  def setNanQuiet  =  { special := True; exponent(1 downto 0) := FpuFloat.NAN; exponent(FpuFloat.NAN_CANONICAL_BIT) := True; mantissa.msb := True; }

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
  val LOAD, STORE, MUL, ADD, FMA, I2F, F2I, CMP, DIV, SQRT, MIN_MAX, SGNJ, FMV_X_W, FMV_W_X, FCLASS, FCVT_X_X = newElement()
}

object FpuFormat extends SpinalEnum{
  val FLOAT, DOUBLE = newElement()
}

object FpuRoundMode extends SpinalEnum(){
  val RNE, RTZ, RDN, RUP, RMM = newElement()
  defaultEncoding = SpinalEnumEncoding("opt")(
    RNE -> 0,
    RTZ -> 1,
    RDN -> 2,
    RUP -> 3,
    RMM -> 4
  )
}
object FpuRoundModeInstr extends SpinalEnum(){
  val RNE, RTZ, RDN, RUP, RMM, DYN = newElement()
  defaultEncoding = SpinalEnumEncoding("opt")(
    RNE -> 0,
    RTZ -> 1,
    RDN -> 2,
    RUP -> 3,
    RMM -> 4,
    DYN -> 7
  )
}


case class FpuParameter( withDouble : Boolean,
                         asyncRegFile : Boolean = false,
                         mulWidthA : Int = 18,
                         mulWidthB : Int = 18,
                         schedulerM2sPipe : Boolean = false,
                         sim : Boolean = false,
                         withAdd : Boolean = true,
                         withMul : Boolean = true,
                         withDivSqrt : Boolean = false,
                         withDiv : Boolean = true,
                         withSqrt : Boolean = true,
                         withShortPipMisc : Boolean = true){

  val internalMantissaSize = if(withDouble) 52 else 23
  val storeLoadType = HardType(Bits(if(withDouble) 64 bits else 32 bits))
  val internalExponentSize = (if(withDouble) 11 else 8) + 1
  val internalFloating = HardType(FpuFloat(exponentSize = internalExponentSize, mantissaSize = internalMantissaSize))
  val writeFloating = HardType(FpuFloat(exponentSize = internalExponentSize, mantissaSize = internalMantissaSize+1))

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
  val flags = FpuFlags()
  val written = Bool() //Used for verification purposes
}

case class FpuCmd(p : FpuParameter) extends Bundle{
  val opcode = p.Opcode()
  val arg = Bits(2 bits) 
  val rs1, rs2, rs3 = p.rfAddress()
  val rd = p.rfAddress()
  val format = p.Format()
  val roundMode = FpuRoundMode()
}

case class FpuCommit(p : FpuParameter) extends Bundle{
  val opcode = FpuOpcode()
  val rd = UInt(5 bits)
  val write = Bool()
  val value = p.storeLoadType() // IEEE 754
}

case class FpuRsp(p : FpuParameter) extends Bundle{
  val value = p.storeLoadType() // IEEE754 store || Integer
  val NV, NX = Bool()
}

case class FpuPort(p : FpuParameter) extends Bundle with IMasterSlave {
  val cmd = Stream(FpuCmd(p))
  val commit = Stream(FpuCommit(p))
  val rsp = Stream(FpuRsp(p))
  val completion = Flow(FpuCompletion())

  override def asMaster(): Unit = {
    master(cmd, commit)
    slave(rsp)
    in(completion)
  }
}
