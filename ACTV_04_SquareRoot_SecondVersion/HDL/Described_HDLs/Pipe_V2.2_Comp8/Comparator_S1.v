

module Comparator_S1 (
    input wire [8:0] A_i,
    input wire [8:0] B_i,
    output reg [1:0] feedback_o
);

    // 00 -> A < B
    // 01 -> A > B
    // 10 -> A == B (precisa olhar os LSBs)


//STAGE 1
always @* begin
        if (A_i < B_i)
            feedback_o = 2'b10;
        else if (A_i > B_i)
            feedback_o = 2'b01;
        else
            feedback_o = 2'b00;
    end


endmodule
