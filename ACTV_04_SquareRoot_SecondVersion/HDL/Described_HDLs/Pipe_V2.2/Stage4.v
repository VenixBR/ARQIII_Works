

module Stage4 (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        en_pipe_i,
    input  wire        S4_ready_i,
    input  wire [12:0] S4_square_sum_i,
    input  wire        S4_Co_square_i,
    input  wire [3:0]  S4_A_high_i,
    input  wire [3:0]  S4_B_high_i,

    output wire        S4_ready_o,
    output wire [12:0] S4_square_sum_o,
    output wire        S4_Co_square_o,
    output wire [3:0]  S4_A_high_o,
    output wire [3:0]  S4_B_high_o
);

wire const_one_s;

assign const_one_s = 1'b1;

dffa S4_ready_reg (
    .d      ( S4_ready_i  ),
    .set    ( rst_n       ),
    .reset  ( const_one_s ),
    .enable ( en_pipe_i   ),
    .clock  ( clk         ),
    .q      ( S4_ready_o  )
);


Reg_Square_S4 square_sum_S4_reg (
    .datain  ( S4_square_sum_i ),
    .set     ( const_one_s     ),
    .reset   ( rst_n           ),
    .enable  ( en_pipe_i       ),
    .clock   ( clk             ),
    .dataout ( S4_square_sum_o )
);

dffa Co_Square_S4_reg (
    .d      ( S4_Co_square_i ),
    .set    ( const_one_s    ),
    .reset  ( rst_n          ),
    .enable ( en_pipe_i      ),
    .clock  ( clk            ),
    .q      ( S4_Co_square_o )
);

gen_reg #(
    .REG_WIDTH(4)
) S3_A_high_S2_reg (
    .datain  ( S4_A_high_i ),
    .set     ( const_one_s ),
    .reset   ( rst_n       ),
    .enable  ( en_pipe_i   ),
    .clock   ( clk         ),
    .dataout ( S4_A_high_o )
);

gen_reg #(
    .REG_WIDTH(4)
) S3_B_high_reg (
    .datain  ( S4_B_high_i ),
    .set     ( const_one_s ),
    .reset   ( rst_n       ),
    .enable  ( en_pipe_i   ),
    .clock   ( clk         ),
    .dataout ( S4_B_high_o )
);


endmodule