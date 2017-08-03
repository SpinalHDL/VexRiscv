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
  wire io_mainClk;
  wire io_jtag_tck;

  SB_GB mainClkBuffer (
    .USER_SIGNAL_TO_GLOBAL_BUFFER (io_J3),
    .GLOBAL_BUFFER_OUTPUT ( io_mainClk)
  );

  SB_GB jtagClkBuffer (
    .USER_SIGNAL_TO_GLOBAL_BUFFER (io_H16),
    .GLOBAL_BUFFER_OUTPUT ( io_jtag_tck)
  );

  assign io_led = io_gpioA_write[7 : 0];

  Murax murax ( 
    .io_asyncReset(0),
    .io_mainClk (io_mainClk ),
    .io_jtag_tck(io_jtag_tck),
    .io_jtag_tdi(io_G15),
    .io_jtag_tdo(io_G16),
    .io_jtag_tms(io_F15),
    .io_gpioA_read       (io_gpioA_read),
    .io_gpioA_write      (io_gpioA_write),
    .io_gpioA_writeEnable(io_gpioA_writeEnable),
    .io_uart_txd(io_B12),
    .io_uart_rxd(io_B10)
  );		
endmodule