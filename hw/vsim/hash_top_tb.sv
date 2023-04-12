`timescale 1ns/1ps
`define HALF_CLOCK_PERIOD #10

module simple_sha256_tb();

	logic 			clk, reset, hashdone, chipselect, write, read;
	logic [4:0] 		address;
	logic [31:0]		writedata;
	logic [511:0]		bitcoin_input, test_input;
	logic [255:0]		bitcoin_output, test_output;

	logic [31:0]		data_out;


	integer i;

	// Binary input: 000000000000000000000000110111000000000000000000000000000000000000110010001110011011010101000000001100110011100110110010001100110011000010110011001100100011100110110011001101011011001000111001101101011011001000111001101101010011100110110000101101010011001100110011001101010011001000110101101101010011000010110101101101100011000010110011001101011011001000110101101100100011100110110101001110011011000010110101001100110011001000111001101100001011001
	parameter [32:0] mem_tb_0 [0:15] = {
		{32'b00000000000000000000000011011100},
		{32'b00000000000000000000000000000000},
		{32'b00110010001110011011010101000000},
		{32'b00110011001110011011001000110011},
		{32'b00110000101100110011001000111001},
		{32'b10110011001101011011001000111001},
		{32'b10110101101100100011100110110101},
		{32'b00111001101100001011010100110011},
		{32'b00110011001101010011001000110101},
		{32'b10110101001100001011010110110110},
		{32'b00110000101100110011010110110010},
		{32'b00110101101100100011100110110101},
		{32'b00111001101100001011010100110011},
		{32'b00110010001110011011000010110011},
		{32'b00000000000000000000000000000000},
		{32'b00000000000000000000000110111111}
	};


	parameter [255:0] tb_0_result = 256'h80cab0c8ef5701aed57f628fd04511fd4f2040ba721acb80c48650a4677f47be;

	
	acc_top acc_top_0(
		.clk(clk),
		.reset(reset),
		.write(write),
		.chipselect(chipselect),
		.address(address),
		.writedata(writedata),
		.data_out(data_out),
		.read(read));
	
	always begin
		`HALF_CLOCK_PERIOD;
		clk = ~clk;
	end

	initial begin
		reset = 1;
		clk = 0;
		read = 0;
		chipselect = 1;
		address = 0;
		writedata = mem_tb_0[0];
		write = 0;
	
		test_output = tb_0_result;

		#50
		// read data
		reset = 0;
		write = 1;
		#60
		address = 0;
		writedata = mem_tb_0[address];
		#20	// read next data
		address = 1;
		writedata = mem_tb_0[address];
		#20	// read next data
		address = 2;
		writedata = mem_tb_0[address];
		#20	// read next data
		address = 3;
		writedata = mem_tb_0[address];
		#20	// read next data
		address = 4;
		writedata = mem_tb_0[address];
		#20	// read next data
		address = 5;
		writedata = mem_tb_0[address];
		#20	// read next data
		address = 6;
		writedata = mem_tb_0[address];
		#20	// read next data
		address = 7;
		writedata = mem_tb_0[address];
		#20	// read next data
		address = 8;
		writedata = mem_tb_0[address];
		#20	// read next data
		address = 9;
		writedata = mem_tb_0[address];
		#20	// read next data
		address = 10;
		writedata = mem_tb_0[address];
		#20	// read next data
		address = 11;
		writedata = mem_tb_0[address];
		#20	// read next data
		address = 12;
		writedata = mem_tb_0[address];
		#20	// read next data
		address = 13;
		writedata = mem_tb_0[address];
		#20	// read next data
		address = 14;
		writedata = mem_tb_0[address];
		#20	// read final data
		address = 15;
		writedata = mem_tb_0[address];
		#20	// drive start = 1
		address = 16;
		writedata = 32'hffffffff;
		// start sha256
		#20
		write = 0;	// drive start = 0
		#1400;	// 64+1 clk cycles
		read = 1;
		#200;
$finish;

	end
endmodule
