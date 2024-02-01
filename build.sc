import mill._, scalalib._

val spinalVersion = "1.10.1"

object ivys {
  val sv = "2.11.12"
  val spinalCore = ivy"com.github.spinalhdl::spinalhdl-core:$spinalVersion"
  val spinalLib = ivy"com.github.spinalhdl::spinalhdl-lib:$spinalVersion"
  val spinalPlugin = ivy"com.github.spinalhdl::spinalhdl-idsl-plugin:$spinalVersion"
  val scalatest = ivy"org.scalatest::scalatest:3.2.5"
  val macroParadise = ivy"org.scalamacros:::paradise:2.1.1"
  val yaml = ivy"org.yaml:snakeyaml:1.8"
}

trait Common extends ScalaModule  {
  override def scalaVersion = ivys.sv
  override def scalacPluginIvyDeps = Agg(ivys.macroParadise, ivys.spinalPlugin)
  override def ivyDeps = Agg(ivys.spinalCore, ivys.spinalLib, ivys.yaml, ivys.scalatest)
  override def scalacOptions = Seq("-Xsource:2.11")
}

object VexRiscv extends Common with SbtModule{
  override def millSourcePath = os.pwd
  override def moduleDeps: Seq[JavaModule] = super.moduleDeps

  object test extends SbtModuleTests with TestModule.ScalaTest
}

