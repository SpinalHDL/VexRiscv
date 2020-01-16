set_property PACKAGE_PIN	F4	 [get_ports tck]
set_property IOSTANDARD LVCMOS33 [get_ports tck]

set_property PACKAGE_PIN	D2	 [get_ports tms]
set_property IOSTANDARD LVCMOS33 [get_ports tms]

set_property PACKAGE_PIN	D4	 [get_ports tdo]
set_property IOSTANDARD LVCMOS33 [get_ports tdo]
set_property PULLUP		true	 [get_ports tdo]

set_property PACKAGE_PIN	E2	 [get_ports tdi]
set_property IOSTANDARD LVCMOS33 [get_ports tdi]

set_property PACKAGE_PIN	D3	 [get_ports trst]
set_property IOSTANDARD LVCMOS33 [get_ports trst]
set_property	PULLUP	true	 [get_ports trst]


## serial:0.tx
set_property PACKAGE_PIN D10 [get_ports serial_tx]
set_property IOSTANDARD LVCMOS33 [get_ports serial_tx]
## serial:0.rx
set_property PACKAGE_PIN A9 [get_ports serial_rx]
set_property IOSTANDARD LVCMOS33 [get_ports serial_rx]
## clk100:0
set_property PACKAGE_PIN E3 [get_ports clk100]
set_property IOSTANDARD LVCMOS33 [get_ports clk100]
## cpu_reset:0
set_property PACKAGE_PIN C2 [get_ports cpu_reset]
set_property IOSTANDARD LVCMOS33 [get_ports cpu_reset]
## eth_ref_clk:0
#set_property LOC G18 [get_ports eth_ref_clk]
#set_property IOSTANDARD LVCMOS33 [get_ports eth_ref_clk]
## user_led:0
set_property PACKAGE_PIN H5 [get_ports user_led0]
set_property IOSTANDARD LVCMOS33 [get_ports user_led0]
## user_led:1
set_property PACKAGE_PIN J5 [get_ports user_led1]
set_property IOSTANDARD LVCMOS33 [get_ports user_led1]
## user_led:2
set_property PACKAGE_PIN T9 [get_ports user_led2]
set_property IOSTANDARD LVCMOS33 [get_ports user_led2]
## user_led:3
set_property PACKAGE_PIN T10 [get_ports user_led3]
set_property IOSTANDARD LVCMOS33 [get_ports user_led3]
## user_sw:0
set_property PACKAGE_PIN A8 [get_ports user_sw0]
set_property IOSTANDARD LVCMOS33 [get_ports user_sw0]
## user_sw:1
set_property PACKAGE_PIN C11 [get_ports user_sw1]
set_property IOSTANDARD LVCMOS33 [get_ports user_sw1]
## user_sw:2
set_property PACKAGE_PIN C10 [get_ports user_sw2]
set_property IOSTANDARD LVCMOS33 [get_ports user_sw2]
## user_sw:3
set_property PACKAGE_PIN A10 [get_ports user_sw3]
set_property IOSTANDARD LVCMOS33 [get_ports user_sw3]
## user_btn:0
set_property PACKAGE_PIN D9 [get_ports user_btn0]
set_property IOSTANDARD LVCMOS33 [get_ports user_btn0]
## user_btn:1
set_property PACKAGE_PIN C9 [get_ports user_btn1]
set_property IOSTANDARD LVCMOS33 [get_ports user_btn1]
## user_btn:2
set_property PACKAGE_PIN B9 [get_ports user_btn2]
set_property IOSTANDARD LVCMOS33 [get_ports user_btn2]
## user_btn:3
set_property PACKAGE_PIN B8 [get_ports user_btn3]
set_property IOSTANDARD LVCMOS33 [get_ports user_btn3]
## spiflash_1x:0.cs_n
#set_property LOC L13 [get_ports spiflash_1x_cs_n]
#set_property IOSTANDARD LVCMOS33 [get_ports spiflash_1x_cs_n]
# ## spiflash_1x:0.mosi
#set_property LOC K17 [get_ports spiflash_1x_mosi]
#set_property IOSTANDARD LVCMOS33 [get_ports spiflash_1x_mosi]
# ## spiflash_1x:0.miso
#set_property LOC K18 [get_ports spiflash_1x_miso]
#set_property IOSTANDARD LVCMOS33 [get_ports spiflash_1x_miso]
# ## spiflash_1x:0.wp
#set_property LOC L14 [get_ports spiflash_1x_wp]
#set_property IOSTANDARD LVCMOS33 [get_ports spiflash_1x_wp]
# ## spiflash_1x:0.hold
#set_property LOC M14 [get_ports spiflash_1x_hold]
#set_property IOSTANDARD LVCMOS33 [get_ports spiflash_1x_hold]
# ## ddram:0.a
#set_property LOC R2 [get_ports ddram_a[0]]
#set_property SLEW FAST [get_ports ddram_a[0]]
#set_property IOSTANDARD SSTL15 [get_ports ddram_a[0]]
# ## ddram:0.a
#set_property LOC M6 [get_ports ddram_a[1]]
#set_property SLEW FAST [get_ports ddram_a[1]]
#set_property IOSTANDARD SSTL15 [get_ports ddram_a[1]]
# ## ddram:0.a
#set_property LOC N4 [get_ports ddram_a[2]]
#set_property SLEW FAST [get_ports ddram_a[2]]
#set_property IOSTANDARD SSTL15 [get_ports ddram_a[2]]
# ## ddram:0.a
#set_property LOC T1 [get_ports ddram_a[3]]
#set_property SLEW FAST [get_ports ddram_a[3]]
#set_property IOSTANDARD SSTL15 [get_ports ddram_a[3]]
# ## ddram:0.a
#set_property LOC N6 [get_ports ddram_a[4]]
#set_property SLEW FAST [get_ports ddram_a[4]]
#set_property IOSTANDARD SSTL15 [get_ports ddram_a[4]]
# ## ddram:0.a
#set_property LOC R7 [get_ports ddram_a[5]]
#set_property SLEW FAST [get_ports ddram_a[5]]
#set_property IOSTANDARD SSTL15 [get_ports ddram_a[5]]
# ## ddram:0.a
#set_property LOC V6 [get_ports ddram_a[6]]
#set_property SLEW FAST [get_ports ddram_a[6]]
#set_property IOSTANDARD SSTL15 [get_ports ddram_a[6]]
# ## ddram:0.a
#set_property LOC U7 [get_ports ddram_a[7]]
#set_property SLEW FAST [get_ports ddram_a[7]]
#set_property IOSTANDARD SSTL15 [get_ports ddram_a[7]]
# ## ddram:0.a
#set_property LOC R8 [get_ports ddram_a[8]]
#set_property SLEW FAST [get_ports ddram_a[8]]
#set_property IOSTANDARD SSTL15 [get_ports ddram_a[8]]
# ## ddram:0.a
#set_property LOC V7 [get_ports ddram_a[9]]
#set_property SLEW FAST [get_ports ddram_a[9]]
#set_property IOSTANDARD SSTL15 [get_ports ddram_a[9]]
# ## ddram:0.a
#set_property LOC R6 [get_ports ddram_a[10]]
#set_property SLEW FAST [get_ports ddram_a[10]]
#set_property IOSTANDARD SSTL15 [get_ports ddram_a[10]]
# ## ddram:0.a
#set_property LOC U6 [get_ports ddram_a[11]]
#set_property SLEW FAST [get_ports ddram_a[11]]
#set_property IOSTANDARD SSTL15 [get_ports ddram_a[11]]
# ## ddram:0.a
#set_property LOC T6 [get_ports ddram_a[12]]
#set_property SLEW FAST [get_ports ddram_a[12]]
#set_property IOSTANDARD SSTL15 [get_ports ddram_a[12]]
# ## ddram:0.a
#set_property LOC T8 [get_ports ddram_a[13]]
#set_property SLEW FAST [get_ports ddram_a[13]]
#set_property IOSTANDARD SSTL15 [get_ports ddram_a[13]]
# ## ddram:0.ba
#set_property LOC R1 [get_ports ddram_ba[0]]
#set_property SLEW FAST [get_ports ddram_ba[0]]
#set_property IOSTANDARD SSTL15 [get_ports ddram_ba[0]]
# ## ddram:0.ba
#set_property LOC P4 [get_ports ddram_ba[1]]
#set_property SLEW FAST [get_ports ddram_ba[1]]
#set_property IOSTANDARD SSTL15 [get_ports ddram_ba[1]]
# ## ddram:0.ba
#set_property LOC P2 [get_ports ddram_ba[2]]
#set_property SLEW FAST [get_ports ddram_ba[2]]
#set_property IOSTANDARD SSTL15 [get_ports ddram_ba[2]]
# ## ddram:0.ras_n
#set_property LOC P3 [get_ports ddram_ras_n]
#set_property SLEW FAST [get_ports ddram_ras_n]
#set_property IOSTANDARD SSTL15 [get_ports ddram_ras_n]
# ## ddram:0.cas_n
#set_property LOC M4 [get_ports ddram_cas_n]
#set_property SLEW FAST [get_ports ddram_cas_n]
#set_property IOSTANDARD SSTL15 [get_ports ddram_cas_n]
# ## ddram:0.we_n
#set_property LOC P5 [get_ports ddram_we_n]
#set_property SLEW FAST [get_ports ddram_we_n]
#set_property IOSTANDARD SSTL15 [get_ports ddram_we_n]
# ## ddram:0.cs_n
#set_property LOC U8 [get_ports ddram_cs_n]
#set_property SLEW FAST [get_ports ddram_cs_n]
#set_property IOSTANDARD SSTL15 [get_ports ddram_cs_n]
# ## ddram:0.dm
#set_property LOC L1 [get_ports ddram_dm[0]]
#set_property SLEW FAST [get_ports ddram_dm[0]]
#set_property IOSTANDARD SSTL15 [get_ports ddram_dm[0]]
# ## ddram:0.dm
#set_property LOC U1 [get_ports ddram_dm[1]]
#set_property SLEW FAST [get_ports ddram_dm[1]]
#set_property IOSTANDARD SSTL15 [get_ports ddram_dm[1]]
# ## ddram:0.dq
#set_property LOC K5 [get_ports ddram_dq[0]]
#set_property SLEW FAST [get_ports ddram_dq[0]]
#set_property IOSTANDARD SSTL15 [get_ports ddram_dq[0]]
#set_property IN_TERM UNTUNED_SPLIT_40 [get_ports ddram_dq[0]]
# ## ddram:0.dq
#set_property LOC L3 [get_ports ddram_dq[1]]
#set_property SLEW FAST [get_ports ddram_dq[1]]
#set_property IOSTANDARD SSTL15 [get_ports ddram_dq[1]]
#set_property IN_TERM UNTUNED_SPLIT_40 [get_ports ddram_dq[1]]
# ## ddram:0.dq
#set_property LOC K3 [get_ports ddram_dq[2]]
#set_property SLEW FAST [get_ports ddram_dq[2]]
#set_property IOSTANDARD SSTL15 [get_ports ddram_dq[2]]
#set_property IN_TERM UNTUNED_SPLIT_40 [get_ports ddram_dq[2]]
# ## ddram:0.dq
#set_property LOC L6 [get_ports ddram_dq[3]]
#set_property SLEW FAST [get_ports ddram_dq[3]]
#set_property IOSTANDARD SSTL15 [get_ports ddram_dq[3]]
#set_property IN_TERM UNTUNED_SPLIT_40 [get_ports ddram_dq[3]]
# ## ddram:0.dq
#set_property LOC M3 [get_ports ddram_dq[4]]
#set_property SLEW FAST [get_ports ddram_dq[4]]
#set_property IOSTANDARD SSTL15 [get_ports ddram_dq[4]]
#set_property IN_TERM UNTUNED_SPLIT_40 [get_ports ddram_dq[4]]
# ## ddram:0.dq
#set_property LOC M1 [get_ports ddram_dq[5]]
#set_property SLEW FAST [get_ports ddram_dq[5]]
#set_property IOSTANDARD SSTL15 [get_ports ddram_dq[5]]
#set_property IN_TERM UNTUNED_SPLIT_40 [get_ports ddram_dq[5]]
# ## ddram:0.dq
#set_property LOC L4 [get_ports ddram_dq[6]]
#set_property SLEW FAST [get_ports ddram_dq[6]]
#set_property IOSTANDARD SSTL15 [get_ports ddram_dq[6]]
#set_property IN_TERM UNTUNED_SPLIT_40 [get_ports ddram_dq[6]]
# ## ddram:0.dq
#set_property LOC M2 [get_ports ddram_dq[7]]
#set_property SLEW FAST [get_ports ddram_dq[7]]
#set_property IOSTANDARD SSTL15 [get_ports ddram_dq[7]]
#set_property IN_TERM UNTUNED_SPLIT_40 [get_ports ddram_dq[7]]
# ## ddram:0.dq
#set_property LOC V4 [get_ports ddram_dq[8]]
#set_property SLEW FAST [get_ports ddram_dq[8]]
#set_property IOSTANDARD SSTL15 [get_ports ddram_dq[8]]
#set_property IN_TERM UNTUNED_SPLIT_40 [get_ports ddram_dq[8]]
# ## ddram:0.dq
#set_property LOC T5 [get_ports ddram_dq[9]]
#set_property SLEW FAST [get_ports ddram_dq[9]]
#set_property IOSTANDARD SSTL15 [get_ports ddram_dq[9]]
#set_property IN_TERM UNTUNED_SPLIT_40 [get_ports ddram_dq[9]]
# ## ddram:0.dq
#set_property LOC U4 [get_ports ddram_dq[10]]
#set_property SLEW FAST [get_ports ddram_dq[10]]
#set_property IOSTANDARD SSTL15 [get_ports ddram_dq[10]]
#set_property IN_TERM UNTUNED_SPLIT_40 [get_ports ddram_dq[10]]
# ## ddram:0.dq
#set_property LOC V5 [get_ports ddram_dq[11]]
#set_property SLEW FAST [get_ports ddram_dq[11]]
#set_property IOSTANDARD SSTL15 [get_ports ddram_dq[11]]
#set_property IN_TERM UNTUNED_SPLIT_40 [get_ports ddram_dq[11]]
# ## ddram:0.dq
#set_property LOC V1 [get_ports ddram_dq[12]]
#set_property SLEW FAST [get_ports ddram_dq[12]]
#set_property IOSTANDARD SSTL15 [get_ports ddram_dq[12]]
#set_property IN_TERM UNTUNED_SPLIT_40 [get_ports ddram_dq[12]]
# ## ddram:0.dq
#set_property LOC T3 [get_ports ddram_dq[13]]
#set_property SLEW FAST [get_ports ddram_dq[13]]
#set_property IOSTANDARD SSTL15 [get_ports ddram_dq[13]]
#set_property IN_TERM UNTUNED_SPLIT_40 [get_ports ddram_dq[13]]
# ## ddram:0.dq
#set_property LOC U3 [get_ports ddram_dq[14]]
#set_property SLEW FAST [get_ports ddram_dq[14]]
#set_property IOSTANDARD SSTL15 [get_ports ddram_dq[14]]
#set_property IN_TERM UNTUNED_SPLIT_40 [get_ports ddram_dq[14]]
# ## ddram:0.dq
#set_property LOC R3 [get_ports ddram_dq[15]]
#set_property SLEW FAST [get_ports ddram_dq[15]]
#set_property IOSTANDARD SSTL15 [get_ports ddram_dq[15]]
#set_property IN_TERM UNTUNED_SPLIT_40 [get_ports ddram_dq[15]]
# ## ddram:0.dqs_p
#set_property LOC N2 [get_ports ddram_dqs_p[0]]
#set_property SLEW FAST [get_ports ddram_dqs_p[0]]
#set_property IOSTANDARD DIFF_SSTL15 [get_ports ddram_dqs_p[0]]
# ## ddram:0.dqs_p
#set_property LOC U2 [get_ports ddram_dqs_p[1]]
#set_property SLEW FAST [get_ports ddram_dqs_p[1]]
#set_property IOSTANDARD DIFF_SSTL15 [get_ports ddram_dqs_p[1]]
# ## ddram:0.dqs_n
#set_property LOC N1 [get_ports ddram_dqs_n[0]]
#set_property SLEW FAST [get_ports ddram_dqs_n[0]]
#set_property IOSTANDARD DIFF_SSTL15 [get_ports ddram_dqs_n[0]]
# ## ddram:0.dqs_n
#set_property LOC V2 [get_ports ddram_dqs_n[1]]
#set_property SLEW FAST [get_ports ddram_dqs_n[1]]
#set_property IOSTANDARD DIFF_SSTL15 [get_ports ddram_dqs_n[1]]
# ## ddram:0.clk_p
#set_property LOC U9 [get_ports ddram_clk_p]
#set_property SLEW FAST [get_ports ddram_clk_p]
#set_property IOSTANDARD DIFF_SSTL15 [get_ports ddram_clk_p]
# ## ddram:0.clk_n
#set_property LOC V9 [get_ports ddram_clk_n]
#set_property SLEW FAST [get_ports ddram_clk_n]
#set_property IOSTANDARD DIFF_SSTL15 [get_ports ddram_clk_n]
# ## ddram:0.cke
#set_property LOC N5 [get_ports ddram_cke]
#set_property SLEW FAST [get_ports ddram_cke]
#set_property IOSTANDARD SSTL15 [get_ports ddram_cke]
# ## ddram:0.odt
#set_property LOC R5 [get_ports ddram_odt]
#set_property SLEW FAST [get_ports ddram_odt]
#set_property IOSTANDARD SSTL15 [get_ports ddram_odt]
# ## ddram:0.reset_n
#set_property LOC K6 [get_ports ddram_reset_n]
#set_property SLEW FAST [get_ports ddram_reset_n]
#set_property IOSTANDARD SSTL15 [get_ports ddram_reset_n]
# ## eth_clocks:0.tx
#set_property LOC H16 [get_ports eth_clocks_tx]
#set_property IOSTANDARD LVCMOS33 [get_ports eth_clocks_tx]
# ## eth_clocks:0.rx
#set_property LOC F15 [get_ports eth_clocks_rx]
#set_property IOSTANDARD LVCMOS33 [get_ports eth_clocks_rx]
# ## eth:0.rst_n
#set_property LOC C16 [get_ports eth_rst_n]
#set_property IOSTANDARD LVCMOS33 [get_ports eth_rst_n]
# ## eth:0.mdio
#set_property LOC K13 [get_ports eth_mdio]
#set_property IOSTANDARD LVCMOS33 [get_ports eth_mdio]
# ## eth:0.mdc
#set_property LOC F16 [get_ports eth_mdc]
#set_property IOSTANDARD LVCMOS33 [get_ports eth_mdc]
# ## eth:0.rx_dv
#set_property LOC G16 [get_ports eth_rx_dv]
#set_property IOSTANDARD LVCMOS33 [get_ports eth_rx_dv]
# ## eth:0.rx_er
#set_property LOC C17 [get_ports eth_rx_er]
#set_property IOSTANDARD LVCMOS33 [get_ports eth_rx_er]
# ## eth:0.rx_data
#set_property LOC D18 [get_ports eth_rx_data[0]]
#set_property IOSTANDARD LVCMOS33 [get_ports eth_rx_data[0]]
# ## eth:0.rx_data
#set_property LOC E17 [get_ports eth_rx_data[1]]
#set_property IOSTANDARD LVCMOS33 [get_ports eth_rx_data[1]]
# ## eth:0.rx_data
#set_property LOC E18 [get_ports eth_rx_data[2]]
#set_property IOSTANDARD LVCMOS33 [get_ports eth_rx_data[2]]
# ## eth:0.rx_data
#set_property LOC G17 [get_ports eth_rx_data[3]]
#set_property IOSTANDARD LVCMOS33 [get_ports eth_rx_data[3]]
# ## eth:0.tx_en
#set_property LOC H15 [get_ports eth_tx_en]
#set_property IOSTANDARD LVCMOS33 [get_ports eth_tx_en]
# ## eth:0.tx_data
#set_property LOC H14 [get_ports eth_tx_data[0]]
#set_property IOSTANDARD LVCMOS33 [get_ports eth_tx_data[0]]
# ## eth:0.tx_data
#set_property LOC J14 [get_ports eth_tx_data[1]]
#set_property IOSTANDARD LVCMOS33 [get_ports eth_tx_data[1]]
# ## eth:0.tx_data
#set_property LOC J13 [get_ports eth_tx_data[2]]
#set_property IOSTANDARD LVCMOS33 [get_ports eth_tx_data[2]]
# ## eth:0.tx_data
#set_property LOC H17 [get_ports eth_tx_data[3]]
#set_property IOSTANDARD LVCMOS33 [get_ports eth_tx_data[3]]
# ## eth:0.col
#set_property LOC D17 [get_ports eth_col]
#set_property IOSTANDARD LVCMOS33 [get_ports eth_col]
# ## eth:0.crs
#set_property LOC G14 [get_ports eth_crs]
#set_property IOSTANDARD LVCMOS33 [get_ports eth_crs]

set_property INTERNAL_VREF 0.75 [get_iobanks 34]


create_clock -period 10.000 -name clk100 [get_nets clk100]

#create_clock -name eth_rx_clk -period 40.0 [get_nets eth_rx_clk]

#create_clock -name eth_tx_clk -period 40.0 [get_nets eth_tx_clk]

#set_clock_groups -group [get_clocks -include_generated_clocks -of [get_nets sys_clk]] -group [get_clocks -include_generated_clocks -of [get_nets eth_rx_clk]] -asynchronous

#set_clock_groups -group [get_clocks -include_generated_clocks -of [get_nets sys_clk]] -group [get_clocks -include_generated_clocks -of [get_nets eth_tx_clk]] -asynchronous

#set_clock_groups -group [get_clocks -include_generated_clocks -of [get_nets eth_rx_clk]] -group [get_clocks -include_generated_clocks -of [get_nets eth_tx_clk]] -asynchronous




set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
