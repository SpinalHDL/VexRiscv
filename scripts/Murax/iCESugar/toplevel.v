`timescale 1ns / 1ps

module toplevel(
    input   clk,
    input   P4_2,   /* jtag_tck */
    input   P4_1,   /* jtag_tdi */
    output  P4_3,   /* jtag_tdo */
    input   P4_4,   /* jtag_tms */
    output  TX,
    input   RX,
    output [7:0] io_pmod2,
    output [7:0] io_pmod3
  );

  wire [31:0] io_gpioA_read;
  wire [31:0] io_gpioA_write;
  wire [31:0] io_gpioA_writeEnable;
  wire io_mainClk;
  wire io_jtag_tck;

  SB_GB mainClkBuffer (
    .USER_SIGNAL_TO_GLOBAL_BUFFER (clk),
    .GLOBAL_BUFFER_OUTPUT ( io_mainClk)
  );

  SB_GB jtagClkBuffer (
    .USER_SIGNAL_TO_GLOBAL_BUFFER (P4_2),
    .GLOBAL_BUFFER_OUTPUT ( io_jtag_tck)
  );

  assign io_pmod2 = io_gpioA_write[15 : 8];
  assign io_pmod3 = io_gpioA_write[7 : 0];
  Murax murax (
    .io_asyncReset(0),
    .io_mainClk (io_mainClk ),
    .io_jtag_tck(io_jtag_tck),
    .io_jtag_tdi(P4_1),
    .io_jtag_tdo(P4_3),
    .io_jtag_tms(P4_4),
    .io_gpioA_read       (io_gpioA_read),
    .io_gpioA_write      (io_gpioA_write),
    .io_gpioA_writeEnable(io_gpioA_writeEnable),
    .io_uart_txd(TX),
    .io_uart_rxd(RX)
  );		
endmodule
