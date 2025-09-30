module DataPath (
    parameter WIDTH = 32
)(
    input  wire clk,
    input  wire rst,
    input  signed wire [WIDTH-1:0] data_serial_i,
    input  wire wr_bigger_i,
    input  wire wr_last_i,
    input  wire wr_counter_i,
    input  wire mux_in_i,
    input  wire rst_counter_i,
    input  wire en_sr_i,

    output signed wire [WIDTH-1:0] data_serial_o,
    output wire eh_maior_o,
    output wire end_comp_o,
    output wire end_sft_o,
    output wire end_count_o
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



endmodule