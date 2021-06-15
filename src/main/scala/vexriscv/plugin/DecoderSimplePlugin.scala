package vexriscv.plugin

import vexriscv._
import spinal.core._
import spinal.core.internals.Literal
import spinal.lib._
import vexriscv.demo.GenFull

import scala.collection.mutable
import scala.collection.mutable.ArrayBuffer


case class Masked(value : BigInt,care : BigInt){
  assert((value & ~care) == 0)
  var isPrime = true

  def < (that: Masked) = value < that.value || value == that.value && ~care < ~that.care

  def intersects(x: Masked) = ((value ^ x.value) & care & x.care) == 0

  def covers(x: Masked) = ((value ^ x.value) & care | (~x.care) & care) == 0

  def setPrime(value : Boolean) = {
    isPrime = value
    this
  }

  def mergeOneBitDifSmaller(x: Masked) = {
    val bit = value - x.value
    val ret = new Masked(value &~ bit, care & ~bit)
    //    ret.isPrime = isPrime || x.isPrime
    isPrime = false
    x.isPrime = false
    ret
  }
  def isSimilarOneBitDifSmaller(x: Masked) = {
    val diff = value - x.value
    care == x.care && value > x.value && (diff & diff - 1) == 0
  }


  def === (hard : Bits) : Bool = (hard & care) === (value & care)

  def toString(bitCount : Int) = (0 until bitCount).map(i => if(care.testBit(i)) (if(value.testBit(i)) "1" else "0") else "-").reverseIterator.reduce(_+_)
}

