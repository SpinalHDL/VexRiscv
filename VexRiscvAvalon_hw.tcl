
package require -exact qsys 13.1

#
# module def
#
set_module_property DESCRIPTION ""
set_module_property NAME VexRiscvAvalon
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME VexRiscvAvalon
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property ANALYZE_HDL false
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false

#
# file sets
#
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL VexRiscvAvalon
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
#add_fileset_file VexRiscvAvalon.vhd VHDL PATH VexRiscvAvalon.vhd TOP_LEVEL_FILE

add_fileset SIM_VHDL SIM_VHDL "" ""
set_fileset_property SIM_VHDL TOP_LEVEL VexRiscvAvalon
set_fileset_property SIM_VHDL ENABLE_RELATIVE_INCLUDE_PATHS false
#add_fileset_file VexRiscvAvalon.vhd VHDL PATH VexRiscvAvalon.vhd


#
# connection point debug_resetOut
#
add_interface debug_resetOut reset start
set_interface_property debug_resetOut associatedClock clk
set_interface_property debug_resetOut associatedDirectReset ""
set_interface_property debug_resetOut associatedResetSinks ""
set_interface_property debug_resetOut synchronousEdges DEASSERT
set_interface_property debug_resetOut ENABLED true
set_interface_property debug_resetOut EXPORT_OF ""
set_interface_property debug_resetOut PORT_NAME_MAP ""
set_interface_property debug_resetOut SVD_ADDRESS_GROUP ""

add_interface_port debug_resetOut debug_resetOut reset Output 1

#
# connection point timerInterrupt
#
add_interface timerInterrupt interrupt start
set_interface_property timerInterrupt associatedAddressablePoint iBusAvalon
set_interface_property timerInterrupt associatedClock clk
set_interface_property timerInterrupt associatedReset reset
set_interface_property timerInterrupt irqScheme INDIVIDUAL_REQUESTS
set_interface_property timerInterrupt ENABLED true
set_interface_property timerInterrupt EXPORT_OF ""
set_interface_property timerInterrupt PORT_NAME_MAP ""
set_interface_property timerInterrupt SVD_ADDRESS_GROUP ""

add_interface_port timerInterrupt timerInterrupt irq Input 1

#
# connection point externalInterrupt
#
add_interface externalInterrupt interrupt start
set_interface_property externalInterrupt associatedAddressablePoint iBusAvalon
set_interface_property externalInterrupt associatedClock clk
set_interface_property externalInterrupt associatedReset reset
set_interface_property externalInterrupt irqScheme INDIVIDUAL_REQUESTS
set_interface_property externalInterrupt ENABLED true
set_interface_property externalInterrupt EXPORT_OF ""
set_interface_property externalInterrupt PORT_NAME_MAP ""
set_interface_property externalInterrupt SVD_ADDRESS_GROUP ""

add_interface_port externalInterrupt externalInterrupt irq Input 1

#
# connection point iBusAvalon
#
add_interface iBusAvalon avalon start
set_interface_property iBusAvalon addressUnits SYMBOLS
set_interface_property iBusAvalon burstcountUnits WORDS
set_interface_property iBusAvalon burstOnBurstBoundariesOnly false
set_interface_property iBusAvalon constantBurstBehavior true
set_interface_property iBusAvalon holdTime 0
set_interface_property iBusAvalon linewrapBursts true
set_interface_property iBusAvalon maximumPendingReadTransactions 1
set_interface_property iBusAvalon maximumPendingWriteTransactions 0
set_interface_property iBusAvalon readLatency 0
set_interface_property iBusAvalon readWaitTime 0
set_interface_property iBusAvalon setupTime 0
set_interface_property iBusAvalon writeWaitTime 0
set_interface_property iBusAvalon holdTime 0

set_interface_property iBusAvalon associatedClock clk
set_interface_property iBusAvalon associatedReset reset
set_interface_property iBusAvalon bitsPerSymbol 8

set_interface_property iBusAvalon timingUnits Cycles
set_interface_property iBusAvalon ENABLED true
set_interface_property iBusAvalon EXPORT_OF ""
set_interface_property iBusAvalon PORT_NAME_MAP ""
set_interface_property iBusAvalon SVD_ADDRESS_GROUP ""

set_interface_property iBusAvalon doStreamReads false
set_interface_property iBusAvalon doStreamWrites false
add_interface_port iBusAvalon iBusAvalon_address address Output 32
add_interface_port iBusAvalon iBusAvalon_read read Output 1
add_interface_port iBusAvalon iBusAvalon_waitRequestn waitrequest_n Input 1
add_interface_port iBusAvalon iBusAvalon_burstCount burstcount Output 4
add_interface_port iBusAvalon iBusAvalon_readDataValid readdatavalid Input 1
add_interface_port iBusAvalon iBusAvalon_readData readdata Input 32

