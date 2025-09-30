module BubbleSort #(
    parameter WIDTH = 32
)(
    input  wire clk,
    input  wire rst,
    input  signed wire [WIDTH-1:0] data_serial_i,

    output signed wire [WIDTH-1:0] data_serial_o,
    output wire ready_o,
    output wire serial_o
);

endmodule