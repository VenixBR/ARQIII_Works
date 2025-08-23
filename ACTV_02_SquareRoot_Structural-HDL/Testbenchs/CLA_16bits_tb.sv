module CLA_16bits_tb;

reg  [16:0] A_i, B_i;
reg Ci_i;
wire [16:0] S_o;
wire Co_o;

string adder;

`ifdef CLAFULL
initial adder = "Carry Look Ahead 16 bits";
CLA DUV (
	.A_i(A_i),
    .B_i(B_i),
    .Ci_i(Ci_i),
    .Co_o(Co_o),
	.S_o(S_o)
);
`endif 

`ifdef CLA4x4
initial adder = "4 x Carry Look Ahead 4 bits";
CLA4x4 DUV (
	.A_i(A_i),
    .B_i(B_i),
    .Ci_i(Ci_i),
    .Co_o(Co_o),
	.S_o(S_o)
);
`endif

`ifdef CLA2x8
initial adder = "2 x Carry Look Ahead 8 bits";
CLA2x8 DUV (
	.A_i(A_i),
    .B_i(B_i),
    .Ci_i(Ci_i),
    .Co_o(Co_o),
	.S_o(S_o)
);
`endif
    

task test_result (
        input logic [16:0] S_exp,
        input logic Co_exp
    ); begin

		$display(  "| A_i=%h  B_i=%h  Ci_i=%b | S_o=%h Co_o=%b | %0d",
                    	 A_i, B_i, Ci_i, S_o, Co_o, $time);

            if(S_o !== S_exp)
                print_error($sformatf("%s should be %h at time %0d", "S_o", S_exp, $time ));
            else if(Co_o !== Co_exp)
                print_error($sformatf("%s should be %b at time %0d", "Co_o", Co_exp, $time ));
        end
    endtask

    task print_error (input string message); begin
			
            $display(  "+----------------------------+-----------------+------------+");
            $display(  "|                           TEST FAILED!! ");
            $display(  "|  %s", message);
            $display(  "+------------------------------------------------------------\n\n");
            $finish;
        end
    endtask

