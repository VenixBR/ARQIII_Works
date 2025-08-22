module CLA2x8 (
    input  wire [15:0] A_i,
    input  wire [15:0] B_i,
    input  wire Ci_i,
    output wire Co_o,
    output wire [15:0] S_o
);

wire c;


CLA #(
   .WIDTH(8)
) adder1 (
    .A_i ( A_i[7:0] ),
    .B_i ( B_i[7:0] ),
    .Ci_i( Ci_i     ),
    .Co_o( c    ),
    .S_o ( S_o[7:0] )
);

CLA #(
   .WIDTH(8)
) adder2 (
    .A_i ( A_i[15:8] ),
    .B_i ( B_i[15:8] ),
    .Ci_i( c     ),
    .Co_o( Co_o     ),
    .S_o ( S_o[15:8] )
);


endmodule