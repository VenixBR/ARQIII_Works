module BubbleSort #(
    parameter WIDTH = 32
)(
    input  wire clk,
    input  wire rst,
    input  signed [WIDTH-1:0] data_serial_i,

    output signed [WIDTH-1:0] data_serial_o,
    output wire ready_o
);

    wire wr_bigger_s;
    wire mux_control_s;
    wire boot_s;
    wire mux_A_s;
    wire end_s;
    wire is_nine_s;
    wire is_bigger_s;
    wire clk_en_s;
    reg en_cg_s;
    wire clk_gated_s;

    // Clock Gate
    always@(clk, clk_en_s) begin
        if(clk==1'b0)
            en_cg_s = clk_en_s;
    end
    assign clk_gated_s = clk && en_cg_s;



    DataPath DATA_PATH(
        .clk           ( clk_gated_s   ),
        .rst           ( rst           ),
        .data_serial_i ( data_serial_i ),
        .wr_bigger_i   ( wr_bigger_s   ),
        .mux_control_i ( mux_control_s ),
        .boot_i        ( boot_s        ),
        .mux_A_i       ( mux_A_s       ),

        .data_serial_o ( data_serial_o ),
        .end_o         ( end_s         ),
        .is_nine_o     ( is_nine_s     ),
        .is_bigger_o   ( is_bigger_s   )
    );

    ControlPath CONTROL_PATH(
        .clk           ( clk_gated_s   ),
        .rst           ( rst           ),
        .is_bigger_i   ( is_bigger_s   ),
        .end_i         ( end_s         ),
        .is_nine_i     ( is_nine_s     ),
        .wr_bigger_o   ( wr_bigger_s   ),
        .mux_control_o ( mux_control_s ),
        .boot_o        ( boot_s        ),
        .mux_A_o       ( mux_A_s       ),
        .clk_en_o      ( clk_en_s      ),
        .ready_o       ( ready_o       )
    );

endmodule