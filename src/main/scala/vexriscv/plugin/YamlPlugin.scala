package vexriscv.plugin

import java.util

import vexriscv.{ReportService, VexRiscv}
import org.yaml.snakeyaml.{DumperOptions, Yaml}


/**
 * Created by spinalvm on 09.06.17.
 */
class YamlPlugin(path : String) extends Plugin[VexRiscv] with ReportService{

  val content = new util.HashMap[String, Object]()

  def add(that : (String,Object)) : Unit  = content.put(that._1,that._2)

  override def setup(pipeline: VexRiscv): Unit = {

  }

  override def build(pipeline: VexRiscv): Unit = {
    val options = new DumperOptions()
    options.setWidth(50)
    options.setIndent(4)
    options.setCanonical(true)
    options.setDefaultFlowStyle(DumperOptions.FlowStyle.BLOCK)

    val yaml = new Yaml()
    yaml.dump(content, new java.io.FileWriter(path))
  }
}
