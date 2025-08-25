module Top_tb;

parameter CLOCK_PERIOD = 2;

logic clk, rst_n, ready;
logic [15:0] valor;
logic [7:0] root;

Top DUV (
    .valor_i(valor),
    .clk(clk),
    .rst_n(rst_n),
    .ready_o(ready),
    .root_o(root)
);


task test_result (
        input logic ready_exp,
        input logic [7:0] root_exp
    ); begin

		$display(  "| valor  = %b = %0d\n
                    | root   = %b %0d\n
                    | ready = %b\n
                    | Cicles = %0d\n
                    | time   = %0d\n
                    +----------------------------------------------",
                    valor, valor, root, root, ready, cicles, $time);

            if(ready !== ready_exp)
                print_error($sformatf("%s should be %h at time %0d", "ready", ready_exp, $time ));
            else if(root !== root_exp)
                print_error($sformatf("%s should be %b at time %0d", "root", root_exp, $time ));
        end
    endtask

    task print_error (input string message); begin
            $display(  "|                  TEST FAILED!! ");
            $display(  "|  %s", message);
            $display(  "+----------------------------------------------\n\n");
        end
    endtask

    task finished;
        $display("|             TEST FINISHED");
        $display("+----------------------------------------------\n");
        $finish;
    endtask

always #CLOCK_PERIOD/2 clk <= ~clk;

logic [10:0] cicles;
logic [16:0] inputs, outputs, temp;
logic [1:0] temp2;
always@(posedge clk, negedge rst_n) begin
    if(rst_n == 0)
        cicles <= 0;
    else if(ready == 1) 
        cicles <= cicles + 1;
    else begin
        temp2 = $fscanf(outputs, "%d\n", temp);
        if(temp2!=1)
            finished();
        test_result(0, temp); 
        #CLOCK_PERIOD/5
        $fscanf(inputs, "%d\n", valor);
        rst_n=0;
        #CLOCK_PERIOD/5
        rst_n=1;
    end
end


initial begin

	$display("\n+----------------------------------------------");
    $display(  "|             TEST STARTED");
    $display(  "+----------------------------------------------");
	
    //  boot_exp, muxes_exp, wr_root_exp, wr_square_exp, root_exp, ready_exp

    clk = 0; rst_n = 0; valor=16'd65535; 
    #(6*CLOCK_PERIOD)/5
    rst_n=1;

    inputs = $fopen("../Testbenchs/input_vector.txt", "r");
    if(inputs == 0) begin
        $display("\nERROR IN THE INPUT TEST VECTOR LOAD!!");
        $finish;
    end

    outputs = $fopen("../Testbenchs/output_vector.txt", "r");
    if(outputs == 0) begin
        $display("\nERROR IN THE OUTPUT TEST VECTOR LOAD!!");
        $finish;
    end
    
end
endmodule