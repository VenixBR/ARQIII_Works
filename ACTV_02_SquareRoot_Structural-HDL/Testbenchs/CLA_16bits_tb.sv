module CLA_16bits_tb;

reg  [15:0] A_i, B_i;
reg Ci_i;
wire [15:0] S_o;
wire Co_o;

//CLA DUV (
//CLA4x4 DUV (
CLA2x8 DUV (
    .A_i(A_i),
    .B_i(B_i),
    .Ci_i(Ci_i),
    .Co_o(Co_o),
	.S_o(S_o)
);

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
/*
initial begin

	$display("\n+----------------------------+-----------------+------------+");
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
	#5 test_result(16'hA87D, 0);               //355ns

	//3FFC + 0000+ 0
	A_i=16'h3FFc; B_i=16'h0000; Ci_i=0;
	#5 test_result(16'h3FFC, 0);               //365ns

	$display("+----------------------------+-----------------+------------+");
    $display("|                         TEST PASSED                       |");
    $display("+-----------------------------------------------------------+\n\n");

	$finish;


end*/

endmodule