`timescale 1ns/1ps

`include "sha256_incl.svh"
`define OPTIMIZE

module sha256_module (
    input clk, reset, start,
    input [511:0] data_in,
    output logic [255:0] data_out,
    output logic done
);
// ch function
function logic [31:0] ch(input [31:0] x,y,z)
    ch = (x & y) ^ ((~x) & z);
endfunction
// maj function
function logic [31:0] maj(input [31:0] x,y,z)
    maj = (z & y) ^ (x & z) ^ (y & z);
endfunction
// epsilone0 function
function logic [31:0] ep0(input [31:0] x)
    // ep0 = (x >> 2) ^ (x >> 13) ^ (x >> 22);
    ep0 = {{2{1'b0}},x[31:2]} ^ {{13{1'b0}},x[31:13]} ^ {{22{1'b0}},x[31:22]};
endfunction
// epsilone1 function
function loigc [31:0] ep1(input [31:0] x)
    // ep1 = (x >> 6) ^ (x >> 11) ^ (x >> 25);
    ep1 = {{6{1'b0},x[31:6]}} ^ {{11{1'b0},x[31:11]}} ^ {{25{1'b0},x[31:25]}};
endfunction
function logic [31:0] sig0(input [31:0] x)
    // sigma0 = (x >> 7) ^ (x >> 18) ^ (x >> 3);
    sig0 = {{7{1'b0}},x[31:7]} ^ {{18{1'b0}},x[31:18]} ^ {{3{1'b0}},x[31:3]};
endfunction
function logic [31:0] sig1(input [31:0] x)
    // sigma1 = (x >> 17) ^ (x >> 19) ^ (x >> 10);
    sig1 = {{17{1'b0}},x[31:17]} ^ {{19{1'b0}},x[31:19]} ^ {{10{1'b0}},x[31:10]};
endfunction

// enum int unsigned { S0 = , S1 = 1} state, next_state;
// logic [31:0] mem_k [0:63];

localparam [31:0] mem_k [0:63] = {
	0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,
	0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
	0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
	0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
	0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,
	0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
	0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
	0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2
};

logic [31:0] mem_m [0:63];
logic [31:0] a,b,c,d,e,f,g,h;
logic [5:0] cnt_0,cnt_1,cnt_2;
logic [31:0] data_0,data_1,data_2,data_3;

// counter for word expansion
always_ff @ (posedge clk) begin
    if(reset) begin
        cnt_0 <= 0;
        cnt_1 <= 0;
    end
    else
        if(start) begin
            cnt_0 <= cnt_0 + 1;
            cnt_1 <= cnt_1 + 4;
        end
        else begin 
            cnt_0 <= cnt_0 == 0? 0 : cnt_0 + 1;
            cnt_1 <= cnt_1 == 0? 0 : cnt_1 + 4;
        end
end

assign data_0 = data_in[(cnt_1 << 3)] << 24;
assign data_1 = {{8{1'b0}},(data_in[((cnt_1 + 1) << 3)]<<16)};
assign data_2 = {{16{1'b0}},(data_in[(cnt_1 + 2) << 3] << 8)};
assign data_3 = {{24{1'b0}},data_in[(cnt_1 + 3) << 3]};

always_ff @ (posedge clk) begin
    if(reset)
        for (int i = 0; i < 63; i=i+1)
            mem_m[i] <= 0;
    else begin
        if(cnt_0[4] == 0 && cnt_2[4] == 0)
            mem_m[cnt_0] <= data_0 | data_1 | data_2 | data_3;
        else
            mem_m[cnt_0] <= sig1(mem_m[cnt_0-2]) + mem_m[cnt_0-7] + sig0(mem_m[cnt_0-15]) + mem_m[cnt_0-16];
    end
end

//counter for operation
always_ff @ (posedge clk) begin
    if (reset) cnt_2 <= 0;
    else
        if(cnt_0==1) cnt_2 <= cnt_2+1;
        else cnt_2 <= cnt_2 == 0? 0 : cnt_2 + 1;
end

logic [31:0] t1,t2;
assign t1 = h + sig1(e) + ch(e,f,g) + mem_k[cnt_2] + mem_m[cnt_2];
assign t2 = sig0(a) + maj(a,b,c);

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

assign done = cnt_1 == 63;

endmodule
