module CLA8and9 #( 
    parameter WIDTH = 8
)(
    input  wire [WIDTH-1:0] A_i,
    input  wire [WIDTH-1:0] B_i,
    input  wire Ci_i,
    output wire [WIDTH-1:0] S_o,
    output wire Co_o
);

wire C_s;

CLA #(
    .WIDTH(4)
) CLA1 (
    .A_i  ( A_i[3:0] ),
    .B_i  ( B_i[3:0] ),
    .Ci_i ( Ci_i     ),
    .S_o  ( S_o[3:0] ),
    .Co_o ( C_s      )
);

CLA #(
    .WIDTH(WIDTH-4)
) CLA2 (
    .A_i  ( A_i[WIDTH-1:4] ),
    .B_i  ( B_i[WIDTH-1:4] ),
    .Ci_i ( C_s      ),
    .S_o  ( S_o[WIDTH-1:4] ),
    .Co_o ( Co_o     )
);

endmodule