

module DataPath (
    input  wire clk,
    input  wire rst_n,
    input  wire [15:0] valor_i,
    output wire [7:0] root_o,
    output wire       ready_o,

    // Control signals
    input  wire wr_square_i,
    input  wire wr_input_i,
    input  wire en_pipe_i,
    input  wire ready_i,
    input  wire mux_root_i,

    // Flags
    output wire N_o
);

// ####################################
// ###       INTERNAL SIGNALS       ###
// ####################################



wire [15:0] S1_o_input_s;
wire [16:0] S1_o_square_s;
wire  [7:0] S1_o_root_s;
wire        S2_o_ready_s;
wire        S2_o_N_s;
wire  [8:0] S2_o_square_adder_sum_l_s;
wire        S2_o_square_adder_co_l_s;
wire  [7:0] S2_o_A_high_s;
wire  [7:0] S2_o_B_high_s;
wire [16:0] valor_ext_s;
wire [16:0] root_shifted_s;
wire  [7:0] root_adder_in_A_s; 
wire  [8:0] square_adder_A_l_s;
wire  [8:0] square_adder_B_l_s;
wire  [7:0] square_adder_A_h_s;
wire  [7:0] square_adder_B_h_s;
wire  [8:0] square_adder_sum_l_s;
wire  [7:0] square_adder_sum_h_s;
wire        square_adder_co_l_s;
wire  [7:0] root_incremented_s;
wire [16:0] square_added_s;
wire        N_s;
wire const_one_s;
wire const_zero_s;
wire carry_unused1_s;
wire carry_unused2_s;




// ####################################
// ###    BIT EXTENSION OF DATAS    ###
// ####################################

assign valor_ext_s = {1'b0, S1_o_input_s};
assign root_shifted_s = {7'b0000000, S1_o_root_s, 2'b11};
assign root_adder_in_A_s = {{6{mux_root_i}}, 2'b01};
assign square_adder_A_l_s = S1_o_square_s[8:0];
assign square_adder_A_h_s = S1_o_square_s[16:9];
assign square_adder_B_l_s = root_shifted_s[8:0];
assign square_adder_B_h_s = root_shifted_s[16:9];
assign square_added_s = {square_adder_sum_h_s, S2_o_square_adder_sum_l_s};
assign N_o = S2_o_N_s;
assign ready_o = S2_o_ready_s;
assign root_o = S1_o_root_s;

assign const_one_s = 1'b1;
assign const_zero_s = 1'b0;

// ####################################
// ###  INSTATIATION OF COMPONENTS  ###
// ####################################



// REGISTERS
Stage1 PIPELINE_STAGE1 (
    .clk           ( clk                ),
    .rst_n         ( rst_n              ),
    .en_pipe_i     ( en_pipe_i          ),
    .wr_square_i   ( wr_square_i        ),
    .wr_input_i    ( wr_input_i         ),
    .input_i       ( valor_i            ),
    .square_i      ( square_added_s     ),
    .root_i        ( root_incremented_s ),
    .input_o       ( S1_o_input_s       ),
    .square_o      ( S1_o_square_s      ),
    .root_o        ( S1_o_root_s        )
);

Stage2 PIPELINE_STAGE2 (
    .clk           ( clk                       ),
    .rst_n         ( rst_n                     ),
    .en_pipe_i     ( en_pipe_i                 ),
    .ready_i       ( ready_i                   ),
    .N_i           ( N_s                       ),
    .sum_low_i     ( square_adder_sum_l_s      ),
    .Co_i          ( square_adder_co_l_s       ),
    .A_high_i      ( square_adder_A_h_s        ),
    .B_high_i      ( square_adder_B_h_s        ),
    .ready_o       ( S2_o_ready_s              ),
    .N_o           ( S2_o_N_s                  ),
    .sum_low_o     ( S2_o_square_adder_sum_l_s ),
    .Co_o          ( S2_o_square_adder_co_l_s  ),
    .A_high_o      ( S2_o_A_high_s             ),
    .B_high_o      ( S2_o_B_high_s             )
);


// ADDERS AND COMPARATOR

CLA #(
    .WIDTH(9)
) SQUARE_LOW_ADDER (
    .A_i  ( square_adder_A_l_s   ),
    .B_i  ( square_adder_B_l_s   ),
    .Ci_i ( const_one_s          ),
    .S_o  ( square_adder_sum_l_s ),
    .Co_o ( square_adder_co_l_s  )
);

CLA #(
    .WIDTH(8)
) SQUARE_HIGH_ADDER (
    .A_i  ( S2_o_A_high_s            ),
    .B_i  ( S2_o_B_high_s            ),
    .Ci_i ( S2_o_square_adder_co_l_s ),
    .S_o  ( square_adder_sum_h_s     ),
    .Co_o ( carry_unused1_s          )
);

CLA #(
    .WIDTH(8)
) ROOT_ADDER (
    .A_i  ( root_adder_in_A_s ),
    .B_i  ( S1_o_root_s       ),
    .Ci_i ( const_zero_s      ),
    .S_o  ( root_incremented_s ),
    .Co_o ( carry_unused2_s    )
);

Comparator COMPARATOR (
    .A_i             ( valor_ext_s   ),
    .B_i             ( S1_o_square_s ),
    .A_less_than_B_o ( N_s           )
);

endmodule