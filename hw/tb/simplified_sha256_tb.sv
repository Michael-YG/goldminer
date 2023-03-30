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

	// 	@(posedge clk);
		
	// 	@(posedge clk);
	// 	reset_n = 1;
	// 	go = 0;
	// 	done = 0;

	// 	test_input = {8'b01100001,8'b01110011,8'b01100100,8'b01100001
	// 		,8'b01100100,8'b01110011,8'b01100001,8'b01110011
	// 		,8'b01100100,8'b01100001,8'b01110011,8'b01100100
	// 		,8'b01100001,8'b01100001,8'b01110011,8'b01110011
	// 		,8'b01100100,8'b01110011,8'b01100100,8'b01110011
	// 		,8'b01100100,8'b01110011,8'b01100100,8'b01100001
	// 		,8'b01110011,8'b01100100,8'b01100001,8'b01110011
	// 		,8'b01100100,8'b01100001,8'b01110011,8'b01100100
	// 		,8'b01100001,8'b01110011,8'b01100100,8'b01100001
	// 		,8'b01110011,8'b01100100,8'b10000000,8'b00000000
	// 		,8'b00000000,8'b00000000,8'b00000000,8'b00000000
	// 		,8'b00000000,8'b00000000,8'b00000000,8'b00000000
	// 		,8'b00000000,8'b00000000,8'b00000000,8'b00000000
	// 		,8'b00000000,8'b00000000,8'b00000000,8'b00000000
	// 		,8'b00000000,8'b00000000,8'b00000000,8'b00000000
	// 		,8'b00000000,8'b00000000,8'b00000001,8'b00110000};
	// 	sha_input = test_input;		
	// 	test_output = 256'h386d4cd64fd1d2e053498544f87ced9bac56ed2988ac58d70e50bbacd374ac21;

	// 	@(posedge clk);
	// 	go = 1;
	// 	reset_n = 0;
		
	// 	for(i=0;i<65;i=i+1) begin	// counter
	// 		@(posedge clk);
			
			
	// 	end
		
	// 	@(posedge clk);
	// 	if (test_output !== sha_output) begin
	// 		$display("Error");
	// 	end else begin
	// 		$display("Correct");
	// 	end

	// 	@(posedge clk);

	// 	@(posedge clk);
	// 	reset_n = 1;
	// 	go = 0;
	// 	done = 0;

	// 	test_input = {8'b01100001,8'b01110011,8'b01100100,8'b01100001
	// 		,8'b01100100,8'b01110011,8'b01100001,8'b01110011
	// 		,8'b01100100,8'b01100001,8'b01110011,8'b01100100
	// 		,8'b01100001,8'b01100001,8'b01110011,8'b01110011
	// 		,8'b01100100,8'b01110011,8'b01100100,8'b01110011
	// 		,8'b01100100,8'b01110011,8'b01100100,8'b01110011
	// 		,8'b01100001,8'b01100001,8'b01110011,8'b01100100
	// 		,8'b01100100,8'b01100100,8'b01100100,8'b01100100
	// 		,8'b01110011,8'b01100100,8'b01100001,8'b01100100
	// 		,8'b01100001,8'b01110011,8'b01100100,8'b01100001
	// 		,8'b01110011,8'b01100100,8'b01100001,8'b01110011
	// 		,8'b01100100,8'b01100001,8'b01110011,8'b01100100
	// 		,8'b01100001,8'b01110011,8'b01100100,8'b01100001
	// 		,8'b01110011,8'b01100100,8'b10000000,8'b00000000
	// 		,8'b00000000,8'b00000000,8'b00000000,8'b00000000
	// 		,8'b00000000,8'b00000000,8'b00000001,8'b10110000};
	// 	sha_input = test_input;		
	// 	test_output = 256'h582ebf39bdb7505eb4da7b39c343d9b780544b1e46a238000bb1b1758a3b5731;

	// 	@(posedge clk);
	// 	go = 1;
	// 	reset_n = 0;
		
	// 	for(i=0;i<65;i=i+1) begin	// counter
	// 		@(posedge clk);
			
			
	// 	end
		
	// 	@(posedge clk);
	// 	if (test_output !== sha_output) begin
	// 		$display("Error");
	// 	end else begin
	// 		$display("Correct");
	// 	end

	// 	@(posedge clk);

		
    // end
endmodule
