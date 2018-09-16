name := "VexRiscv"

organization := "com.github.spinalhdl"

version := "1.0.0"

scalaVersion := "2.11.6"

EclipseKeys.withSource := true

libraryDependencies ++= Seq(
  "com.github.spinalhdl" % "spinalhdl-core_2.11" % "1.2.0",
  "com.github.spinalhdl" % "spinalhdl-lib_2.11" % "1.2.0",
  "org.scalatest" % "scalatest_2.11" % "2.2.1",
  "org.yaml" % "snakeyaml" % "1.8"
)



addCompilerPlugin("org.scala-lang.plugins" % "scala-continuations-plugin_2.11.6" % "1.0.2")
scalacOptions += "-P:continuations:enable"
fork := true
