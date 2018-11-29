package vexriscv.demo


import spinal.core._
import spinal.lib.bus.misc._
import spinal.lib._

import scala.collection.mutable
import scala.collection.mutable.ArrayBuffer

case class SimpleBusConfig(addressWidth : Int, dataWidth : Int)

case class SimpleBusCmd(config : SimpleBusConfig) extends Bundle{
  val wr = Bool
  val address = UInt(config.addressWidth bits)
  val data = Bits(config.dataWidth bits)
  val mask = Bits(4 bit)
}

case class SimpleBusRsp(config : SimpleBusConfig) extends Bundle{
  val data = Bits(config.dataWidth bits)
}

object SimpleBus{
  def apply(addressWidth : Int, dataWidth : Int) = new SimpleBus(SimpleBusConfig(addressWidth, dataWidth))
}
case class SimpleBus(config : SimpleBusConfig) extends Bundle with IMasterSlave {
  val cmd = Stream(SimpleBusCmd(config))
  val rsp = Flow(SimpleBusRsp(config))

  override def asMaster(): Unit = {
    master(cmd)
    slave(rsp)
  }

  def <<(m : SimpleBus) : Unit = {
    val s = this
    assert(m.config.addressWidth >= s.config.addressWidth)
    assert(m.config.dataWidth == s.config.dataWidth)
    s.cmd.valid := m.cmd.valid
    s.cmd.wr := m.cmd.wr
    s.cmd.address := m.cmd.address.resized
    s.cmd.data := m.cmd.data
    s.cmd.mask := m.cmd.mask
    m.cmd.ready := s.cmd.ready
    m.rsp.valid := s.rsp.valid
    m.rsp.data := s.rsp.data
  }
  def >>(s : SimpleBus) : Unit = s << this

  def cmdM2sPipe(): SimpleBus = {
    val ret = cloneOf(this)
    this.cmd.m2sPipe() >> ret.cmd
    this.rsp           << ret.rsp
    ret
  }

  def cmdS2mPipe(): SimpleBus = {
    val ret = cloneOf(this)
    this.cmd.s2mPipe() >> ret.cmd
    this.rsp << ret.rsp
    ret
  }

  def rspPipe(): SimpleBus = {
    val ret = cloneOf(this)
    this.cmd >> ret.cmd
    this.rsp << ret.rsp.stage()
    ret
  }
}





object SimpleBusArbiter{
  def apply(inputs : Seq[SimpleBus], pendingRspMax : Int, rspRouteQueue : Boolean, transactionLock : Boolean): SimpleBus = {
    val c = SimpleBusArbiter(inputs.head.config, inputs.size, pendingRspMax, rspRouteQueue, transactionLock)
    (inputs, c.io.inputs).zipped.foreach(_ <> _)
    c.io.output
  }
}

case class SimpleBusArbiter(simpleBusConfig : SimpleBusConfig, portCount : Int, pendingRspMax : Int, rspRouteQueue : Boolean, transactionLock : Boolean = true) extends Component{
  val io = new Bundle{
    val inputs = Vec(slave(SimpleBus(simpleBusConfig)), portCount)
    val output = master(SimpleBus(simpleBusConfig))
  }
  val logic = if(portCount == 1) new Area{
    io.output << io.inputs(0)
  } else new Area {
    val arbiterFactory = StreamArbiterFactory.lowerFirst
    if(transactionLock) arbiterFactory.transactionLock else arbiterFactory.noLock
    val arbiter = arbiterFactory.build(SimpleBusCmd(simpleBusConfig), portCount)
    (arbiter.io.inputs, io.inputs).zipped.foreach(_ <> _.cmd)

    val rspRouteOh = Bits(portCount bits)

    val rsp = if(!rspRouteQueue) new Area{
      assert(pendingRspMax == 1)
      val pending = RegInit(False) clearWhen(io.output.rsp.valid)
      val target = Reg(Bits(portCount bits))
      rspRouteOh := target
      when(io.output.cmd.fire && !io.output.cmd.wr){
        target  := arbiter.io.chosenOH
        pending := True
      }
      io.output.cmd << arbiter.io.output.haltWhen(pending && !io.output.rsp.valid)
    } else new Area{
      val (outputCmdFork, routeCmdFork) = StreamFork2(arbiter.io.output)
      io.output.cmd << outputCmdFork

      val rspRoute = routeCmdFork.translateWith(arbiter.io.chosenOH).throwWhen(routeCmdFork.wr).queueLowLatency(size = pendingRspMax, latency = 1)
      rspRoute.ready := io.output.rsp.valid
      rspRouteOh := rspRoute.payload
    }

    for ((input, id) <- io.inputs.zipWithIndex) {
      input.rsp.valid := io.output.rsp.valid && rspRouteOh(id)
      input.rsp.payload := io.output.rsp.payload
    }
  }
}

