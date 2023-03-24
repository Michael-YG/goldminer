`timescale 1ns/1ps
`define HALF_CLOCK_PERIOD #5

module simple_sha256_tb();

	logic 			clk, reset_n, go, done;
	logic [511:0]		sha_input, test_input;
	logic [255:0]		sha_output, test_output;

	integer i;

	// Connect sha256 module
	//-----------------------

	//-----------------------

	always begin
		`HALF_CLOCK_PERIOD;
		clk = ~clk;
	end

	initial begin
		reset_n = 1;
		go = 0;
		done = 0;
		clk = 1;
		
		test_input = {8'b00110001,8'b00110010,8'b00110011,8'b00110100,8'b00110101,8'b00110110,8'b00110111,8'b00111000,
				8'b00111001,8'b00110000,8'b10000000,416'b0,8'b01010000};	// 512 bits
		sha_input = test_input;		
		test_output = 64'hc775e7b757ede630cd0aa1113bd102661ab38829ca52a6422ab782862f268646;	// 256 bits

		@(posedge clk);
		go = 1;
		reset_n = 0;
		
		for(i=0;i<65;i=i+1) begin
			@(posedge clk);
			
			
		end
		
		@(posedge clk);
		if (test_output !== sha_output) begin
			$display("Error");
		end else begin
			$display("Correct");
		end
		
	end
