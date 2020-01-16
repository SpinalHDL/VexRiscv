`timescale 1ns / 1ps

module toplevel(
    input  wire clk100,
    input  wire cpu_reset,//active low

    input  wire tck,
    input  wire tms,
    input  wire tdi,
    input  wire trst,//ignored
    output reg  tdo,

    input  wire serial_rx,
    output wire serial_tx,

    input  wire user_sw0,
    input  wire user_sw1,
    input  wire user_sw2,
    input  wire user_sw3,

    input  wire user_btn0,
    input  wire user_btn1,
    input  wire user_btn2,
    input  wire user_btn3,

    output wire user_led0,
    output wire user_led1,
    output wire user_led2,
    output wire user_led3
  );

  wire [31:0] io_gpioA_read;
  wire [31:0] io_gpioA_write;
  wire [31:0] io_gpioA_writeEnable;

  wire io_asyncReset = ~cpu_reset;

  assign {user_led3,user_led2,user_led1,user_led0} = io_gpioA_write[3 : 0];
  assign io_gpioA_read[3:0] = {user_sw3,user_sw2,user_sw1,user_sw0};
  assign io_gpioA_read[7:4] = {user_btn3,user_btn2,user_btn1,user_btn0};
  assign io_gpioA_read[11:8] = {tck,tms,tdi,trst};

  reg  tesic_tck,tesic_tms,tesic_tdi;
  wire tesic_tdo;
  reg  soc_tck,soc_tms,soc_tdi;
  wire soc_tdo;

  always @(*) begin
      {soc_tck,  soc_tms,  soc_tdi  } = {tck,tms,tdi};
      tdo = soc_tdo;
  end

  Murax core (
    .io_asyncReset(io_asyncReset),
    .io_mainClk (clk100 ),
    .io_jtag_tck(soc_tck),
    .io_jtag_tdi(soc_tdi),
    .io_jtag_tdo(soc_tdo),
    .io_jtag_tms(soc_tms),
    .io_gpioA_read       (io_gpioA_read),
    .io_gpioA_write      (io_gpioA_write),
    .io_gpioA_writeEnable(io_gpioA_writeEnable),
    .io_uart_txd(serial_tx),
    .io_uart_rxd(serial_rx)
  );
endmodule