class SimpleBusSlaveFactory(bus: SimpleBus) extends BusSlaveFactoryDelayed{
  bus.cmd.ready := True

  val readAtCmd = Flow(Bits(bus.config.dataWidth bits))
  val readAtRsp = readAtCmd.stage()

  val askWrite = (bus.cmd.valid && bus.cmd.wr).allowPruning()
  val askRead  = (bus.cmd.valid && !bus.cmd.wr).allowPruning()
  val doWrite  = (askWrite && bus.cmd.ready).allowPruning()
  val doRead   = (askRead  && bus.cmd.ready).allowPruning()

  bus.rsp.valid := readAtRsp.valid
  bus.rsp.data := readAtRsp.payload

  readAtCmd.valid := doRead
  readAtCmd.payload := 0

  def readAddress() : UInt = bus.cmd.address
  def writeAddress() : UInt = bus.cmd.address

  override def readHalt(): Unit = bus.cmd.ready := False
  override def writeHalt(): Unit = bus.cmd.ready := False

  override def build(): Unit = {
    super.doNonStopWrite(bus.cmd.data)

    def doMappedElements(jobs : Seq[BusSlaveFactoryElement]) = super.doMappedElements(
      jobs = jobs,
      askWrite = askWrite,
      askRead = askRead,
      doWrite = doWrite,
      doRead = doRead,
      writeData = bus.cmd.data,
      readData = readAtCmd.payload
    )

    switch(bus.cmd.address) {
      for ((address, jobs) <- elementsPerAddress if address.isInstanceOf[SingleMapping]) {
        is(address.asInstanceOf[SingleMapping].address) {
          doMappedElements(jobs)
        }
      }
    }

    for ((address, jobs) <- elementsPerAddress if !address.isInstanceOf[SingleMapping]) {
      when(address.hit(bus.cmd.address)){
        doMappedElements(jobs)
      }
    }
  }

  override def busDataWidth: Int = bus.config.dataWidth
  override def wordAddressInc: Int = busDataWidth / 8
}

case class SimpleBusDecoder(busConfig : SimpleBusConfig, mappings : Seq[AddressMapping], pendingMax : Int = 3) extends Component{
  val io = new Bundle {
    val input = slave(SimpleBus(busConfig))
    val outputs = Vec(master(SimpleBus(busConfig)), mappings.size)
  }
  val hasDefault = mappings.contains(DefaultMapping)
  val logic = if(hasDefault && mappings.size == 1){
    io.outputs(0) <> io.input
  } else new Area {
    val hits = Vec(Bool, mappings.size)
    for ((slaveBus, memorySpace, hit) <- (io.outputs, mappings, hits).zipped) yield {
      hit := (memorySpace match {
        case DefaultMapping => !hits.filterNot(_ == hit).orR
        case _ => memorySpace.hit(io.input.cmd.address)
      })
      slaveBus.cmd.valid := io.input.cmd.valid && hit
      slaveBus.cmd.payload := io.input.cmd.payload.resized
    }
    val noHit = if (!hasDefault) !hits.orR else False
    io.input.cmd.ready := (hits, io.outputs).zipped.map(_ && _.cmd.ready).orR || noHit

    val rspPendingCounter = Reg(UInt(log2Up(pendingMax + 1) bits)) init (0)
    rspPendingCounter := rspPendingCounter + U(io.input.cmd.fire && !io.input.cmd.wr) - U(io.input.rsp.valid)
    val rspHits = RegNextWhen(hits, io.input.cmd.fire)
    val rspPending = rspPendingCounter =/= 0
    val rspNoHit = if (!hasDefault) !rspHits.orR else False
    io.input.rsp.valid := io.outputs.map(_.rsp.valid).orR || (rspPending && rspNoHit)
    io.input.rsp.payload := io.outputs.map(_.rsp.payload).read(OHToUInt(rspHits))

    val cmdWait = (io.input.cmd.valid && rspPending && hits =/= rspHits) || rspPendingCounter === pendingMax
    when(cmdWait) {
      io.input.cmd.ready := False
      io.outputs.foreach(_.cmd.valid := False)
    }
  }
}

object SimpleBusConnectors{
  def direct(m : SimpleBus, s : SimpleBus) : Unit = m >> s
}