/*
	logic clk;
	logic [32:0] inputs;
	logic [16:0] outputs; 

	always #1 clk <= ~clk;
	always@ (posedge clk) begin
		if(inputs == '1) begin
			$display("TEST PASSED");
			$finish;
		end
		A_i  = inputs[15:0];
		B_i  = inputs[31:16];
		Ci_i = inputs[32];
		outputs = A_i + B_i + Ci_i;
		#1 test_result(outputs[15:0], outputs[16]);
		inputs = inputs + 307;
	end
initial begin
clk = 0;
	inputs = '0;
	outputs = '0; 
end
*/
initial begin
	$display("\n+-----------------------------------------------------------+");
	$display(  "| ADDER: %s", adder);
	$display(  "+----------------------------+-----------------+------------+");
    $display(  "|            INPUTS          |      OUTPUTS    |  TIME      |");
    $display(  "+----------------------------+-----------------+------------+");
	

	//00 + 00 + 0
	A_i=17'h00000; B_i=17'h00000; Ci_i=0;
	#5 test_result(17'h00000, 0); #5            //5ns

	//01 + 02 + 0
	A_i=17'h00001; B_i=17'h00002; Ci_i=0; 
	#5 test_result(17'h00003, 0); #5           //15ns

	//01 + 02 + 1
	A_i=17'h00001; B_i=17'h00002; Ci_i=1;
	#5 test_result(17'h00004, 0); #5            //25ns

	//52 + 32 + 0
	A_i=17'h00052; B_i=17'h00032; Ci_i=0;    
	#5 test_result(17'h00084, 0); #5            //35ns

	//C4 + D5 + 0
	A_i=17'h000C4; B_i=17'h000D5; Ci_i=0;  
	#5 test_result(17'h00199, 0); #5            //45ns

	//B2 + 35 + 1
	A_i=17'h000B2; B_i=17'h00035; Ci_i=1;  
	#5 test_result(17'h000E8, 0); #5            //55ns

	//85 + 37 + 1
	A_i=17'h00085; B_i=17'h00037; Ci_i=1;   
	#5 test_result(17'h000BD, 0); #5            //65ns

	//FF + FF + 0
	A_i=17'h000FF; B_i=17'h000FF; Ci_i=0;
	#5 test_result(17'h001FE, 0); #5            //75ns

	//99 + D3 + 0
	A_i=17'h00099; B_i=17'h000D3; Ci_i=0;
	#5 test_result(17'h0016C, 0); #5            //85ns

	//A6 + A7 + 1
	A_i=17'h000A6; B_i=17'h000A7; Ci_i=1;
	#5 test_result(17'h0014E, 0); #5            //95ns

	//FF + FF + 1
	A_i=17'h000FF; B_i=17'h000FF; Ci_i=1;
	#5 test_result(17'h001FF, 0); #5            //105ns

	//C1 + 43 + 0
	A_i=17'h000C1; B_i=17'h00043; Ci_i=0;
	#5 test_result(17'h00104, 0); #5            //115ns

	//85 + 36 + 0
	A_i=17'h00085; B_i=17'h00036; Ci_i=0;
	#5 test_result(17'h000BB, 0); #5            //125ns

	//25 + B9 + 0
	A_i=17'h00025; B_i=17'h000B9; Ci_i=0;
	#5 test_result(17'h000DE, 0); #5            //135ns

	//FF + 01 + 0
	A_i=17'h000FF; B_i=17'h00001; Ci_i=0;
	#5 test_result(17'h00100, 0); #5            //145ns

	//EF + FE + 1
	A_i=17'h000EF; B_i=17'h000FE; Ci_i=1; 
	#5 test_result(17'h001EE, 0); #5            //155ns

	//AA + AA + 0
	A_i=17'h000AA; B_i=17'h000AA; Ci_i=0;
	#5 test_result(17'h00154, 0); #5            //165ns

	//BBBB + BBBB + 1
	A_i=17'h0BBBB; B_i=17'h0BBBB; Ci_i=1;
	#5 test_result(17'h17777, 0); #5            //175ns

	//08 + 96 + 0
	A_i=17'h00008; B_i=17'h00096; Ci_i=0;
	#5 test_result(17'h0009E, 0); #5            //185ns

	//45 + B7 + 0
	A_i=17'h00045; B_i=17'h000B7; Ci_i=0; 
	#5 test_result(17'h000FC, 0); #5            //195ns

	//FC + 25 + 1
	A_i=17'h000FC; B_i=17'h00025; Ci_i=1; 
	#5 test_result(17'h00122, 0); #5            //205ns

	//C1 + D2 + 1
	A_i=17'h000C1; B_i=17'h000D2; Ci_i=1; 
	#5 test_result(17'h00194, 0); #5            //215ns

	//62 + AA + 0
	A_i=17'h00062; B_i=17'h000AA; Ci_i=0; 
	#5 test_result(17'h0010C, 0); #5            //225ns

	//DA + C1 + 0
	A_i=17'h000DA; B_i=17'h000C1; Ci_i=0;
	#5 test_result(17'h0019B, 0); #5            //235ns

	//94 + CA + 0
	A_i=17'h00094; B_i=17'h000CA; Ci_i=0; 
	#5 test_result(17'h0015E, 0); #5            //245ns

	//895E + 7925 + 1
	A_i=17'h0895E; B_i=17'h07925; Ci_i=1;
	#5 test_result(17'h10284, 0); #5            //255ns

	//84 + 4F + 1
	A_i=17'h00084; B_i=17'h0004F; Ci_i=1; 
	#5 test_result(17'h000D4, 0); #5            //265ns

	//D4 + 63 + 0
	A_i=17'h000D4; B_i=17'h00063; Ci_i=0;
	#5 test_result(17'h00137, 0); #5            //275ns

	//37 + 9B + 0
	A_i=17'h00037; B_i=17'h0009B; Ci_i=0;
	#5 test_result(17'h000D2, 0); #5            //285ns

	//D2 + 11 + 0
	A_i=17'h000D2; B_i=17'h00011; Ci_i=0;
	#5 test_result(17'h000E3, 0); #5            //295ns

	//E3 + 81 + 0
	A_i=17'h000E3; B_i=17'h00081; Ci_i=0;
	#5 test_result(17'h00164, 0); #5            //305ns

	//E474 + 2857 + 0
	A_i=17'h0E474; B_i=17'h02857; Ci_i=0;
	#5 test_result(17'h10CCB, 0); #5            //315ns

	//D529 + A82E + 1
	A_i=17'h0D529; B_i=17'h0A82E; Ci_i=1;
	#5 test_result(17'h17D58, 0); #5            //325ns

	//99A7 + 8FF2 + 0
	A_i=17'h099A7; B_i=17'h08FF2; Ci_i=0;
	#5 test_result(17'h12999, 0); #5            //335ns

	//0FFF + 987E + 0
	A_i=17'h08F2B; B_i=17'h07EA2; Ci_i=1;
	#5 test_result(17'h10DCE, 0); #5            //345ns

	//0FFF + 987E + 0
	A_i=17'h00FFF; B_i=17'h0987E; Ci_i=0;
	#5 test_result(17'h0A87D, 0); #5            //355ns

	//3FFC + 0000+ 0
	A_i=17'h03FFc; B_i=17'h00000; Ci_i=0;
	#5 test_result(17'h03FFC, 0); #5            //365ns

		//1234 + 4321 + 0
	A_i=17'h01234; B_i=17'h04321; Ci_i=0;
	#5 test_result(17'h05555, 0); #5            //375ns

	//7FFF + 0001 + 0
	A_i=17'h07FFF; B_i=17'h00001; Ci_i=0;
	#5 test_result(17'h08000, 0); #5            //385ns

	//7FFF + 0001 + 1
	A_i=17'h07FFF; B_i=17'h00001; Ci_i=1;
	#5 test_result(17'h08001, 0); #5            //395ns

	//8000 + 8000 + 0
	A_i=17'h08000; B_i=17'h08000; Ci_i=0;
	#5 test_result(17'h10000, 0); #5            //405ns

	//AAAA + 5555 + 0
	A_i=17'h0AAAA; B_i=17'h05555; Ci_i=0;
	#5 test_result(17'h0FFFF, 0); #5            //415ns

	//AAAA + 5555 + 1
	A_i=17'h0AAAA; B_i=17'h05555; Ci_i=1;
	#5 test_result(17'h10000, 0); #5            //425ns

	//FFFF + 0001 + 0
	A_i=17'h0FFFF; B_i=17'h00001; Ci_i=0;
	#5 test_result(17'h10000, 0); #5            //435ns

	//1234 + EDCC + 1
	A_i=17'h01234; B_i=17'h0EDCC; Ci_i=1;
	#5 test_result(17'h10001, 0); #5            //445ns

	//BEEF + 1111 + 0
	A_i=17'h0BEEF; B_i=17'h01111; Ci_i=0;
	#5 test_result(17'h0D000, 0); #5            //455ns

	//FACE + 1234 + 1
	A_i=17'h0FACE; B_i=17'h01234; Ci_i=1;
	#5 test_result(17'h10D03, 0); #5            //465ns

		//0F0F + F0F0 + 0
	A_i=17'h00F0F; B_i=17'h0F0F0; Ci_i=0;
	#5 test_result(17'h0FFFF, 0); #5            //475ns

	//0F0F + F0F0 + 1
	A_i=17'h00F0F; B_i=17'h0F0F0; Ci_i=1;
	#5 test_result(17'h10000, 0); #5            //485ns

	//DEAD + BEEF + 0
	A_i=17'h0DEAD; B_i=17'h0BEEF; Ci_i=0;
	#5 test_result(17'h19D9C, 0); #5            //495ns

	//CAFE + BABE + 1
	A_i=17'h0CAFE; B_i=17'h0BABE; Ci_i=1;
	#5 test_result(17'h185BD, 0); #5            //505ns

	//1111 + 2222 + 0
	A_i=17'h01111; B_i=17'h02222; Ci_i=0;
	#5 test_result(17'h03333, 0); #5            //515ns

	//1357 + 2468 + 1
	A_i=17'h01357; B_i=17'h02468; Ci_i=1;
	#5 test_result(17'h037C0, 0); #5            //525ns

	//8000 + 7FFF + 0
	A_i=17'h08000; B_i=17'h07FFF; Ci_i=0;
	#5 test_result(17'h0FFFF, 0); #5            //535ns

	//8000 + 7FFF + 1
	A_i=17'h08000; B_i=17'h07FFF; Ci_i=1;
	#5 test_result(17'h10000, 0); #5            //545ns

	//AAAA + AAAA + 0
	A_i=17'h0AAAA; B_i=17'h0AAAA; Ci_i=0;
	#5 test_result(17'h15554, 0); #5            //555ns

	//7ACE + 1357 + 1
	A_i=17'h07ACE; B_i=17'h01357; Ci_i=1;
	#5 test_result(17'h08E26, 0); #5            //565ns

	//FFFF + FFFF + 0
	A_i=17'h0FFFF; B_i=17'h0FFFF; Ci_i=0;
	#5 test_result(17'h1FFFE, 0); #5            //575ns

	//FFFF + FFFF + 1
	A_i=17'h0FFFF; B_i=17'h0FFFF; Ci_i=1;
	#5 test_result(17'h1FFFF, 0); #5            //585ns

	//1234 + 5678 + 0
	A_i=17'h01234; B_i=17'h05678; Ci_i=0;
	#5 test_result(17'h068AC, 0); #5            //595ns

		//9ABC + 1234 + 0
	A_i=17'h09ABC; B_i=17'h01234; Ci_i=0;
	#5 test_result(17'h0ACF0, 0); #5            //605ns

	//9ABC + 1234 + 1
	A_i=17'h09ABC; B_i=17'h01234; Ci_i=1;
	#5 test_result(17'h0ACF1, 0); #5            //615ns

	//8001 + 7FFF + 0
	A_i=17'h08001; B_i=17'h07FFF; Ci_i=0;
	#5 test_result(17'h10000, 0); #5            //625ns

	//2468 + 1357 + 0
	A_i=17'h02468; B_i=17'h01357; Ci_i=0;
	#5 test_result(17'h037BF, 0); #5            //635ns

	//2468 + 1357 + 1
	A_i=17'h02468; B_i=17'h01357; Ci_i=1;
	#5 test_result(17'h037C0, 0); #5            //645ns

	//FACE + CAFE + 0
	A_i=17'h0FACE; B_i=17'h0CAFE; Ci_i=0;
	#5 test_result(17'h1C5CC, 0); #5            //655ns

	//FACE + CAFE + 1
	A_i=17'h0FACE; B_i=17'h0CAFE; Ci_i=1;
	#5 test_result(17'h1C5CD, 0); #5            //665ns

	//0A0A + 0B0B + 0
	A_i=17'h00A0A; B_i=17'h00B0B; Ci_i=0;
	#5 test_result(17'h01515, 0); #5            //675ns

	//0A0A + 0B0B + 1
	A_i=17'h00A0A; B_i=17'h00B0B; Ci_i=1;
	#5 test_result(17'h01516, 0); #5            //685ns

	//ABCD + DCBA + 0
	A_i=17'h0ABCD; B_i=17'h0DCBA; Ci_i=0;
	#5 test_result(17'h18887, 0); #5            //695ns

	//1111 + FFFF + 1
	A_i=17'h01111; B_i=17'h0FFFF; Ci_i=1;
	#5 test_result(17'h11111, 0); #5            //705ns

	//7F7F + 8080 + 1
	A_i=17'h07F7F; B_i=17'h08080; Ci_i=1;
	#5 test_result(17'h10000, 0); #5            //715ns

	//55AA + AA55 + 0
	A_i=17'h055AA; B_i=17'h0AA55; Ci_i=0;
	#5 test_result(17'h0FFFF, 0); #5            //725ns

	//55AA + AA55 + 1
	A_i=17'h055AA; B_i=17'h0AA55; Ci_i=1;
	#5 test_result(17'h10000, 0); #5            //735ns

	//0123 + FEDC + 0
	A_i=17'h00123; B_i=17'h0FEDC; Ci_i=0;
	#5 test_result(17'h0FFFF, 0); #5            //745ns

	//0123 + FEDC + 1
	A_i=17'h00123; B_i=17'h0FEDC; Ci_i=1;
	#5 test_result(17'h10000, 0); #5            //755ns

	//AAAA + 1111 + 0
	A_i=17'h0AAAA; B_i=17'h01111; Ci_i=0;
	#5 test_result(17'h0BBBB, 0); #5            //765ns

	//AAAA + 1111 + 1
	A_i=17'h0AAAA; B_i=17'h01111; Ci_i=1;
	#5 test_result(17'h0BBBC, 0); #5            //775ns

	//FEDC + CDEF + 0
	A_i=17'h0FEDC; B_i=17'h0CDEF; Ci_i=0;
	#5 test_result(17'h1CCCB, 0); #5            //785ns

	//FEDC + CDEF + 1
	A_i=17'h0FEDC; B_i=17'h0CDEF; Ci_i=1;
	#5 test_result(17'h1CCCC, 0); #5            //795ns

	//ABCD + 1234 + 0
	A_i=17'h0ABCD; B_i=17'h01234; Ci_i=0;
	#5 test_result(17'h0BE01, 0); #5            //805ns

	//ABCD + 1234 + 1
	A_i=17'h0ABCD; B_i=17'h01234; Ci_i=1;
	#5 test_result(17'h0BE02, 0); #5            //815ns

	//F000 + 0FFF + 0
	A_i=17'h0F000; B_i=17'h00FFF; Ci_i=0;
	#5 test_result(17'h0FFFF, 0); #5            //825ns

	//F000 + 0FFF + 1
	A_i=17'h0F000; B_i=17'h00FFF; Ci_i=1;
	#5 test_result(17'h10000, 0); #5            //835ns

	//1234 + 1234 + 0
	A_i=17'h01234; B_i=17'h01234; Ci_i=0;
	#5 test_result(17'h02468, 0); #5            //845ns

	//1234 + 1234 + 1
	A_i=17'h01234; B_i=17'h01234; Ci_i=1;
	#5 test_result(17'h02469, 0); #5            //855ns

	//ABCD + EEEE + 0
	A_i=17'h0ABCD; B_i=17'h0EEEE; Ci_i=0;
	#5 test_result(17'h19ABB, 0); #5            //865ns

	//ABCD + EEEE + 1
	A_i=17'h0ABCD; B_i=17'h0EEEE; Ci_i=1;
	#5 test_result(17'h19ABC, 0); #5            //875ns

	//CAFE + FACE + 0
	A_i=17'h0CAFE; B_i=17'h0FACE; Ci_i=0;
	#5 test_result(17'h1C5CC, 0); #5            //885ns

	//CAFE + FACE + 1
	A_i=17'h0CAFE; B_i=17'h0FACE; Ci_i=1;
	#5 test_result(17'h1C5CD, 0); #5            //895ns

	//1111 + 8888 + 0
	A_i=17'h01111; B_i=17'h08888; Ci_i=0;
	#5 test_result(17'h09999, 0); #5            //905ns

	//1111 + 8888 + 1
	A_i=17'h01111; B_i=17'h08888; Ci_i=1;
	#5 test_result(17'h0999A, 0); #5            //915ns

	//5555 + 5555 + 0
	A_i=17'h05555; B_i=17'h05555; Ci_i=0;
	#5 test_result(17'h0AAAA, 0); #5            //925ns

	//5555 + 5555 + 1
	A_i=17'h05555; B_i=17'h05555; Ci_i=1;
	#5 test_result(17'h0AAAB, 0); #5            //935ns

	//1357 + 9ACE + 0
	A_i=17'h01357; B_i=17'h09ACE; Ci_i=0;
	#5 test_result(17'h0AE25, 0); #5            //945ns

	//1357 + 9ACE + 1
	A_i=17'h01357; B_i=17'h09ACE; Ci_i=1;
	#5 test_result(17'h0AE26, 0); #5            //955ns

	//DEAD + 1111 + 0
	A_i=17'h0DEAD; B_i=17'h01111; Ci_i=0;
	#5 test_result(17'h0EFBE, 0); #5            //965ns

	//DEAD + 1111 + 1
	A_i=17'h0DEAD; B_i=17'h01111; Ci_i=1;
	#5 test_result(17'h0EFBF, 0); #5            //975ns

	//C0DE + 1234 + 0
	A_i=17'h0C0DE; B_i=17'h01234; Ci_i=0;
	#5 test_result(17'h0D312, 0); #5            //985ns

	//C0DE + 1234 + 1
	A_i=17'h0C0DE; B_i=17'h01234; Ci_i=1;
	#5 test_result(17'h0D313, 0); #5            //995ns

	//C0DE + 1234 + 1
	A_i=17'h0C0DE; B_i=17'h01234; Ci_i=1;
	#5 test_result(17'h0D313, 0); #5    //1005ns

	//ABCD + 5678 + 0
	A_i=17'h0ABCD; B_i=17'h05678; Ci_i=0;
	#5 test_result(17'h10245, 0); #5    //1015ns

	//ABCD + 5678 + 1
	A_i=17'h0ABCD; B_i=17'h05678; Ci_i=1;
	#5 test_result(17'h10246, 0); #5    //1025ns

	//1357 + 2468 + 0
	A_i=17'h01357; B_i=17'h02468; Ci_i=0;
	#5 test_result(17'h037BF, 0); #5    //1035ns

	//1357 + 2468 + 1
	A_i=17'h01357; B_i=17'h02468; Ci_i=1;
	#5 test_result(17'h037C0, 0); #5    //1045ns

	//FACE + CAFE + 0
	A_i=17'h0FACE; B_i=17'h0CAFE; Ci_i=0;
	#5 test_result(17'h1C5CC, 0); #5    //1055ns

	//FACE + CAFE + 1
	A_i=17'h0FACE; B_i=17'h0CAFE; Ci_i=1;
	#5 test_result(17'h1C5CD, 0); #5    //1065ns

	//0A0A + 0B0B + 0
	A_i=17'h00A0A; B_i=17'h00B0B; Ci_i=0;
	#5 test_result(17'h01515, 0); #5    //1075ns

	//0A0A + 0B0B + 1
	A_i=17'h00A0A; B_i=17'h00B0B; Ci_i=1;
	#5 test_result(17'h01516, 0); #5    //1085ns

	//ABCD + DCBA + 0
	A_i=17'h0ABCD; B_i=17'h0DCBA; Ci_i=0;
	#5 test_result(17'h18887, 0); #5    //1095ns

	//ABCD + DCBA + 1
	A_i=17'h0ABCD; B_i=17'h0DCBA; Ci_i=1;
	#5 test_result(17'h18888, 0); #5    //1105ns

	//1111 + FFFF + 0
	A_i=17'h01111; B_i=17'h0FFFF; Ci_i=0;
	#5 test_result(17'h11110, 0); #5    //1115ns

	//1111 + FFFF + 1
	A_i=17'h01111; B_i=17'h0FFFF; Ci_i=1;
	#5 test_result(17'h11111, 0); #5    //1125ns

	//7F7F + 8080 + 0
	A_i=17'h07F7F; B_i=17'h08080; Ci_i=0;
	#5 test_result(17'h0FFFF, 0); #5    //1135ns

	//7F7F + 8080 + 1
	A_i=17'h07F7F; B_i=17'h08080; Ci_i=1;
	#5 test_result(17'h10000, 0); #5    //1145ns

	//55AA + AA55 + 0
	A_i=17'h055AA; B_i=17'h0AA55; Ci_i=0;
	#5 test_result(17'h0FFFF, 0); #5    //1155ns

	//55AA + AA55 + 1
	A_i=17'h055AA; B_i=17'h0AA55; Ci_i=1;
	#5 test_result(17'h10000, 0); #5    //1165ns

	//0123 + FEDC + 0
	A_i=17'h00123; B_i=17'h0FEDC; Ci_i=0;
	#5 test_result(17'h0FFFF, 0); #5    //1175ns

	//0123 + FEDC + 1
	A_i=17'h00123; B_i=17'h0FEDC; Ci_i=1;
	#5 test_result(17'h10000, 0); #5    //1185ns

		//AAAA + 1111 + 0
	A_i=17'h0AAAA; B_i=17'h01111; Ci_i=0;
	#5 test_result(17'h0BBBB, 0); #5    //1195ns

	//AAAA + 1111 + 1
	A_i=17'h0AAAA; B_i=17'h01111; Ci_i=1;
	#5 test_result(17'h0BBBC, 0); #5    //1205ns

	//FEDC + CDEF + 0
	A_i=17'h0FEDC; B_i=17'h0CDEF; Ci_i=0;
	#5 test_result(17'h1CCCB, 0); #5    //1215ns

	//FEDC + CDEF + 1
	A_i=17'h0FEDC; B_i=17'h0CDEF; Ci_i=1;
	#5 test_result(17'h1CCCC, 0); #5    //1225ns

	//ABCD + 1234 + 0
	A_i=17'h0ABCD; B_i=17'h01234; Ci_i=0;
	#5 test_result(17'h0BE01, 0); #5    //1235ns

	//ABCD + 1234 + 1
	A_i=17'h0ABCD; B_i=17'h01234; Ci_i=1;
	#5 test_result(17'h0BE02, 0); #5    //1245ns

	//F000 + 0FFF + 0
	A_i=17'h0F000; B_i=17'h00FFF; Ci_i=0;
	#5 test_result(17'h0FFFF, 0); #5    //1255ns

	//F000 + 0FFF + 1
	A_i=17'h0F000; B_i=17'h00FFF; Ci_i=1;
	#5 test_result(17'h10000, 0); #5    //1265ns

	//1234 + 1234 + 0
	A_i=17'h01234; B_i=17'h01234; Ci_i=0;
	#5 test_result(17'h02468, 0); #5    //1275ns

	//1234 + 1234 + 1
	A_i=17'h01234; B_i=17'h01234; Ci_i=1;
	#5 test_result(17'h02469, 0); #5    //1285ns

	//ABCD + EEEE + 0
	A_i=17'h0ABCD; B_i=17'h0EEEE; Ci_i=0;
	#5 test_result(17'h19ABB, 0); #5    //1295ns

	//ABCD + EEEE + 1
	A_i=17'h0ABCD; B_i=17'h0EEEE; Ci_i=1;
	#5 test_result(17'h19ABC, 0); #5    //1305ns

	//CAFE + FACE + 0
	A_i=17'h0CAFE; B_i=17'h0FACE; Ci_i=0;
	#5 test_result(17'h1C5CC, 0); #5    //1315ns

	//CAFE + FACE + 1
	A_i=17'h0CAFE; B_i=17'h0FACE; Ci_i=1;
	#5 test_result(17'h1C5CD, 0); #5    //1325ns

	//1111 + 8888 + 0
	A_i=17'h01111; B_i=17'h08888; Ci_i=0;
	#5 test_result(17'h09999, 0); #5    //1335ns

	//1111 + 8888 + 1
	A_i=17'h01111; B_i=17'h08888; Ci_i=1;
	#5 test_result(17'h0999A, 0); #5    //1345ns

	//5555 + 5555 + 0
	A_i=17'h05555; B_i=17'h05555; Ci_i=0;
	#5 test_result(17'h0AAAA, 0); #5    //1355ns

	//5555 + 5555 + 1
	A_i=17'h05555; B_i=17'h05555; Ci_i=1;
	#5 test_result(17'h0AAAB, 0); #5    //1365ns

	//1357 + 9ACE + 0
	A_i=17'h01357; B_i=17'h09ACE; Ci_i=0;
	#5 test_result(17'h0AE25, 0); #5    //1375ns

	//1357 + 9ACE + 1
	A_i=17'h01357; B_i=17'h09ACE; Ci_i=1;
	#5 test_result(17'h0AE26, 0); #5    //1385ns

	//DEAD + 1111 + 0
	A_i=17'h0DEAD; B_i=17'h01111; Ci_i=0;
	#5 test_result(17'h0EFBE, 0); #5    //1395ns

	//DEAD + 1111 + 1
	A_i=17'h0DEAD; B_i=17'h01111; Ci_i=1;
	#5 test_result(17'h0EFBF, 0); #5    //1405ns

	//C0DE + 1234 + 0
	A_i=17'h0C0DE; B_i=17'h01234; Ci_i=0;
	#5 test_result(17'h0D312, 0); #5    //1415ns

	//C0DE + 1234 + 1
	A_i=17'h0C0DE; B_i=17'h01234; Ci_i=1;
	#5 test_result(17'h0D313, 0); #5    //1425ns

	//2468 + 1357 + 0
	A_i=17'h02468; B_i=17'h01357; Ci_i=0;
	#5 test_result(17'h037BF, 0); #5    //1435ns

	//2468 + 1357 + 1
	A_i=17'h02468; B_i=17'h01357; Ci_i=1;
	#5 test_result(17'h037C0, 0); #5    //1445ns

	//FACE + CAFE + 0
	A_i=17'h0FACE; B_i=17'h0CAFE; Ci_i=0;
	#5 test_result(17'h1C5CC, 0); #5    //1455ns

	//FACE + CAFE + 1
	A_i=17'h0FACE; B_i=17'h0CAFE; Ci_i=1;
	#5 test_result(17'h1C5CD, 0); #5    //1465ns

	//0A0A + 0B0B + 0
	A_i=17'h00A0A; B_i=17'h00B0B; Ci_i=0;
	#5 test_result(17'h01515, 0); #5    //1475ns

	//0A0A + 0B0B + 1
	A_i=17'h00A0A; B_i=17'h00B0B; Ci_i=1;
	#5 test_result(17'h01516, 0); #5    //1485ns

	//ABCD + DCBA + 0
	A_i=17'h0ABCD; B_i=17'h0DCBA; Ci_i=0;
	#5 test_result(17'h18887, 0); #5    //1495ns

	//ABCD + DCBA + 1
	A_i=17'h0ABCD; B_i=17'h0DCBA; Ci_i=1;
	#5 test_result(17'h18888, 0); #5    //1505ns

	//1111 + FFFF + 0
	A_i=17'h01111; B_i=17'h0FFFF; Ci_i=0;
	#5 test_result(17'h11110, 0); #5    //1515ns

	//1111 + FFFF + 1
	A_i=17'h01111; B_i=17'h0FFFF; Ci_i=1;
	#5 test_result(17'h11111, 0); #5    //1525ns

	//7F7F + 8080 + 0
	A_i=17'h07F7F; B_i=17'h08080; Ci_i=0;
	#5 test_result(17'h0FFFF, 0); #5    //1535ns

	//7F7F + 8080 + 1
	A_i=17'h07F7F; B_i=17'h08080; Ci_i=1;
	#5 test_result(17'h10000, 0); #5    //1545ns

	//55AA + AA55 + 0
	A_i=17'h055AA; B_i=17'h0AA55; Ci_i=0;
	#5 test_result(17'h0FFFF, 0); #5    //1555ns

	//55AA + AA55 + 1
	A_i=17'h055AA; B_i=17'h0AA55; Ci_i=1;
	#5 test_result(17'h10000, 0); #5    //1565ns

	//0123 + FEDC + 0
	A_i=17'h00123; B_i=17'h0FEDC; Ci_i=0;
	#5 test_result(17'h0FFFF, 0); #5    //1575ns

	//0123 + FEDC + 1
	A_i=17'h00123; B_i=17'h0FEDC; Ci_i=1;
	#5 test_result(17'h10000, 0); #5    //1585ns

	//1234 + 4321 + 1
	A_i=17'h01234; B_i=17'h04321; Ci_i=1;
	#5 test_result(17'h05556, 0); #5    //1595ns

	//8000 + 8000 + 0
	A_i=17'h08000; B_i=17'h08000; Ci_i=0;
	#5 test_result(17'h10000, 0); #5        //1605

	//FFFF + 0001 + 0
	A_i=17'h0FFFF; B_i=17'h00001; Ci_i=0;
	#5 test_result(17'h10000, 0); #5        //1615

	//FFFF + 0001 + 1
	A_i=17'h0FFFF; B_i=17'h00001; Ci_i=1;
	#5 test_result(17'h10001, 0); #5        //1625

	//7FFF + 8001 + 0
	A_i=17'h07FFF; B_i=17'h08001; Ci_i=0;
	#5 test_result(17'h10000, 0); #5        //1635

	//8000 + 8000 + 1
	A_i=17'h08000; B_i=17'h08000; Ci_i=1;
	#5 test_result(17'h10001, 0); #5        //1645

	//A5A5 + 5A5B + 0
	A_i=17'h0A5A5; B_i=17'h05A5B; Ci_i=0;
	#5 test_result(17'h10000, 0); #5        //1655

	//F000 + 1000 + 0
	A_i=17'h0F000; B_i=17'h01000; Ci_i=0;
	#5 test_result(17'h10000, 0); #5        //1665

	//BEEF + 4112 + 1
	A_i=17'h0BEEF; B_i=17'h04112; Ci_i=1;
	#5 test_result(17'h10002, 0); #5        //1675

	//8888 + 7777 + 1
	A_i=17'h08888; B_i=17'h07777; Ci_i=1;
	#5 test_result(17'h10000, 0); #5        //1685

	//C400 + 3C00 + 0
	A_i=17'h0C400; B_i=17'h03C00; Ci_i=0;
	#5 test_result(17'h10000, 0); #5        //1695

	//10000 + 10000 + 0 -> Co = 1, S = 00000
