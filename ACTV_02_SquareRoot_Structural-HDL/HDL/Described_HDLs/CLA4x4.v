module CLA4x4 (
    input  wire [16:0] A_i,
    input  wire [16:0] B_i,
    input  wire Ci_i,
    output wire Co_o,
    output wire [16:0] S_o
);

wire c [2:0];


CLA #(
   .WIDTH(4)
) adder1 (
    .A_i ( A_i[3:0] ),
    .B_i ( B_i[3:0] ),
    .Ci_i( Ci_i     ),
    .Co_o( c[0]     ),
    .S_o ( S_o[3:0] )
);

CLA #(
   .WIDTH(4)
) adder2 (
    .A_i ( A_i[7:4] ),
    .B_i ( B_i[7:4] ),
    .Ci_i( c[0]     ),
    .Co_o( c[1]     ),
    .S_o ( S_o[7:4] )
);

CLA #(
   .WIDTH(4)
) adder3 (
    .A_i ( A_i[11:8] ),
    .B_i ( B_i[11:8] ),
    .Ci_i( c[1]      ),
    .Co_o( c[2]      ),
    .S_o ( S_o[11:8] )
);

CLA #(
   .WIDTH(5)
) adder4 (
    .A_i ( A_i[16:12] ),
    .B_i ( B_i[16:12] ),
    .Ci_i( c[2]       ),
    .Co_o( Co_o       ),
    .S_o ( S_o[16:12] )
);


endmodule
