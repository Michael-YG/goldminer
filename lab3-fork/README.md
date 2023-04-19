On a lab workstation, in your lab3-directory, replace `vga_ball.sv` with the one
here.
Then run:
```
qsys-edit soc_system.qsys
```
Edit the Vga Ball component, and reanalyze the source `vga_ball.sv` file. Then
double check that the readdata, writedata terminals are now 32 bit wide, and the
address terminal is 4 bit wide.

Then click Finish. And close Platform Designer fully. Then run the following:
```
embedded_command_shell.sh
make qsys-clean && make qsys && make quartus && make rbf && make dtb
```
Everything should complete with no problems.

Then upload the files below to the `/mnt` folder on the fpga.
```
./soc_system.dtb
./output_files/soc_system.rbf
```
Reboot the fpga.

Next, in the software folder replace the following files with the ones in this
directory.
```
vga_ball.h
vga_ball.c
hello.c
```
And run the following:
```
rmmod vga_ball
make clean && make
insmod vga_ball.ko
./hello
```

You should see `PASS` on your screen.

For multiple devices:

- Add multiple instances of the same vga ball module, connect them to the same
exact ports.
- Make sure the address ranges of the devices don't overlap. An increment of
0x100 per device is enough.
- Make the hardware just as above. Update the hardware files on the fpga.
- Copy the software files in this repository into `lab3-sw` on your fpga.
- Mount the driver into the kernel, and run.
- You should now see this below on your screen - the same test passed on the
three accelerators running on the fpga. See `hello.c` for the testbench.
```
PASS
PASS
PASS
```

Todo:
- [ ] Perform a reset from software.
- [ ] Remove VGA outputs.
- [ ] Reproduce on another fpga following exactly these instructions.
