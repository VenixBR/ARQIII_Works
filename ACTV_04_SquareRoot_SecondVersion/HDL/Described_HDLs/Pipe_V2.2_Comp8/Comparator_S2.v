module Comparator_S2 (
    input  wire [7:0]  A_i,
    input  wire [7:0]  B_i,
    input  wire [1:0]  feedback_i,
    output reg         A_less_than_B_o
);

always @* begin
    case (feedback_i)
        2'b10 : A_less_than_B_o = 1'b1;                  // A < B
        2'b01 : A_less_than_B_o = 1'b0;                  // A > B
        2'b00 : A_less_than_B_o = (A_i < B_i) ? 1'b1 : 1'b0; // compara LSBs
        default: A_less_than_B_o = 1'b0;
    endcase
end

endmodule
