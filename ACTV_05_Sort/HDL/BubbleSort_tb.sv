

module BubbleSort_tb;

parameter CLOCK_PERIOD = 10;

logic clk, rst, ready;
logic signed [31:0] data_serial_i, data_serial_o;

BubbleSort DUV (
    .clk(clk),
    .rst(rst),
    .data_serial_i(data_serial_i),
    .data_serial_o(data_serial_o),
    .ready_o(ready)
);

always #(CLOCK_PERIOD/2) clk <= ~clk;

logic signed [31:0] entradas [0:9];
logic signed [31:0] saidas [0:9];

int cycles = 0;


always@(posedge clk)
    cycles <= cycles + 1;

initial begin


    entradas[0] = 32'h0000023A;   //  570
    entradas[1] = 32'hFFFFFEA5;   // -347
    entradas[2] = 32'h00000000;   //    0
    entradas[3] = 32'h0000017F;   //  383
    entradas[4] = 32'hFFFFFEA5;   // -347
    entradas[5] = 32'hFFFFFC8F;   // -881
    entradas[6] = 32'h000000CB;   //  203
    entradas[7] = 32'hFFFFFEE7;   // -281
    entradas[8] = 32'h0000031D;   //  797
    entradas[9] = 32'h00000159;   //  345

    // entradas[0] = 32'h0000023A;   //  570
    // entradas[1] = 32'h0000023A;   //  570
    // entradas[2] = 32'h0000023A;   //  570
    // entradas[3] = 32'h0000023A;   //  570
    // entradas[4] = 32'h0000023A;   //  570
    // entradas[5] = 32'h0000023A;   //  570
    // entradas[6] = 32'h0000023A;   //  570
    // entradas[7] = 32'h0000023A;   //  570
    // entradas[8] = 32'h0000023A;   //  570
    // entradas[9] = 32'h0000023A;   //  570


	$display("\n+----------------------+");
    $display(  "|     TEST STARTED     |");
    $display(  "+----------------------+");
    $display(  "| INTPUT VECTOR:                               ");
    $display(  "|");
    $display(  "| i=0 %h (%0d)", entradas[0], entradas[0]);
    $display(  "| i=1 %h (%0d)", entradas[1], entradas[1]);
    $display(  "| i=2 %h (%0d)", entradas[2], entradas[2]);
    $display(  "| i=3 %h (%0d)", entradas[3], entradas[3]);
    $display(  "| i=4 %h (%0d)", entradas[4], entradas[4]);
    $display(  "| i=5 %h (%0d)", entradas[5], entradas[5]);
    $display(  "| i=6 %h (%0d)", entradas[6], entradas[6]);
    $display(  "| i=7 %h (%0d)", entradas[7], entradas[7]);
    $display(  "| i=8 %h (%0d)", entradas[8], entradas[8]);
    $display(  "| i=9 %h (%0d)", entradas[9], entradas[9]);
    $display(  "+-----------------------");

    clk = 0; 
    rst = 0; 
    data_serial_i = entradas[0];

    #(CLOCK_PERIOD)

    rst=1; 
    
    #(CLOCK_PERIOD/2)

    rst=0;

    #(CLOCK_PERIOD/2)

    data_serial_i = entradas[1]; 

    #(CLOCK_PERIOD)

    data_serial_i = entradas[2]; 

    #(CLOCK_PERIOD)

    data_serial_i = entradas[3]; 

    #(CLOCK_PERIOD)

    data_serial_i = entradas[4]; 

    #(CLOCK_PERIOD)

    data_serial_i = entradas[5]; 

    #(CLOCK_PERIOD)

    data_serial_i = entradas[6]; 

    #(CLOCK_PERIOD)

    data_serial_i = entradas[7]; 

    #(CLOCK_PERIOD)

    data_serial_i = entradas[8]; 

    #(CLOCK_PERIOD)

    data_serial_i = entradas[9]; 




    #(85*CLOCK_PERIOD)

    saidas[0] = data_serial_o;

    #(CLOCK_PERIOD)

    saidas[1] = data_serial_o;

    #(CLOCK_PERIOD)

    saidas[2] = data_serial_o;

    #(CLOCK_PERIOD)

    saidas[3] = data_serial_o;

    #(CLOCK_PERIOD)

    saidas[4] = data_serial_o;

    #(CLOCK_PERIOD)

    saidas[5] = data_serial_o;

    #(CLOCK_PERIOD)

    saidas[6] = data_serial_o;

    #(CLOCK_PERIOD)

    saidas[7] = data_serial_o;

    #(CLOCK_PERIOD)

    saidas[8] = data_serial_o;

    #(CLOCK_PERIOD)

    saidas[9] = data_serial_o;


    $display(  "| OUTPUT VECTOR:");
    $display(  "| CYCLES: %0d", cycles-1);
    $display(  "|");
    $display(  "| i=0 %h (%0d)", saidas[0], saidas[0]);
    $display(  "| i=1 %h (%0d)", saidas[1], saidas[1]);
    $display(  "| i=2 %h (%0d)", saidas[2], saidas[2]);
    $display(  "| i=3 %h (%0d)", saidas[3], saidas[3]);
    $display(  "| i=4 %h (%0d)", saidas[4], saidas[4]);
    $display(  "| i=5 %h (%0d)", saidas[5], saidas[5]);
    $display(  "| i=6 %h (%0d)", saidas[6], saidas[6]);
    $display(  "| i=7 %h (%0d)", saidas[7], saidas[7]);
    $display(  "| i=8 %h (%0d)", saidas[8], saidas[8]);
    $display(  "| i=9 %h (%0d)", saidas[9], saidas[9]);
    $display(  "+----------------------+");
    $display(  "|     TEST FINISHED    |");
    $display(  "+----------------------+\n\n");
    $finish;
    
end
endmodule