package vexriscv

import spinal.core._


object Riscv{
  def funct7Range = 31 downto 25
  def rdRange = 11 downto 7
  def funct3Range = 14 downto 12
  def rs1Range = 19 downto 15
  def rs2Range = 24 downto 20
  def csrRange = 31 downto 20

  case class IMM(instruction  : Bits) extends Area{
    // immediates
    def i = instruction(31 downto 20)
    def s = instruction(31 downto 25) ## instruction(11 downto 7)
    def b = instruction(31) ## instruction(7) ## instruction(30 downto 25) ## instruction(11 downto 8)
    def u = instruction(31 downto 12) ## U"x000"
    def j = instruction(31) ## instruction(19 downto 12) ## instruction(20) ## instruction(30 downto 21)
    def z = instruction(19 downto 15)

    // sign-extend immediates
    def i_sext = B((19 downto 0) -> i(11)) ## i
    def s_sext = B((19 downto 0) -> s(11)) ## s
    def b_sext = B((18 downto 0) -> b(11)) ## b ## False
    def j_sext = B((10 downto 0) -> j(19)) ## j ## False
  }


  def ADD                = M"0000000----------000-----0110011"
  def SUB                = M"0100000----------000-----0110011"
  def SLL                = M"0000000----------001-----0110011"
  def SLT                = M"0000000----------010-----0110011"
  def SLTU               = M"0000000----------011-----0110011"
  def XOR                = M"0000000----------100-----0110011"
  def SRL                = M"0000000----------101-----0110011"
  def SRA                = M"0100000----------101-----0110011"
  def OR                 = M"0000000----------110-----0110011"
  def AND                = M"0000000----------111-----0110011"

  def ADDI               = M"-----------------000-----0010011"
  def SLLI               = M"000000-----------001-----0010011"
  def SLTI               = M"-----------------010-----0010011"
  def SLTIU              = M"-----------------011-----0010011"
  def XORI               = M"-----------------100-----0010011"
  def SRLI               = M"000000-----------101-----0010011"
  def SRAI               = M"010000-----------101-----0010011"
  def ORI                = M"-----------------110-----0010011"
  def ANDI               = M"-----------------111-----0010011"

  def LB                 = M"-----------------000-----0000011"
  def LH                 = M"-----------------001-----0000011"
  def LW                 = M"-----------------010-----0000011"
  def LBU                = M"-----------------100-----0000011"
  def LHU                = M"-----------------101-----0000011"
  def LWU                = M"-----------------110-----0000011"
  def SB                 = M"-----------------000-----0100011"
  def SH                 = M"-----------------001-----0100011"
  def SW                 = M"-----------------010-----0100011"

  def LR                 = M"00010--00000-----010-----0101111"
  def SC                 = M"00011------------010-----0101111"

  def AMOSWAP            = M"00001------------010-----0101111"
  def AMOADD             = M"00000------------010-----0101111"
  def AMOXOR             = M"00100------------010-----0101111"
  def AMOAND             = M"01100------------010-----0101111"
  def AMOOR              = M"01000------------010-----0101111"
  def AMOMIN             = M"10000------------010-----0101111"
  def AMOMAX             = M"10100------------010-----0101111"
  def AMOMINU            = M"11000------------010-----0101111"
  def AMOMAXU            = M"11100------------010-----0101111"

  def BEQ (rvc : Boolean) = if(rvc) M"-----------------000-----1100011" else M"-----------------000---0-1100011"
  def BNE (rvc : Boolean) = if(rvc) M"-----------------001-----1100011" else M"-----------------001---0-1100011"
  def BLT (rvc : Boolean) = if(rvc) M"-----------------100-----1100011" else M"-----------------100---0-1100011"
  def BGE (rvc : Boolean) = if(rvc) M"-----------------101-----1100011" else M"-----------------101---0-1100011"
  def BLTU(rvc : Boolean) = if(rvc) M"-----------------110-----1100011" else M"-----------------110---0-1100011"
  def BGEU(rvc : Boolean) = if(rvc) M"-----------------111-----1100011" else M"-----------------111---0-1100011"
  def JALR               = M"-----------------000-----1100111"
  def JAL(rvc : Boolean) = if(rvc) M"-------------------------1101111" else M"----------0--------------1101111"
  def LUI                = M"-------------------------0110111"
  def AUIPC              = M"-------------------------0010111"

