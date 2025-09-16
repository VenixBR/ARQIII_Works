

module Comparator (
    input wire [16:0] A_i,
    input wire [16:0] B_i,
    output reg A_less_than_B_o
);

always@* begin
    if(A_i < B_i)
        A_less_than_B_o = 1'b1;
    else
        A_less_than_B_o = 1'b0;
end

endmodule
