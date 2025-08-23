module ControlPath_tb;

logic clk, rst;
logic [1:0] N_i;
logic boot_o, muxes_o, ready_o, wr_root_o, wr_square_o, root_o;

ControlPath DUV (
    .clk        ( clk         ),
    .rst        ( rst         ),
    .N_i        ( N_i         ),
    .boot_o     ( boot_o      ),
    .muxes_o    ( muxes_o     ),
    .ready_o    ( ready_o     ),
    .wr_root_o  ( wr_root_o   ),
    .wr_square_o( wr_square_o ),
    .root_o     ( root_o      )
);

task test_result (
        input logic boot_exp, muxes_exp, wr_root_exp, wr_square_exp, root_exp, ready_exp,
        input string currentstate
    ); begin

		$display(  "| N2=%b N1=%b | boot=%b  muxes=%b ready=%b wr_root=%b wr_square=%b root=%b | %s | %0d",
                    	 N_i[1], N_i[0], boot_o, muxes_o, ready_o, wr_root_o, wr_square_o,root_o,currentstate, $time);

            if(boot_o !== boot_exp)
                print_error($sformatf("%s should be %h at time %0d", "boot", boot_exp, $time ));
            else if(muxes_o !== muxes_exp)
                print_error($sformatf("%s should be %b at time %0d", "muxes", muxes_exp, $time ));
            else if(ready_o !== ready_exp)
                print_error($sformatf("%s should be %b at time %0d", "ready", ready_exp, $time ));
            else if(wr_root_o !== wr_root_exp)
                print_error($sformatf("%s should be %b at time %0d", "wr_root", wr_root_exp, $time ));
            else if(wr_square_o !== wr_square_exp)
                print_error($sformatf("%s should be %b at time %0d", "wr_square", wr_square_exp, $time ));
            else if(root_o !== root_exp)
                print_error($sformatf("%s should be %b at time %0d", "root", root_exp, $time ));
        end
    endtask

    task print_error (input string message); begin
			
            $display(  "+-----------+------------------------------------------------------+----+------------+");
            $display(  "|                                    TEST FAILED!! ");
            $display(  "|  %s", message);
            $display(  "+-------------------------------------------------------------------------------------\n\n");
            $finish;
        end
    endtask

always #5 clk <= ~clk;

initial begin

	$display("\n+-----------+------------------------------------------------------+----+------------+");
    $display(  "|   INPUTS  |                         OUTPUTS                      |    |    TIME    |");
    $display(  "+-----------+------------------------------------------------------+----+------------+");
	
    //  boot_exp, muxes_exp, wr_root_exp, wr_square_exp, root_exp, ready_exp

    clk = 0; rst = 1; N_i[1] = 0; N_i[0] = 0;
    #1 rst=0;                 test_result(1,'x,1,1,'x,1,"S0");    // 1ns
    #1 N_i[1]=0; N_i[0]=1;    test_result(1,'x,1,1,'x,1,"S0");    // 2ns
    #1 N_i[1]=1; N_i[0]=0;    test_result(1,'x,1,1,'x,1,"S0");    // 3ns
    #1 N_i[1]=1; N_i[0]=1;    test_result(1,'x,1,1,'x,1,"S0");    // 4ns 
    #1 N_i[1]=0; N_i[0]=0; #1 test_result(0,1 ,1,0,'x,1,"S1");    // 6ns 
    #1 N_i[1]=0; N_i[0]=1; #1 test_result(0,1 ,0,0,0 ,0,"S1");    // 8ns 
    #1 N_i[1]=1; N_i[0]=0; #1 test_result(0,1 ,0,0,1 ,0,"S1");    // 10ns 
    #1 N_i[1]=1; N_i[0]=1; #1 test_result(0,1 ,0,0,0 ,0,"S1");    // 12ns 
    #1 N_i[1]=0; N_i[0]=0; #3 test_result(0,0 ,0,1,'x,1,"S2");    // 16ns 
    #1 N_i[1]=0; N_i[0]=1; #1 test_result(0,0 ,0,1,'x,1,"S2");    // 18ns
    #1 N_i[1]=1; N_i[0]=0; #1 test_result(0,0 ,0,1,'x,1,"S2");    // 20ns 
    #1 N_i[1]=1; N_i[0]=1; #1 test_result(0,0 ,0,1,'x,1,"S2");    // 22ns
    #1 N_i[1]=0; N_i[0]=0; #3 test_result(0,1 ,1,0,'x,1,"S1");    // 26ns
    #1 N_i[1]=0; N_i[0]=1; #9 test_result(0,1 ,0,0,0 ,0,"S1");    // 36ns


    





	$display("+-----------+------------------------------------------------------+----+------------+");
    $display("|                                       TEST PASSED                                  |");
    $display("+------------------------------------------------------------------------------------+\n\n");

	$finish;
end
endmodule