  def MULX               = M"0000001----------0-------0110011"
  def DIVX               = M"0000001----------1-------0110011"

  def MUL                = M"0000001----------000-----0110011"
  def MULH               = M"0000001----------001-----0110011"
  def MULHSU             = M"0000001----------010-----0110011"
  def MULHU              = M"0000001----------011-----0110011"


  def DIV                = M"0000001----------100-----0110011"
  def DIVU               = M"0000001----------101-----0110011"
  def REM                = M"0000001----------110-----0110011"
  def REMU               = M"0000001----------111-----0110011"



  def CSRRW              = M"-----------------001-----1110011"
  def CSRRS              = M"-----------------010-----1110011"
  def CSRRC              = M"-----------------011-----1110011"
  def CSRRWI             = M"-----------------101-----1110011"
  def CSRRSI             = M"-----------------110-----1110011"
  def CSRRCI             = M"-----------------111-----1110011"

  def ECALL              = M"00000000000000000000000001110011"
  def EBREAK             = M"00000000000100000000000001110011"
  def FENCEI             = M"00000000000000000001000000001111"
  def MRET               = M"00110000001000000000000001110011"
  def SRET               = M"00010000001000000000000001110011"
  def WFI                = M"00010000010100000000000001110011"

  def FENCE              = M"-----------------000-----0001111"
  def FENCE_I            = M"-----------------001-----0001111"
  def SFENCE_VMA         = M"0001001----------000000001110011"

  object CSR{
    def MVENDORID = 0xF11 // MRO Vendor ID.
    def MARCHID   = 0xF12 // MRO Architecture ID.
    def MIMPID    = 0xF13 // MRO Implementation ID.
    def MHARTID   = 0xF14 // MRO Hardware thread ID.Machine Trap Setup
    def MSTATUS   = 0x300 // MRW Machine status register.
    def MISA      = 0x301 // MRW ISA and extensions
    def MEDELEG   = 0x302 // MRW Machine exception delegation register.
    def MIDELEG   = 0x303 // MRW Machine interrupt delegation register.
    def MIE       = 0x304 // MRW Machine interrupt-enable register.
    def MTVEC     = 0x305 // MRW Machine trap-handler base address. Machine Trap Handling
    def MSCRATCH  = 0x340 // MRW Scratch register for machine trap handlers.
    def MEPC      = 0x341 // MRW Machine exception program counter.
    def MCAUSE    = 0x342 // MRW Machine trap cause.
    def MBADADDR  = 0x343 // MRW Machine bad address.
    def MIP       = 0x344 // MRW Machine interrupt pending.
    def MBASE     = 0x380 // MRW Base register.
    def MBOUND    = 0x381 // MRW Bound register.
    def MIBASE    = 0x382 // MRW Instruction base register.
    def MIBOUND   = 0x383 // MRW Instruction bound register.
    def MDBASE    = 0x384 // MRW Data base register.
    def MDBOUND   = 0x385 // MRW Data bound register.
    def MCYCLE    = 0xB00 // MRW Machine cycle counter.
    def MINSTRET  = 0xB02 // MRW Machine instructions-retired counter.
    def MCYCLEH   = 0xB80 // MRW Upper 32 bits of mcycle, RV32I only.
    def MINSTRETH = 0xB82 // MRW Upper 32 bits of minstret, RV32I only.

    val SSTATUS     = 0x100
    val SIE         = 0x104
    val STVEC       = 0x105
    val SCOUNTEREN  = 0x106
    val SSCRATCH    = 0x140
    val SEPC        = 0x141
    val SCAUSE      = 0x142
    val SBADADDR    = 0x143
    val SIP         = 0x144
    val SATP        = 0x180



    def UCYCLE    = 0xC00 // UR Machine ucycle counter.
    def UCYCLEH   = 0xC80
    def UINSTRET  = 0xC02 // UR Machine instructions-retired counter.
    def UINSTRETH = 0xC82 // UR Upper 32 bits of minstret, RV32I only.
  }
}
