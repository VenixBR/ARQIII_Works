module DataPath #(
    parameter SQUARE_INIT = 16'b0000000000000001,
    parameter ROOT_INIT   = 8'b00000000,
    parameter ROOT_INC    = 8'b00000001,
    parameter ROOT_SFT    = 8'b00000001
)(
    input  wire clk,
    input  wire rst_n,
    input  wire [15:0] valor_i,
    output wire [15:0] root_o,

    // Control signals
    input  wire boot_i,
    input  wire wr_square_i,
    input  wire wr_root_i,
    input  wire muxes_i,

    // Flags
    output wire N_o
);

// ####################################
// ###       INTERNAL SIGNALS       ###
// ####################################

wire [16:0] valor_ext_s;
wire [16:0] square_init_ext_s;
wire [16:0] root_ext_s;

wire [16:0] mux_square_s;
wire  [7:0] mux_root_s;

wire  [7:0] root_s;
wire [16:0] square_s;
wire [16:0] not_square_s;
wire  [7:0] root_incremented_s;
wire [16:0] square_added_s;
wire [16:0] adder_in_up_s;
wire [16:0] adder_in_down_s;
wire [16:0] root_shifted_s;


// ####################################
// ###    BIT EXTENSION OF DATAS    ###
// ####################################

assign valor_ext_s = {1'b0, valor_i};
assign square_init_ext_s = {1'b0, SQUARE_INIT};
assign root_ext_s = {9'b000000000,  root_s};


// ####################################
// ###  INSTATIATION OF COMPONENTS  ###
// ####################################

assign not_square_s = !square_s;
assign root_o = root_s;
assign N_o = square_added_s[16];

// MUXES

mux_2_1 #(
    .DATA_WIDTH(17)
) SQUARE_MUX (
    .A0    ( square_added_s    ),
    .A1    ( square_init_ext_s ),
    .s0    ( boot_i            ),
    .result( mux_square_s      )
);

mux_2_1 #(
    .DATA_WIDTH(8)
) ROOT_MUX (
    .A0    ( root_incremented_s ),
    .A1    ( root_init_ext_s    ),
    .s0    ( boot_i             ),
    .result( mux_root_s         )
);

mux_2_1 #(
    .DATA_WIDTH(17)
) ADDER_IN_UP (
    .A0    ( square_s      ),
    .A1    ( not_square_s  ),
    .s0    ( muxes_i       ),
    .result( adder_in_up_s )
);

mux_2_1 #(
    .DATA_WIDTH(17)
) ADDER_IN_DOWN (
    .A0    ( root_shifted_s  ),
    .A1    ( valor_ext_s     ),
    .s0    ( muxes_i         ),
    .result( adder_in_down_s )
);

// REGISTERS

gen_reg #(
    .REG_WIDTH(17)
) SQUARE_REG (
    .datain ( mux_square_s ),
    .set    ( 1'b1         ),
    .reset  ( rst_n        ),
    .enable ( wr_square_i  ),
    .clock  ( clk          ),
    .dataout( square_s     )
); 

gen_reg #(
    .REG_WIDTH(8)
) ROOT_REG (
    .datain ( mux_root_s ),
    .set    ( 1'b1       ),
    .reset  ( rst_n      ),
    .enable ( wr_root_i  ),
    .clock  ( clk        ),
    .dataout( root_s     )
); 

// ADDERS

CLA #(
    .WIDTH(17)
) SQUARE_ADDER (
    .A_i ( adder_in_up_s   ),
    .B_i ( adder_in_down_s ),
    .Ci_i( muxes_i         ),
    .S_o ( square_added_s  ),
    .Co_o(                 )
);

CLA #(
    .WIDTH(8)
) ROOT_ADDER (
    .A_i ( root_s             ),
    .B_i ( ROOT_INC           ),
    .Ci_i( 1'b0               ),
    .S_o ( root_incremented_s ),
    .Co_o(                    )
);

// SHIFTER

leftShifter #(
    .SHIFT(ROOT_SFT)
) SHIFTER_NETS (
    .in_i ( root_ext_s     ),
    .out_o( root_shifted_s )
);

endmodule