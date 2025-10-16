module DataPath #(
    parameter WIDTH = 32
)(
    input  wire clk,
    input  wire rst,
    input  signed [WIDTH-1:0] data_serial_i,
    input  wire wr_bigger_i,
    input  wire mux_control_i,
    input  wire boot_i,
    input  wire mux_A_i,
    
    output signed [WIDTH-1:0] data_serial_o,
    output wire end_o,
    output wire is_nine_o,
    output wire is_bigger_o
);

    wire signed [WIDTH-1:0] mux_input_out_s;
    wire signed [WIDTH-1:0] mux_bigger_out_s;
    wire mux_control_sf_s;

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

    reg C_SF_0_s;
    reg C_SF_1_s;
    reg C_SF_2_s;
    reg C_SF_3_s;
    reg C_SF_4_s;
    reg C_SF_5_s;
    reg C_SF_6_s;
    reg C_SF_7_s;
    reg C_SF_8_s;
    reg C_SF_9_s;



    

    // INPUT MUX
    assign mux_input_out_s = ( boot_i == 1'b1 ) ? data_serial_i : mux_bigger_out_s;

    // BIGGER MUX
    assign mux_bigger_out_s = ( wr_bigger_i == 1'b0 ) ? SF_8_s : SF_9_s;

    // CONTROL SHIFT ENABLE MUX
    assign mux_control_sf_s = ( mux_control_i == 1'b0 ) ? mux_A_i : C_SF_9_s;

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
        else begin
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

    // SHIFT REGISTER CONTROL
    always @( posedge clk, posedge rst ) begin
        if( rst == 1'b1 ) begin
            C_SF_0_s <= 1'b0;
            C_SF_1_s <= 1'b0;
            C_SF_2_s <= 1'b0;
            C_SF_3_s <= 1'b0;
            C_SF_4_s <= 1'b0;
            C_SF_5_s <= 1'b0;
            C_SF_6_s <= 1'b0;
            C_SF_7_s <= 1'b0;
            C_SF_8_s <= 1'b0;
            C_SF_9_s <= 1'b0;
        end
        else begin
            C_SF_0_s <= mux_control_sf_s;
            C_SF_1_s <= C_SF_0_s;
            C_SF_2_s <= C_SF_1_s;
            C_SF_3_s <= C_SF_2_s;
            C_SF_4_s <= C_SF_3_s;
            C_SF_5_s <= C_SF_4_s;
            C_SF_6_s <= C_SF_5_s;
            C_SF_7_s <= C_SF_6_s;
            C_SF_8_s <= C_SF_7_s;
            C_SF_9_s <= C_SF_8_s;
        end
    end

   
    // COMPARATOR IS_BIGGER
    Comparator #(
        .WIDTH(32)
    ) COMP_eh_maior (
        .A_i                ( SF_9_s      ),
        .B_i                ( SF_8_s      ),
        .A_less_than_B_o    ( is_bigger_o ),
        .A_greater_than_B_o (  ),
        .A_equal_B_o        (  )
    );

    assign end_o = C_SF_0_s && C_SF_1_s && C_SF_2_s && C_SF_3_s && C_SF_4_s && C_SF_5_s && C_SF_6_s && C_SF_7_s && C_SF_8_s && C_SF_9_s;
    assign is_nine_o = C_SF_8_s;
    assign data_serial_o = SF_3_s;



endmodule