A_i=17'h10000; B_i=17'h10000; Ci_i=0;
#5 test_result(17'h00000, 1); #5    //1705ns

//1FFFF + 0001 + 0 -> Co = 1, S = 00000
A_i=17'h1FFFF; B_i=17'h00001; Ci_i=0;
#5 test_result(17'h00000, 1); #5    //1715ns

//1FFFF + 1FFFF + 1 -> Co = 1, S = 1FFFF
A_i=17'h1FFFF; B_i=17'h1FFFF; Ci_i=1;
#5 test_result(17'h1FFFF, 1); #5    //1725ns

//0A0A0 + 15151 + 0 -> Co = 1, S = 1F1F1
A_i=17'h0A0A0; B_i=17'h15151; Ci_i=0;
#5 test_result(17'h1F1F1, 0); #5    //1735ns

//07FFF + 18001 + 0 -> Co = 1, S = 00000
A_i=17'h07FFF; B_i=17'h18001; Ci_i=0;
#5 test_result(17'h00000, 1); #5    //1745ns

//10000 + FFFF + 1 -> Co = 1, S = 00000
A_i=17'h10000; B_i=17'h0FFFF; Ci_i=1;
#5 test_result(17'h00000, 1); #5    //1755ns

//1F000 + 1000 + 0 -> Co = 1, S = 00000
A_i=17'h1F000; B_i=17'h01000; Ci_i=0;
#5 test_result(17'h00000, 1); #5    //1765ns

