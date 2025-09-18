

module Stage3 (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       en_pipe_i,
    input  wire [8:0] S3_square_sum_i,
    input  wire       S3_Co_square_i,
    input  wire [7:0] S3_A_high_i,
    input  wire [7:0] S3_B_high_i,

    output wire [8:0] S3_square_sum_o,
    output wire       S3_Co_square_o,
    output wire [7:0] S3_A_high_o,
    output wire [7:0] S3_B_high_o
);

wire const_one_s;

assign const_one_s = 1'b1;



Reg_Square_S3 square_sum_S3_reg (
    .datain  ( S3_square_sum_i ),
    .set     ( const_one_s     ),
    .reset   ( rst_n           ),
    .enable  ( en_pipe_i       ),
    .clock   ( clk             ),
    .dataout ( S3_square_sum_o )
);

dffa Co_Square_S3_reg (
    .d      ( S3_Co_square_i ),
    .set    ( const_one_s    ),
    .reset  ( rst_n          ),
    .enable ( en_pipe_i      ),
    .clock  ( clk            ),
    .q      ( S3_Co_square_o )
);

gen_reg #(
    .REG_WIDTH(8)
) S3_A_high_S2_reg (
    .datain  ( S3_A_high_i ),
    .set     ( const_one_s ),
    .reset   ( rst_n       ),
    .enable  ( en_pipe_i   ),
    .clock   ( clk         ),
    .dataout ( S3_A_high_o )
);

gen_reg #(
    .REG_WIDTH(8)
) S3_B_high_reg (
    .datain  ( S3_B_high_i ),
    .set     ( const_one_s ),
    .reset   ( rst_n       ),
    .enable  ( en_pipe_i   ),
    .clock   ( clk         ),
    .dataout ( S3_B_high_o )
);


endmodule