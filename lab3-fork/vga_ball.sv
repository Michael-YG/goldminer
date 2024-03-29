/*
 * Avalon memory-mapped peripheral that generates sha256 hashes
 *
 * Stephen A. Edwards
 * Columbia University
 */

module vga_ball(input logic        clk,
	        input logic 	   reset,
		input logic [31:0]  writedata,
		output logic [31:0]  readdata,
		input logic 	   write,
		input logic 	   read,
		input 		   chipselect,
		input logic [4:0]  address);

   logic [63:0][31:0] message_schedule;
   logic [7:0] counter;
   logic [31:0] a, b, c, d, e, f, g, h;
   logic [31:0] h0, h1, h2, h3, h4, h5, h6, h7, done = 1;
   logic [31:0] reg_reset;
   logic go;
   /* verilator lint_off UNUSED */
   logic [31:0] trash;

   logic[31:0] sig0, sig1, expand;
   logic[31:0] ch, ep0, ep1, maj, temp1, temp2;


   localparam [0:63][31:0] k_words = '{
      32'h428a2f98,32'h71374491,32'hb5c0fbcf,32'he9b5dba5,
      32'h3956c25b,32'h59f111f1,32'h923f82a4,32'hab1c5ed5,
      32'hd807aa98,32'h12835b01,32'h243185be,32'h550c7dc3,
      32'h72be5d74,32'h80deb1fe,32'h9bdc06a7,32'hc19bf174,
      32'he49b69c1,32'hefbe4786,32'h0fc19dc6,32'h240ca1cc,
      32'h2de92c6f,32'h4a7484aa,32'h5cb0a9dc,32'h76f988da,
      32'h983e5152,32'ha831c66d,32'hb00327c8,32'hbf597fc7,
      32'hc6e00bf3,32'hd5a79147,32'h06ca6351,32'h14292967,
      32'h27b70a85,32'h2e1b2138,32'h4d2c6dfc,32'h53380d13,
      32'h650a7354,32'h766a0abb,32'h81c2c92e,32'h92722c85,
      32'ha2bfe8a1,32'ha81a664b,32'hc24b8b70,32'hc76c51a3,
      32'hd192e819,32'hd6990624,32'hf40e3585,32'h106aa070,
      32'h19a4c116,32'h1e376c08,32'h2748774c,32'h34b0bcb5,
      32'h391c0cb3,32'h4ed8aa4a,32'h5b9cca4f,32'h682e6ff3,
      32'h748f82ee,32'h78a5636f,32'h84c87814,32'h8cc70208,
      32'h90befffa,32'ha4506ceb,32'hbef9a3f7,32'hc67178f2
   };

   always_ff @(posedge clk) begin
      if (reset || reg_reset == 32'h1) begin
         counter <= 0;
         done <= 1;
         go <= 0;
         readdata <= 0;
         reg_reset <= 0;
         h0 <= 32'h6a09e667;
         h1 <= 32'hbb67ae85;
         h2 <= 32'h3c6ef372;
         h3 <= 32'ha54ff53a;
         h4 <= 32'h510e527f;
         h5 <= 32'h9b05688c;
         h6 <= 32'h1f83d9ab;
         h7 <= 32'h5be0cd19;
      end

      if (chipselect && write) begin
         case (address)
            5'h0: message_schedule[0] <= writedata;
            5'h1: message_schedule[1] <= writedata;
            5'h2: message_schedule[2] <= writedata;
            5'h3: message_schedule[3] <= writedata;
            5'h4: message_schedule[4] <= writedata;
            5'h5: message_schedule[5] <= writedata;
            5'h6: message_schedule[6] <= writedata;
            5'h7: message_schedule[7] <= writedata;
            5'h8: message_schedule[8] <= writedata;
            5'h9: message_schedule[9] <= writedata;
            5'ha: message_schedule[10] <= writedata;
            5'hb: message_schedule[11] <= writedata;
            5'hc: message_schedule[12] <= writedata;
            5'hd: message_schedule[13] <= writedata;
            5'he: message_schedule[14] <= writedata;
            5'hf:
            begin
                  message_schedule[15] <= writedata;
                  go <= 1;
                  done <= 0;
            end
            5'h1f: reg_reset <= writedata;
            default: trash <= writedata;
         endcase
         readdata <= 0;
      end

      if (chipselect && read) begin
         case (address)
            5'h0: readdata <= h0;
            5'h1: readdata <= h1;
            5'h2: readdata <= h2;
            5'h3: readdata <= h3;
            5'h4: readdata <= h4;
            5'h5: readdata <= h5;
            5'h6: readdata <= h6;
            5'h7: readdata <= h7;
            5'hf: readdata <= done;
            default: readdata <= 0;
         endcase
      end

      if (!write) begin
         if (go) begin
            go <= 0;
            counter <= 0;
            a <= h0;
            b <= h1;
            c <= h2;
            d <= h3;
            e <= h4;
            f <= h5;
            g <= h6;
            h <= h7;
         end else if (!(|done)) begin
            if (counter[6]) begin
               h0 <= h0 + a;
               h1 <= h1 + b;
               h2 <= h2 + c;
               h3 <= h3 + d;
               h4 <= h4 + e;
               h5 <= h5 + f;
               h6 <= h6 + g;
               h7 <= h7 + h;
               done <= 1;
               counter <= 0;
            end else begin
               if (!(&counter[5:4]))
                  message_schedule[counter + 16] <= expand;
               h <= g;
               g <= f;
               f <= e;
               e <= d + temp1;
               d <= c;
               c <= b;
               b <= a;
               a <= temp1 + temp2;
               counter <= counter + 1;
            end
         end
      end
   end


   function logic [31:0] rot_r(input [31:0] x, input [8:0] shift);
      rot_r = x >> shift | x << 32 - shift;
   endfunction

   assign sig0 = rot_r(message_schedule[counter +  1], 7)
        ^ rot_r(message_schedule[counter +  1], 18)
        ^ message_schedule[counter +  1] >> 3;
   assign sig1 = rot_r(message_schedule[counter + 14], 17)
        ^ rot_r(message_schedule[counter + 14], 19)
        ^ message_schedule[counter + 14] >> 10;
   assign expand = message_schedule[counter] + sig0
          + message_schedule[counter + 9] + sig1;

   assign ch = e & f ^ ~e & g;
   assign ep0 = rot_r(a, 2) ^ rot_r(a, 13) ^ rot_r(a, 22);
   assign ep1 = rot_r(e, 6) ^ rot_r(e, 11) ^ rot_r(e, 25);
   assign maj = a & b ^ a & c ^ b & c;
   assign temp1 = h + ep1 + ch + k_words[counter] + message_schedule[counter];
   assign temp2 = ep0 + maj;
endmodule
