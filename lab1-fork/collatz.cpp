#include <iostream>
#include "Vcollatz.h"
#include <verilated.h>
#include <verilated_vcd_c.h>

const unsigned ROUNDS = 3;
const unsigned WRITE_OFFSET = 500;
// Do not change - its 16 input words * (20 ns / (1 input word write))
const unsigned WRITE_PERIOD = 320;

int main(int argc, const char ** argv, const char ** env) {
  Verilated::commandArgs(argc, argv);

  // Treat the argument on the command-line as the place to start
  //int n;
  //if (argc > 1 && argv[1][0] != '+') n = atoi(argv[1]);
  //else n = 7; // Default

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
  bool launched = false;
  int time;
  unsigned data = 0x00000000;
  unsigned count = 0;
  unsigned write_start_time = WRITE_OFFSET;
  unsigned address = 0;
  for (time = 0 ; time < 10000 ; time += 10) {
    dut->clk = ((time % 20) >= 10) ? 1 : 0; // Simulate a 50 MHz clock
    if (time == 0) {
      dut->reset = 1;
    }

    if (time >= write_start_time && time < write_start_time + WRITE_PERIOD) {
      dut->reset = 0;
      dut->write = 1;
      dut->chipselect = 1;

      if (time%20 == 0) {
        data = data == 0xffffffff ? 0x00000000 : data + 0x11111111;
        dut->address = address;
        dut->writedata = data;
        address++;
      }
    } else {
      dut->write = 0;
      dut->chipselect = 0;
      address = 0;
    }

    if (time == WRITE_OFFSET + WRITE_PERIOD + 40) {
      dut->go = 1;
      launched = true;
      write_start_time = time + WRITE_OFFSET;
      data = data == 0xffffffff ? 0x00000000 : data + 0x11111111;
    }

    dut->eval();     // Run the simulation for a cycle
    tfp->dump(time); // Write the VCD file for this cycle

    if (dut->clk && !last_clk && !dut->go) {
      if (dut->done && launched) {
         count++;
         if (count == ROUNDS)
            break;
         else {
            dut->go = 1;
            if (time % 20 == 0)
               write_start_time = time + WRITE_OFFSET;
            else
               write_start_time = time + WRITE_OFFSET + 10;
            data = data == 0xffffffff ? 0x00000000 : data + 0x11111111;
         }
      }
    } else if (dut->clk && !last_clk) {
      dut->go = 0;
    }
    last_clk = dut->clk;
  }

  address = 16;
  unsigned results[8];
  for (int k = 0 ; k < 17 ; k++, time += 10) {
    dut->clk = ((time % 20) >= 10) ? 1 : 0;
    dut->eval();
    tfp->dump(time);

    if (time%20 != 0) { // why does this now change on posedge ?
       dut->chipselect = 1;
       dut->read = 1;
       dut->address = address;
       if (k != 0) {
         results[address-17] = dut->readdata;
       }
       address++;
    }
  }
  
  // Run a few more clock cycles
  for (int k = 0 ; k < 4 ; k++, time += 10) {
    dut->clk = ((time % 20) >= 10) ? 1 : 0;
      dut->eval();
      tfp->dump(time);
  }
  
  tfp->close(); // Stop dumping the VCD file
  delete tfp;

  dut->final(); // Stop the simulation
  delete dut;

  unsigned golden[8] = {0x20178e07, 0x0c6ae70f, 0xb41a5e91, 0x36076c58,
                         0xd27c7765, 0x7ebffa22, 0xdb7a862a, 0x988199bc,};
  bool pass = true;
  for (int i = 0; i<8; i++) {
      if (results[i] != golden[i])
         pass = false;
  } 
  if (pass) std::cout << "PASS" << std::endl;
  else std::cout << "FAIL" << std::endl;

  return 0;
}
