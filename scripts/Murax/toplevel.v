`timescale 1ns / 1ps

module toplevel(
    input   io_J3,
    input   io_H16,
    input   io_G15,
    output  io_G16,
    input   io_F15,
    output  io_B12,
    input   io_B10,
    output [7:0] io_led
  );
  
  wire [31:0] io_gpioA_read;
  wire [31:0] io_gpioA_write;
  wire [31:0] io_gpioA_writeEnable;


  wire io_jtag_tck;
  wire io_jtag_tdi;
  wire io_jtag_tms;

  SB_IO #(
      .PIN_TYPE(6'b0000_01),
      .PULLUP(1'b1)
  ) io_jtag_tck_buff (
      .PACKAGE_PIN(io_H16),
      .D_IN_0(io_jtag_tck)
  );

  SB_IO #(
      .PIN_TYPE(6'b0000_01),
      .PULLUP(1'b1)
  ) io_jtag_tdi_buff (
      .PACKAGE_PIN(io_G15),
      .D_IN_0(io_jtag_tdi)
  );

  SB_IO #(
      .PIN_TYPE(6'b0000_01),
      .PULLUP(1'b1)
  ) io_jtag_tms_buff (
      .PACKAGE_PIN(io_F15),
      .D_IN_0(io_jtag_tms)
  );


  wire io_mainClk_gb;
  wire io_jtag_tck_gb;

  SB_GB mainClkBuffer (
    .USER_SIGNAL_TO_GLOBAL_BUFFER (io_J3),
    .GLOBAL_BUFFER_OUTPUT ( io_mainClk_gb)
  );

  SB_GB jtagClkBuffer (
    .USER_SIGNAL_TO_GLOBAL_BUFFER (io_jtag_tck),
    .GLOBAL_BUFFER_OUTPUT ( io_jtag_tck_gb)
  );



  assign io_led = io_gpioA_write[7 : 0];

  Murax murax ( 
    .io_asyncReset(0),
    .io_mainClk (io_mainClk_gb ),
    .io_jtag_tck(io_jtag_tck_gb),
    .io_jtag_tdi(io_jtag_tdi),
    .io_jtag_tdo(io_jtag_tdo),
    .io_jtag_tms(io_jtag_tms),
    .io_gpioA_read       (io_gpioA_read),
    .io_gpioA_write      (io_gpioA_write),
    .io_gpioA_writeEnable(io_gpioA_writeEnable),
    .io_uart_txd(io_B12),
    .io_uart_rxd(io_B10)
  );		
endmodule