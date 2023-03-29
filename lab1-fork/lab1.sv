// CSEE 4840 Lab 1: Run and Display Collatz Conjecture Iteration Counts
//
// Spring 2023
//
// By: Zain Merchant, Eva Gupta, Jules Comte
// Uni: ztm2105, eg3207, jgc2158

module lab1( input logic        CLOCK_50,  // 50 MHz Clock input
	     
	     input logic [3:0] 	KEY, // Pushbuttons; KEY[0] is rightmost

	     input logic [9:0] 	SW, // Switches; SW[0] is rightmost

	     // 7-segment LED displays; HEX0 is rightmost
	     output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,

	     output logic [9:0] LEDR // LEDs above the switches; LED[0] on right
	     );

   logic 			clk, go, done;   
   logic [31:0] 		start;
   logic [15:0] 		count;

   logic [11:0] 		n;
   logic [11:0] 		n_star;
   
   assign clk = CLOCK_50;
 
   range #(256, 8) // RAM_WORDS = 256, RAM_ADDR_BITS = 8)
         r ( .* ); // Connect everything with matching names

   // Replace this comment and the code below it with your own code;
   // The code below is merely to suppress Verilator lint warnings

   logic[21:0]          hold_count;

   logic                last_state;

   assign n = { 1'b0, 1'b0, SW[9:0] };

   assign n_star = { 1'b0, 1'b0, SW[9:0] + start };

   // leftmost 3 show value of n, rightmost 3 show number of 
   //   iterations to reach 1 given n (count)
   hex7seg h3(.a(n_star[3:0]), .y(HEX3));
   hex7seg h4(.a(n_star[7:4]), .y(HEX4));
   hex7seg h5(.a(n_star[11:8]), .y(HEX5));
   hex7seg h0(.a(count[3:0]), .y(HEX0));
   hex7seg h1(.a(count[7:4]), .y(HEX1));
   hex7seg h2(.a(count[11:8]), .y(HEX2));
   
   // -----------------------------------
   //   INITIALIZE
   // -----------------------------------
   initial begin
     last_state <= 0;
     hold_count <= 0;
   end

   always_ff @(posedge clk) begin
      // -----------------------------------
      //   KEYPRESS OPERATIONS
      // -----------------------------------

      // rightmost buttons increment (KEY[0]) / decrement (KEY[1]) n @ 5hz 
      //   using 22bit counter
      if (!KEY[0]) begin
        hold_count <= hold_count + 1;
        if (hold_count == 22'b1111111111111111111111) begin
          hold_count <= 0;
          start <= start == 255 ? start : start + 1;
        end
      end

      if (!KEY[1]) begin
        hold_count <= hold_count + 1;
        if (hold_count == 22'b1111111111111111111111) begin
          hold_count <= 0;
          start <= start == 0 ? start : start - 1;
        end
      end

      // KEY[2] (2nd to left) resets the difference between the n displayed 
      //   and the value on the switches
      if (!KEY[2]) begin
        start <= 0;
      end

      // KEY[3] triggers range module over 256 values (trigger go) starting 
      //   from the value on the switches
      if (!KEY[3])
        last_state <= 1;
      else
        last_state <= 0;

      // -----------------------------------
      //   COLLATZ
      // -----------------------------------

      if (!KEY[3] && !last_state) begin start <= n; go <= 1; end
      else go <= 0;

      if (done) start <= 0;
   end	
endmodule
