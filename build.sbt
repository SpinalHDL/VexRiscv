name := "VexRiscv"

organization := "com.github.spinalhdl"

version := "1.0"

scalaVersion := "2.11.8"

EclipseKeys.withSource := true

libraryDependencies ++= Seq(
  "com.github.spinalhdl" % "spinalhdl-core_2.11" % "0.11.5",
  "com.github.spinalhdl" % "spinalhdl-lib_2.11" % "0.11.5",
  "org.yaml" % "snakeyaml" % "1.8"
)
