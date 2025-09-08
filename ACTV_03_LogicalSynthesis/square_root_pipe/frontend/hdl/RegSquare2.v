module RegSquare2 (
    input  wire [16:0] datain,
    input  wire        set,
    input  wire        reset,
    input  wire        enable,
    input  wire        clock,
    output wire [16:0] dataout
);

wire const_one_s;
wire enable_s;

assign enable_s = enable;
assign const_one_s = 1'b1;


dffa RegSquare2_0 (
    .d(datain[0]),
    .set(reset),
    .reset(set),
    .enable(enable_s),
    .clock(clock),
    .q(dataout[0])
);

genvar i;
generate
    for (i=1; i<17 ; i=i+1) begin : reg_array
        dffa RegSquare2_inst(
        .d(datain[i]),
        .set(set),
        .reset(reset),
        .enable(enable_s),
        .clock(clock),
        .q(dataout[i])
    );
    end
endgenerate





endmodule