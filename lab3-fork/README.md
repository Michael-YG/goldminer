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

Todo:
- [ ] Perform a reset from software.
- [ ] Reproduce on another fpga following exactly these instructions.
