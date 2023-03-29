On a lab workstation do:
```
make collatz.vcd
```
Then:
```
gtkwave --save=collatz.gtkw collatz.vcd
```
For ROUNDS = 1, the output on h0-h7 should be:
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
For ROUNDS = 7, the output on h0-h7 should be:
```
h0 = 0xa010b16b
h1 = 0x4a185174
h2 = 0xe4c218c9
h3 = 0x9034c72c
h4 = 0x258c9f14
h5 = 0x2c780e75
h6 = 0x8d72319e
h7 = 0x8fc8b5dc
```
Relevant files so far:
```
collatz.cpp  // Testbench
collatz.sv   // DUT
collatz.gtkw // Waveform settings
sw-rs        // Rust software implementation
```
To get golden outputs from rust implementation:
```
Install rust on your machine
cd sw-rs
cargo run
```
