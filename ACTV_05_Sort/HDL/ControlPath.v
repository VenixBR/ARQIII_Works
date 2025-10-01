module ControlPath (
    input wire clk,
    input wire rst,

    input wire eh_maior_i,
    input wire end_comp_i,
    input wire end_sft_i,
    input wire end_count_i,

    output reg wr_bigger_o,
    output reg wr_last_o,
    output reg wr_counter_o,
    output reg mux_in_o,
    output reg rst_cntr_o,
    output reg en_sr_o,
    output reg data_valid_o,
    output reg ready_o
);

localparam S0 = 3'b000;
localparam S1 = 3'b001;
localparam S2 = 3'b011;
localparam S3 = 3'b111;
localparam S4 = 3'b010;
localparam S5 = 3'b110;
localparam S6 = 3'b100;

reg [2:0] CurrentState;
reg [2:0] NextState;

// NEXT STATE LOGIC
always@* begin
    case(CurrentState)
        S0 : NextState = (end_count_i==1'b1) ? S1 : S0;
        S1 : NextState = S2;
        S2 : NextState = (end_comp_i==1'b1 && end_sft_i==1'b0)  ? S3 : S2;

        S3 : begin
                if(end_sft_i==1'b1 && end_count_i==1'b1)
                    NextState = S4;
                else if(end_sft_i == 1'b1)
                    NextState = S2;
                else
                    NextState = S3;
            end
        S4 : NextState = S5;
        S5 : NextState = (end_count_i == 1'b1) ? S6 : S5;
        S6 : NextState = S6;
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
                wr_bigger_o  = 1'b1;
                wr_last_o    = 1'b0;
                wr_counter_o = 1'b1;
                mux_in_o     = 1'b0;
                rst_cntr_o   = 1'b0;
                en_sr_o      = 1'b1;
                data_valid_o = 1'b0;
                ready_o      = 1'b0;
            end
        S1 : begin
                wr_bigger_o  = (eh_maior_i==1'b1) ? 1'b1 : 1'b0;
                wr_last_o    = 1'b1;
                wr_counter_o = 1'b0;
                mux_in_o     = 1'b1;
                rst_cntr_o   = 1'b1;
                en_sr_o      = 1'b1;
                data_valid_o = 1'b0;
                ready_o      = 1'b0;
            end
        S2 : begin
                wr_bigger_o  = (eh_maior_i==1'b1 || end_comp_i==1'b1) ? 1'b1 : 1'b0;
                wr_last_o    = (end_comp_i==1'b1) ? 1'b1 : 1'b0;
                wr_counter_o = (end_comp_i==1'b1) ? 1'b1 : 1'b0;
                mux_in_o     = 1'b1;
                rst_cntr_o   = 1'b0;
                en_sr_o      = 1'b1;
                data_valid_o = 1'b0;
                ready_o      = 1'b0;
            end
        S3 : begin
                wr_bigger_o  = 1'b1;
                wr_last_o    = 1'b0;
                wr_counter_o = 1'b0;
                mux_in_o     = 1'b1;
                rst_cntr_o   = 1'b0;
                en_sr_o      = 1'b1;
                data_valid_o = 1'b0;
                ready_o      = 1'b0;
            end
        S4 : begin
                wr_bigger_o  = 1'b0;
                wr_last_o    = 1'bx;
                wr_counter_o = 1'b0;
                mux_in_o     = 1'b1;
                rst_cntr_o   = 1'b1;
                en_sr_o      = 1'b0;
                data_valid_o = 1'b1;
                ready_o      = 1'b0;
            end
        S5 : begin
                wr_bigger_o  = 1'b1;
                wr_last_o    = 1'bx;
                wr_counter_o = 1'b1;
                mux_in_o     = 1'bx;
                rst_cntr_o   = 1'b0;
                en_sr_o      = 1'b1;
                data_valid_o = 1'b1;
                ready_o      = (end_count_i==1'b1) ? 1'b1 : 1'b0;
            end
        S6 : begin
                wr_bigger_o  = 1'b0;
                wr_last_o    = 1'b0;
                wr_counter_o = 1'b0;
                mux_in_o     = 1'bx;
                rst_cntr_o   = 1'b0;
                en_sr_o      = 1'b0;
                data_valid_o = 1'bx;
                ready_o      = 1'b0;
            end
        default : begin
                wr_bigger_o  = 1'bx;
                wr_last_o    = 1'bx;
                wr_counter_o = 1'bx;
                mux_in_o     = 1'bx;
                rst_cntr_o   = 1'bx;
                en_sr_o      = 1'bx;
                data_valid_o = 1'bx;
                ready_o      = 1'bx;
            end
        
    endcase 
end

endmodule