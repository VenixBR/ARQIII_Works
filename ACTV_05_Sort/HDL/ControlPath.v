module ControlPath (
    input wire clk,
    input wire rst,

    input wire is_bigger_i,
    input wire end_i,
    input wire is_nine_i,

    output reg wr_bigger_o,
    output reg mux_control_o,
    output reg boot_o,
    output reg mux_A_o,
    output reg clk_en_o,
    output reg ready_o
);

localparam S0 = 3'b000;
localparam S1 = 3'b001;
localparam S2 = 3'b011; 
localparam S3 = 3'b010; 
localparam S4 = 3'b110; 
localparam S5 = 3'b111;

reg [2:0] CurrentState;
reg [2:0] NextState;

// NEXT STATE LOGIC
always@* begin
    case(CurrentState)
        S0 : NextState = S1;
        S1 : NextState = ( is_nine_i==1'b1 ) ? S2 : S1;
        S2 : NextState = ( is_nine_i==1'b1 ) ? S3 : S2;
        S3 : begin
                if( end_i==1'b1 )
                    NextState = S4;
                else if( is_nine_i == 1'b0 )
                    NextState = S2;
                else
                    NextState = S3;
            end
        S4 : NextState = ( is_nine_i==1'b1 ) ? S4 : S5;
        S5 : NextState = S5;
        default : NextState = 3'bx;
    endcase
end

// MEMORY LOGIC
always@( posedge clk, posedge rst) begin
    if(rst == 1'b1)
        CurrentState <= S0;
    else
        CurrentState <= NextState;
end

// OUTPUTS LOGIC
always@* begin
    case(CurrentState)
        S0 : begin
                wr_bigger_o   = 1'b1;
                mux_control_o = 1'b0;
                boot_o        = 1'b1;
                mux_A_o       = 1'b1;
                clk_en_o      = 1'b1;
                ready_o       = 1'b0;
            end
        S1 : begin
                wr_bigger_o   = 1'b1;
                mux_control_o = 1'b1;
                boot_o        = 1'b1;
                mux_A_o       = 1'bx;
                clk_en_o      = 1'b1;
                ready_o       = 1'b0;
            end
        S2 : begin
                wr_bigger_o   = ( is_nine_i==1'b0 && is_bigger_i==1'b0) ? 1'b0 : 1'b1;
                mux_control_o = ( is_nine_i==1'b0 ) ? 1'b1 : 1'b0;
                boot_o        = 1'b0;
                mux_A_o       = 1'b1;
                clk_en_o      = 1'b1;
                ready_o       = 1'b0;
            end
        S3 : begin
                wr_bigger_o   = ( is_nine_i==1'b0 && is_bigger_i==1'b0 && end_i==1'b0) ? 1'b0 : 1'b1;
                mux_control_o = 1'b1;
                boot_o        = 1'b0;
                mux_A_o       = 1'bx;
                clk_en_o      = 1'b1;
                ready_o       = 1'b0;
            end
        S4 : begin
                wr_bigger_o   = 1'b1;
                mux_control_o = 1'b0;
                boot_o        = 1'b0;
                mux_A_o       = 1'b0;
                clk_en_o      = 1'b1;
                ready_o       = 1'b1;
            end
        S5 : begin
                wr_bigger_o   = 1'bx;
                mux_control_o = 1'bx;
                boot_o        = 1'bx;
                mux_A_o       = 1'bx;
                clk_en_o      = 1'b0;
                ready_o       = 1'bx;
            end
        default : begin
                wr_bigger_o   = 1'bx;
                mux_control_o = 1'bx;
                boot_o        = 1'bx;
                mux_A_o       = 1'bx;
                clk_en_o      = 1'bx;
                ready_o       = 1'bx;
            end
        
    endcase 
end

endmodule