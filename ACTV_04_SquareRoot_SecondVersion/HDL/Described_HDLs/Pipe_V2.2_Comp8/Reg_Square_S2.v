

module Reg_Square_S2 (
    input  wire [4:0] datain,
    input  wire        set,
    input  wire        reset,
    input  wire        enable,
    input  wire        clock,
    output wire [4:0] dataout
);

wire const_one_s;
assign const_one_s = 1'b1;

dffa RegSumLow_0 (
    .d(datain[0]),
    .set(reset),
    .reset(set),
    .enable(enable),
    .clock(clock),
    .q(dataout[0])
);

dffa RegSumLow_1 (
    .d(datain[1]),
    .set(set),
    .reset(reset),
    .enable(enable),
    .clock(clock),
    .q(dataout[1])
);

dffa RegSumLow_2 (
    .d(datain[2]),
    .set(set),
    .reset(reset),
    .enable(enable),
    .clock(clock),
    .q(dataout[2])
);

dffa RegSumLow_3 (
    .d(datain[3]),
    .set(reset),
    .reset(set),
    .enable(enable),
    .clock(clock),
    .q(dataout[3])
);

dffa RegSumLow_4 (
    .d(datain[4]),
    .set(set),
    .reset(reset),
    .enable(enable),
    .clock(clock),
    .q(dataout[4])
);



endmodule