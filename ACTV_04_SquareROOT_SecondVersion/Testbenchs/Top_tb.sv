module Top_tb;

parameter CLOCK_PERIOD =10;

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

int errors = 0;
int tests = 1;

task test_result (
        input logic ready_exp,
        input logic [7:0] root_exp
    ); begin

		$display(  "| valor  = %b = %0d\n| root   = %b         = %0d\n| Cicles = %0d\n+----------------------------------------------",
                    valor, valor, root, root, cicles);

            if(ready !== ready_exp)
                print_error($sformatf("%s should be %h at time %0d", "ready", ready_exp, $time ));
            else if(root !== root_exp)
                print_error($sformatf("%s should be %b(%0d) at time %0d", "root", root_exp,root_exp, $time ));
        end
    endtask

    task print_error (input string message); begin
            errors = errors + 1;
            $display(  "|                  TEST FAILED!! ");
            $display(  "|  %s", message);
            $display(  "+----------------------------------------------\n");
        end
    endtask

    task finished;
        $display("|             TEST FINISHED");
        $display("| Number of tests : %0d", tests);
        $display("| Number of errors: %0d", errors);
        $display("+----------------------------------------------\n");
        $finish;
    endtask

always #(CLOCK_PERIOD/2) clk <= ~clk;

logic [10:0] cicles;
logic [16:0] inputs, outputs, temp;
int temp2;
logic ready_reg;


always@(ready)begin
    $fscanf(inputs, "%d\n", valor);

    #(CLOCK_PERIOD/10)
    test_result(0, temp); 
    #(CLOCK_PERIOD/20)
    rst_n=0;

    #(CLOCK_PERIOD)
    temp2 = $fscanf(outputs, "%d\n", temp);

    if(temp2!=1) begin
        finished();
    end
    rst_n=1;
    tests = tests + 1;
end


always@(posedge clk, negedge rst_n) begin
    if(rst_n == 0)
        cicles <= 0;
    else if(ready == 1) begin
        cicles <= cicles + 1;
    end
    ready_reg <= ready;
end


initial begin

	$display("\n+----------------------------------------------");
    $display(  "|             TEST STARTED");
    $display(  "+----------------------------------------------");
	
    //  boot_exp, muxes_exp, wr_root_exp, wr_square_exp, root_exp, ready_exp

    clk = 0; rst_n = 0; valor=16'd65535; temp=8'd255;
    #((6*CLOCK_PERIOD)/5)
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