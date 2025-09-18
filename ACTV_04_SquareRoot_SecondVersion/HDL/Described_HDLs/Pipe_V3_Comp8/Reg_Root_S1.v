

module Reg_Root_S1 (
    input  wire [7:0] datain,
    input  wire        set,
    input  wire        reset,
    input  wire        enable,
    input  wire        clock,
    output wire [7:0] dataout
);

wire const_one_s;
assign const_one_s = 1'b1;

dffa Reg_Root_S1_inst_0 (
    .d(datain[0]),
    .set(reset),
    .reset(set),
    .enable(enable),
    .clock(clock),
    .q(dataout[0])
);

genvar i;
generate
    for (i=1; i<8 ; i=i+1) begin : reg_array
        dffa Reg_Root_S1_inst(
        .d(datain[i]),
        .set(set),
        .reset(reset),
        .enable(enable),
        .clock(clock),
        .q(dataout[i])
    );
    end
endgenerate





endmodule