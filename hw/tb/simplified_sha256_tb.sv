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
		test_output = 256'hc775e7b757ede630cd0aa1113bd102661ab38829ca52a6422ab782862f268646;	// 256 bits

		@(posedge clk);
		go = 1;
		reset_n = 0;
		
		for(i=0;i<65;i=i+1) begin	// change the counter if needed
			@(posedge clk);
			
		end
		
		@(posedge clk);
		if (test_output !== sha_output) begin
			$display("Error");
		end else begin
			$display("Correct");
		end

		@(posedge clk);
		@(posedge clk);
		reset_n = 1;
		go = 0;
		done = 0;

		test_input = {8'b01100001,8'b01100010,8'b01100001,8'b01100010,
			8'b01100001,8'b01100010,8'b01100001,8'b01100010,
			8'b01100001,8'b01100010,8'b01100001,8'b01100010,
			8'b01100001,8'b01100010,8'b01100001,8'b01100010,
			8'b01100001,8'b01100010,8'b01100001,8'b01100010,
			8'b01100001,8'b01100010,8'b01100001,8'b01100010,
			8'b01100001,8'b01100010,8'b01100001,8'b01100010,
			8'b01100001,8'b01100010,8'b01100001,8'b01100010,
			8'b01100001,8'b01100010,8'b01100001,8'b01100010,
			8'b01100001,8'b01100010,8'b01100001,8'b01100010,
			8'b01100001,8'b01100010,8'b01100001,8'b01100010,
			8'b01100001,8'b01100010,8'b01100001,8'b01100010,
			8'b01100001,8'b01100010,8'b01100001,8'b10000000,
			8'b00000000,8'b00000000,8'b00000000,8'b00000000,
			8'b00000000,8'b00000000,8'b00000000,8'b00000000,
			8'b00000000,8'b00000000,8'b00000001,8'b10011000};
		sha_input = test_input;		
		test_output = 256'h5165b7f3f2e2a96f3a87bc6800a4e051618b1e12d78c5c7ef3f86cd3a04f654e;

		@(posedge clk);
		go = 1;
		reset_n = 0;
		
		for(i=0;i<65;i=i+1) begin	// change the counter
			@(posedge clk);
			
			
		end
		
		@(posedge clk);
		if (test_output !== sha_output) begin
			$display("Error");
		end else begin
			$display("Correct");
		end

		@(posedge clk);
		
		@(posedge clk);
		reset_n = 1;
		go = 0;
		done = 0;

		test_input = {8'b01100001,8'b01110011,8'b01100100,8'b01100001
			,8'b01100100,8'b01110011,8'b01100001,8'b01110011
			,8'b01100100,8'b01100001,8'b01110011,8'b01100100
			,8'b01100001,8'b01100001,8'b01110011,8'b01110011
			,8'b01100100,8'b01110011,8'b01100100,8'b01110011
			,8'b01100100,8'b01110011,8'b01100100,8'b01100001
			,8'b01110011,8'b01100100,8'b01100001,8'b01110011
			,8'b01100100,8'b01100001,8'b01110011,8'b01100100
			,8'b01100001,8'b01110011,8'b01100100,8'b01100001
			,8'b01110011,8'b01100100,8'b10000000,8'b00000000
			,8'b00000000,8'b00000000,8'b00000000,8'b00000000
			,8'b00000000,8'b00000000,8'b00000000,8'b00000000
			,8'b00000000,8'b00000000,8'b00000000,8'b00000000
			,8'b00000000,8'b00000000,8'b00000000,8'b00000000
			,8'b00000000,8'b00000000,8'b00000000,8'b00000000
			,8'b00000000,8'b00000000,8'b00000001,8'b00110000};
		sha_input = test_input;		
		test_output = 256'h386d4cd64fd1d2e053498544f87ced9bac56ed2988ac58d70e50bbacd374ac21;

		@(posedge clk);
		go = 1;
		reset_n = 0;
		
		for(i=0;i<65;i=i+1) begin	// counter
			@(posedge clk);
			
			
		end
		
		@(posedge clk);
		if (test_output !== sha_output) begin
			$display("Error");
		end else begin
			$display("Correct");
		end

		@(posedge clk);

		@(posedge clk);
		reset_n = 1;
		go = 0;
		done = 0;

		test_input = {8'b01100001,8'b01110011,8'b01100100,8'b01100001
			,8'b01100100,8'b01110011,8'b01100001,8'b01110011
			,8'b01100100,8'b01100001,8'b01110011,8'b01100100
			,8'b01100001,8'b01100001,8'b01110011,8'b01110011
			,8'b01100100,8'b01110011,8'b01100100,8'b01110011
			,8'b01100100,8'b01110011,8'b01100100,8'b01110011
			,8'b01100001,8'b01100001,8'b01110011,8'b01100100
			,8'b01100100,8'b01100100,8'b01100100,8'b01100100
			,8'b01110011,8'b01100100,8'b01100001,8'b01100100
			,8'b01100001,8'b01110011,8'b01100100,8'b01100001
			,8'b01110011,8'b01100100,8'b01100001,8'b01110011
			,8'b01100100,8'b01100001,8'b01110011,8'b01100100
			,8'b01100001,8'b01110011,8'b01100100,8'b01100001
			,8'b01110011,8'b01100100,8'b10000000,8'b00000000
			,8'b00000000,8'b00000000,8'b00000000,8'b00000000
			,8'b00000000,8'b00000000,8'b00000001,8'b10110000};
		sha_input = test_input;		
		test_output = 256'h582ebf39bdb7505eb4da7b39c343d9b780544b1e46a238000bb1b1758a3b5731;

		@(posedge clk);
		go = 1;
		reset_n = 0;
		
		for(i=0;i<65;i=i+1) begin	// counter
			@(posedge clk);
			
			
		end
		
		@(posedge clk);
		if (test_output !== sha_output) begin
			$display("Error");
		end else begin
			$display("Correct");
		end

		@(posedge clk);

		
	end
endmodule