class DecoderSimplePlugin(catchIllegalInstruction : Boolean = false,
                          throwIllegalInstruction : Boolean = false,
                          assertIllegalInstruction : Boolean = false,
                          forceLegalInstructionComputation : Boolean = false,
                          decoderIsolationBench : Boolean = false,
                          stupidDecoder : Boolean = false) extends Plugin[VexRiscv] with DecoderService {
  override def add(encoding: Seq[(MaskedLiteral, Seq[(Stageable[_ <: BaseType], Any)])]): Unit = encoding.foreach(e => this.add(e._1,e._2))
  override def add(key: MaskedLiteral, values: Seq[(Stageable[_ <: BaseType], Any)]): Unit = {
    val instructionModel = encodings.getOrElseUpdate(key,ArrayBuffer[(Stageable[_ <: BaseType], BaseType)]())
    values.map{case (a,b) => {
      assert(!instructionModel.contains(a), s"Over specification of $a")
      val value = b match {
        case e: SpinalEnumElement[_] => e()
        case e: BaseType => e
      }
      instructionModel += (a->value)
    }}
  }

  override def addDefault(key: Stageable[_  <: BaseType], value: Any): Unit = {
    assert(!defaults.contains(key))
    defaults(key) = value match{
      case e : SpinalEnumElement[_] => e()
      case e : BaseType => e
    }
  }

  val defaults = mutable.LinkedHashMap[Stageable[_ <: BaseType], BaseType]()
  val encodings = mutable.LinkedHashMap[MaskedLiteral,ArrayBuffer[(Stageable[_ <: BaseType], BaseType)]]()
  var decodeExceptionPort : Flow[ExceptionCause] = null


  override def setup(pipeline: VexRiscv): Unit = {
    if(catchIllegalInstruction) {
      val exceptionService = pipeline.plugins.filter(_.isInstanceOf[ExceptionService]).head.asInstanceOf[ExceptionService]
      decodeExceptionPort = exceptionService.newExceptionPort(pipeline.decode).setName("decodeExceptionPort")
    }
  }

  val detectLegalInstructions = catchIllegalInstruction || throwIllegalInstruction || forceLegalInstructionComputation || assertIllegalInstruction

  object ASSERT_ERROR extends Stageable(Bool)

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline.config._
    import pipeline.decode._

    val stageables = (encodings.flatMap(_._2.map(_._1)) ++ defaults.map(_._1)).toList.distinct


    if(stupidDecoder){
      if (detectLegalInstructions) insert(LEGAL_INSTRUCTION) := False
      for(stageable <- stageables){
        if(defaults.contains(stageable)){
          insert(stageable).assignFrom(defaults(stageable))
        } else {
          insert(stageable).assignDontCare()
        }
      }
      for((key, tasks) <- encodings){
        when(input(INSTRUCTION) === key){
          if (detectLegalInstructions) insert(LEGAL_INSTRUCTION) := True
          for((stageable, value) <- tasks){
            insert(stageable).assignFrom(value)
          }
        }
      }
    } else {
      var offset = 0
      var defaultValue, defaultCare = BigInt(0)
      val offsetOf = mutable.LinkedHashMap[Stageable[_ <: BaseType], Int]()

      //Build defaults value and field offset map
      stageables.foreach(e => {
        defaults.get(e) match {
          case Some(value) => {
            value.head.source match {
              case literal: EnumLiteral[_] => literal.fixEncoding(e.dataType.asInstanceOf[SpinalEnumCraft[_]].getEncoding)
              case _ =>
            }
            defaultValue += value.head.source.asInstanceOf[Literal].getValue << offset
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
        for ((e, literal) <- values) {
          literal.head.source match {
            case literal: EnumLiteral[_] => literal.fixEncoding(e.dataType.asInstanceOf[SpinalEnumCraft[_]].getEncoding)
            case _ =>
          }
          val offset = offsetOf(e)
          decodedValue |= literal.head.source.asInstanceOf[Literal].getValue << offset
          decodedCare |= ((BigInt(1) << e.dataType.getBitsWidth) - 1) << offset
        }
        (Masked(key.value, key.careAbout), Masked(decodedValue, decodedCare))
      }


      // logic implementation
      val decodedBits = Bits(stageables.foldLeft(0)(_ + _.dataType.getBitsWidth) bits)
      decodedBits := Symplify(input(INSTRUCTION), spec, decodedBits.getWidth)
      if (detectLegalInstructions) insert(LEGAL_INSTRUCTION) := Symplify.logicOf(input(INSTRUCTION), SymplifyBit.getPrimeImplicantsByTrueAndDontCare(spec.unzip._1.toSeq, Nil, 32))
      if (throwIllegalInstruction) {
        input(LEGAL_INSTRUCTION) //Fill the request for later (prePopTask)
        Component.current.addPrePopTask(() => arbitration.isValid clearWhen(!input(LEGAL_INSTRUCTION)))
      }
      if(assertIllegalInstruction){
        val reg = RegInit(False) setWhen(arbitration.isValid) clearWhen(arbitration.isRemoved || !arbitration.isStuck)
        insert(ASSERT_ERROR) := arbitration.isValid || reg
      }

      if(decoderIsolationBench){
        KeepAttribute(RegNext(KeepAttribute(RegNext(decodedBits.removeAssignments().asInput()))))
        out(Bits(32 bits)).setName("instruction") := KeepAttribute(RegNext(KeepAttribute(RegNext(input(INSTRUCTION)))))
      }

      //Unpack decodedBits and insert fields in the pipeline
      offset = 0
      stageables.foreach(e => {
        insert(e).assignFromBits(decodedBits(offset, e.dataType.getBitsWidth bits))
        //            insert(e).assignFromBits(RegNext(decodedBits(offset, e.dataType.getBitsWidth bits)))
        offset += e.dataType.getBitsWidth
      })
    }

    if(catchIllegalInstruction){
      decodeExceptionPort.valid := arbitration.isValid && !input(LEGAL_INSTRUCTION) // ?? HalitIt to alow decoder stage to wait valid data from 2 stages cache cache ??
      decodeExceptionPort.code := 2
      decodeExceptionPort.badAddr := input(INSTRUCTION).asUInt
    }
    if(assertIllegalInstruction){
      pipeline.stages.tail.foreach(s => s.output(ASSERT_ERROR) clearWhen(s.arbitration.isRemoved))
      assert(!pipeline.stages.last.output(ASSERT_ERROR))
    }
  }

  def bench(toplevel : VexRiscv): Unit ={
    toplevel.rework{
      import toplevel.config._
      toplevel.getAllIo.toList.foreach{io =>
        if(io.isInput) { io.assignDontCare()}
        io.setAsDirectionLess()
      }
      toplevel.decode.input(INSTRUCTION).removeAssignments()
      toplevel.decode.input(INSTRUCTION) := Delay((in Bits(32 bits)).setName("instruction"),2)
      val stageables = encodings.flatMap(_._2.map(_._1)).toSet
      stageables.foreach(e => out(RegNext(RegNext(toplevel.decode.insert(e)).setName(e.getName()))))
      if(catchIllegalInstruction) out(RegNext(RegNext(toplevel.decode.insert(LEGAL_INSTRUCTION)).setName(LEGAL_INSTRUCTION.getName())))
      //  toplevel.getAdditionalNodesRoot.clear()
    }
  }
}

object DecodingBench extends App{
  SpinalVerilog{
    val top = GenFull.cpu()
    top.service(classOf[DecoderSimplePlugin]).bench(top)
    top
  }
}


object Symplify{
  val cache = mutable.LinkedHashMap[Bits,mutable.LinkedHashMap[Masked,Bool]]()
  def getCache(addr : Bits) = cache.getOrElseUpdate(addr,mutable.LinkedHashMap[Masked,Bool]())

  //Generate terms logic for the given input
  def logicOf(input : Bits,terms : Seq[Masked]) = terms.map(t => getCache(input).getOrElseUpdate(t,t === input)).asBits.orR

  //Decode 'input' b using an mapping[key, decoding] specification
  def apply(input: Bits, mapping: Iterable[(Masked, Masked)],resultWidth : Int) : Bits = {
    val addrWidth = widthOf(input)
    (for(bitId <- 0 until resultWidth) yield{
      val trueTerm = mapping.filter { case (k,t) => (t.care.testBit(bitId) && t.value.testBit(bitId))}.map(_._1)
      val falseTerm = mapping.filter { case (k,t) => (t.care.testBit(bitId) &&  !t.value.testBit(bitId))}.map(_._1)
      val symplifiedTerms = SymplifyBit.getPrimeImplicantsByTrueAndFalse(trueTerm.toSeq, falseTerm.toSeq, addrWidth)
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
      if (t != null && !falseTerms.exists(_.intersects(t))) {
        t.isPrime = false
        return t
      }
    }
    null
  }

  //Return primes implicants for the trueTerms, falseTerms spec. Default value is don't care
  def getPrimeImplicantsByTrueAndFalse(trueTerms: Seq[Masked], falseTerms: Seq[Masked], inputWidth : Int): Seq[Masked] = {
    val primes = mutable.LinkedHashSet[Masked]()
    trueTerms.foreach(_.isPrime = true)
    falseTerms.foreach(_.isPrime = true)
    val trueTermByCareCount = (inputWidth to 0 by -1).map(b => trueTerms.filter(b == _.care.bitCount))
    //table[Vector[HashSet[Masked]]](careCount)(bitSetCount)
    val table = trueTermByCareCount.map(c => (0 to inputWidth).map(b => collection.mutable.Set(c.filter(b == _.value.bitCount): _*)))
    for (i <- 0 to inputWidth) {
      //Expends explicit terms
      for (j <- 0 until inputWidth - i){
        for(term <- table(i)(j)){
          table(i+1)(j) ++= table(i)(j+1).withFilter(_.isSimilarOneBitDifSmaller(term)).map(_.mergeOneBitDifSmaller(term))
        }
      }
      //Expends implicit don't care terms
      for (j <- 0 until inputWidth-i) {
        for (prime <- table(i)(j).withFilter(_.isPrime)) {
          val dc = genImplicitDontCare(falseTerms, prime, inputWidth, true)
          if (dc != null)
            table(i+1)(j) += dc mergeOneBitDifSmaller prime
        }
        for (prime <- table(i)(j+1).withFilter(_.isPrime)) {
          val dc = genImplicitDontCare(falseTerms, prime, inputWidth, false)
          if (dc != null)
            table(i+1)(j) += prime mergeOneBitDifSmaller dc
        }
      }
      for (r <- table(i))
        for (p <- r; if p.isPrime)
          primes += p
    }

    def optimise() {
      val duplicateds = primes.filter(prime => verifyTrueFalse(primes.filterNot(_ == prime), trueTerms, falseTerms))
      if(duplicateds.nonEmpty) {
        primes -= duplicateds.maxBy(_.care.bitCount)
        optimise()
      }
    }

    optimise()

    verifyTrueFalse(primes, trueTerms, falseTerms)
    var duplication = 0
    for(prime <- primes){
      if(verifyTrueFalse(primes.filterNot(_ == prime), trueTerms, falseTerms)){
        duplication += 1
      }
    }
    if(duplication != 0){
      PendingError(s"Duplicated primes : $duplication")
    }
    primes.toSeq
  }

  //Verify that the 'terms' doesn't violate the trueTerms ++ falseTerms spec
  def verifyTrueFalse(terms : Iterable[Masked], trueTerms : Seq[Masked], falseTerms : Seq[Masked]): Boolean ={
    return (trueTerms.forall(trueTerm => terms.exists(_ covers trueTerm))) && (falseTerms.forall(falseTerm => !terms.exists(_ covers falseTerm)))
  }

  def checkTrue(terms : Iterable[Masked], trueTerms : Seq[Masked]): Boolean ={
    return trueTerms.forall(trueTerm => terms.exists(_ covers trueTerm))
  }


  def getPrimeImplicantsByTrue(trueTerms: Seq[Masked], inputWidth : Int) : Seq[Masked] = getPrimeImplicantsByTrueAndDontCare(trueTerms, Nil, inputWidth)

  // Return primes implicants for the trueTerms, default value is False.
  // You can insert don't care values by adding non-prime implicants in the trueTerms
  // Will simplify the trueTerms from the most constrained ones to the least constrained ones
  def getPrimeImplicantsByTrueAndDontCare(trueTerms: Seq[Masked],dontCareTerms: Seq[Masked], inputWidth : Int): Seq[Masked] = {
    val primes = mutable.LinkedHashSet[Masked]()
    trueTerms.foreach(_.isPrime = true)
    dontCareTerms.foreach(_.isPrime = false)
    val termsByCareCount = (inputWidth to 0 by -1).map(b => (trueTerms ++ dontCareTerms).filter(b == _.care.bitCount))
    //table[Vector[HashSet[Masked]]](careCount)(bitSetCount)
    val table = termsByCareCount.map(c => (0 to inputWidth).map(b => collection.mutable.Set(c.filter(m => b == m.value.bitCount): _*)))
    for (i <- 0 to inputWidth) {
      for (j <- 0 until inputWidth - i){
        for(term <- table(i)(j)){
          table(i+1)(j) ++= table(i)(j+1).withFilter(_.isSimilarOneBitDifSmaller(term)).map(_.mergeOneBitDifSmaller(term))
        }
      }
      for (r <- table(i))
        for (p <- r; if p.isPrime)
          primes += p
    }


    def optimise() {
      val duplicateds = primes.filter(prime => checkTrue(primes.filterNot(_ == prime), trueTerms))
      if(duplicateds.nonEmpty) {
        primes -= duplicateds.maxBy(_.care.bitCount)
        optimise()
      }
    }

    optimise()


    var duplication = 0
    for(prime <- primes){
      if(checkTrue(primes.filterNot(_ == prime), trueTerms)){
        duplication += 1
      }
    }
    if(duplication != 0){
      PendingError(s"Duplicated primes : $duplication")
    }
    primes.toSeq
  }

  def main(args: Array[String]) {
    {
      //      val default = Masked(0, 0xF)
      //      val primeImplicants = List(4, 8, 10, 11, 12, 15).map(v => Masked(v, 0xF))
      //      val dcImplicants = List(9, 14).map(v => Masked(v, 0xF).setPrime(false))
      //      val reducedPrimeImplicants = getPrimeImplicantsByTrueAndDontCare(primeImplicants, dcImplicants, 4)
      //      println("UUT")
      //      println(reducedPrimeImplicants.map(_.toString(4)).mkString("\n"))
      //      println("REF")
      //      println("-100\n10--\n1--0\n1-1-")
    }

    {
      val primeImplicants = List(0).map(v => Masked(v, 0xF))
      val dcImplicants = (1 to 15).map(v => Masked(v, 0xF))
      val reducedPrimeImplicants = getPrimeImplicantsByTrueAndDontCare(primeImplicants, dcImplicants, 4)
      println("UUT")
      println(reducedPrimeImplicants.map(_.toString(4)).mkString("\n"))
    }
    {
      val trueTerms = List(0, 15).map(v => Masked(v, 0xF))
      val falseTerms = List(3).map(v => Masked(v, 0xF))
      val primes =  getPrimeImplicantsByTrueAndFalse(trueTerms, falseTerms, 4)
      println(primes.map(_.toString(4)).mkString("\n"))
    }
  }
}