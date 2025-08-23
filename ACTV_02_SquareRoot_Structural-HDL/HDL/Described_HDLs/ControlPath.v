module ControlPath (

    input  wire clk,
    input  wire rst,

    // Flags
    input  wire [1:0] N_i,

    // Control signals
    output reg boot_o,
    output reg muxes_o,
    output reg ready_o,
    output reg wr_root_o,
    output reg wr_square_o,
    output reg root_o
);

    // States codification
    localparam S0 = 2'b00;
    localparam S1 = 2'b01;
    localparam S2 = 2'b11;



    // Internal signals
    reg  [1:0] CurrentState;
    reg  [1:0] NextState;

    // Next state logic
    always@* begin
        case( CurrentState )
            S0 : NextState = S1;
            S1 : NextState = (N_i==2'b00) ? S2 : S1; // Ternary operator, <VAR> = <TEST> ? <VALUE IF TRUE> : <VALUE IF FALSE> ;
            S2 : NextState = S1;
            default : NextState = S0;
        endcase
    end

    // State memory logic
    always@( posedge clk , posedge rst) begin
        if( rst == 1) begin
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
                    boot_o      = 1'b1;
                    muxes_o     = 1'bx;
                    ready_o     = 1'b1;
                    wr_root_o   = 1'b1;
                    wr_square_o = 1'b1;
                    root_o      = 1'bx;
                end
            S1 : begin
                    boot_o      = 1'b0;
                    muxes_o     = 1'b1;
                    wr_square_o = 1'b0;
                    case( N_i )
                        2'b00 : begin
                                    ready_o   = 1'b1;
                                    wr_root_o = 1'b1;
                                    root_o    = 1'bx;
                                end
                        2'b01 : begin
                                    ready_o   = 1'b0;
                                    wr_root_o = 1'b0;
                                    root_o    = 1'b0;
                                end
                        2'b10 : begin
                                    ready_o   = 1'b0;
                                    wr_root_o = 1'b0;
                                    root_o    = 1'b1;
                                end
                        2'b11 : begin
                                    ready_o   = 1'b0;
                                    wr_root_o = 1'b0;
                                    root_o    = 1'b0;
                                end
                    endcase
                end
            S2 : begin
                    boot_o      = 1'b0;
                    muxes_o     = 1'b0;
                    ready_o     = 1'b1;
                    wr_root_o   = 1'b0;
                    wr_square_o = 1'b1;
                    root_o      = 1'bx;
                end
            default : begin
                    boot_o      = 1'b0;
                    muxes_o     = 1'bx;
                    ready_o     = 1'b1;
                    wr_root_o   = 1'b0;
                    wr_square_o = 1'b0;
                    root_o      = 1'bx;
                end
        endcase
    end
endmodule 