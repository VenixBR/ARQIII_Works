

module Reg_Square_S3 (
    input  wire [8:0] datain,
    input  wire        set,
    input  wire        reset,
    input  wire        enable,
    input  wire        clock,
    output wire [8:0] dataout
);

wire const_one_s;
assign const_one_s = 1'b1;

dffa RegSumLow_0 (
    .d(datain[0]),
    .set(set),
    .reset(reset),
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
    .set(reset),
    .reset(set),
    .enable(enable),
    .clock(clock),
    .q(dataout[2])
);

dffa RegSumLow_3 (
    .d(datain[3]),
    .set(set),
    .reset(reset),
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

dffa RegSumLow_5 (
    .d(datain[5]),
    .set(set),
    .reset(reset),
    .enable(enable),
    .clock(clock),
    .q(dataout[5])
);

dffa RegSumLow_6 (
    .d(datain[6]),
    .set(set),
    .reset(reset),
    .enable(enable),
    .clock(clock),
    .q(dataout[6])
);

dffa RegSumLow_7 (
    .d(datain[7]),
    .set(set),
    .reset(reset),
    .enable(enable),
    .clock(clock),
    .q(dataout[7])
);

dffa RegSumLow_8 (
    .d(datain[8]),
    .set(set),
    .reset(reset),
    .enable(enable),
    .clock(clock),
    .q(dataout[8])
);




endmodule