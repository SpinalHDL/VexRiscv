package vexriscv.ip.fpu

object MiaouDiv extends App{
  val input = 2.5
  var output = 1/(input*0.95)

  def y = output
  def x = input

  for(i <- 0 until 10) {
    output = 2 * y - x * y * y
    println(output)
  }


  //output = x*output
  println(1/input)
}

object MiaouSqrt extends App{
  val input = 2.0
  var output = 1/Math.sqrt(input*0.95)
  //  def x = output
  //  def y = input

  def y = output
  def x = input

  for(i <- 0 until 10) {
    output = y * (1.5 - x * y * y / 2)
    println(output)
  }

  output = x*output
  println(output)
  println(s"ref ${Math.sqrt(input)}")
}


object MiaouNan extends App{
  println(Float.NaN + 3.0f)
  println(3.0f + Float.NaN )
  println(0.0f*Float.PositiveInfinity )
  println(1.0f/0.0f )
  println(Float.MaxValue -1 )
  println(Float.PositiveInfinity - Float.PositiveInfinity)
}