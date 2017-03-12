#include "VVexRiscv.h"
#include "verilated.h"
#include "verilated_vcd_c.h"


int main(int argc, char **argv, char **env) {
  int i;
  int clk;
  Verilated::commandArgs(argc, argv);
  // init top verilog instance
  VVexRiscv* top = new VVexRiscv;
  // init trace dump
  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;
  top->trace (tfp, 99);
  tfp->open ("sim.vcd");
  // initialize simulation inputs
  top->clk = 1;
 // top->rst = 1;
 // top->cen = 0;
 // top->wen = 0;
 // top->dat = 0x55;
  // run simulation for 100 clock periods
  for (i=0; i<20; i++) {
 //   top->rst = (i < 2);
    // dump variables into VCD file and toggle clock
    for (clk=0; clk<2; clk++) {
      tfp->dump (2*i+clk);
      top->clk = !top->clk;
      top->eval ();
    }
  //  top->cen = (i > 5);
  //  top->wen = (i == 10);
    if (Verilated::gotFinish())  exit(0);
  }
  tfp->close();
  exit(0);
}
