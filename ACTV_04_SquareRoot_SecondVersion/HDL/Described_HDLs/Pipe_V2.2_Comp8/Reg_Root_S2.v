

module Reg_Root_S2 (
    input  wire [3:0] datain,
    input  wire        set,
    input  wire        reset,
    input  wire        enable,
    input  wire        clock,
    output wire [3:0] dataout
);

wire const_one_s;
assign const_one_s = 1'b1;

dffa Reg_Root_S2_0 (
    .d(datain[0]),
    .set(set),
    .reset(reset),
    .enable(enable),
    .clock(clock),
    .q(dataout[0])
);

dffa Reg_Root_S2_1 (
    .d(datain[1]),
    .set(reset),
    .reset(set),
    .enable(enable),
    .clock(clock),
    .q(dataout[1])
);

dffa Reg_Root_S2_2 (
    .d(datain[2]),
    .set(set),
    .reset(reset),
    .enable(enable),
    .clock(clock),
    .q(dataout[2])
);

dffa Reg_Root_S2_3 (
    .d(datain[3]),
    .set(set),
    .reset(reset),
    .enable(enable),
    .clock(clock),
    .q(dataout[3])
);

endmodule