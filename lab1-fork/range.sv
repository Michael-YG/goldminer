module range
   #(parameter
     RAM_WORDS = 16,            // Number of counts to store in RAM
     RAM_ADDR_BITS = 4)         // Number of RAM address bits
   (input logic         clk,    // Clock
    input logic 	go,     // Read start and start testing
    input logic [31:0] 	start,  // Number to start from or count to read
    output logic 	done,   // True once memory is filled
    output logic [15:0] count); // Iteration count once finished

   logic 		cgo;    // "go" for the Collatz iterator
   logic                cdone;  // "done" from the Collatz iterator
   logic [31:0] 	n;      // number to start the Collatz iterator

// verilator lint_off PINCONNECTEMPTY
   
   // Instantiate the Collatz iterator
   collatz c1(.clk(clk),
	      .go(cgo),
	      .n(n),
	      .done(cdone),
	      .dout());

   logic [RAM_ADDR_BITS - 1:0] 	 num;         // The RAM address to write

   typedef enum logic [5:0] {A, B, C, D, E} state_t;
   state_t state, next_state;

   /* verilator lint_off UNUSED */
   logic running = 0;

   /* Replace this comment and the code below with your solution,
      which should generate running, done, cgo, n, num, we, and din */
   always_ff @(posedge clk) begin
      state <= next_state;
      if      (next_state == A) begin done <= 0; end
      else if (next_state == B) begin n <= start; din <= 0; running <= 1; cgo <= 1; num <= 0; end
      else if (next_state == C) begin cgo <= 0; din <= din + 1; end
      else if (next_state == D) begin num <= num + 1; if (num == 15) begin running <= 0; done <= 1; end; end
      else if (next_state == E) begin n <= n + 1; din <= 0; cgo <= 1; end
   end

   always_comb begin
      next_state = state;
      we = 0;
      if (go)  next_state = B;
      else case (state)
         B: begin next_state = C; end
         C: begin next_state = cdone ? D : C; we = cdone ? 1 : 0; end
         D: begin we = 0; next_state = num == 0 ? A : E; end
         E: begin next_state = C; end
         default: next_state = state;
      endcase
   end
   /* Replace this comment and the code above with your solution */

   logic 			 we;                    // Write din to addr
   logic [15:0] 		 din;                   // Data to write
   logic [15:0] 		 mem[RAM_WORDS - 1:0];  // The RAM itself
   logic [RAM_ADDR_BITS - 1:0] 	 addr;                  // Address to read/write

   assign addr = we ? num : start[RAM_ADDR_BITS-1:0];
   
   always_ff @(posedge clk) begin
      if (we) mem[addr] <= din;
      count <= mem[addr];      
   end

endmodule
	     
