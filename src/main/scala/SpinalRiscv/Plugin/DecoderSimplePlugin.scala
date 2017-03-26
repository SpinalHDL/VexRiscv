package SpinalRiscv.Plugin

import SpinalRiscv._
import spinal.core._
import spinal.lib._

import scala.Predef.assert
import scala.collection.mutable


case class Masked(value : BigInt,care : BigInt){

}

class DecoderSimplePlugin(catchIllegalInstruction : Boolean) extends Plugin[VexRiscv] with DecoderService {
  override def add(encoding: Seq[(MaskedLiteral, Seq[(Stageable[_ <: BaseType], Any)])]): Unit = encoding.foreach(e => this.add(e._1,e._2))
  override def add(key: MaskedLiteral, values: Seq[(Stageable[_ <: BaseType], Any)]): Unit = {
    assert(!encodings.contains(key))
    encodings(key) = values.map{case (a,b) => (a,b match{
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
  val encodings = mutable.HashMap[MaskedLiteral,Seq[(Stageable[_ <: BaseType], BaseType)]]()
  var decodeExceptionPort : Flow[ExceptionCause] = null


  override def setup(pipeline: VexRiscv): Unit = {
    import pipeline.config._
    addDefault(LEGAL_INSTRUCTION, False)

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
          value.input match {
            case literal: EnumLiteral[_] => literal.fixEncoding(e.dataType.asInstanceOf[SpinalEnumCraft[_]].getEncoding)
            case _ =>
          }
          defaultValue += value.input.asInstanceOf[Literal].getValue << offset
          defaultCare += ((BigInt(1) << e.dataType.getBitsWidth) - 1) << offset

        }
        case _ =>
      }
      offsetOf(e) = offset
      offset += e.dataType.getBitsWidth
    })

    //Build spec
    val spec = encodings.map { case (key, values) =>
      var decodedValue, decodedCare = BigInt(0)
      for((e, literal) <- values){
        literal.input match{
          case literal : EnumLiteral[_] => literal.fixEncoding(e.dataType.asInstanceOf[SpinalEnumCraft[_]].getEncoding)
          case _ =>
        }
        val offset = offsetOf(e)
        decodedValue += literal.input.asInstanceOf[Literal].getValue << offset
        decodedCare += ((BigInt(1) << e.dataType.getBitsWidth)-1) << offset
      }
      (Masked(key.value,key.careAbout),Masked(decodedValue,decodedCare))
    }



    // logic implementation
    val decodedBits = Bits(stageables.foldLeft(0)(_ + _.dataType.getBitsWidth) bits)
    val defaultBits = cloneOf(decodedBits)

//    assert(defaultValue == 0)
//    defaultBits := defaultValue
//
//    val logicOr = for((key, mapping) <- spec) yield Mux[Bits](((input(INSTRUCTION) &  key.care) === (key.value & key.care)), B(mapping.value & mapping.care, decodedBits.getWidth bits) , B(0, decodedBits.getWidth bits))
//    decodedBits := logicOr.foldLeft(defaultBits)(_ | _)


    for(i <- decodedBits.range)
      if(defaultCare.testBit(i))
        defaultBits(i) := Bool(defaultValue.testBit(i))
      else
        defaultBits(i).assignDontCare()


    val logicOr = for((key, mapping) <- spec) yield Mux[Bits](((input(INSTRUCTION) &  key.care) === (key.value & key.care)), B(mapping.value & mapping.care, decodedBits.getWidth bits) , B(0, decodedBits.getWidth bits))
    val logicAnd = for((key, mapping) <- spec) yield Mux[Bits](((input(INSTRUCTION) &  key.care) === (key.value & key.care)), B(~mapping.value & mapping.care, decodedBits.getWidth bits) , B(0, decodedBits.getWidth bits))
    decodedBits :=  (defaultBits | logicOr.foldLeft(B(0, decodedBits.getWidth bits))(_ | _)) & ~logicAnd.foldLeft(B(0, decodedBits.getWidth bits))(_ | _)


    //Unpack decodedBits and insert fields in the pipeline
    offset = 0
    stageables.foreach(e => {
      insert(e).assignFromBits(decodedBits(offset, e.dataType.getBitsWidth bits))
//            insert(e).assignFromBits(RegNext(decodedBits(offset, e.dataType.getBitsWidth bits)))
      offset += e.dataType.getBitsWidth
    })


    if(catchIllegalInstruction){
      decodeExceptionPort.valid := arbitration.isValid && !input(LEGAL_INSTRUCTION)
      decodeExceptionPort.code := 2
    }
  }

  def bench(toplevel : VexRiscv): Unit ={
    toplevel.rework{
      import toplevel.config._
      toplevel.getAllIo.toList.foreach(_.asDirectionLess())
      toplevel.decode.input(INSTRUCTION) := Delay((in Bits(32 bits)).setName("instruction"),2)
      val stageables = encodings.flatMap(_._2.map(_._1)).toSet
      stageables.foreach(e => out(Delay(toplevel.decode.insert(e),2)).setName(e.getName))
      toplevel.getAdditionalNodesRoot.clear()
    }
  }
}