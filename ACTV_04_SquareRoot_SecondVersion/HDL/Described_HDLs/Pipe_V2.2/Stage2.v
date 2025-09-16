

module Stage2 (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        en_pipe_i,
    input  wire        S2_N_i,
    input  wire [4:0]  S2_square_sum_i,
    input  wire        S2_Co_square_i,
    input  wire [11:0] S2_A_high_i,
    input  wire [11:0] S2_B_high_i,
    input  wire [3:0]  S2_root_sum_i,
    input  wire        S2_Co_root_i,
    input  wire [3:0]  S2_root_high_i,

    output wire        S2_N_o,
    output wire [4:0]  S2_square_sum_o,
    output wire        S2_Co_square_o,
    output wire [11:0] S2_A_high_o,
    output wire [11:0] S2_B_high_o,
    output wire [3:0]  S2_root_sum_o,
    output wire        S2_Co_root_o,
    output wire [3:0]  S2_root_high_o
);

wire const_one_s;

assign const_one_s = 1'b1;

dffa N_S2_reg (
    .d      ( S2_N_i         ),
    .set    ( const_one_s    ),
    .reset  ( rst_n          ),
    .enable ( en_pipe_i      ),
    .clock  ( clk            ),
    .q      ( S2_N_o         )
);

Reg_Square_S2 square_sum_S2_reg (
    .datain  ( S2_square_sum_i ),
    .set     ( const_one_s     ),
    .reset   ( rst_n           ),
    .enable  ( en_pipe_i       ),
    .clock   ( clk             ),
    .dataout ( S2_square_sum_o )
);

dffa Co_Square_S2_reg (
    .d      ( S2_Co_square_i ),
    .set    ( const_one_s    ),
    .reset  ( rst_n          ),
    .enable ( en_pipe_i      ),
    .clock  ( clk            ),
    .q      ( S2_Co_square_o )
);

gen_reg #(
    .REG_WIDTH(12)
) S2_A_high_S2_reg (
    .datain  ( S2_A_high_i ),
    .set     ( const_one_s ),
    .reset   ( rst_n       ),
    .enable  ( en_pipe_i   ),
    .clock   ( clk         ),
    .dataout ( S2_A_high_o )
);

gen_reg #(
    .REG_WIDTH(12)
) S2_B_high_reg (
    .datain  ( S2_B_high_i ),
    .set     ( const_one_s ),
    .reset   ( rst_n       ),
    .enable  ( en_pipe_i   ),
    .clock   ( clk         ),
    .dataout ( S2_B_high_o )
);

Reg_Root_S2 S2_root_reg (
    .datain  ( S2_root_sum_i ),
    .set     ( const_one_s   ),
    .reset   ( rst_n         ),
    .enable  ( en_pipe_i     ),
    .clock   ( clk           ),
    .dataout ( S2_root_sum_o )
);

dffa S2_Co_Root_reg (
    .d      ( S2_Co_root_i ),
    .set    ( const_one_s  ),
    .reset  ( rst_n        ),
    .enable ( en_pipe_i    ),
    .clock  ( clk          ),
    .q      ( S2_Co_root_o )
);

gen_reg #(
    .REG_WIDTH(4)
) S2_root_high_reg (
    .datain  ( S2_root_high_i ),
    .set     ( const_one_s    ),
    .reset   ( rst_n          ),
    .enable  ( en_pipe_i      ),
    .clock   ( clk            ),
    .dataout ( S2_root_high_o )
);


endmodule