

module Stage1 (
    input  wire clk,
    input  wire rst_n, 
    input  wire en_pipe_i,
    input  wire wr_input_i,
    input  wire wr_square_s_i,
    input  wire [15:0] input_i,
    input  wire [16:0] square1_i,
    input  wire [16:0] square2_i,
    input  wire [7:0]  root_i,
    input  wire wr_square_i,

    output wire wr_square_s_o,
    output wire [15:0] input_o,
    output wire [16:0] square1_o,
    output wire [16:0] square2_o,
    output wire [7:0]  root_o
);

wire const_one_s;
wire not_wr_square_s;

assign const_one_s = 1'b1;
assign not_wr_square_s = ~wr_square_i;

dffa wr_square_s_reg (
    .d      ( wr_square_s_i ),
    .set    ( const_one_s   ),
    .reset  ( rst_n         ),
    .enable ( en_pipe_i     ),
    .clock  ( clk           ),
    .q      ( wr_square_s_o )
);

gen_reg #(
    .REG_WIDTH(16)
) input_reg (
    .datain  ( input_i     ),
    .set     ( const_one_s ),
    .reset   ( rst_n       ),
    .enable  ( wr_input_i  ),
    .clock   ( clk         ),
    .dataout ( input_o     )
);

gen_reg #(
    .REG_WIDTH(17)
) square1_reg (
    .datain  ( square1_i       ),
    .set     ( const_one_s     ),
    .reset   ( rst_n           ),
    .enable  ( not_wr_square_s ),
    .clock   ( clk             ),
    .dataout ( square1_o       )
);

RegSquare2 square2_reg (
    .datain  ( square2_i   ),
    .set     ( const_one_s ),
    .reset   ( rst_n       ),
    .enable  ( wr_square_i ),
    .clock   ( clk         ),
    .dataout ( square2_o   )
);

gen_reg #(
    .REG_WIDTH(8)
) root_reg (
    .datain  ( root_i      ),
    .set     ( const_one_s ),
    .reset   ( rst_n       ),
    .enable  ( en_pipe_i   ),
    .clock   ( clk         ),
    .dataout ( root_o      )
);

endmodule