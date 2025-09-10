module CLA2x4 (
    input  wire [7:0] A_i,
    input  wire [7:0] B_i,
    input  wire Ci_i,
    output wire Co_o,
    output wire [7:0] S_o
);

wire c_s;


CLA #(
   .WIDTH(4)
) adder1 (
    .A_i ( A_i[3:0] ),
    .B_i ( B_i[3:0] ),
    .Ci_i( Ci_i     ),
    .Co_o( c_s      ),
    .S_o ( S_o[3:0] )
);

CLA #(
   .WIDTH(4)
) adder4 (
    .A_i ( A_i[7:4] ),
    .B_i ( B_i[7:4] ),
    .Ci_i( c_s      ),
    .Co_o( Co_o     ),
    .S_o ( S_o[7:4] )
);


endmodule
