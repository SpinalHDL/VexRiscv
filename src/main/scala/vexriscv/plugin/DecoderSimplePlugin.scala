package vexriscv.plugin

import vexriscv._
import spinal.core._
import spinal.core.internals.Literal
import spinal.lib._

import scala.collection.mutable
import scala.collection.mutable.ArrayBuffer


case class Masked(value : BigInt,care : BigInt){
  var isPrime = true

  def < (that: Masked) = value < that.value || value == that.value && ~care < ~that.care

  def intersects(x: Masked) = ((value ^ x.value) & care & x.care) == 0

  def covers(x: Masked) = ((value ^ x.value) & care | (~x.care) & care) == 0

  def setPrime(value : Boolean) = {
    isPrime = value
    this
  }

  def merge(x: Masked) = {
    isPrime = false
    x.isPrime = false
    val bit = value - x.value
    new Masked(value &~ bit, care & ~bit)
  }
  def similar(x: Masked) = {
    val diff = value - x.value
    care == x.care && value > x.value && (diff & diff - 1) == 0
  }


  def === (hard : Bits) : Bool = (hard & care) === (value & care)

  def toString(bitCount : Int) = (0 until bitCount).map(i => if(care.testBit(i)) (if(value.testBit(i)) "1" else "0") else "-").reverseIterator.reduce(_+_)
}

class DecoderSimplePlugin(catchIllegalInstruction : Boolean, forceLegalInstructionComputation : Boolean = false) extends Plugin[VexRiscv] with DecoderService {
  override def add(encoding: Seq[(MaskedLiteral, Seq[(Stageable[_ <: BaseType], Any)])]): Unit = encoding.foreach(e => this.add(e._1,e._2))
  override def add(key: MaskedLiteral, values: Seq[(Stageable[_ <: BaseType], Any)]): Unit = {
    assert(!encodings.contains(key))
    encodings.getOrElseUpdate(key,ArrayBuffer[(Stageable[_ <: BaseType], BaseType)]()) ++= values.map{case (a,b) => (a,b match{
      case e : SpinalEnumElement[_] => e()
      case e : BaseType => e
    })}
  }

  override def addDefault(key: Stageable[_  <: BaseType], value: Any): Unit = {
    assert(!defaults.contains(key))
    defaults(key) = value match{
      case e : SpinalEnumElement[_] => e()
      case e : BaseType => e
    }
  }

  val defaults = mutable.HashMap[Stageable[_ <: BaseType], BaseType]()
  val encodings = mutable.HashMap[MaskedLiteral,ArrayBuffer[(Stageable[_ <: BaseType], BaseType)]]()
  var decodeExceptionPort : Flow[ExceptionCause] = null


