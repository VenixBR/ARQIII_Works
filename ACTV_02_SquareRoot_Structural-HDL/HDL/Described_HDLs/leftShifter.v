module leftShifter #(
    parameter SHIFT = 1
)(  
    input  wire [16:0] in_i,
    output reg [16:0] out_o
);

always@* begin
    out_o <= 17'b00000000000000000;
    out_o[SHIFT] <= in_i[0];
    out_o[SHIFT+1] <= in_i[1];
    out_o[SHIFT+2] <= in_i[2];
    out_o[SHIFT+3] <= in_i[3];
    out_o[SHIFT+4] <= in_i[4];
    out_o[SHIFT+5] <= in_i[5];
    out_o[SHIFT+6] <= in_i[6];
    out_o[SHIFT+7] <= in_i[7];
end


endmodule