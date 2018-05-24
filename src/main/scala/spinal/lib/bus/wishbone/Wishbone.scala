package spinal.lib.bus.wishbone

import spinal.core._
import spinal.lib._

/** This class is used for configuring the Wishbone class
  * @param addressWidth size in bits of the address line
  * @param dataWidth size in bits of the data line
  * @param selWidth size in bits of the selection line, deafult to 0 (disabled)
  * @param useSTALL activate the stall line, default to false (disabled)
  * @param useLOCK activate the lock line, default to false (disabled)
  * @param useERR activate the error line, default to false (disabled)
  * @param useRTY activate the retry line, default to false (disabled)
  * @param tgaWidth size in bits of the tag address linie, deafult to 0 (disabled)
  * @param tgcWidth size in bits of the tag cycle line, deafult to 0 (disabled)
  * @param tgdWidth size in bits of the tag data line, deafult to 0 (disabled)
  * @param useBTE activate the BTE line, deafult to 0 (disabled)
  * @param useCTI activate the CTI line, deafult to 0 (disabled)
  * @example {{{
  * val wishboneBusConf = new WishboneConfig(32,8).withCycleTag(8).withDataTag(8)
  * val wishboneBus = new Wishbone(wishboneBusConf)
  * }}}
  * @todo test example
  */
case class WishboneConfig(
                           val addressWidth : Int,
                           val dataWidth : Int,
                           val selWidth : Int = 0,
                           val useSTALL : Boolean = false,
                           val useLOCK : Boolean = false,
                           val useERR : Boolean = false,
                           val useRTY : Boolean = false,
                           val tgaWidth : Int = 0,
                           val tgcWidth : Int = 0,
                           val tgdWidth : Int = 0,
                           val useBTE : Boolean = false,
                           val useCTI : Boolean = false
                         ){
  def useTGA = tgaWidth > 0
  def useTGC = tgcWidth > 0
  def useTGD = tgdWidth > 0
  def useSEL = selWidth > 0
  def isPipelined = useSTALL
  def pipelined : WishboneConfig = this.copy(useSTALL = true)
  def withDataTag(size : Int)    : WishboneConfig = this.copy(tgdWidth = size)
  def withAddressTag(size : Int) : WishboneConfig = this.copy(tgaWidth = size)
  def withCycleTag(size : Int)   : WishboneConfig = this.copy(tgdWidth = size)
}

/** This class rappresent a Wishbone bus
  * @param config an istance of WishboneConfig, it will be used to configurate the Wishbone Bus
  */
