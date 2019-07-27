
lazy val root = (project in file(".")).
  settings(
    inThisBuild(List(
      organization := "com.github.spinalhdl",
      scalaVersion := "2.11.12",
      version      := "2.0.0"
    )),
    libraryDependencies ++= Seq(
        "com.github.spinalhdl" % "spinalhdl-core_2.11" % "1.3.6",
        "com.github.spinalhdl" % "spinalhdl-lib_2.11" % "1.3.6",
        "org.scalatest" % "scalatest_2.11" % "2.2.1",
        "org.yaml" % "snakeyaml" % "1.8"
    ),
    name := "VexRiscv"
  )//.dependsOn(spinalHdlSim,spinalHdlCore,spinalHdlLib)
//lazy val spinalHdlSim = ProjectRef(file("../SpinalHDL"), "sim")
//lazy val spinalHdlCore = ProjectRef(file("../SpinalHDL"), "core")
//lazy val spinalHdlLib = ProjectRef(file("../SpinalHDL"), "lib")


fork := true