//1BEEF + 4112 + 1 -> Co = 1, S = FFF10
A_i=17'h1BEEF; B_i=17'h04112; Ci_i=1;
#5 test_result(17'h00002, 1); #5    //1775ns

//18888 + 7777 + 1 -> Co = 1, S = 00000
A_i=17'h18888; B_i=17'h07777; Ci_i=1;
#5 test_result(17'h00000, 1); #5    //1785ns

//1C400 + 3C00 + 0 -> Co = 1, S = 00000
A_i=17'h1C400; B_i=17'h03C00; Ci_i=0;
#5 test_result(17'h00000, 1); #5    //1795ns

//A_i=17'h1A000 + B_i=17'h1B000 + Ci_i=0
A_i=17'h1A000; B_i=17'h1B000; Ci_i=0;
#5 test_result(17'h15000, 1); #5    //1805ns

//A_i=17'h1FFFF + B_i=17'h1FFFF + Ci_i=0
A_i=17'h1FFFF; B_i=17'h1FFFF; Ci_i=0;
#5 test_result(17'h1FFFE, 1); #5    //1815ns

//A_i=17'h18000 + B_i=17'h18000 + Ci_i=1
A_i=17'h18000; B_i=17'h18000; Ci_i=1;
#5 test_result(17'h10001, 1); #5    //1825ns