case class Wishbone(config: WishboneConfig) extends Bundle with IMasterSlave {
  /////////////////////
  // MINIMAL SIGNALS //
  /////////////////////
  val CYC       = Bool
  val STB       = Bool
  val ACK       = Bool
  val WE        = Bool
  val ADR       = UInt(config.addressWidth bits)
  val DAT_MISO  = Bits(config.dataWidth bits)
  val DAT_MOSI  = Bits(config.dataWidth bits)

  ///////////////////////////
  // OPTIONAL FLOW CONTROS //
  ///////////////////////////
  val SEL       = if(config.useSEL)   Bits(config.selWidth bits) else null
  val STALL     = if(config.useSTALL) Bool                       else null
  val LOCK      = if(config.useLOCK)  Bool                       else null
  val ERR       = if(config.useERR)   Bool                       else null
  val RTY       = if(config.useRTY)   Bool                       else null

  //////////
  // TAGS //
  //////////
  val TGD_MISO  = if(config.useTGD)   Bits(config.tgdWidth bits) else null
  val TGD_MOSI  = if(config.useTGD)   Bits(config.tgdWidth bits) else null
  val TGA       = if(config.useTGA)   Bits(config.tgaWidth bits) else null
  val TGC       = if(config.useTGC)   Bits(config.tgcWidth bits) else null
  val BTE       = if(config.useBTE)   Bits(2 bits)               else null
  val CTI       = if(config.useCTI)   Bits(3 bits)               else null

  override def asMaster(): Unit = {
    outWithNull(DAT_MOSI, TGD_MOSI, ADR, CYC, LOCK, SEL, STB, TGA, TGC, WE, CTI, BTE)
    inWithNull(DAT_MISO, TGD_MISO, ACK, STALL, ERR, RTY)
  }

  // def isCycle : Bool = if(config.useERR) !ERR && CYC else CYC
  // def isWrite : Bool = isCycle && WE
  // def isRead : Bool  = isCycle && !WE
  // def isReadCycle : Bool = isRead && STB
  // def isWriteCycle : Bool = isWrite && STB
  // def isStalled : Bool = if(config.isPipelined) isCycle && STALL else False
  // def isAcknoledge : Bool = isCycle && ACK
  // def isStrobe : Bool = isCycle && STB

  // def doSlaveWrite : Bool = this.CYC && this.STB && this.WE
  // def doSlaveRead : Bool = this.CYC && this.STB && !this.WE
  // def doSlavePipelinedWrite : Bool = this.CYC && this.WE
  // def doSlavePipelinedRead : Bool = this.CYC && !this.WE

  /** Connect the istance of this bus with another, allowing for resize of data
    * @param that the wishbone instance that will be connected and resized
    * @param allowDataResize allow to resize "that" data lines, default to false (disable)
    * @param allowAddressResize allow to resize "that" address lines, default to false (disable)
    * @param allowTagResize allow to resize "that" tag lines, default to false (disable)
    */
  def connectTo(that : Wishbone, allowDataResize : Boolean = false, allowAddressResize : Boolean = false, allowTagResize : Boolean = false) : Unit = {
    this.CYC      <> that.CYC
    this.STB      <> that.STB
    this.WE       <> that.WE
    this.ACK      <> that.ACK

    if(allowDataResize){
      this.DAT_MISO.resized <> that.DAT_MISO
      this.DAT_MOSI <> that.DAT_MOSI.resized
    } else {
      this.DAT_MOSI <> that.DAT_MOSI
      this.DAT_MISO <> that.DAT_MISO
    }

    if(allowAddressResize){
      this.ADR <> that.ADR.resized
    } else {
      this.ADR <> that.ADR
    }

    ///////////////////////////
    // OPTIONAL FLOW CONTROS //
    ///////////////////////////
    if(this.config.useSTALL && that.config.useSTALL) this.STALL <> that.STALL
    if(this.config.useERR   && that.config.useERR)   this.ERR   <> that.ERR
    if(this.config.useRTY   && that.config.useRTY)   this.RTY   <> that.RTY
    if(this.config.useSEL   && that.config.useSEL)   this.SEL   <> that.SEL
    if(this.config.useCTI   && that.config.useCTI)   this.CTI   <> that.CTI

    //////////
    // TAGS //
    //////////
    if(this.config.useTGA && that.config.useTGA)
      if(allowTagResize) this.TGA <> that.TGA.resized else this.TGA <> that.TGA

    if(this.config.useTGC && that.config.useTGC)
      if(allowTagResize) this.TGC <> that.TGC.resized else this.TGC <> that.TGC

    if(this.config.useBTE && that.config.useBTE)
      if(allowTagResize) this.BTE <> that.BTE.resized else this.BTE <> that.BTE

    if(this.config.useTGD && that.config.useTGD){
      if(allowTagResize){
        this.TGD_MISO <> that.TGD_MISO.resized
        this.TGD_MOSI <> that.TGD_MOSI.resized
      } else {
        this.TGD_MISO <> that.TGD_MISO
        this.TGD_MOSI <> that.TGD_MOSI
      }
    }
  }

  /** Connect common Wishbone signals
    * @example{{{wishbone1 <-> wishbone2}}}
    */
  def <-> (sink : Wishbone) : Unit = {
    /////////////////////
    // MINIMAL SIGNALS //
    /////////////////////
    sink.CYC      <> this.CYC
    sink.ADR      <> this.ADR
    sink.DAT_MOSI <> this.DAT_MOSI
    sink.DAT_MISO <> this.DAT_MISO
    sink.STB      <> this.STB
    sink.WE       <> this.WE
    sink.ACK      <> this.ACK

    ///////////////////////////
    // OPTIONAL FLOW CONTROS //
    ///////////////////////////
    if(this.config.useSTALL && sink.config.useSTALL) sink.STALL <> this.STALL
    if(this.config.useERR   && sink.config.useERR)   sink.ERR   <> this.ERR
    if(this.config.useRTY   && sink.config.useRTY)   sink.RTY   <> this.RTY
    if(this.config.useSEL   && sink.config.useSEL)   sink.SEL   <> this.SEL

    //////////
    // TAGS //
    //////////
    if(this.config.useTGA && sink.config.useTGA) sink.TGA <> this.TGA
    if(this.config.useTGC && sink.config.useTGC) sink.TGC <> this.TGC
    if(this.config.useCTI && sink.config.useCTI) sink.CTI <> this.CTI
    if(this.config.useBTE && sink.config.useBTE) sink.BTE <> this.BTE
    if(this.config.useTGD && sink.config.useTGD){
      sink.TGD_MISO  <> this.TGD_MISO
      sink.TGD_MOSI  <> this.TGD_MOSI
    }
  }

  /** Clear all the relevant signals in the wishbone bus
    * @example{{{
    * val wishbone1 = master(Wishbone(WishboneConfig(8,8)))
    * val wishbone2 = slave(Wishbone(WishboneConfig(8,8)))
    * val wishbone2 = slave(Wishbone(WishboneConfig(8,8).withDataTag(8)))
    *
    * // this will clear only the following signals: CYC,ADR,DAT_MOSI,STB,WE
    * wishbone1.clearAll()
    * // this will clear only the following signals: DAT_MISO,ACK
    * wishbone2.clearAll()
    * // this will clear only the following signals: DAT_MISO,ACK,TGD_MISO
    * wishbone3.clearAll()
    * }}}
    */
  def clearAll() : Unit = {
    /////////////////////
    // MINIMAl SIGLALS //
    /////////////////////
    if( isMasterInterface) this.CYC.clear()
    if( isMasterInterface) this.ADR.clearAll()
    if( isMasterInterface) this.DAT_MOSI.clearAll()
    if(!isMasterInterface) this.DAT_MISO.clearAll()
    if( isMasterInterface) this.STB.clear()
    if( isMasterInterface) this.WE.clear()
    if(!isMasterInterface) this.ACK.clear()

    ///////////////////////////
    // OPTIONAL FLOW CONTROS //
    ///////////////////////////
    if(this.config.useSTALL && !isMasterInterface) this.STALL.clear()
    if(this.config.useERR   && !isMasterInterface) this.ERR.clear()
    if(this.config.useRTY   && !isMasterInterface) this.RTY.clear()
    if(this.config.useSEL   &&  isMasterInterface) this.SEL.clearAll()

    //////////
    // TAGS //
    //////////
    if(this.config.useTGA &&  isMasterInterface) this.TGA.clearAll()
    if(this.config.useTGC &&  isMasterInterface) this.TGC.clearAll()
    if(this.config.useCTI &&  isMasterInterface) this.CTI.clearAll()
    if(this.config.useBTE &&  isMasterInterface) this.BTE.clearAll()
    if(this.config.useTGD && !isMasterInterface) this.TGD_MISO.clearAll()
    if(this.config.useTGD &&  isMasterInterface) this.TGD_MOSI.clearAll()
  }
}
