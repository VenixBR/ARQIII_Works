module CLA_16bits_tb;

reg  [15:0] A_i, B_i;
reg Ci_i;
wire [15:0] S_o;
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
        input logic [15:0] S_exp,
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
	A_i=16'h0000; B_i=16'h0000; Ci_i=0;
	#5 test_result(16'h0000, 0); #5            //5ns

	//01 + 02 + 0
	A_i=16'h0001; B_i=16'h0002; Ci_i=0; 
	#5 test_result(16'h0003, 0); #5           //15ns

	//01 + 02 + 1
	A_i=16'h0001; B_i=16'h0002; Ci_i=1;
	#5 test_result(16'h0004, 0); #5            //25ns

	//52 + 32 + 0
	A_i=16'h0052; B_i=16'h0032; Ci_i=0;    
	#5 test_result(16'h0084, 0); #5            //35ns

	//C4 + D5 + 0
	A_i=16'h00C4; B_i=16'h00D5; Ci_i=0;  
	#5 test_result(16'h0199, 0); #5            //45ns

	//B2 + 35 + 1
	A_i=16'h00B2; B_i=16'h0035; Ci_i=1;  
	#5 test_result(16'h00E8, 0); #5            //55ns

	//85 + 37 + 1
	A_i=16'h0085; B_i=16'h0037; Ci_i=1;   
	#5 test_result(16'h00BD, 0); #5            //65ns

	//FF + FF + 0
	A_i=16'h00FF; B_i=16'h00FF; Ci_i=0;
	#5 test_result(16'h01FE, 0); #5            //75ns

	//99 + D3 + 0
	A_i=16'h0099; B_i=16'h00D3; Ci_i=0;
	#5 test_result(16'h016C, 0); #5            //85ns

	//A6 + A7 + 1
	A_i=16'h00A6; B_i=16'h00A7; Ci_i=1;
	#5 test_result(16'h014E, 0); #5            //95ns

	//FF + FF + 1
	A_i=16'h00FF; B_i=16'h00FF; Ci_i=1;
	#5 test_result(16'h01FF, 0); #5            //105ns

	//C1 + 43 + 0
	A_i=16'h00C1; B_i=16'h0043; Ci_i=0;
	#5 test_result(16'h0104, 0); #5            //115ns

	//85 + 36 + 0
	A_i=16'h0085; B_i=16'h0036; Ci_i=0;
	#5 test_result(16'h00BB, 0); #5            //125ns

	//25 + B9 + 0
	A_i=16'h0025; B_i=16'h00B9; Ci_i=0;
	#5 test_result(16'h00DE, 0); #5            //135ns

	//FF + 01 + 0
	A_i=16'h00FF; B_i=16'h0001; Ci_i=0;
	#5 test_result(16'h0100, 0); #5            //145ns

	//EF + FE + 1
	A_i=16'h00EF; B_i=16'h00FE; Ci_i=1; 
	#5 test_result(16'h01EE, 0); #5            //155ns

	//AA + AA + 0
	A_i=16'h00AA; B_i=16'h00AA; Ci_i=0;
	#5 test_result(16'h0154, 0); #5            //165ns

	//BBBB + BBBB + 1
	A_i=16'hBBBB; B_i=16'hBBBB; Ci_i=1;
	#5 test_result(16'h7777, 1); #5            //175ns

	//08 + 96 + 0
	A_i=16'h0008; B_i=16'h0096; Ci_i=0;
	#5 test_result(16'h009E, 0); #5            //185ns

	//45 + B7 + 0
	A_i=16'h0045; B_i=16'h00B7; Ci_i=0; 
	#5 test_result(16'h00FC, 0); #5            //195ns

	//FC + 25 + 1
	A_i=16'h00FC; B_i=16'h0025; Ci_i=1; 
	#5 test_result(16'h0122, 0); #5            //205ns

	//C1 + D2 + 1
	A_i=16'h00C1; B_i=16'h00D2; Ci_i=1; 
	#5 test_result(16'h0194, 0); #5            //215ns

	//62 + AA + 0
	A_i=16'h0062; B_i=16'h00AA; Ci_i=0; 
	#5 test_result(16'h010C, 0); #5            //225ns

	//DA + C1 + 0
	A_i=16'h00DA; B_i=16'h00C1; Ci_i=0;
	#5 test_result(16'h019B, 0); #5            //235ns

	//94 + CA + 0
	A_i=16'h0094; B_i=16'h00CA; Ci_i=0; 
	#5 test_result(16'h015E, 0); #5            //245ns

	//895E + 7925 + 1
	A_i=16'h895E; B_i=16'h7925; Ci_i=1;
	#5 test_result(16'h0284, 1); #5            //255ns

	//84 + 4F + 1
	A_i=16'h0084; B_i=16'h004F; Ci_i=1; 
	#5 test_result(16'h00D4, 0); #5            //265ns

	//D4 + 63 + 0
	A_i=16'h00D4; B_i=16'h0063; Ci_i=0;
	#5 test_result(16'h0137, 0); #5            //275ns

	//37 + 9B + 0
	A_i=16'h0037; B_i=16'h009B; Ci_i=0;
	#5 test_result(16'h00D2, 0); #5            //285ns

	//D2 + 11 + 0
	A_i=16'h00D2; B_i=16'h0011; Ci_i=0;
	#5 test_result(16'h00E3, 0); #5            //295ns

	//E3 + 81 + 0
	A_i=16'h00E3; B_i=16'h0081; Ci_i=0;
	#5 test_result(16'h0164, 0); #5            //305ns

	//E474 + 2857 + 0
	A_i=16'hE474; B_i=16'h2857; Ci_i=0;
	#5 test_result(16'h0CCB, 1); #5            //315ns

	//D529 + A82E + 1
	A_i=16'hD529; B_i=16'hA82E; Ci_i=1;
	#5 test_result(16'h7D58, 1); #5            //325ns

	//99A7 + 8FF2 + 0
	A_i=16'h99A7; B_i=16'h8FF2; Ci_i=0;
	#5 test_result(16'h2999, 1); #5            //335ns

	//0FFF + 987E + 0
	A_i=16'h8F2B; B_i=16'h7EA2; Ci_i=1;
	#5 test_result(16'h0DCE, 1); #5            //345ns

	//0FFF + 987E + 0
	A_i=16'h0FFF; B_i=16'h987E; Ci_i=0;
	#5 test_result(16'hA87D, 0); #5            //355ns

	//3FFC + 0000+ 0
	A_i=16'h3FFc; B_i=16'h0000; Ci_i=0;
	#5 test_result(16'h3FFC, 0); #5            //365ns

		//1234 + 4321 + 0
	A_i=16'h1234; B_i=16'h4321; Ci_i=0;
	#5 test_result(16'h5555, 0); #5            //375ns

	//7FFF + 0001 + 0
	A_i=16'h7FFF; B_i=16'h0001; Ci_i=0;
	#5 test_result(16'h8000, 0); #5            //385ns

	//7FFF + 0001 + 1
	A_i=16'h7FFF; B_i=16'h0001; Ci_i=1;
	#5 test_result(16'h8001, 0); #5            //395ns

	//8000 + 8000 + 0
	A_i=16'h8000; B_i=16'h8000; Ci_i=0;
	#5 test_result(16'h0000, 1); #5            //405ns

	//AAAA + 5555 + 0
	A_i=16'hAAAA; B_i=16'h5555; Ci_i=0;
	#5 test_result(16'hFFFF, 0); #5            //415ns

	//AAAA + 5555 + 1
	A_i=16'hAAAA; B_i=16'h5555; Ci_i=1;
	#5 test_result(16'h0000, 1); #5            //425ns

	//FFFF + 0001 + 0
	A_i=16'hFFFF; B_i=16'h0001; Ci_i=0;
	#5 test_result(16'h0000, 1); #5            //435ns

	//1234 + EDCC + 1
	A_i=16'h1234; B_i=16'hEDCC; Ci_i=1;
	#5 test_result(16'h0001, 1); #5            //445ns

	//BEEF + 1111 + 0
	A_i=16'hBEEF; B_i=16'h1111; Ci_i=0;
	#5 test_result(16'hD000, 0); #5            //455ns

	//FACE + 1234 + 1
	A_i=16'hFACE; B_i=16'h1234; Ci_i=1;
	#5 test_result(16'h0D03, 1); #5            //465ns

		//0F0F + F0F0 + 0
	A_i=16'h0F0F; B_i=16'hF0F0; Ci_i=0;
	#5 test_result(16'hFFFF, 0); #5            //475ns

	//0F0F + F0F0 + 1
	A_i=16'h0F0F; B_i=16'hF0F0; Ci_i=1;
	#5 test_result(16'h0000, 1); #5            //485ns

	//DEAD + BEEF + 0
	A_i=16'hDEAD; B_i=16'hBEEF; Ci_i=0;
	#5 test_result(16'h9D9C, 1); #5            //495ns

	//CAFE + BABE + 1
	A_i=16'hCAFE; B_i=16'hBABE; Ci_i=1;
	#5 test_result(16'h85BD, 1); #5            //505ns

	//1111 + 2222 + 0
	A_i=16'h1111; B_i=16'h2222; Ci_i=0;
	#5 test_result(16'h3333, 0); #5            //515ns

	//1357 + 2468 + 1
	A_i=16'h1357; B_i=16'h2468; Ci_i=1;
	#5 test_result(16'h37C0, 0); #5            //525ns

	//8000 + 7FFF + 0
	A_i=16'h8000; B_i=16'h7FFF; Ci_i=0;
	#5 test_result(16'hFFFF, 0); #5            //535ns

	//8000 + 7FFF + 1
	A_i=16'h8000; B_i=16'h7FFF; Ci_i=1;
	#5 test_result(16'h0000, 1); #5            //545ns

	//AAAA + AAAA + 0
	A_i=16'hAAAA; B_i=16'hAAAA; Ci_i=0;
	#5 test_result(16'h5554, 1); #5            //555ns

	//7ACE + 1357 + 1
	A_i=16'h7ACE; B_i=16'h1357; Ci_i=1;
	#5 test_result(16'h8E26, 0); #5            //565ns

	//FFFF + FFFF + 0
	A_i=16'hFFFF; B_i=16'hFFFF; Ci_i=0;
	#5 test_result(16'hFFFE, 1); #5            //575ns

	//FFFF + FFFF + 1
	A_i=16'hFFFF; B_i=16'hFFFF; Ci_i=1;
	#5 test_result(16'hFFFF, 1); #5            //585ns

	//1234 + 5678 + 0
	A_i=16'h1234; B_i=16'h5678; Ci_i=0;
	#5 test_result(16'h68AC, 0); #5            //595ns

		//9ABC + 1234 + 0
	A_i=16'h9ABC; B_i=16'h1234; Ci_i=0;
	#5 test_result(16'hACF0, 0); #5            //605ns

	//9ABC + 1234 + 1
	A_i=16'h9ABC; B_i=16'h1234; Ci_i=1;
	#5 test_result(16'hACF1, 0); #5            //615ns

	//8001 + 7FFF + 0
	A_i=16'h8001; B_i=16'h7FFF; Ci_i=0;
	#5 test_result(16'h0000, 1); #5            //625ns

	//2468 + 1357 + 0
	A_i=16'h2468; B_i=16'h1357; Ci_i=0;
	#5 test_result(16'h37BF, 0); #5            //635ns

	//2468 + 1357 + 1
	A_i=16'h2468; B_i=16'h1357; Ci_i=1;
	#5 test_result(16'h37C0, 0); #5            //645ns

	//FACE + CAFE + 0
	A_i=16'hFACE; B_i=16'hCAFE; Ci_i=0;
	#5 test_result(16'hC5CC, 1); #5            //655ns

	//FACE + CAFE + 1
	A_i=16'hFACE; B_i=16'hCAFE; Ci_i=1;
	#5 test_result(16'hC5CD, 1); #5            //665ns

	//0A0A + 0B0B + 0
	A_i=16'h0A0A; B_i=16'h0B0B; Ci_i=0;
	#5 test_result(16'h1515, 0); #5            //675ns

	//0A0A + 0B0B + 1
	A_i=16'h0A0A; B_i=16'h0B0B; Ci_i=1;
	#5 test_result(16'h1516, 0); #5            //685ns

	//ABCD + DCBA + 0
	A_i=16'hABCD; B_i=16'hDCBA; Ci_i=0;
	#5 test_result(16'h8887, 1); #5            //695ns

	//1111 + FFFF + 1
	A_i=16'h1111; B_i=16'hFFFF; Ci_i=1;
	#5 test_result(16'h1111, 1); #5            //705ns

	//7F7F + 8080 + 1
	A_i=16'h7F7F; B_i=16'h8080; Ci_i=1;
	#5 test_result(16'h0000, 1); #5            //715ns

	//55AA + AA55 + 0
	A_i=16'h55AA; B_i=16'hAA55; Ci_i=0;
	#5 test_result(16'hFFFF, 0); #5            //725ns

	//55AA + AA55 + 1
	A_i=16'h55AA; B_i=16'hAA55; Ci_i=1;
	#5 test_result(16'h0000, 1); #5            //735ns

	//0123 + FEDC + 0
	A_i=16'h0123; B_i=16'hFEDC; Ci_i=0;
	#5 test_result(16'hFFFF, 0); #5            //745ns

	//0123 + FEDC + 1
	A_i=16'h0123; B_i=16'hFEDC; Ci_i=1;
	#5 test_result(16'h0000, 1); #5            //755ns

	//AAAA + 1111 + 0
	A_i=16'hAAAA; B_i=16'h1111; Ci_i=0;
	#5 test_result(16'hBBBB, 0); #5            //765ns

	//AAAA + 1111 + 1
	A_i=16'hAAAA; B_i=16'h1111; Ci_i=1;
	#5 test_result(16'hBBBC, 0); #5            //775ns

	//FEDC + CDEF + 0
	A_i=16'hFEDC; B_i=16'hCDEF; Ci_i=0;
	#5 test_result(16'hCCCB, 1); #5            //785ns

	//FEDC + CDEF + 1
	A_i=16'hFEDC; B_i=16'hCDEF; Ci_i=1;
	#5 test_result(16'hCCCC, 1); #5            //795ns

	//ABCD + 1234 + 0
	A_i=16'hABCD; B_i=16'h1234; Ci_i=0;
	#5 test_result(16'hBE01, 0); #5            //805ns

	//ABCD + 1234 + 1
	A_i=16'hABCD; B_i=16'h1234; Ci_i=1;
	#5 test_result(16'hBE02, 0); #5            //815ns

	//F000 + 0FFF + 0
	A_i=16'hF000; B_i=16'h0FFF; Ci_i=0;
	#5 test_result(16'hFFFF, 0); #5            //825ns

	//F000 + 0FFF + 1
	A_i=16'hF000; B_i=16'h0FFF; Ci_i=1;
	#5 test_result(16'h0000, 1); #5            //835ns

	//1234 + 1234 + 0
	A_i=16'h1234; B_i=16'h1234; Ci_i=0;
	#5 test_result(16'h2468, 0); #5            //845ns

	//1234 + 1234 + 1
	A_i=16'h1234; B_i=16'h1234; Ci_i=1;
	#5 test_result(16'h2469, 0); #5            //855ns

	//ABCD + EEEE + 0
	A_i=16'hABCD; B_i=16'hEEEE; Ci_i=0;
	#5 test_result(16'h9ABB, 1); #5            //865ns

	//ABCD + EEEE + 1
	A_i=16'hABCD; B_i=16'hEEEE; Ci_i=1;
	#5 test_result(16'h9ABC, 1); #5            //875ns

	//CAFE + FACE + 0
	A_i=16'hCAFE; B_i=16'hFACE; Ci_i=0;
	#5 test_result(16'hC5CC, 1); #5            //885ns

	//CAFE + FACE + 1
	A_i=16'hCAFE; B_i=16'hFACE; Ci_i=1;
	#5 test_result(16'hC5CD, 1); #5            //895ns

	//1111 + 8888 + 0
	A_i=16'h1111; B_i=16'h8888; Ci_i=0;
	#5 test_result(16'h9999, 0); #5            //905ns

	//1111 + 8888 + 1
	A_i=16'h1111; B_i=16'h8888; Ci_i=1;
	#5 test_result(16'h999A, 0); #5            //915ns

	//5555 + 5555 + 0
	A_i=16'h5555; B_i=16'h5555; Ci_i=0;
	#5 test_result(16'hAAAA, 0); #5            //925ns

	//5555 + 5555 + 1
	A_i=16'h5555; B_i=16'h5555; Ci_i=1;
	#5 test_result(16'hAAAB, 0); #5            //935ns

	//1357 + 9ACE + 0
	A_i=16'h1357; B_i=16'h9ACE; Ci_i=0;
	#5 test_result(16'hAE25, 0); #5            //945ns

	//1357 + 9ACE + 1
	A_i=16'h1357; B_i=16'h9ACE; Ci_i=1;
	#5 test_result(16'hAE26, 0); #5            //955ns

	//DEAD + 1111 + 0
	A_i=16'hDEAD; B_i=16'h1111; Ci_i=0;
	#5 test_result(16'hEFBE, 0); #5            //965ns

	//DEAD + 1111 + 1
	A_i=16'hDEAD; B_i=16'h1111; Ci_i=1;
	#5 test_result(16'hEFBF, 0); #5            //975ns

	//C0DE + 1234 + 0
	A_i=16'hC0DE; B_i=16'h1234; Ci_i=0;
	#5 test_result(16'hD312, 0); #5            //985ns

	//C0DE + 1234 + 1
	A_i=16'hC0DE; B_i=16'h1234; Ci_i=1;
	#5 test_result(16'hD313, 0); #5            //995ns

	//C0DE + 1234 + 1
	A_i=16'hC0DE; B_i=16'h1234; Ci_i=1;
	#5 test_result(16'hD313, 0); #5    //1005ns

	//ABCD + 5678 + 0
	A_i=16'hABCD; B_i=16'h5678; Ci_i=0;
	#5 test_result(16'h0245, 1); #5    //1015ns

	//ABCD + 5678 + 1
	A_i=16'hABCD; B_i=16'h5678; Ci_i=1;
	#5 test_result(16'h0246, 1); #5    //1025ns

	//1357 + 2468 + 0
	A_i=16'h1357; B_i=16'h2468; Ci_i=0;
	#5 test_result(16'h37BF, 0); #5    //1035ns

	//1357 + 2468 + 1
	A_i=16'h1357; B_i=16'h2468; Ci_i=1;
	#5 test_result(16'h37C0, 0); #5    //1045ns

	//FACE + CAFE + 0
	A_i=16'hFACE; B_i=16'hCAFE; Ci_i=0;
	#5 test_result(16'hC5CC, 1); #5    //1055ns

	//FACE + CAFE + 1
	A_i=16'hFACE; B_i=16'hCAFE; Ci_i=1;
	#5 test_result(16'hC5CD, 1); #5    //1065ns

	//0A0A + 0B0B + 0
	A_i=16'h0A0A; B_i=16'h0B0B; Ci_i=0;
	#5 test_result(16'h1515, 0); #5    //1075ns

	//0A0A + 0B0B + 1
	A_i=16'h0A0A; B_i=16'h0B0B; Ci_i=1;
	#5 test_result(16'h1516, 0); #5    //1085ns

	//ABCD + DCBA + 0
	A_i=16'hABCD; B_i=16'hDCBA; Ci_i=0;
	#5 test_result(16'h8887, 1); #5    //1095ns

	//ABCD + DCBA + 1
	A_i=16'hABCD; B_i=16'hDCBA; Ci_i=1;
	#5 test_result(16'h8888, 1); #5    //1105ns

	//1111 + FFFF + 0
	A_i=16'h1111; B_i=16'hFFFF; Ci_i=0;
	#5 test_result(16'h1110, 1); #5    //1115ns

	//1111 + FFFF + 1
	A_i=16'h1111; B_i=16'hFFFF; Ci_i=1;
	#5 test_result(16'h1111, 1); #5    //1125ns

	//7F7F + 8080 + 0
	A_i=16'h7F7F; B_i=16'h8080; Ci_i=0;
	#5 test_result(16'hFFFF, 0); #5    //1135ns

	//7F7F + 8080 + 1
	A_i=16'h7F7F; B_i=16'h8080; Ci_i=1;
	#5 test_result(16'h0000, 1); #5    //1145ns

	//55AA + AA55 + 0
	A_i=16'h55AA; B_i=16'hAA55; Ci_i=0;
	#5 test_result(16'hFFFF, 0); #5    //1155ns

	//55AA + AA55 + 1
	A_i=16'h55AA; B_i=16'hAA55; Ci_i=1;
	#5 test_result(16'h0000, 1); #5    //1165ns

	//0123 + FEDC + 0
	A_i=16'h0123; B_i=16'hFEDC; Ci_i=0;
	#5 test_result(16'hFFFF, 0); #5    //1175ns

	//0123 + FEDC + 1
	A_i=16'h0123; B_i=16'hFEDC; Ci_i=1;
	#5 test_result(16'h0000, 1); #5    //1185ns

		//AAAA + 1111 + 0
	A_i=16'hAAAA; B_i=16'h1111; Ci_i=0;
	#5 test_result(16'hBBBB, 0); #5    //1195ns

	//AAAA + 1111 + 1
	A_i=16'hAAAA; B_i=16'h1111; Ci_i=1;
	#5 test_result(16'hBBBC, 0); #5    //1205ns

	//FEDC + CDEF + 0
	A_i=16'hFEDC; B_i=16'hCDEF; Ci_i=0;
	#5 test_result(16'hCCCB, 1); #5    //1215ns

	//FEDC + CDEF + 1
	A_i=16'hFEDC; B_i=16'hCDEF; Ci_i=1;
	#5 test_result(16'hCCCC, 1); #5    //1225ns

	//ABCD + 1234 + 0
	A_i=16'hABCD; B_i=16'h1234; Ci_i=0;
	#5 test_result(16'hBE01, 0); #5    //1235ns

	//ABCD + 1234 + 1
	A_i=16'hABCD; B_i=16'h1234; Ci_i=1;
	#5 test_result(16'hBE02, 0); #5    //1245ns

	//F000 + 0FFF + 0
	A_i=16'hF000; B_i=16'h0FFF; Ci_i=0;
	#5 test_result(16'hFFFF, 0); #5    //1255ns

	//F000 + 0FFF + 1
	A_i=16'hF000; B_i=16'h0FFF; Ci_i=1;
	#5 test_result(16'h0000, 1); #5    //1265ns

	//1234 + 1234 + 0
	A_i=16'h1234; B_i=16'h1234; Ci_i=0;
	#5 test_result(16'h2468, 0); #5    //1275ns

	//1234 + 1234 + 1
	A_i=16'h1234; B_i=16'h1234; Ci_i=1;
	#5 test_result(16'h2469, 0); #5    //1285ns

	//ABCD + EEEE + 0
	A_i=16'hABCD; B_i=16'hEEEE; Ci_i=0;
	#5 test_result(16'h9ABB, 1); #5    //1295ns

	//ABCD + EEEE + 1
	A_i=16'hABCD; B_i=16'hEEEE; Ci_i=1;
	#5 test_result(16'h9ABC, 1); #5    //1305ns

	//CAFE + FACE + 0
	A_i=16'hCAFE; B_i=16'hFACE; Ci_i=0;
	#5 test_result(16'hC5CC, 1); #5    //1315ns

	//CAFE + FACE + 1
	A_i=16'hCAFE; B_i=16'hFACE; Ci_i=1;
	#5 test_result(16'hC5CD, 1); #5    //1325ns

	//1111 + 8888 + 0
	A_i=16'h1111; B_i=16'h8888; Ci_i=0;
	#5 test_result(16'h9999, 0); #5    //1335ns

	//1111 + 8888 + 1
	A_i=16'h1111; B_i=16'h8888; Ci_i=1;
	#5 test_result(16'h999A, 0); #5    //1345ns

	//5555 + 5555 + 0
	A_i=16'h5555; B_i=16'h5555; Ci_i=0;
	#5 test_result(16'hAAAA, 0); #5    //1355ns

	//5555 + 5555 + 1
	A_i=16'h5555; B_i=16'h5555; Ci_i=1;
	#5 test_result(16'hAAAB, 0); #5    //1365ns

	//1357 + 9ACE + 0
	A_i=16'h1357; B_i=16'h9ACE; Ci_i=0;
	#5 test_result(16'hAE25, 0); #5    //1375ns

	//1357 + 9ACE + 1
	A_i=16'h1357; B_i=16'h9ACE; Ci_i=1;
	#5 test_result(16'hAE26, 0); #5    //1385ns

	//DEAD + 1111 + 0
	A_i=16'hDEAD; B_i=16'h1111; Ci_i=0;
	#5 test_result(16'hEFBE, 0); #5    //1395ns

	//DEAD + 1111 + 1
	A_i=16'hDEAD; B_i=16'h1111; Ci_i=1;
	#5 test_result(16'hEFBF, 0); #5    //1405ns

	//C0DE + 1234 + 0
	A_i=16'hC0DE; B_i=16'h1234; Ci_i=0;
	#5 test_result(16'hD312, 0); #5    //1415ns

	//C0DE + 1234 + 1
	A_i=16'hC0DE; B_i=16'h1234; Ci_i=1;
	#5 test_result(16'hD313, 0); #5    //1425ns

	//2468 + 1357 + 0
	A_i=16'h2468; B_i=16'h1357; Ci_i=0;
	#5 test_result(16'h37BF, 0); #5    //1435ns

	//2468 + 1357 + 1
	A_i=16'h2468; B_i=16'h1357; Ci_i=1;
	#5 test_result(16'h37C0, 0); #5    //1445ns

	//FACE + CAFE + 0
	A_i=16'hFACE; B_i=16'hCAFE; Ci_i=0;
	#5 test_result(16'hC5CC, 1); #5    //1455ns

	//FACE + CAFE + 1
	A_i=16'hFACE; B_i=16'hCAFE; Ci_i=1;
	#5 test_result(16'hC5CD, 1); #5    //1465ns

	//0A0A + 0B0B + 0
	A_i=16'h0A0A; B_i=16'h0B0B; Ci_i=0;
	#5 test_result(16'h1515, 0); #5    //1475ns

	//0A0A + 0B0B + 1
	A_i=16'h0A0A; B_i=16'h0B0B; Ci_i=1;
	#5 test_result(16'h1516, 0); #5    //1485ns

	//ABCD + DCBA + 0
	A_i=16'hABCD; B_i=16'hDCBA; Ci_i=0;
	#5 test_result(16'h8887, 1); #5    //1495ns

	//ABCD + DCBA + 1
	A_i=16'hABCD; B_i=16'hDCBA; Ci_i=1;
	#5 test_result(16'h8888, 1); #5    //1505ns

	//1111 + FFFF + 0
	A_i=16'h1111; B_i=16'hFFFF; Ci_i=0;
	#5 test_result(16'h1110, 1); #5    //1515ns

	//1111 + FFFF + 1
	A_i=16'h1111; B_i=16'hFFFF; Ci_i=1;
	#5 test_result(16'h1111, 1); #5    //1525ns

	//7F7F + 8080 + 0
	A_i=16'h7F7F; B_i=16'h8080; Ci_i=0;
	#5 test_result(16'hFFFF, 0); #5    //1535ns

	//7F7F + 8080 + 1
	A_i=16'h7F7F; B_i=16'h8080; Ci_i=1;
	#5 test_result(16'h0000, 1); #5    //1545ns

	//55AA + AA55 + 0
	A_i=16'h55AA; B_i=16'hAA55; Ci_i=0;
	#5 test_result(16'hFFFF, 0); #5    //1555ns

	//55AA + AA55 + 1
	A_i=16'h55AA; B_i=16'hAA55; Ci_i=1;
	#5 test_result(16'h0000, 1); #5    //1565ns

	//0123 + FEDC + 0
	A_i=16'h0123; B_i=16'hFEDC; Ci_i=0;
	#5 test_result(16'hFFFF, 0); #5    //1575ns

	//0123 + FEDC + 1
	A_i=16'h0123; B_i=16'hFEDC; Ci_i=1;
	#5 test_result(16'h0000, 1); #5    //1585ns

	//1234 + 4321 + 1
	A_i=16'h1234; B_i=16'h4321; Ci_i=1;
	#5 test_result(16'h5556, 0); #5    //1595ns





	$display("+----------------------------+-----------------+------------+");
    $display("|                         TEST PASSED                       |");
    $display("+-----------------------------------------------------------+\n\n");

	$finish;


end

endmodule