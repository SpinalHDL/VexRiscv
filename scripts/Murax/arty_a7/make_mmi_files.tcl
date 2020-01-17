source [file join [file dirname [file normalize [info script]]] vivado_params.tcl]

open_project -read_only $outputdir/$projectName
open_run impl_1
source $base/soc_mmi.tcl
puts "mmi files generated"
