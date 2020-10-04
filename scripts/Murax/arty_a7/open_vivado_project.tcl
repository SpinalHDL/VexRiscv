source [file join [file dirname [file normalize [info script]]] vivado_params.tcl]

open_project -read_only $outputdir/$projectName
start_gui
