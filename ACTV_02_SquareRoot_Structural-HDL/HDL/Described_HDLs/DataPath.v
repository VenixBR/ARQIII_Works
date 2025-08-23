module DataPath #(
    parameter SQUARE_INIT = 16'h0001,
    parameter ROOT_INIT   = 8'h00,
    parameter ROOT_INC    = 8'h01,
    parameter ROOT_SFT    = 8'h01
)(
    input wire clk,
    input wire rst,
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

reg root_s;
reg square_s;



// ####################################
// ###    BIT EXTENSION OF DATAS    ###
// ####################################

assign valor_ext_s = {1'b0, valor_i};
assign square_init_ext_s = {1'b0, SQUARE_INIT};
assign root_ext_s = {9'b000000000,  root_s};

endmodule