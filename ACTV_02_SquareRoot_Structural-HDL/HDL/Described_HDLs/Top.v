module Top (
    input  wire [15:0] valor_i,
    input  wire clk,
    input  wire rst_n,

    output wire ready_o,
    output wire [7:0] root_o
);

// INTERNAL SIGNALS

// Control Signals
wire [1:0] N_s;
wire boot_s;
wire muxes_s;
wire wr_root_s;
wire wr_square_s;
wire root_s;

// Datapath outputs
wire [7:0] root_1_s;

wire [15:0] valor_s;



// INPUT REGISTER
gen_reg #(
    .REG_WIDTH(16)
) INPUT_REG (
    .datain ( valor_i ),
    .set    ( 1'b1    ),
    .reset  ( rst_n   ),
    .enable ( boot_s  ),
    .clock  ( clk     ),
    .dataout( valor_s )
); 



// INSTANTIATION OF CONTROL PATH AND DATA PATHS

ControlPath CONTROL_PATH(
    .clk(clk),
    .rst_n(rst_n),
    .N_i(N_s),
    .boot_o(boot_s),
    .muxes_o(muxes_s),
    .ready_o(ready_o),
    .wr_root_o(wr_root_s)
    .wr_square_o(wr_square_s),
    .root_o(root_s)
);

DataPath #(
    .SQUARE_INIT( 16'b0000000000000001 ),
    .ROOT_INIT  ( 8'b00000000          ),
    .ROOT_INC   ( 8'b00000010          ),
    .ROOT_SFT   ( 8'b00000010          )
) DATA_PATH_1 (
    .clk(clk),
    .rst_n(rst_n),
    .valor_i(valor_s),
    .root_o(root_1_s),
    .boot_i(boot_s),
    .wr_square_i(wr_square_s),
    .wr_square_i(wr_root_s),
    .muxes_i(muxes_s),
    .N_o(N_s[0])
);

DataPath #(
    .SQUARE_INIT( 16'b0000000000000100 ),
    .ROOT_INIT  ( 8'b00000001          ),
    .ROOT_INC   ( 8'b00000010          ),
    .ROOT_SFT   ( 8'b00000010          )
) DATA_PATH_2 (
    .clk(clk),
    .rst_n(rst_n),
    .valor_i(valor_s),
    .root_o(root_2_s),
    .boot_i(boot_s),
    .wr_square_i(wr_square_s),
    .wr_square_i(wr_root_s),
    .muxes_i(muxes_s),
    .N_o(N_s[1])
);



// INSTANTIATION OF OUTPUT MUX

mux_2_1 #(
    .DATA_WIDTH(8)
) ROOT_OUTPUT_MUX (
    .A0    ( root_1_s ),
    .A1    ( root_2_s ),
    .s0    ( root_s   ),
    .result( root_o   )
);


endmodule