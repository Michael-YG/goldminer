`timescale 1ns/1ps

`include "sha256_incl.svh"
`define OPTIMIZE

module sha256_module (
    input clk, reset, start,
    input [511:0] data_in,
    output logic [255:0] data_out,
    output logic done
);

function logic [31:0] rotL(input [31:0] a, input [5:0] b);
    rotL = (a << b) | (a >> (32 - b));
endfunction

function logic [31:0] rotR(input [31:0] a, input [5:0] b);
    rotR = (a >> b) | (a << (32 - b));
endfunction

// ch function
//function logic [31:0] ch(input [31:0] x,y,z);
//    ch = (x & y) ^ ((~x) & z);
//endfunction
module ch (input [31:0] x,y,z, output [31:0] ch);
    assign ch = (x & y) ^ ((~x) & z);
endmodule
//// maj function
//function logic [31:0] maj(input [31:0] x,y,z)
//    maj = (z & y) ^ (x & z) ^ (y & z);
//endfunction

module maj (input [31:0] x,y,z, output [31:0] maj);
    assign maj = (z & y) ^ (x & z) ^ (y & z);
endmodule
//// epsilone0 function
//function logic [31:0] ep0(input [31:0] x)
//    // ep0 = (x >> 2) ^ (x >> 13) ^ (x >> 22);
//    ep0 = {{2{1'b0}},x[31:2]} ^ {{13{1'b0}},x[31:13]} ^ {{22{1'b0}},x[31:22]};
//endfunction
module ep0 (input [31:0] x, output [31:0] ep0);
    assign ep0 = rotR(x,2) ^ rotR(x,13) ^ rotR(x,22);
endmodule
//// epsilone1 function
//function loigc [31:0] ep1(input [31:0] x)
//    // ep1 = (x >> 6) ^ (x >> 11) ^ (x >> 25);
//    ep1 = {{6{1'b0},x[31:6]}} ^ {{11{1'b0},x[31:11]}} ^ {{25{1'b0},x[31:25]}};
//endfunction
module ep1 (input [31:0] x, output [31:0] ep1);
    assign ep1 = rotR(x,6) ^ rotR(x,11) ^ rotR(x,25);
endmodule
//function logic [31:0] sig0(input [31:0] x)
//    // sigma0 = (x >> 7) ^ (x >> 18) ^ (x >> 3);
//    sig0 = {{7{1'b0}},x[31:7]} ^ {{18{1'b0}},x[31:18]} ^ {{3{1'b0}},x[31:3]};
//endfunction
module sig0(input [31:0] x, output [31:0] sig0);
    assign sig0 = rotR(x,7) ^ rotR(x,18) ^ ({3{1'b0},x[31:3]});
endmodule
//function logic [31:0] sig1(input [31:0] x)
//    // sigma1 = (x >> 17) ^ (x >> 19) ^ (x >> 10);
//    sig1 = {{17{1'b0}},x[31:17]} ^ {{19{1'b0}},x[31:19]} ^ {{10{1'b0}},x[31:10]};
//endfunction
module sig1(input [31:0] x, output [31:0] sig1);
    assign sig1 = rotR(x,17) ^ rotR(x,19) ^ ({10{1'b0},x[31:10]});
endmodule

// enum int unsigned { S0 = , S1 = 1} state, next_state;
// logic [31:0] mem_k [0:63];

localparam [31:0] mem_k [0:63] = {
	32'h428a2f98,32'h71374491,32'hb5c0fbcf,32'he9b5dba5,32'h3956c25b,32'h59f111f1,32'h923f82a4,32'hab1c5ed5,
	32'hd807aa98,32'h12835b01,32'h243185be,32'h550c7dc3,32'h72be5d74,32'h80deb1fe,32'h9bdc06a7,32'hc19bf174,
	32'he49b69c1,32'hefbe4786,32'h0fc19dc6,32'h240ca1cc,32'h2de92c6f,32'h4a7484aa,32'h5cb0a9dc,32'h76f988da,
	32'h983e5152,32'ha831c66d,32'hb00327c8,32'hbf597fc7,32'hc6e00bf3,32'hd5a79147,32'h06ca6351,32'h14292967,
	32'h27b70a85,32'h2e1b2138,32'h4d2c6dfc,32'h53380d13,32'h650a7354,32'h766a0abb,32'h81c2c92e,32'h92722c85,
	32'ha2bfe8a1,32'ha81a664b,32'hc24b8b70,32'hc76c51a3,32'hd192e819,32'hd6990624,32'hf40e3585,32'h106aa070,
	32'h19a4c116,32'h1e376c08,32'h2748774c,32'h34b0bcb5,32'h391c0cb3,32'h4ed8aa4a,32'h5b9cca4f,32'h682e6ff3,
	32'h748f82ee,32'h78a5636f,32'h84c87814,32'h8cc70208,32'h90befffa,32'ha4506ceb,32'hbef9a3f7,32'hc67178f2
};

logic [31:0] mem_m [0:63];
logic [31:0] a,b,c,d,e,f,g,h;
logic [5:0] cnt_0,cnt_2;
// logic [7:0] cnt_1;
// logic [6:0] cnt;
logic [31:0] data_0,data_1,data_2,data_3;

// counter for word expansion
always_ff @ (posedge clk) begin
    if(reset) begin
        cnt_0 <= 0;
        // cnt_1 <= 0;
    end
    else
        if(start) begin
            cnt_0 <= cnt_0 + 1;
            // cnt_1 <= cnt_1 + 4;
        end
        else begin 
            cnt_0 <= cnt_0 == 0? 0 : cnt_0 + 1;
            // cnt_1 <= cnt_1 == 0? 0 : cnt_1 + 4;
        end
end

// logic [7:0] data_0_select, data_1_select, data_2_select, data_3_select;
// assign data_0_select = data_in[(cnt_1 << 3) +: 8];
// assign data_1_select = data_in[((cnt_1 + 1) << 3) +: 8];
// assign data_2_select = data_in[(cnt_1 + 2) << 3 +: 8];
// assign data_3_select = data_in[(cnt_1 + 3) << 3 +: 8];

// assign data_0 = data_0_select << 24;
// assign data_1 = {{8{1'b0}},(data_1_select << 16)};
// assign data_2 = {{16{1'b0}},(data_2_select << 8)};
// assign data_3 = {{24{1'b0}},data_3_select};

logic [31:0] sig1_next_0;
logic [31:0] sig0_next_0;
logic [9:0] address;

assign address = cnt_0 * 32;

sig0 sig0_0(.x(mem_m[cnt_0-15]),.sig0(sig0_next_0));
sig1 sig1_0(.x(mem_m[cnt_0-2]),.sig1(sig1_next_0));

always_ff @ (posedge clk) begin
    if(reset)
        for (int i = 0; i < 64; i=i+1)
            mem_m[i] <= 0;
    else begin
        if(cnt_0[4] == 0 && cnt_2[4] == 0)
            // mem_m[cnt_0] <= data_0 | data_1 | data_2 | data_3;
            mem_m[cnt_0] <= data_in[address +: 32];
        else
            // mem_m[cnt_0] <= sig1(mem_m[cnt_0-2]) + mem_m[cnt_0-7] + sig0(mem_m[cnt_0-15]) + mem_m[cnt_0-16];
            mem_m[cnt_0] <= sig1_next_0 + mem_m[cnt_0-7] + sig0_next_0 + mem_m[cnt_0-16];
    end
end

//counter for operation
always_ff @ (posedge clk) begin
    if (reset) cnt_2 <= 0;
    else
        if(cnt_0==1) cnt_2 <= cnt_2+1;
        else cnt_2 <= cnt_2 == 0? 0 : cnt_2 + 1;
end

logic [31:0] sig0_next_1,sig1_next_1,ch_next_0,maj_next_0;
logic [31:0] t1,t2;
sig0 sig0_1(.x(a),.sig0(sig0_next_1));
sig1 sig1_1(.x(e),.sig1(sig1_next_1));
ch ch_0(.x(e),.y(f),.z(g),.ch(ch_next_0));
maj maj_0(.x(a),.y(b),.z(c),.maj(maj_next_0));
// assign t1 = h + sig1(e) + ch(e,f,g) + mem_k[cnt_2] + mem_m[cnt_2];
// assign t2 = sig0(a) + maj(a,b,c);
assign t1 = h + sig1_next_1 + ch_next_0 + mem_k[cnt_2] + mem_m[cnt_2];
assign t2 = sig0_next_1 + maj_next_0;

always_ff @ (posedge clk) begin
    if(cnt_0 == 0) begin
        a <= data_out[31:0];
        b <= data_out[63:32];
        c <= data_out[95:64];
        d <= data_out[127:96]; 
        e <= data_out[159:128];
        f <= data_out[191:160];
        g <= data_out[223:192];
        h <= data_out[255:224];
    end else begin
        if(cnt_0 != 0) begin
            h <= g;
            g <= f;
            f <= e;
            e <= d + t1;
            d <= c;
            c <= b;
            b <= a;
            a <= t1 + t2;
        end
    end
end

always_ff @ (posedge clk) begin
    if(reset) begin
        data_out[31:0] <= `SHA256_H0;
        data_out[63:32] <= `SHA256_H1;
        data_out[95:64] <= `SHA256_H2;
        data_out[127:96] <= `SHA256_H3;
        data_out[159:128] <= `SHA256_H4;
        data_out[191:160] <= `SHA256_H5;
        data_out[223:192] <= `SHA256_H6;
        data_out[255:224] <= `SHA256_H7;
    end else begin
        if(done) begin
            data_out[31:0] <= a+data_out[31:0];
            data_out[63:32] <= b+data_out[63:32];
            data_out[95:64] <= c+data_out[95:64];
            data_out[127:96] <= d+data_out[127:96];
            data_out[159:128] <= e+data_out[159:128];
            data_out[191:160] <= f+data_out[191:160];
            data_out[223:192] <= g+data_out[223:192];
            data_out[255:224] <= h+data_out[255:224];
        end
    end
end

assign done = cnt_2 == 63;

endmodule
