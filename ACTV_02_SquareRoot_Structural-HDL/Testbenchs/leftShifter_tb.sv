module shifter_tb;

reg  [16:0] in_i;
wire [16:0] out_o;

leftShifter #(
	.SHIFT(2)
) DUV (
	.in_i(in_i),
	.out_o(out_o)
);
    
initial begin

	in_i = 17'b00000000000000001;
	#1

	$display("\n+---------------------+---------------------+");
	$display(  "|        INPUT        |        OUTPUT       |");
	$display(  "+---------------------+---------------------+");
	$display(  "|  %b  |  %b  |", in_i, out_o);
	$display(  "+---------------------+---------------------+");
	$finish;

end

endmodule