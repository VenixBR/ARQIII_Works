

module Square_root (
    input  wire [15:0] valor_i,
    input  wire clk,
    input  wire rst_n,

    output wire ready_o,
    output wire [7:0] root_o
);

// INTERNAL SIGNALS

// Control Signals
wire N_s;
wire en_pipe_s;
wire ready_s;
wire wr_square_s;
wire wr_input_s;
wire mux_root_s;


// INSTANTIATION OF CONTROL PATH AND DATA PATH

ControlPath CONTROL_PATH (
    .clk         ( clk         ),
    .rst_n       ( rst_n       ),
    .N_i         ( N_s         ),
    .en_pipe_o   ( en_pipe_s   ),
    .wr_input_o  ( wr_input_s  )
);

DataPath DATA_PATH (
    .clk         ( clk         ),
    .rst_n       ( rst_n       ),
    .valor_i     ( valor_i     ),
    .root_o      ( root_o      ),
    .ready_o     ( ready_o     ),
    .wr_input_i  ( wr_input_s  ),
    .en_pipe_i   ( en_pipe_s   ),
    .N_o         ( N_s         )
);

endmodule