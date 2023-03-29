On a lab workstation do:
```
make collatz.vcd
```
Then:
```
gtkwave --save=collatz.gtkw collatz.vcd
```
The output on h0-h7 should be:
```
h0 = 0x88a88b84
h1 = 0x85514c14
h2 = 0x7fd1bc96
h3 = 0xcb46ce85
h4 = 0x341f31ac
h5 = 0x68aaa824
h6 = 0x3dce9376
h7 = 0xf8524d39
```
Relevant files so far:
```
collatz.cpp  // Testbench
collatz.sv   // DUT
collatz.gtkw // Waveform settings
sw-rs        // Rust software implementation
```
