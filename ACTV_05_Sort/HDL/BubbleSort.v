module BubbleSort #(
    parameter WIDTH = 32
)(
    input  wire clk,
    input  wire rst,
    input  signed [WIDTH-1:0] data_serial_i,

    output signed [WIDTH-1:0] data_serial_o,
    output wire data_valid_o
);

    wire wr_bigger_s;
    wire wr_last_s;
    wire wr_counter_s;
    wire mux_in_s;
    wire rst_counter_s;
    wire en_sr_s;
    wire data_valid_s;
    wire eh_maior_s;
    wire end_comp_s;
    wire end_sft_s;
    wire end_count_s;



    DataPath DATA_PATH(
        .clk           ( clk           ),
        .rst           ( rst           ),
        .data_serial_i ( data_serial_i ),
        .wr_bigger_i   ( wr_bigger_s   ),
        .wr_last_i     ( wr_last_s     ),
        .wr_counter_i  ( wr_counter_s  ),
        .mux_in_i      ( mux_in_s      ),
        .rst_counter_i ( rst_counter_s ),
        .en_sr_i       ( en_sr_s       ),
        .data_valid_i  ( data_valid_s  ),
        .data_serial_o ( data_serial_o ),
        .eh_maior_o    ( eh_maior_s    ),
        .end_comp_o    ( end_comp_s    ),
        .end_sft_o     ( end_sft_s     ),
        .end_count_o   ( end_count_s   ),
        .data_valid_o  ( data_valid_o  )
    );

    ControlPath CONTROL_PATH(
        .clk          ( clk           ),
        .rst          ( rst           ),
        .eh_maior_i   ( eh_maior_s    ),
        .end_comp_i   ( end_comp_s    ),
        .end_sft_i    ( end_sft_s     ),
        .end_count_i  ( end_count_s   ),
        .wr_bigger_o  ( wr_bigger_s   ),
        .wr_last_o    ( wr_last_s     ),
        .wr_counter_o ( wr_counter_s  ),
        .mux_in_o     ( mux_in_s      ),
        .rst_cntr_o   ( rst_counter_s ),
        .en_sr_o      ( en_sr_s       ),
        .data_valid_o ( data_valid_s  )
    );

endmodule