#
# connection point dBusAvalon
#
add_interface dBusAvalon avalon start
set_interface_property dBusAvalon addressUnits SYMBOLS
set_interface_property dBusAvalon burstcountUnits WORDS
set_interface_property dBusAvalon burstOnBurstBoundariesOnly true
set_interface_property dBusAvalon constantBurstBehavior true
set_interface_property dBusAvalon holdTime 0
set_interface_property dBusAvalon linewrapBursts false
set_interface_property dBusAvalon maximumPendingReadTransactions 2
set_interface_property dBusAvalon maximumPendingWriteTransactions 0
set_interface_property dBusAvalon readLatency 0
set_interface_property dBusAvalon readWaitTime 0
set_interface_property dBusAvalon setupTime 0
set_interface_property dBusAvalon writeWaitTime 0
set_interface_property dBusAvalon holdTime 0

set_interface_property dBusAvalon associatedClock clk
set_interface_property dBusAvalon associatedReset reset
set_interface_property dBusAvalon bitsPerSymbol 8

set_interface_property dBusAvalon timingUnits Cycles
set_interface_property dBusAvalon ENABLED true
set_interface_property dBusAvalon EXPORT_OF ""
set_interface_property dBusAvalon PORT_NAME_MAP ""
set_interface_property dBusAvalon SVD_ADDRESS_GROUP ""

set_interface_property dBusAvalon doStreamReads false
set_interface_property dBusAvalon doStreamWrites false
add_interface_port dBusAvalon dBusAvalon_address address Output 32
add_interface_port dBusAvalon dBusAvalon_read read Output 1
add_interface_port dBusAvalon dBusAvalon_write write Output 1
add_interface_port dBusAvalon dBusAvalon_waitRequestn waitrequest_n Input 1
add_interface_port dBusAvalon dBusAvalon_burstCount burstcount Output 4
add_interface_port dBusAvalon dBusAvalon_byteEnable byteenable Output 4
add_interface_port dBusAvalon dBusAvalon_writeData writedata Output 32
add_interface_port dBusAvalon dBusAvalon_readDataValid readdatavalid Input 1
add_interface_port dBusAvalon dBusAvalon_readData readdata Input 32

#
# connection point debugBusAvalon
#
add_interface debugBusAvalon avalon end
set_interface_property debugBusAvalon addressUnits SYMBOLS
set_interface_property debugBusAvalon burstcountUnits WORDS
set_interface_property debugBusAvalon burstOnBurstBoundariesOnly false
set_interface_property debugBusAvalon constantBurstBehavior false
set_interface_property debugBusAvalon holdTime 0
set_interface_property debugBusAvalon linewrapBursts false
set_interface_property debugBusAvalon maximumPendingReadTransactions 0
set_interface_property debugBusAvalon maximumPendingWriteTransactions 0
set_interface_property debugBusAvalon readLatency 0
set_interface_property debugBusAvalon readWaitTime 0
set_interface_property debugBusAvalon setupTime 0
set_interface_property debugBusAvalon writeWaitTime 0
set_interface_property debugBusAvalon holdTime 0

set_interface_property debugBusAvalon associatedClock clk
set_interface_property debugBusAvalon associatedReset debugReset
set_interface_property debugBusAvalon bitsPerSymbol 8

set_interface_property debugBusAvalon timingUnits Cycles
set_interface_property debugBusAvalon ENABLED true
set_interface_property debugBusAvalon EXPORT_OF ""
set_interface_property debugBusAvalon PORT_NAME_MAP ""
set_interface_property debugBusAvalon SVD_ADDRESS_GROUP ""

add_interface_port debugBusAvalon debugBusAvalon_address address Input 8
add_interface_port debugBusAvalon debugBusAvalon_read read Input 1
add_interface_port debugBusAvalon debugBusAvalon_write write Input 1
add_interface_port debugBusAvalon debugBusAvalon_waitRequestn waitrequest_n Output 1
add_interface_port debugBusAvalon debugBusAvalon_writeData writedata Input 32
add_interface_port debugBusAvalon debugBusAvalon_readData readdata Output 32

#
# connection point clk
#
add_interface clk clock end
set_interface_property clk clockRate 0
set_interface_property clk ENABLED true
set_interface_property clk EXPORT_OF ""
set_interface_property clk PORT_NAME_MAP ""
set_interface_property clk SVD_ADDRESS_GROUP ""

add_interface_port clk clk clk Input 1
             
#
# connection point debugReset
#
add_interface debugReset reset end
set_interface_property debugReset associatedClock clk
set_interface_property debugReset synchronousEdges DEASSERT
set_interface_property debugReset ENABLED true
set_interface_property debugReset EXPORT_OF ""
set_interface_property debugReset PORT_NAME_MAP ""
set_interface_property debugReset SVD_ADDRESS_GROUP ""

add_interface_port debugReset debugReset reset Input 1
             
#
# connection point reset
#
add_interface reset reset end
set_interface_property reset associatedClock clk
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset reset Input 1
             