  override def setup(pipeline: VexRiscv): Unit = {
    if(catchIllegalInstruction) {
      val exceptionService = pipeline.plugins.filter(_.isInstanceOf[ExceptionService]).head.asInstanceOf[ExceptionService]
      decodeExceptionPort = exceptionService.newExceptionPort(pipeline.decode).setName("decodeExceptionPort")
    }
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline.config._
    import pipeline.decode._

    val stageables = (encodings.flatMap(_._2.map(_._1)) ++ defaults.map(_._1)).toSet.toList

    var offset = 0
    var defaultValue, defaultCare = BigInt(0)
    val offsetOf = mutable.HashMap[Stageable[_ <: BaseType],Int]()

    //Build defaults value and field offset map
    stageables.foreach(e => {
      defaults.get(e) match {
        case Some(value) => {
          value.head.source match {
            case literal: EnumLiteral[_] => literal.fixEncoding(e.dataType.asInstanceOf[SpinalEnumCraft[_]].getEncoding)
            case _ =>
          }
          defaultValue += value.head.source .asInstanceOf[Literal].getValue << offset
          defaultCare += ((BigInt(1) << e.dataType.getBitsWidth) - 1) << offset

        }
        case _ =>
      }
      offsetOf(e) = offset
      offset += e.dataType.getBitsWidth
    })

    //Build spec
    val spec = encodings.map { case (key, values) =>
      var decodedValue = defaultValue
      var decodedCare = defaultCare
      for((e, literal) <- values){
        literal.head.source  match{
          case literal : EnumLiteral[_] => literal.fixEncoding(e.dataType.asInstanceOf[SpinalEnumCraft[_]].getEncoding)
          case _ =>
        }
        val offset = offsetOf(e)
        decodedValue |= literal.head.source.asInstanceOf[Literal].getValue << offset
        decodedCare  |= ((BigInt(1) << e.dataType.getBitsWidth)-1) << offset
      }
      (Masked(key.value,key.careAbout),Masked(decodedValue,decodedCare))
    }



    // logic implementation
    val decodedBits = Bits(stageables.foldLeft(0)(_ + _.dataType.getBitsWidth) bits)
    decodedBits := Symplify(input(INSTRUCTION),spec, decodedBits.getWidth)
    if(catchIllegalInstruction || forceLegalInstructionComputation) insert(LEGAL_INSTRUCTION) := Symplify.logicOf(input(INSTRUCTION), SymplifyBit.getPrimeImplicants(spec.unzip._1.toSeq, 32))


    //Unpack decodedBits and insert fields in the pipeline
    offset = 0
    stageables.foreach(e => {
      insert(e).assignFromBits(decodedBits(offset, e.dataType.getBitsWidth bits))
//            insert(e).assignFromBits(RegNext(decodedBits(offset, e.dataType.getBitsWidth bits)))
      offset += e.dataType.getBitsWidth
    })


    if(catchIllegalInstruction){
      decodeExceptionPort.valid := arbitration.isValid && input(INSTRUCTION_READY) && !input(LEGAL_INSTRUCTION) // ?? HalitIt to alow decoder stage to wait valid data from 2 stages cache cache ??
      decodeExceptionPort.code := 2
      decodeExceptionPort.badAddr.assignDontCare()
    }
  }

  def bench(toplevel : VexRiscv): Unit ={
    toplevel.rework{
      import toplevel.config._
      toplevel.getAllIo.toList.foreach(_.asDirectionLess())
      toplevel.decode.input(INSTRUCTION) := Delay((in Bits(32 bits)).setName("instruction"),2)
      val stageables = encodings.flatMap(_._2.map(_._1)).toSet
      stageables.foreach(e => out(RegNext(RegNext(toplevel.decode.insert(e)).setName(e.getName()))))
      if(catchIllegalInstruction) out(RegNext(RegNext(toplevel.decode.insert(LEGAL_INSTRUCTION)).setName(LEGAL_INSTRUCTION.getName())))
    //  toplevel.getAdditionalNodesRoot.clear()
    }
  }
}



object Symplify{
  val cache = mutable.HashMap[Bits,mutable.HashMap[Masked,Bool]]()
  def getCache(addr : Bits) = cache.getOrElseUpdate(addr,mutable.HashMap[Masked,Bool]())
  
  //Generate terms logic for the given input
  def logicOf(input : Bits,terms : Seq[Masked]) = terms.map(t => getCache(input).getOrElseUpdate(t,t === input)).asBits.orR

  //Decode 'input' b using an mapping[key, decoding] specification
  def apply(input: Bits, mapping: Iterable[(Masked, Masked)],resultWidth : Int) : Bits = {
    val addrWidth = widthOf(input)
    (for(bitId <- 0 until resultWidth) yield{
      val trueTerm = mapping.filter { case (k,t) => (t.care.testBit(bitId) && t.value.testBit(bitId))}.map(_._1)
      val falseTerm = mapping.filter { case (k,t) => (t.care.testBit(bitId) &&  !t.value.testBit(bitId))}.map(_._1)
      val symplifiedTerms = SymplifyBit.getPrimeImplicants(trueTerm.toSeq, falseTerm.toSeq, addrWidth)
      logicOf(input, symplifiedTerms)
    }).asBits
  }
}

object SymplifyBit{