case class SimpleBusInterconnect(){
  case class MasterModel(var connector : (SimpleBus,SimpleBus) => Unit = SimpleBusConnectors.direct)
  case class SlaveModel(mapping : AddressMapping, var connector : (SimpleBus,SimpleBus) => Unit = SimpleBusConnectors.direct, var transactionLock : Boolean = true)
  case class ConnectionModel(m : SimpleBus, s : SimpleBus, var connector : (SimpleBus,SimpleBus) => Unit = SimpleBusConnectors.direct)

  val masters = mutable.LinkedHashMap[SimpleBus, MasterModel]()
  val slaves = mutable.LinkedHashMap[SimpleBus, SlaveModel]()
  val connections = ArrayBuffer[ConnectionModel]()
  var arbitrationPendingRspMaxDefault = 1
  var arbitrationRspRouteQueueDefault = false

  def perfConfig(): Unit ={
    arbitrationPendingRspMaxDefault = 7
    arbitrationRspRouteQueueDefault = true
  }

  def areaConfig(): Unit ={
    arbitrationPendingRspMaxDefault = 1
    arbitrationRspRouteQueueDefault = false
  }

  def setConnector(bus : SimpleBus)( connector : (SimpleBus,SimpleBus) => Unit): Unit = (masters.get(bus), slaves.get(bus)) match {
    case (Some(m), _) =>    m.connector = connector
    case (None, Some(s)) => s.connector = connector
  }

  def setConnector(m : SimpleBus, s : SimpleBus)(connector : (SimpleBus,SimpleBus) => Unit): Unit = connections.find(e => e.m == m && e.s == s) match {
    case Some(c) => c.connector = connector
  }

  def addSlave(bus: SimpleBus,mapping: AddressMapping) : this.type = {
    slaves(bus) = SlaveModel(mapping)
    this
  }

  def addSlaves(orders : (SimpleBus,AddressMapping)*) : this.type = {
    orders.foreach(order => addSlave(order._1,order._2))
    this
  }

  def noTransactionLockOn(slave : SimpleBus) : Unit = slaves(slave).transactionLock = false
  def noTransactionLockOn(slaves : Seq[SimpleBus]) : Unit = slaves.foreach(noTransactionLockOn(_))


  def addMaster(bus : SimpleBus, accesses : Seq[SimpleBus]) : this.type = {
    masters(bus) = MasterModel()
    for(s <- accesses) connections += ConnectionModel(bus, s)
    this
  }

  def addMasters(specs : (SimpleBus,Seq[SimpleBus])*) : this.type = {
    specs.foreach(spec => addMaster(spec._1,spec._2))
    this
  }

  def build(): Unit ={
    def applyName(bus : Bundle,name : String, onThat : Nameable) : Unit = {
      if(bus.component == Component.current)
        onThat.setCompositeName(bus,name)
      else if(bus.isNamed)
        onThat.setCompositeName(bus.component,bus.getName() + "_" + name)
    }

    val connectionsInput  = mutable.HashMap[ConnectionModel,SimpleBus]()
    val connectionsOutput = mutable.HashMap[ConnectionModel,SimpleBus]()
    for((bus, model) <- masters){
      val busConnections = connections.filter(_.m == bus)
      val busSlaves = busConnections.map(c => slaves(c.s))
      val decoder = new SimpleBusDecoder(bus.config, busSlaves.map(_.mapping))
      applyName(bus,"decoder",decoder)
      model.connector(bus, decoder.io.input)
      for((connection, decoderOutput) <- (busConnections, decoder.io.outputs).zipped) {
        connectionsInput(connection) = decoderOutput
      }
    }

    for((bus, model) <- slaves){
      val busConnections = connections.filter(_.s == bus)
      val busMasters = busConnections.map(c => masters(c.m))
      val arbiter = new SimpleBusArbiter(bus.config, busMasters.size, arbitrationPendingRspMaxDefault, arbitrationRspRouteQueueDefault, model.transactionLock)
      applyName(bus,"arbiter",arbiter)
      model.connector(arbiter.io.output, bus)
      for((connection, arbiterInput) <- (busConnections, arbiter.io.inputs).zipped) {
        connectionsOutput(connection) = arbiterInput
      }
    }

    for(connection <- connections){
      val m = connectionsInput(connection)
      val s = connectionsOutput(connection)
      if(m.config == s.config) {
        connection.connector(m, s)
      }else{
        val tmp = cloneOf(s)
        m >> tmp //Adapte the bus kind.
        connection.connector(tmp,s)
      }
    }
  }

  //Will make SpinalHDL calling the build function at the end of the current component elaboration
  Component.current.addPrePopTask(build)
}
