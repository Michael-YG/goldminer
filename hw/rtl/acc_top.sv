/*
* Avalon memory-mapped SHA256 accelerator
*/
module acc_top(
    input clk,reset,write,chipselect,
    input [4:0] address, // hash input value 0-31 and start flag 32
    input [31:0] writedata,
    output logic [31:0] data_out,
    output logic [3:0] writeaddress
);

logic [511:0] buffer;
logic [3:0] cnt;
logic [255:0] hashvalue;
// logic finish;
logic done,start,outputdone,loading,hash_ack;
enum int unsigned {st_idle = 0, st_load = 1, st_exe = 2, st_send = 3} state, state_next;

/* FSM logic */
always_ff @ (posedge clk)
    if (reset) state <= st_idle;
    else state <= state_next;

always_comb begin
    state_next = state;
    case(state)
        st_idle: state_next = loading? st_load:state;
        st_load: state_next = start? st_exe:state;
        st_exe: state_next = done? st_send:state;
        st_send: state_next = outputdone? st_idle:state;
    endcase
end

/* Counter and buffer loading logic */
assign loading = chipselect && write;

logic [31:0] control_buf;

always_ff @ (posedge clk) begin
    if (reset)  buffer <= 0;
    else
        if(loading)
            case(address)
                0: buffer[31:0] <= writedata;
                1: buffer[63:32] <= writedata;
                2: buffer[95:64] <= writedata;
                3: buffer[127:96] <= writedata;
                4: buffer[159:128] <= writedata;
                5: buffer[191:160] <= writedata;
                6: buffer[223:192] <= writedata;
                7: buffer[255:224] <= writedata;
                8: buffer[287:256] <= writedata;
                9: buffer[319:288] <= writedata;
                10: buffer[351:320] <= writedata;
                11: buffer[383:352] <= writedata;
                12: buffer[415:384] <= writedata;
                13: buffer[447:416] <= writedata;
                14: buffer[479:448] <= writedata;
                15: buffer[511:480] <= writedata;
            endcase
end

always_ff @ (posedge clk)
    if (reset) control_buf <= 0;
    else control_buf <= address[4] && loading? writedata : 0;

assign start = control_buf == 32'hffffffff;

/* Sending logic */
always_ff @ (posedge clk)
    if (reset) cnt <= 0;
    else 
        if(cnt == 8)
            cnt <= hash_ack? 0 : cnt;
        else
            cnt <= cnt + (state == st_send);

// logic outputdone_reg;
assign outputdone = cnt == 7;
// always_ff @ (posedge clk)
    // if (reset) outputdone_reg <= 0;
    // else outputdone_reg <= outputdone;
assign hash_ack = control_buf == 32'h0f0f0f0f; // handshake ack from sw, received when hash value is sent to sw part


// assign finish = outputdone_reg && !outputdone;
always_ff @ (posedge clk)
    if (reset) 
        {writeaddress,data_out} <= 0;
    else 
        // if(finish | !hash_ack)
            // {writeaddress,data_out} <= {4'b1000,32'hffffffff};
        case(cnt)
            0: {writeaddress,data_out} <= {{1'b0,cnt},hashvalue[31:0]};
            1: {writeaddress,data_out} <= {{1'b0,cnt},hashvalue[63:32]};
            2: {writeaddress,data_out} <= {{1'b0,cnt},hashvalue[95:64]};
            3: {writeaddress,data_out} <= {{1'b0,cnt},hashvalue[127:96]};
            4: {writeaddress,data_out} <= {{1'b0,cnt},hashvalue[159:128]};
            5: {writeaddress,data_out} <= {{1'b0,cnt},hashvalue[191:160]};
            6: {writeaddress,data_out} <= {{1'b0,cnt},hashvalue[223:192]};
            7: {writeaddress,data_out} <= {{1'b0,cnt},hashvalue[255:224]};
            8: {writeaddress,data_out} <= {4'b1000,32'hffffffff};
        endcase

/**** Module ports map ****/
sha256_module sha256_module_0(
    .clk(clk),
    .reset(reset),
    .start(start),
    .data_in(buffer),
    .data_out(hashvalue),
    .done(done)
);
/**************************/

endmodule