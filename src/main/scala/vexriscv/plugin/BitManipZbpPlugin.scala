/*
 * Copyright (c) 2020 Romain Dolbeau <romain.dolbeau@european-processor-initiative.eu>
 * MIT License
 * See the LICENSE file at the top level of this software distribution for details.
 */

package vexriscv.plugin
import spinal.core._
import vexriscv.{Stageable, DecoderService, VexRiscv}

/**
  * This plugin implements the Zbp extension (subset of the 'B' bit manipulation extension)
  * using V0.92 <https://github.com/riscv/riscv-bitmanip/blob/master/bitmanip-0.92.pdf>
  * for RV32
  */
object BitManipZbpPlugin {
  // enumeration for the bitwise operations
  object BitManipZbpBitwiseCtrlEnum extends SpinalEnum(binarySequential){
    val XNOR, ORN, ANDN = newElement()
  }
  // enumeration for the added operation (BITWISE is sub-selected by BitManipZbpBitwiseCtrlEnum)
  object BitManipZbpCtrlEnum extends SpinalEnum(binarySequential){
    val ROR, ROL, GREV, GORC, PACK, PACKU, PACKH, SHFL, UNSHFL, BITWISE = newElement()
  }
   object BITMANIPZBP_CTRL extends Stageable(BitManipZbpCtrlEnum())
   object BITMANIPZBP_BITWISE_CTRL extends Stageable(BitManipZbpBitwiseCtrlEnum())

   // function implementing the semantic of 32-bits generalized reverse
   def fun_grev( a:Bits, b:Bits ) : Bits = {
       val x1  = ((b&B"32'x00000001")===B"32'x00000001") ? (((a  & B"32'x55555555") |<< 1) | ((a  & B"32'xAAAAAAAA") |>> 1)) | a
       val x2  = ((b&B"32'x00000002")===B"32'x00000002") ? (((x1 & B"32'x33333333") |<< 2) | ((x1 & B"32'xCCCCCCCC") |>> 2)) | x1
       val x4  = ((b&B"32'x00000004")===B"32'x00000004") ? (((x2 & B"32'x0F0F0F0F") |<< 4) | ((x2 & B"32'xF0F0F0F0") |>> 4)) | x2
       val x8  = ((b&B"32'x00000008")===B"32'x00000008") ? (((x4 & B"32'x00FF00FF") |<< 8) | ((x4 & B"32'xFF00FF00") |>> 8)) | x4
       val x16 = ((b&B"32'x00000010")===B"32'x00000010") ? (((x8 & B"32'x0000FFFF") |<<16) | ((x8 & B"32'xFFFF0000") |>>16)) | x8
       x16 // return value
   }
   // function implementing the semantic of 32-bits generalized OR-combine
   def fun_gorc( a:Bits, b:Bits ) : Bits = {
       val x1  = ((b&B"32'x00000001")===B"32'x00000001") ? (a  | ((a  & B"32'x55555555") |<< 1) | ((a  & B"32'xAAAAAAAA") |>> 1)) | a
       val x2  = ((b&B"32'x00000002")===B"32'x00000002") ? (x1 | ((x1 & B"32'x33333333") |<< 2) | ((x1 & B"32'xCCCCCCCC") |>> 2)) | x1
       val x4  = ((b&B"32'x00000004")===B"32'x00000004") ? (x2 | ((x2 & B"32'x0F0F0F0F") |<< 4) | ((x2 & B"32'xF0F0F0F0") |>> 4)) | x2
       val x8  = ((b&B"32'x00000008")===B"32'x00000008") ? (x4 | ((x4 & B"32'x00FF00FF") |<< 8) | ((x4 & B"32'xFF00FF00") |>> 8)) | x4
       val x16 = ((b&B"32'x00000010")===B"32'x00000010") ? (x8 | ((x8 & B"32'x0000FFFF") |<<16) | ((x8 & B"32'xFFFF0000") |>>16)) | x8
       x16 // return value
   }

