module collatz(
      input logic         clk,      // Clock
      input logic         reset,
      input logic         go,       // Start sha256 round
      input logic  [31:0] writedata,
      input logic         write,
      input               chipselect,
      input logic  [3:0]  address,
      output logic [31:0] h0,       // h0
      output logic [31:0] h1,       // h1
      output logic [31:0] h2,       // h2
      output logic [31:0] h3,       // h3
      output logic [31:0] h4,       // h4
      output logic [31:0] h5,       // h5
      output logic [31:0] h6,       // h6
      output logic [31:0] h7,       // h7
      output logic        done);    // True when sha256 round is done

      logic [15:0][31:0] input_words;
      logic [63:0][31:0] message_schedule;
      
      logic [7:0] counter;

      logic [31:0] a, b, c, d, e, f, g, h;
   
      /* verilator lint_off LITENDIAN */
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

   function logic [31:0] rot_r(input [31:0] x, input [8:0] shift);
      rot_r = (x >> shift) | (x << (32 - shift));
   endfunction

   function logic [31:0] sig0(input [31:0] x);
      sig0 = rot_r(x, 7) ^ rot_r(x, 18) ^ (x >> 3);
   endfunction

   function logic [31:0] sig1(input [31:0] x);
      sig1 = rot_r(x, 17) ^ rot_r(x, 19) ^ (x >> 10);
   endfunction
  
   function logic [31:0] expand();
      expand =    message_schedule     [counter     ]
                + sig0(message_schedule[counter +  1])
                + message_schedule     [counter +  9]
                + sig1(message_schedule[counter + 14]);
   endfunction

   function logic [31:0] ch();
      ch = (e & f) ^ ((~e) & g);
   endfunction

   function logic [31:0] ep0();
      ep0 = rot_r(a, 2) ^ rot_r(a, 13) ^ rot_r(a, 22);
   endfunction

   function logic [31:0] ep1();
      ep1 = rot_r(e, 6) ^ rot_r(e, 11) ^ rot_r(e, 25);
   endfunction

   function logic [31:0] maj();
      maj = (a & b) ^ (a & c) ^ (b & c);
   endfunction

   function logic [31:0] temp1();
      temp1 = h + ep1() + ch() + k_words[counter] + message_schedule[counter];
   endfunction

   function logic [31:0] temp2();
      temp2 = ep0() + maj();
   endfunction

   always_ff @(posedge clk) begin
      if (reset) begin
         counter <= 0;
         input_words <= 0;
         done <= 1;
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
         input_words[address] <= writedata;
      end

      if (go) begin
         message_schedule[15:0] <= input_words[15:0];
         done <= 0;
         a <= h0;
         b <= h1;
         c <= h2;
         d <= h3;
         e <= h4;
         f <= h5;
         g <= h6;
         h <= h7;
      end else begin
         if (!done) begin
            if (counter == 64) begin
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
               // eventually does out of bound accesses,
               // nothing wrong in behavioral simulation thus far
               message_schedule[counter + 16] <= expand();
               h <= g;
               g <= f;
               f <= e;
               e <= d + temp1();
               d <= c;
               c <= b;
               b <= a;
               a <= temp1() + temp2();
               counter <= counter + 1;
            end
         end
      end
   end
endmodule
