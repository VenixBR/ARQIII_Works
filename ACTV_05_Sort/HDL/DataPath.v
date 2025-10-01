module DataPath #(
    parameter WIDTH = 32
)(
    input  wire clk,
    input  wire rst,
    input  signed [WIDTH-1:0] data_serial_i,
    input  wire wr_bigger_i,
    input  wire wr_last_i,
    input  wire wr_counter_i,
    input  wire mux_in_i,
    input  wire rst_counter_i,
    input  wire en_sr_i,
    input  wire data_valid_i,
    input  wire ready_i,

    output signed [WIDTH-1:0] data_serial_o,
    output wire eh_maior_o,
    output wire end_comp_o,
    output wire end_sft_o,
    output wire end_count_o,
    output reg data_valid_o,
    output reg ready_o
);

    wire signed [WIDTH-1:0] mux_input_out_s;
    wire signed [WIDTH-1:0] mux_bigger_out_s;

    reg  signed [WIDTH-1:0] SF_0_s;
    reg  signed [WIDTH-1:0] SF_1_s;
    reg  signed [WIDTH-1:0] SF_2_s;
    reg  signed [WIDTH-1:0] SF_3_s;
    reg  signed [WIDTH-1:0] SF_4_s;
    reg  signed [WIDTH-1:0] SF_5_s;
    reg  signed [WIDTH-1:0] SF_6_s;
    reg  signed [WIDTH-1:0] SF_7_s;
    reg  signed [WIDTH-1:0] SF_8_s;
    reg  signed [WIDTH-1:0] SF_9_s;

    reg  signed [WIDTH-1:0] Last_s;
    reg  signed [WIDTH-1:0] First_s;
    reg  signed [3:0] Counter_s;
    wire wr_first_s;
    wire rst_counter_s;
    

    // INPUT MUX
    assign mux_input_out_s = ( mux_in_i == 1'b0 ) ? data_serial_i : mux_bigger_out_s;

    // BIGGER MUX
    assign mux_bigger_out_s = ( wr_bigger_i == 1'b0 ) ? SF_8_s : SF_9_s;

    // SHIFT REGISTER 9 BITS
    always @( posedge clk, posedge rst ) begin
        if( rst == 1'b1 ) begin
            SF_0_s <= { {WIDTH{1'b0}} };
            SF_1_s <= { {WIDTH{1'b0}} };
            SF_2_s <= { {WIDTH{1'b0}} };
            SF_3_s <= { {WIDTH{1'b0}} };
            SF_4_s <= { {WIDTH{1'b0}} };
            SF_5_s <= { {WIDTH{1'b0}} };
            SF_6_s <= { {WIDTH{1'b0}} };
            SF_7_s <= { {WIDTH{1'b0}} };
            SF_8_s <= { {WIDTH{1'b0}} };
        end
        else if( en_sr_i == 1'b1 ) begin
            SF_0_s <= mux_input_out_s;
            SF_1_s <= SF_0_s;
            SF_2_s <= SF_1_s;
            SF_3_s <= SF_2_s;
            SF_4_s <= SF_3_s;
            SF_5_s <= SF_4_s;
            SF_6_s <= SF_5_s;
            SF_7_s <= SF_6_s;
            SF_8_s <= SF_7_s;
        end
    end

    // REGISTER BIGGER 
    always @( posedge clk, posedge rst) begin
        if( rst == 1'b1 )
            SF_9_s <= { {WIDTH{1'b0}} };
        else if( wr_bigger_i == 1'b1 )
            SF_9_s <= SF_8_s;
    end

    // REGISTER LAST
    always @( posedge clk, posedge rst) begin
        if( rst == 1'b1 )
            Last_s <= { {WIDTH{1'b0}} };
        else if( wr_last_i == 1'b1 )
            Last_s <= mux_bigger_out_s;
    end

    // REGISTER FIRST
    always @( posedge clk, posedge rst) begin
        if( rst == 1'b1 )
            First_s <= { {WIDTH{1'b0}} };
        else if( wr_first_s == 1'b1 )
            First_s <= SF_9_s;
    end

    // COUNTER ENABLE
    assign wr_first_s = (Counter_s==4'b0000) ? 1'b1 : 1'b0;


    // COMPARATOR EH MAIOR
    Comparator #(
        .WIDTH(32)
    ) COMP_eh_maior (
        .A_i                ( SF_9_s     ),
        .B_i                ( SF_8_s     ),
        .A_less_than_B_o    ( eh_maior_o ),
        .A_greater_than_B_o (  ),
        .A_equal_B_o        (  )
    );

    // COMPARATOR END COMPARATION
    Comparator #(
        .WIDTH(32)
    ) COMP_end_comp (
        .A_i                ( SF_8_s     ),
        .B_i                ( Last_s     ),
        .A_less_than_B_o    (  ),
        .A_greater_than_B_o (  ),
        .A_equal_B_o        ( end_comp_o )
    );

    // COMPARATOR END SHIFT
    Comparator #(
        .WIDTH(32)
    ) COMP_end_sft (
        .A_i                ( SF_9_s    ),
        .B_i                ( First_s   ),
        .A_less_than_B_o    (  ),
        .A_greater_than_B_o (  ),
        .A_equal_B_o        ( end_sft_o )
    );

    // COMPARATOR COUNTER
    assign end_count_o = (Counter_s==4'b1001) ? 1'b1 : 1'b0;

        // COUNTER RESET
    assign rst_counter_s = rst || rst_counter_i;

    // COUNTER
    always @( posedge clk ) begin
        if( rst_counter_s == 1'b1 )
            Counter_s <= { {WIDTH{1'b0}} };
        else if( wr_counter_i == 1'b1 )
            Counter_s <= Counter_s + 4'b0001;
    end


    // FLIP FLOP DATA VALID AND READY
    always@(posedge clk, posedge rst)begin
        if(rst == 1'b1) begin
            data_valid_o <= 1'b0;
            ready_o <= 1'b0;
        end
        else begin
            data_valid_o <= data_valid_i;
            ready_o <= ready_i;
        end
    end

    assign data_serial_o = SF_9_s;

endmodule