   // helper function for the implementation of the generalized shuffles
   def fun_shuffle32_stage(src:Bits, maskL:Bits, maskR:Bits, N:Int) : Bits = {
    val x = src & ~(maskL | maskR)
    val x2 = x | ((src |<< N) & maskL) | ((src |>> N) & maskR);
    return x2;
   }
   // function implementing the semantic of 32-bits generalized shuffle
   def fun_shfl32(a:Bits, b:Bits) : Bits = {
       val x = a;
       val x1 = ((b&B"32'x00000008")===B"32'x00000008") ? fun_shuffle32_stage(x , B"32'x00FF0000", B"32'x0000FF00", 8) | x;
       val x2 = ((b&B"32'x00000004")===B"32'x00000004") ? fun_shuffle32_stage(x1, B"32'x0F000F00", B"32'x00F000F0", 4) | x1;
       val x3 = ((b&B"32'x00000002")===B"32'x00000002") ? fun_shuffle32_stage(x2, B"32'x30303030", B"32'x0C0C0C0C", 2) | x2;
       val x4 = ((b&B"32'x00000001")===B"32'x00000001") ? fun_shuffle32_stage(x3, B"32'x44444444", B"32'x22222222", 1) | x3;
       return x4;
   }
   // function implementing the semantic of 32-bits generalized unshuffle
   def fun_unshfl32(a:Bits, b:Bits) : Bits = {
      val x = a;
      val x1 = ((b&B"32'x00000001")===B"32'x00000001") ? fun_shuffle32_stage(x , B"32'x44444444", B"32'x22222222", 1) | x;
      val x2 = ((b&B"32'x00000002")===B"32'x00000002") ? fun_shuffle32_stage(x1, B"32'x30303030", B"32'x0C0C0C0C", 2) | x1;
      val x3 = ((b&B"32'x00000004")===B"32'x00000004") ? fun_shuffle32_stage(x2, B"32'x0F000F00", B"32'x00F000F0", 4) | x2;
      val x4 = ((b&B"32'x00000008")===B"32'x00000008") ? fun_shuffle32_stage(x3, B"32'x00FF0000", B"32'x0000FF00", 8) | x3;
      return x4;
   }
 }

class BitManipZbpPlugin extends Plugin[VexRiscv]{
  import BitManipZbpPlugin._

  // whether we've matched one of our instruction
  object IS_BITMANIPZBP extends Stageable(Bool)

