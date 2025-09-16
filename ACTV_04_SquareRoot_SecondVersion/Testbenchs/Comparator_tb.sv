module comparator_tb;

reg  [16:0] A_i;
reg  [16:0] B_i;
wire A_less_than_B;

Comparator DUV (
	.A_i(A_i),
	.B_i(B_i),
	.A_less_than_B_o(A_less_than_B)
);
    
initial begin

	A_i = 17'b11111111111111111;
	B_i = 17'b11111111111111110;
	#1

	$display("\n+----------------------+---------------------+");
	$display(  "|        INPUTS        |        OUTPUT       |");
	$display(  "+----------------------+---------------------+");
	$display(  "|  A=%d   B=%d |  A_less_than_B=%b    |", A_i, B_i, A_less_than_B);
	$display(  "+----------------------+---------------------+");
	$finish;

end

endmodule