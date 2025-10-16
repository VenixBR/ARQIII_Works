module Comparator #(
    parameter WIDTH = 32
)(
    input signed [WIDTH-1:0] A_i,
    input signed [WIDTH-1:0] B_i,

    output wire A_greater_than_B_o,
    output wire A_less_than_B_o,
    output wire A_equal_B_o
);

assign A_greater_than_B_o = (A_i>B_i)  ? 1'b1 : 1'b0;
assign A_less_than_B_o    = (A_i<B_i)  ? 1'b1 : 1'b0;
assign A_equal_B_o        = (A_i==B_i) ? 1'b1 : 1'b0;

endmodule
