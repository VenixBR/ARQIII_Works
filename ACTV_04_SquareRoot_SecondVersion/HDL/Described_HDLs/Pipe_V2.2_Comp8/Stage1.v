

module Stage1 (
    input  wire clk,
    input  wire rst_n, 
    input  wire en_pipe_i,
    input  wire wr_input_i,
    input  wire [15:0] input_i,
    input  wire [16:0] square_i,
    input  wire [7:0]  root_i,

    output wire [15:0] input_o,
    output wire [16:0] square_o,
    output wire [7:0]  root_o
);

wire const_one_s;

assign const_one_s = 1'b1;


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
) square_reg (
    .datain  ( square_i    ),
    .set     ( const_one_s ),
    .reset   ( rst_n       ),
    .enable  ( en_pipe_i   ),
    .clock   ( clk         ),
    .dataout ( square_o    )
);

Reg_Root_S1 S1_root_reg (
    .datain  ( root_i      ),
    .set     ( const_one_s ),
    .reset   ( rst_n       ),
    .enable  ( en_pipe_i   ),
    .clock   ( clk         ),
    .dataout ( root_o      )
);

endmodule