`timescale 1ns/1ps

`include "sha256_incl.svh"

module sha256_module (
    input clk, reset_n, start,
    input logic[15:0] message_addr,
    input logic[15:0] output_addr,
    input logic[31:0] mem_read_data,
    output logic done,
    output logic mem_we,
    output logic[31:0] mem_write_data,
    output logic[15:0] mem_addr,
    output logic mem_clk
);

assign mem_clk = clk;

endmodule