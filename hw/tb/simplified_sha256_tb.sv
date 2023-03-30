`timescale 1ns/1ps
`define HALF_CLOCK_PERIOD #5
`define TB0 32'b00110001001100100011001100110100
`define TB1 32'b00110101001101100011011100111000
`define TB2 16'b0011100100110000


module simple_sha256_tb();

	logic 			clk, reset_n, go, done;
	logic [511:0]		sha_input, test_input;
	logic [255:0]		sha_output, test_output;

	integer i;

	// Connect sha256 module
	//-----------------------
    sha256_module sha256_module_dut(
		.clk(clk),
		.reset(!reset_n),
		.start(go),
		.done(done),
		.data_in(sha_input),
		.data_out(sha_output)
	);
	//-----------------------

	always begin
		`HALF_CLOCK_PERIOD;
		clk = ~clk;
	end

	initial begin
		reset_n = 0;
		go = 0;
		done = 0;
		clk = 1;
		#10;
		
		test_input = {32'b00000000000000000000000110111111,{32{1'b0}},{31{1'b0}},1'b1,
		{320{1'b0}},32'b00111001001100000000000000000000,32'b00110101001101100011011100111000,32'b00110001001100100011001100110100};	// 512 bits
		sha_input = test_input;		
		test_output = 256'h7d12643bec5c8e5b07fda92f1c07e5f2dda528048200d86def89af1ec22d9f0d;	// 256 bits
        #10;
		@(posedge clk);
		go = 1;
		reset_n = 1;
		#20;
		go = 0;
		
		for(i=0;i<80;i=i+1) begin
			@(posedge clk);
		end
		
		@(posedge clk);
		if (test_output !== sha_output) begin
			$display("Error");
		end else begin
			$display("Correct");
		end
		
    end
endmodule