//A_i=17'h11111 + B_i=17'h1EEEE + Ci_i=1
A_i=17'h11111; B_i=17'h1EEEE; Ci_i=1;
#5 test_result(17'h10000, 1); #5    //1835ns

//A_i=17'h12345 + B_i=17'h1EDCB + Ci_i=0
A_i=17'h12345; B_i=17'h1EDCB; Ci_i=0;
#5 test_result(17'h11110, 1); #5    //1845ns

//A_i=17'h1FFFC + B_i=17'h00003 + Ci_i=1
A_i=17'h1FFFC; B_i=17'h00003; Ci_i=1;
#5 test_result(17'h00000, 1); #5    //1855ns

//A_i=17'h1FFF0 + B_i=17'h00010 + Ci_i=0
A_i=17'h1FFF0; B_i=17'h00010; Ci_i=0;
#5 test_result(17'h00000, 1); #5    //1865ns

//A_i=17'h1AAAA + B_i=17'h1AAAA + Ci_i=0
A_i=17'h1AAAA; B_i=17'h1AAAA; Ci_i=0;
#5 test_result(17'h15554, 1); #5    //1875ns

//A_i=17'h10000 + B_i=17'h10000 + Ci_i=1
A_i=17'h10000; B_i=17'h10000; Ci_i=1;
#5 test_result(17'h00001, 1); #5    //1885ns

//A_i=17'h186A0 + B_i=17'h0F852 + Ci_i=0
A_i=17'h186A0; B_i=17'h0F852; Ci_i=0;
#5 test_result(17'h07EF2, 1); #5    //1895ns

// 12345 + 1EDCB + 0 -> Co = 1, S = 11110
A_i=17'h12345; B_i=17'h1EDCB; Ci_i=0;
#5 test_result(17'h11110, 1); #5    //1905ns

// 18000 + 1FFFF + 0 -> Co = 1, S = 17FFF
A_i=17'h18000; B_i=17'h1FFFF; Ci_i=0;
#5 test_result(17'h17FFF, 1); #5    //1915ns

// 12345 + FEDC + 0 
A_i=17'h12345; B_i=17'h0FEDC; Ci_i=0;
#5 test_result(17'h02221, 1); #5    //1925ns




	$display("+----------------------------+-----------------+------------+");
    $display("|                         TEST PASSED                       |");
    $display("+-----------------------------------------------------------+\n\n");

	$finish;


end

endmodule