  //Return a new term with only one bit difference with 'term' and not included in falseTerms. above => 0 to 1 dif, else 1 to 0 diff
  def genImplicitDontCare(falseTerms: Seq[Masked], term: Masked, bits: Int, above: Boolean): Masked = {
    for (i <- 0 until bits; if term.care.testBit(i)) {
      var t: Masked = null
      if(above) {
        if (!term.value.testBit(i))
          t = Masked(term.value.setBit(i), term.care)
      } else {
        if (term.value.testBit(i))
          t = Masked(term.value.clearBit(i), term.care)
      }
      if (t != null && !falseTerms.exists(_.intersects(t)))
        return t
    }
    null
  }

  //Return primes implicants for the trueTerms, falseTerms spec. Default value is don't care
  def getPrimeImplicants(trueTerms: Seq[Masked],falseTerms: Seq[Masked],inputWidth : Int): Seq[Masked] = {
    val primes = ArrayBuffer[Masked]()
    trueTerms.foreach(_.isPrime = true)
    falseTerms.foreach(_.isPrime = true)
    val trueTermByCareCount = (inputWidth to 0 by -1).map(b => trueTerms.filter(b == _.care.bitCount))
    val table = trueTermByCareCount.map(c => (0 to inputWidth).map(b => collection.mutable.Set(c.filter(b == _.value.bitCount): _*)))
    for (i <- 0 to inputWidth) {
      for (j <- 0 until inputWidth - i){
        for(term <- table(i)(j)){
          table(i+1)(j) ++= table(i)(j+1).filter(_.similar(term)).map(_.merge(term))
        }
      }
      for (j <- 0 until inputWidth-i) {
        for (a <- table(i)(j).filter(_.isPrime)) {
          val dc = genImplicitDontCare(falseTerms, a, inputWidth, true)
          if (dc != null)
            table(i+1)(j) += dc merge a
        }
        for (a <- table(i)(j+1).filter(_.isPrime)) {
          val dc = genImplicitDontCare(falseTerms, a, inputWidth, false)
          if (dc != null)
            table(i+1)(j) += a merge dc
        }
      }
      for (r <- table(i))
        for (p <- r; if p.isPrime)
          primes += p
    }

    verify(primes, trueTerms, falseTerms)
    primes
  }

  //Verify that the 'terms' doesn't violate the trueTerms ++ falseTerms spec
  def verify(terms : Seq[Masked], trueTerms : Seq[Masked], falseTerms : Seq[Masked]): Unit ={
    require(trueTerms.forall(trueTerm => terms.exists(_ covers trueTerm)))
    require(falseTerms.forall(falseTerm => !terms.exists(_ covers falseTerm)))
  }

  //Return primes implicants for the trueTerms, default value is False
  def getPrimeImplicants(trueTerms: Seq[Masked],inputWidth : Int): Seq[Masked] = {
    val primes = ArrayBuffer[Masked]()
    trueTerms.foreach(_.isPrime = true)
    val trueTermByCareCount = (inputWidth to 0 by -1).map(b => trueTerms.filter(b == _.care.bitCount))
    val table = trueTermByCareCount.map(c => (0 to inputWidth).map(b => collection.mutable.Set(c.filter(b == _.value.bitCount): _*)))
    for (i <- 0 to inputWidth) {
      for (j <- 0 until inputWidth - i){
        for(term <- table(i)(j)){
          table(i+1)(j) ++= table(i)(j+1).filter(_.similar(term)).map(_.merge(term))
        }
      }
      for (r <- table(i))
        for (p <- r; if p.isPrime)
          primes += p
    }
    primes
  }

  def main(args: Array[String]) {
    val default = Masked(0,0xF)
    val primeImplicants = List(4,8,10,11,12,15).map(v => Masked(v,0xF))
    val dcImplicants = List(9,14).map(v => Masked(v,0xF).setPrime(false))
    val reducedPrimeImplicants = getPrimeImplicants(primeImplicants ++ dcImplicants,4)
    println("UUT")
    println(reducedPrimeImplicants.map(_.toString(4)).mkString("\n"))
    println("REF")
    println("-100\n10--\n1--0\n1-1-")
  }
}