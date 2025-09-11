

module Stage2 (
    input  wire clk,
    input  wire rst_n,
    input  wire en_pipe_i,
    input  wire ready_i,
    input  wire wr_square_s_i,
    input  wire N_i,
    input  wire [7:0] sum_low_i,
    input  wire Co_i,
    input  wire [8:0] A_high_i,
    input  wire [8:0] B_high_i,

    output  wire ready_o,
    output  wire wr_square_s_o,
    output  wire N_o,
    output  wire [7:0] sum_low_o,
    output  wire Co_o,
    output  wire [8:0] A_high_o,
    output  wire [8:0] B_high_o
);

wire const_one_s;

assign const_one_s = 1'b1;

dffa ready_reg (
    .d      ( ready_i     ),
    .set    ( rst_n       ),
    .reset  ( const_one_s ),
    .enable ( en_pipe_i   ),
    .clock  ( clk         ),
    .q      ( ready_o     )
);

dffa wr_square_s_reg (
    .d      ( wr_square_s_i ),
    .set    ( const_one_s   ),
    .reset  ( rst_n         ),
    .enable ( en_pipe_i     ),
    .clock  ( clk           ),
    .q      ( wr_square_s_o )
);

dffa N_reg (
    .d      ( N_i         ),
    .set    ( const_one_s ),
    .reset  ( rst_n       ),
    .enable ( en_pipe_i   ),
    .clock  ( clk         ),
    .q      ( N_o         )
);

gen_reg #(
    .REG_WIDTH(8)
) sum_low_reg (
    .datain  ( sum_low_i   ),
    .set     ( const_one_s ),
    .reset   ( rst_n       ),
    .enable  ( en_pipe_i   ),
    .clock   ( clk         ),
    .dataout ( sum_low_o   )
);

dffa Co_reg (
    .d      ( Co_i         ),
    .set    ( const_one_s ),
    .reset  ( rst_n       ),
    .enable ( en_pipe_i   ),
    .clock  ( clk         ),
    .q      ( Co_o         )
);

gen_reg #(
    .REG_WIDTH(9)
) A_high_reg (
    .datain  ( A_high_i    ),
    .set     ( const_one_s ),
    .reset   ( rst_n       ),
    .enable  ( en_pipe_i   ),
    .clock   ( clk         ),
    .dataout ( A_high_o    )
);

gen_reg #(
    .REG_WIDTH(9)
) B_high_reg (
    .datain  ( B_high_i    ),
    .set     ( const_one_s ),
    .reset   ( rst_n       ),
    .enable  ( en_pipe_i   ),
    .clock   ( clk         ),
    .dataout ( B_high_o    )
);


endmodule