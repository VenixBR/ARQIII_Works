

module ControlPath (

    input  wire clk,
    input  wire rst_n,

    // Flags
    input  wire N_i,

    // Control signals
    output reg en_pipe_o,
    output reg ready_o,
    output reg mux_root_o,
    output reg wr_input_o,
    output reg wr_square_o
);

    // States codification
    localparam S0 = 3'b00;
    localparam S1 = 3'b01;
    localparam S2 = 3'b11;
    localparam S3 = 3'b10;



    // Internal signals
    reg  [1:0] CurrentState;
    reg  [1:0] NextState;

    // Next state logic
    always@* begin
        case( CurrentState )
            S0 : NextState = S1;
            S1 : NextState = (N_i==1'b0) ? S1 : S2; // Ternary operator, <VAR> = <TEST> ? <VALUE IF TRUE> : <VALUE IF FALSE> ;
            S2 : NextState = S3;
            S3 : NextState = S3;
        endcase
    end

    // State memory logic
    always@( posedge clk , negedge rst_n) begin
        if( rst_n == 1'b0) begin
            CurrentState <= S0;
        end
        else begin
            CurrentState <= NextState;
        end
    end

    // Outputs logic
    always@* begin
        case( CurrentState )
            S0 : begin
                    wr_input_o    = 1'b1;
                    wr_square_o   = 1'b0;
                    en_pipe_o     = 1'b0;
                    ready_o       = 1'bx;
                    mux_root_o    = 1'bx;
                end
            S1 : begin
                    wr_input_o    = 1'b0;
                    wr_square_o   = 1'b1;
                    en_pipe_o     = 1'b1;
                    ready_o       = 1'b1;
                    mux_root_o    = 1'b0;
                end
            S2 : begin
                    wr_input_o    = 1'b0;
                    wr_square_o   = 1'bx;
                    en_pipe_o     = 1'b1;
                    ready_o       = 1'b0;
                    mux_root_o    = 1'b1;
                end
            S3 : begin
                    wr_input_o    = 1'b0;
                    wr_square_o   = 1'bx;
                    en_pipe_o     = 1'b0;
                    ready_o       = 1'bx;
                    mux_root_o    = 1'bx;
                end
        endcase
    end
endmodule 