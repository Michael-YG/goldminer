/*
* Avalon memory-mapped SHA256 accelerator
*/
module acc_top(
    input clk,reset,write,chipselect,
    input [2:0] adderss,
    input [31:0] writedata,
    output logic [31:0] data_out,
    output logic [2:0] writeaddress,
    output logic valid
);

logic [511:0] buf;
logic [5:0] cnt;
assign valid = cnt[1];
enum integer {st_idle = 0, ,st_load = 1,st_exe = 2} state, state_next;

always_ff @ (posedge clk)
    if(reset) state <= st_idle;
    else state <= state_next;

logic loading, hashdone;
assign loading = chipselect && write;

always_ff @ (posedge clk)
    if(reset) cnt <= 0;
    else cnt <= cnt == 31? cnt:cnt + loading;

always_comb begin
    state_next = state;
    case(state)
        st_idle: state_next = loading? st_load:state;
        st_load: state_next = cnt == 31? st_exe:state;
        st_exe: state_next = hashdone? st_idle:state;
    endcase
end

logic [10:0] buf_addr;
assign buf_addr = cnt << 5;

always_ff @ (posedge clk) begin
    if(reset) buf <= 0;
    else buf[buf_addr+31:buf_addr] <= writedata;
end

logic stateisexe,stateisexe_next;
assign stateisexe_next = state == st_exe;

always_ff @ (posedge clk)
    // if(reset) state_reg <= 0
    stateisexe <= stateisexe_next;
 
logic start;
assign start = !stateisexe && stateisexe_next;
logic [255:0] hashvalue;

// **** Module ports map ****
sha256_module sha256_module_0(
    .clk(clk),
    .reset(reset),
    .start(start),
    .data_in(buf),
    .data_out(hashvalue),
    .done(done)
)
// **************************


endmodule