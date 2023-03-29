#include <iostream>
#include "Vcollatz.h"
#include <verilated.h>
#include <verilated_vcd_c.h>

int main(int argc, const char ** argv, const char ** env) {
  Verilated::commandArgs(argc, argv);

  // Treat the argument on the command-line as the place to start
  int n;
  if (argc > 1 && argv[1][0] != '+') n = atoi(argv[1]);
  else n = 7; // Default

  Vcollatz * dut = new Vcollatz;  // Instantiate the collatz module

  // Enable dumping a VCD file
  
  Verilated::traceEverOn(true);
  VerilatedVcdC * tfp = new VerilatedVcdC;
  dut->trace(tfp, 99);
  tfp->open("collatz.vcd");

  // Initial values
  
  dut->go = 0;
  dut->write = 0;
  dut->chipselect = 0;

  bool last_clk = true;
  int time;
  int data = 0x00000000;
  for (time = 0 ; time < 10000 ; time += 10) {
    dut->clk = ((time % 20) >= 10) ? 1 : 0; // Simulate a 50 MHz clock
    if (time == 0) {
      dut->reset = 1;
    }
    if (time == 20) {
      dut->reset = 0;
      dut->write = 1;
      dut->chipselect = 1;
    }
    if (time >= 20 && time < 340) {
      if (time%20 == 0) {
        data = data == 0xffffffff ? 0x00000000 : data + 0x11111111;
        dut->address = time / 20 - 1;
        dut->writedata = data;
      }
    }
    if (time == 360) {
      dut->write = 0;
      dut->chipselect = 0;
      dut->go = 1;
    }
    if (time == 380) dut->go = 0;

    dut->eval();     // Run the simulation for a cycle
    tfp->dump(time); // Write the VCD file for this cycle

    if (dut->clk && !last_clk && !dut->go) {
      if (dut->done) break; // Stop once "done" appears
    }
    last_clk = dut->clk;
  }

  // Once "done" is received, run a few more clock cycles
  
  for (int k = 0 ; k < 4 ; k++, time += 10) {
    dut->clk = ((time % 20) >= 10) ? 1 : 0;
      dut->eval();
      tfp->dump(time);
  }
  
  tfp->close(); // Stop dumping the VCD file
  delete tfp;

  dut->final(); // Stop the simulation
  delete dut;

  return 0;
}
