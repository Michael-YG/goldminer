/*
* Avalon memory-mapped SHA256 accelerator
*/

module acc_top(
    input clk,reset,write,chipselect,
    input [4:0] address, // hash input value 0-31 and start flag 32
    input [31:0] writedata,
    output logic [31:0] data_out,
    output logic [6:0] writeaddress
    // output logic valid
);

logic [512:0] buf;
logic [5:0] cnt;
logic [255:0] hashvalue;
logic done;
enum int unsigned {st_idle = 0, st_load = 1, st_exe = 2} state, state_next;

/* FSM logic */
always_ff @ (posedge clk)
    if (reset) state <= st_idle;
    else state <= state_next;
logic start;
always_comb begin
    state_next = state;
    case(state)
        st_idle: state_next = loading? st_load:state;
        st_load: state_next = start? st_exe:state;
        st_exe: state_next = hashdone? st_idle:state;
    endcase
end

/* Counter and buffer loading logic */
logic loading, hashdone;
assign loading = chipselect && write;

always_ff @ (posedge clk)
    if (reset) cnt <= 0;
    else cnt <= cnt == 31? cnt:cnt + loading;

logic [31:0] control_data;

always_ff @ (posedge clk) begin
    if (reset)
        buf <= 0;
    // else buf[buf_addr+31:buf_addr] <= writedata;
    else
        if(loading)
            case(address)
                0: buf[31:0] <= writedata;
                1: buf[63:32] <= writedata;
                2: buf[95:64] <= writedata;
                3: buf[127:96] <= writedata;
                4: buf[159:128] <= writedata;
                5: buf[191:160] <= writedata;
                6: buf[223:192] <= writedata;
                7: buf[255:224] <= writedata;
                8: buf[287:256] <= writedata;
                9: buf[319:288] <= writedata;
                10: buf[351:320] <= writedata;
                11: buf[383:352] <= writedata;
                12: buf[415:384] <= writedata;
                13: buf[447:416] <= writedata;
                14: buf[479:448] <= writedata;
                15: buf[511:480] <= writedata;
            endcase
end

always_ff @ (posedge clk)
    if (reset) control_data <= 0;
    else control_data <= address[4] && loading? writedata : 0;

assign start = control_data == 32'hffffffff;

logic stateisexe,stateisexe_next;
assign stateisexe_next = state == st_exe;

always_ff @ (posedge clk)
    // if(reset) state_reg <= 0
    stateisexe <= stateisexe_next;
 
/**** Module ports map ****/
sha256_module sha256_module_0(
    .clk(clk),
    .reset(reset),
    .start(start),
    .data_in(buf),
    .data_out(hashvalue),
    .done(done)
)
/**************************/

endmodule