

module Reg_Square_S4 (
    input  wire [12:0] datain,
    input  wire        set,
    input  wire        reset,
    input  wire        enable,
    input  wire        clock,
    output wire [12:0] dataout
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

genvar i;
generate
    for(i=1 ; i<13 ; i=i+1) begin : reg_array
        dffa S4_square_reg_inst(
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