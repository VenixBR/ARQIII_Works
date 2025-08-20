module CLA_16bits_tb;

reg  [15:0] A_i, B_i;
reg Ci_i;
wire [15:0] S_o;
wire Co_o;

CLA_16bits DUV (
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

            $display(  "| A_i=%0d  B_i=%0d  Ci_i=%b | S_o=%0d Co_o=%b | %0d",
                     A_i, B_i, Ci_i, S_o, Co_o, $time);

            if(S_o !== S_exp)
                print_error($sformatf("%s should be %b at time %0d", "S_o", S_exp, $time ));
            else if(Co_o !== Co_exp)
                print_error($sformatf("%s should be %b at time %0d", "Co_o", Co_exp, $time ));
        end
    endtask

    task print_error (input string message); begin
            $display(  "+-----------------------------+-----------------------------------------------------------------------+------------+");
            $display(  "|                                                    TEST FAILED!! ");
            $display(  "|  %s", message);
            $display(  "+-------------------------------------------------------------------------------------------------------------------\n\n");
            //$finish;
        end
    endtask

initial begin

	//00 + 00 + 0
	A_i_tb=16'h0000; B_i_tb=16'h0000; Ci_i=0;
	#10 test_result(16'h0000, 0);             //10ns

	//01 + 02 + 0
	A_i_tb=16'h0001; B_i_tb=16'h0002; Ci_i=0; 
	#10 test_result(16'h0003, 0);             //20ns

	//01 + 02 + 1
	A_i_tb=16'h0001; B_i_tb=16'h0002; Ci_i=1;
	#10 test_result(16'h0004, 0);             //30ns

	//52 + 32 + 0
	A_i_tb=16'h0052; B_i_tb=16'h0032; Ci_i=0;    
	#10 test_result(16'h0084, 0);             //40ns

	//C4 + D5 + 0
	A_i_tb=16'h00C4; B_i_tb=16'h00D5; Ci_i=0;  
	#10 test_result(16'h0099, 0);             //50ns

	//B2 + 35 + 1
	A_i_tb=16'h00B2; B_i_tb=16'h0035; Ci_i=1;  
	#10 test_result(16'h00E8, 0);             //60ns

	//85 + 37 + 1
	A_i_tb=16'h0085; B_i_tb=16'h0037; Ci_i=1;   
	#10 test_result(16'h00BD, 0);             //70ns

	//FF + FF + 0
	A_i_tb=16'h00FF; B_i_tb=16'h00FF; Ci_i=0;
	#10 test_result(16'h00FE, 0);             //80ns

	//99 + D3 + 0
	A_i_tb=16'h0099; B_i_tb=16'h00D3; Ci_i=0;
	#10 test_result(16'h006C, 0);             //90ns

	//A6 + A7 + 1
	A_i_tb=16'h00A6; B_i_tb=16'h00A7; Ci_i=1;
	#10 test_result(16'h004E, 0);             //100ns

	//FF + FF + 1
	A_i_tb=16'h00FF; B_i_tb=16'h00FF; Ci_i=1;
	#10 test_result(16'h00FF, 0);             //110ns

	//C1 + 43 + 0
	A_i_tb=16'h00C1; B_i_tb=16'h0043; Ci_i=0;
	#10 test_result(16'h0004, 0);             //120ns

	//85 + 36 + 0
	A_i_tb=16'h0085; B_i_tb=16'h0036; Ci_i=0;
	#10 test_result(16'h00BB, 0);             //130ns

	//25 + B9 + 0
	A_i_tb=16'h0025; B_i_tb=16'h00B9; Ci_i=0;
	#10 test_result(16'h00DE, 0);             //140ns

	//FF + 01 + 0
	A_i_tb=16'h00FF; B_i_tb=16'h0001; Ci_i=0;
	#10 test_result(16'h0000, 0);             //150ns

	//EF + FE + 1
	A_i_tb=16'h00EF; B_i_tb=16'h00FE; Ci_i=1; 
	#10 test_result(16'h00EE, 0);             //160ns

	//AA + AA + 0
	A_i_tb=16'h00AA; B_i_tb=16'h00AA; Ci_i=0;
	#10 test_result(16'h0054, 0);             //170ns

	//BBBB + BBBB + 1
	A_i_tb=16'h00BB; B_i_tb=16'h00BB; Ci_i=1;
	#10 test_result(16'h7777, 1);             //180ns

	//08 + 96 + 0
	A_i_tb=16'h0008; B_i_tb=16'h0096; Ci_i=0;
	#10 test_result(16'h009E, 0);             //190ns

	//45 + B7 + 0
	A_i_tb=16'h0045; B_i_tb=16'h00B7; Ci_i=0; 
	#10 test_result(16'h00FC, 0);             //200ns

	//FC + 25 + 1
	A_i_tb=16'h00FC; B_i_tb=16'h0025; Ci_i=1; 
	#10 test_result(16'h0022, 0);             //210ns

	//C1 + D2 + 1
	A_i_tb=16'h00C1; B_i_tb=16'h00D2; Ci_i=1; 
	#10 test_result(16'h0094, 0);             //220ns

	//62 + AA + 0
	A_i_tb=16'h0062; B_i_tb=16'h00AA; Ci_i=0; 
	#10 test_result(16'h000C, 0);             //230ns

	//DA + C1 + 0
	A_i_tb=16'h00DA; B_i_tb=16'h00C1; Ci_i=0;
	#10 test_result(16'h009B, 0);             //240ns

	//94 + CA + 0
	A_i_tb=16'h0094; B_i_tb=16'h00CA; Ci_i=0; 
	#10 test_result(16'h005E, 0);             //250ns

	//895E + 7925 + 1
	A_i_tb=16'h895E; B_i_tb=16'h7925; Ci_i=1;
	#10 test_result(16'h0284, 1);             //260ns

	//84 + 4F + 1
	A_i_tb=16'h0084; B_i_tb=16'h004F; Ci_i=1; 
	#10 test_result(16'h00D4, 0);             //270ns

	//D4 + 63 + 0
	A_i_tb=16'h00D4; B_i_tb=16'h0063; Ci_i=0;
	#10 test_result(16'h0037, 0);             //280ns

	//37 + 9B + 0
	A_i_tb=16'h0037; B_i_tb=16'h009B; Ci_i=0;
	#10 test_result(16'h00D2, 0);             //290ns

	//D2 + 11 + 0
	A_i_tb=16'h00D2; B_i_tb=16'h0011; Ci_i=0;
	#10 test_result(16'h00E3, 0);             //300ns

	//E3 + 81 + 0
	A_i_tb=16'h00E3; B_i_tb=16'h0081; Ci_i=0;
	#10 test_result(16'h0064, 0);             //310ns

	//E474 + 2857 + 0
	A_i_tb=16'hE474; B_i_tb=16'h2857; Ci_i=0;
	#10 test_result(16'h0CCB, 1);             //320ns

	//D529 + A82E + 1
	A_i_tb=16'hD529; B_i_tb=16'hA82E; Ci_i=1;
	#10 test_result(16'h7D58, 1);             //330ns

	//99A7 + 8FF2 + 0
	A_i_tb=16'h99A7; B_i_tb=16'h8FF2; Ci_i=0;
	#10 test_result(16'h2999, 1);             //340ns

	//0FFF + 987E + 0
	A_i_tb=16'h8F2B; B_i_tb=16'h7EA2; Ci_i=1;
	#10 test_result(16'h0DCE, 1);             //350ns

	//0FFF + 987E + 0
	A_i_tb=16'h0FFF; B_i_tb=16'h987E; Ci_i=0;
	#10 test_result(16'hA87D, 0);             //360ns


end

endmodule