val spinalVersion = "1.13.0"

lazy val root = (project in file(".")).
  settings(
    inThisBuild(List(
      organization       := "com.github.spinalhdl",
      crossScalaVersions := Seq("2.13.18", "2.12.18"),
      version            := "2.1.0"
    )),
    libraryDependencies ++= Seq(
      "com.github.spinalhdl" %% "spinalhdl-core" % spinalVersion,
      "com.github.spinalhdl" %% "spinalhdl-lib" % spinalVersion,
      compilerPlugin("com.github.spinalhdl" %% "spinalhdl-idsl-plugin" % spinalVersion),
      "org.scalatest" %% "scalatest" % "3.2.17" % Test,
      "org.yaml" % "snakeyaml" % "1.8"
    ),
    name := "VexRiscv"
  )

fork := true
