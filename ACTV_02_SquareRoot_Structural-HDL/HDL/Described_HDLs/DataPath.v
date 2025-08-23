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

wire valor_ext_s;
wire square_init_ext_s;
wire root_ext_s;

wire mux_square_s;
wire mux_root_s;

wire root_s;
wire square_s;
wire root_incremented_s;
wire square_added_s;



// ####################################
// ###    BIT EXTENSION OF DATAS    ###
// ####################################

assign valor_ext_s = {1'b0, valor_i};
assign square_init_ext_s = {1'b0, SQUARE_INIT};
assign root_ext_s = {9'b000000000,  root_s};


// ####################################
// ###  INSTATIATION OF COMPONENTS  ###
// ####################################

mux_2_1 #(
    .DATA_WIDTH(16)
) SQUARE_MUX (
    .A0    ( square_added_s    ),
    .A1    ( square_init_ext_s ),
    .s0    ( boot_i            ),
    .result( mux_square_s      )
);

mux_2_1 #(
    .DATA_WIDTH(16)
) ROOT_MUX (
    .A0    ( root_incremented_s ),
    .A1    ( root_init_ext_s    ),
    .s0    ( boot_i             ),
    .result( mux_root_s         )
);

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

CLA #()

endmodule