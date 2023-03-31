`timescale 1ns/1ps
`define HALF_CLOCK_PERIOD #10

module simple_sha256_tb();

	logic 			clk, reset, hashdone, chipselect, write;
	logic [4:0] 		address;
	logic [31:0]		writedata;
	logic [511:0]		bitcoin_input, test_input;
	logic [255:0]		bitcoin_output, test_output;

	logic [31:0]		data_out;
	logic [8:0]		writeaddress;

	integer i;

	
	acc_top acc_top_0(
		.clk(clk),
		.reset(reset),
		.write(write),
		.chipselect(chipselect),
		.address(address),
		.writedata(writedata),
		.data_out(data_out),
		.writeaddress(writeaddress));
	

	always begin
		`HALF_CLOCK_PERIOD;
		clk = ~clk;
	end

	initial begin
		reset = 1;
		clk = 0;
		chipselect = 1;
		address = 0;
		writedata = 32'b0;
		write = 0;
	
		test_output = 256'h2a19f8a396959e87a0607a7eae4abb941135e49b8d342e7bb923a7ca33b09ff7;

		#10
		// read data
		reset = 0;
		write = 1;
		address = 0;
		writedata = 32'b00000001000000000000000000000000;
		#20	// read next data
		address = 1;
		writedata = 32'b10010101000000001100010000111010;
		#20	// read next data
		address = 2;
		writedata = 32'b00100101110001100010010001010010;
		#20	// read next data
		address = 3;
		writedata = 32'b00001011010100010000000010101101;
		#20	// read next data
		address = 4;
		writedata = 32'b11111000001011001011100111111001;
		#20	// read next data
		address = 5;
		writedata = 32'b11011010011100101111110100100100;
		#20	// read next data
		address = 6;
		writedata = 32'b01000111101001001001011010111100;
		#20	// read next data
		address = 7;
		writedata = 32'b01100000000010110000000000000000;
		#20	// read next data
		address = 8;
		writedata = 32'b00000000000000000000000000000000;
		#20	// read next data
		address = 9;
		writedata = 32'b01101100110110000110001000110111;
		#20	// read next data
		address = 10;
		writedata = 32'b00000011100101011101111011011111;
		#20	// read next data
		address = 11;
		writedata = 32'b00011101101000101000010000011100;
		#20	// read next data
		address = 12;
		writedata = 32'b11001101101000001111110001001000;
		#20	// read next data
		address = 13;
		writedata = 32'b10011110001100000011100111011110;
		#20	// read next data
		address = 14;
		writedata = 32'b01011111000111001100110111011110;
		#20	// read final data
		address = 15;
		writedata = 32'b11110000111010000011010010011001;
		
		#20	// drive start = 1
		address = 16;
		writedata = 32'hffffffff;
		// start sha256
		#10
		write = 0;	// drive start = 0
		#10
		#1280	// 64+1 clk cycles
		
		

		
	end
endmodule