  //Callback to setup the plugin and ask for different services
  override def setup(pipeline: VexRiscv): Unit = {
    import pipeline.config._

    val immediateActions = List[(Stageable[_ <: BaseType],Any)](
      SRC1_CTRL                -> Src1CtrlEnum.RS,
      SRC2_CTRL                -> Src2CtrlEnum.IMI,
      REGFILE_WRITE_VALID      -> True,
      BYPASSABLE_EXECUTE_STAGE -> True,
      BYPASSABLE_MEMORY_STAGE  -> True,
      RS1_USE -> True,
      IS_BITMANIPZBP -> True
    )

    val nonImmediateActions = List[(Stageable[_ <: BaseType],Any)](
      SRC1_CTRL                -> Src1CtrlEnum.RS,
      SRC2_CTRL                -> Src2CtrlEnum.RS,
      REGFILE_WRITE_VALID      -> True,
      BYPASSABLE_EXECUTE_STAGE -> True,
      BYPASSABLE_MEMORY_STAGE  -> True,
      RS1_USE -> True,
      RS2_USE -> True,
      IS_BITMANIPZBP -> True
    )


    // must match the patterns in the B extension, of course
    // this may still change...
    def ROR_key =     M"0110000----------101-----0110011"
    def ROL_key =     M"0110000----------001-----0110011"
    def RORI_key =    M"01100------------101-----0010011"
    
    def XNOR_key =    M"0100000----------100-----0110011"
    def ANDN_key =    M"0100000----------111-----0110011"
    def ORN_key =     M"0100000----------110-----0110011"
    
    def GREV_key =    M"0110100----------101-----0110011"
    def GREVI_key =   M"01101------------101-----0010011"
    def GORC_key =    M"0010100----------101-----0110011"
    def GORCI_key =   M"00101------------101-----0010011"
    
    def PACK_key =    M"0000100----------100-----0110011"
    def PACKU_key =   M"0100100----------100-----0110011"
    def PACKH_key =   M"0000100----------111-----0110011"
    
    def SHFL_key  =   M"0000100----------001-----0110011"
    def UNSHFL_key =  M"0000100----------101-----0110011"
    def SHFLI_key =   M"000010-----------001-----0010011"
    def UNSHFLI_key = M"000010-----------101-----0010011"

    val decoderService = pipeline.service(classOf[DecoderService])

    decoderService.addDefault(IS_BITMANIPZBP, False)

    // register all the register-register forms with the decoder
    decoderService.add(List(
      ROR_key    -> (nonImmediateActions ++ List(BITMANIPZBP_CTRL -> BitManipZbpCtrlEnum.ROR)),
      ROL_key    -> (nonImmediateActions ++ List(BITMANIPZBP_CTRL -> BitManipZbpCtrlEnum.ROL)),
      GREV_key   -> (nonImmediateActions ++ List(BITMANIPZBP_CTRL -> BitManipZbpCtrlEnum.GREV)),
      GORC_key   -> (nonImmediateActions ++ List(BITMANIPZBP_CTRL -> BitManipZbpCtrlEnum.GORC)),
      XNOR_key   -> (nonImmediateActions ++ List(BITMANIPZBP_CTRL -> BitManipZbpCtrlEnum.BITWISE, BITMANIPZBP_BITWISE_CTRL -> BitManipZbpBitwiseCtrlEnum.XNOR)),
      ANDN_key   -> (nonImmediateActions ++ List(BITMANIPZBP_CTRL -> BitManipZbpCtrlEnum.BITWISE, BITMANIPZBP_BITWISE_CTRL -> BitManipZbpBitwiseCtrlEnum.ANDN)),
      ORN_key    -> (nonImmediateActions ++ List(BITMANIPZBP_CTRL -> BitManipZbpCtrlEnum.BITWISE, BITMANIPZBP_BITWISE_CTRL -> BitManipZbpBitwiseCtrlEnum.ORN)),
      PACK_key   -> (nonImmediateActions ++ List(BITMANIPZBP_CTRL -> BitManipZbpCtrlEnum.PACK)),
      PACKU_key  -> (nonImmediateActions ++ List(BITMANIPZBP_CTRL -> BitManipZbpCtrlEnum.PACKU)),
      PACKH_key  -> (nonImmediateActions ++ List(BITMANIPZBP_CTRL -> BitManipZbpCtrlEnum.PACKH)),
      SHFL_key   -> (nonImmediateActions ++ List(BITMANIPZBP_CTRL -> BitManipZbpCtrlEnum.SHFL)),
      UNSHFL_key -> (nonImmediateActions ++ List(BITMANIPZBP_CTRL -> BitManipZbpCtrlEnum.UNSHFL))
    ))

    // register all the register-immediate forms with the decoder
    decoderService.add(List(
      RORI_key    -> (immediateActions ++ List(BITMANIPZBP_CTRL -> BitManipZbpCtrlEnum.ROR)),
      GREVI_key   -> (immediateActions ++ List(BITMANIPZBP_CTRL -> BitManipZbpCtrlEnum.GREV)),
      GORCI_key   -> (immediateActions ++ List(BITMANIPZBP_CTRL -> BitManipZbpCtrlEnum.GORC)),
      SHFLI_key   -> (immediateActions ++ List(BITMANIPZBP_CTRL -> BitManipZbpCtrlEnum.SHFL)),
      UNSHFLI_key -> (immediateActions ++ List(BITMANIPZBP_CTRL -> BitManipZbpCtrlEnum.UNSHFL))
    ))
  }
  
  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    execute plug new Area{
      import execute._

      val bitwise = input(BITMANIPZBP_BITWISE_CTRL).mux(
        BitManipZbpBitwiseCtrlEnum.ANDN  -> (input(SRC1) & ~input(SRC2)),
        BitManipZbpBitwiseCtrlEnum.ORN   -> (input(SRC1) | ~input(SRC2)),
        BitManipZbpBitwiseCtrlEnum.XNOR  -> (input(SRC1) ^ ~input(SRC2))
      )

      // should there be other second-level mux the way it's done for BITWISE ? 
      val rotr = input(SRC1).rotateRight((input(SRC2)&31)(4 downto 0).asUInt)
      val rotl = input(SRC1).rotateLeft((input(SRC2)&31)(4 downto 0).asUInt)

      val grev = fun_grev(input(SRC1), input(SRC2))
      val gorc = fun_gorc(input(SRC1), input(SRC2))

      val pack = (input(SRC2)(15 downto 0) ## input(SRC1)(15 downto 0))
      val packu = (input(SRC2)(31 downto 16) ## input(SRC1)(31 downto 16))
      val packh = B"16'x0000" ## (input(SRC2)(7 downto 0) ## input(SRC1)(7 downto 0))

      val shfl = fun_shfl32(input(SRC1), input(SRC2))
      val unshfl = fun_unshfl32(input(SRC1), input(SRC2))

      when (input(IS_BITMANIPZBP)) {
      execute.output(REGFILE_WRITE_DATA) := input(BITMANIPZBP_CTRL).mux(
         BitManipZbpCtrlEnum.ROR -> rotr.asBits,
         BitManipZbpCtrlEnum.ROL -> rotl.asBits,
         BitManipZbpCtrlEnum.GREV -> grev.asBits,
         BitManipZbpCtrlEnum.GORC -> gorc.asBits,
         BitManipZbpCtrlEnum.PACK -> pack.asBits,
         BitManipZbpCtrlEnum.PACKU -> packu.asBits,
         BitManipZbpCtrlEnum.PACKH -> packh.asBits,
         BitManipZbpCtrlEnum.SHFL -> shfl.asBits,
         BitManipZbpCtrlEnum.UNSHFL -> unshfl.asBits,
	 BitManipZbpCtrlEnum.BITWISE -> bitwise.asBits
      )
      }
    }
  }
}
