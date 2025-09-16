

module DataPath (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [15:0] input_i,
    output wire [7:0]  root_o,
    output wire        ready_o,

    // Control signals
    input  wire wr_input_i,
    input  wire en_pipe_i,
    input  wire ready_i,
    input  wire mux_root_i,

    // Flags
    output wire N_o
);

// ####################################
// ###       INTERNAL SIGNALS       ###
// ####################################

wire        const_one_s;
wire        const_zero_s;
wire        carry_unused1_s;
wire        carry_unused2_s;

// STAGE 1
wire [15:0] S1_o_input_s;
wire [16:0] S1_o_square_s;
wire [7:0]  S1_o_root_s;

wire [16:0] S1_input_ext_s;
wire [16:0] S1_root_shifted_s;

wire [8:0]  S1_input_h_s;
wire [7:0]  S1_input_l_s;
wire [8:0]  S1_square_h_s;
wire [7:0]  S1_square_l_s;
wire [4:0]  S1_A_l_s;
wire [11:0] S1_A_h_s;
wire [4:0]  S1_B_l_s;
wire [11:0] S1_B_h_s;
wire [3:0]  S1_root_l_s;
wire [3:0]  S1_root_h_s;
wire        S1_not_mux_root;
wire [3:0]  S1_root_B_s;

wire [1:0]  S1_feedback_s;
wire [4:0]  S1_square_sum_s;
wire        S1_co_square_s;
wire [3:0]  S1_root_sum_s;
wire        S1_co_root_s;
//wire        S1_N_s;

// STAGE 2
wire [4:0]  S2_o_square_s;
wire        S2_o_co_square_s;
wire [11:0] S2_o_A_s;
wire [11:0] S2_o_B_s;
wire [3:0]  S2_o_root_s;
wire        S2_o_co_root_s;
wire [3:0]  S2_o_root_h_s;
wire [1:0]  S2_o_feedback_s;
wire [7:0]  S2_o_input_s;
wire [7:0]  S2_o_square_c_s;

wire [3:0]  S2_A_l_s;
wire [7:0]  S2_A_h_s;
wire [3:0]  S2_B_l_s;
wire [7:0]  S2_B_h_s;
wire [3:0]  S2_root_B_s;

wire        S2_N_s;
wire [3:0]  S2_square_sum_s;
wire [8:0]  S2_square_s;
wire [3:0]  S2_root_sum_s;
wire [7:0]  S2_root_s;
wire        S2_co_square_s;



// STAGE 3
wire [8:0]  S3_o_square_s;
wire        S3_o_co_square_s;
wire [7:0]  S3_o_A_s;
wire [7:0]  S3_o_B_s;

wire [3:0]  S3_A_l_s;
wire [3:0]  S3_A_h_s;
wire [3:0]  S3_B_l_s;
wire [3:0]  S3_B_h_s;

wire        S3_co_square_s;
wire [3:0]  S3_square_sum_s;
wire [12:0] S3_square_s;


// STAGE 4
wire [12:0] S4_o_square_s;
wire        S4_o_co_square_s;
wire [3:0]  S4_o_A_s;
wire [3:0]  S4_o_B_s;

wire [3:0]  S4_square_sum_s;
wire [16:0] S4_square_s;




// ####################################
// ###  INSTATIATION OF COMPONENTS  ###
// ####################################

assign const_one_s = 1'b1;
assign const_zero_s = 1'b0;

Stage1 PIPELINE_STAGE1 (
    .clk           ( clk                ),
    .rst_n         ( rst_n              ),
    .en_pipe_i     ( en_pipe_i          ),
    .wr_input_i    ( wr_input_i         ),
    .input_i       ( input_i            ),
    .square_i      ( S4_square_s        ),
    .root_i        ( S2_root_s          ),
    .input_o       ( S1_o_input_s       ),
    .square_o      ( S1_o_square_s      ),
    .root_o        ( S1_o_root_s        )
);


assign S1_input_ext_s    = {1'b0, S1_o_input_s};
assign S1_root_shifted_s = {6'b000000, S1_o_root_s, 3'b111}; //root<<3 + 7
assign S1_A_l_s          = S1_o_square_s[4:0];
assign S1_A_h_s          = S1_o_square_s[16:5];
assign S1_B_l_s          = S1_root_shifted_s[4:0];
assign S1_B_h_s          = S1_root_shifted_s[16:5];
assign S1_root_l_s       = S1_o_root_s[3:0]; 
assign S1_root_h_s       = S1_o_root_s[7:4];
assign S1_not_mux_root   = ~mux_root_i;
assign S1_root_B_s       = {mux_root_i, mux_root_i, S1_not_mux_root, 1'b0};
 

Comparator COMPARATOR (
    .A_i             ( S1_input_ext_s ),
    .B_i             ( S1_o_square_s  ),
    .A_less_than_B_o ( S1_N_s         )
);


CLA #(
    .WIDTH(5)
) S1_SQUARE_ADDER (
    .A_i  ( S1_A_l_s        ),
    .B_i  ( S1_B_l_s        ),
    .Ci_i ( const_one_s     ),
    .S_o  ( S1_square_sum_s ),
    .Co_o ( S1_co_square_s  )
);

// S1_A_h_s
// S1_B_h_s

CLA #(
    .WIDTH(4)
) S1_ROOT_ADDER (
    .A_i  ( S1_root_l_s   ),
    .B_i  ( S1_root_B_s   ),
    .Ci_i ( const_zero_s  ),
    .S_o  ( S1_root_sum_s ),
    .Co_o ( S1_co_root_s  )
);

// S1_root_h_s





Stage2 PIPELINE_STAGE2 (
    .clk             ( clk              ),
    .rst_n           ( rst_n            ),
    .en_pipe_i       ( en_pipe_i        ),
    .S2_N_i          ( S1_N_s           ),
    .S2_square_sum_i ( S1_square_sum_s  ),
    .S2_Co_square_i  ( S1_co_square_s   ),
    .S2_A_high_i     ( S1_A_h_s         ),
    .S2_B_high_i     ( S1_B_h_s         ),
    .S2_root_sum_i   ( S1_root_sum_s    ),
    .S2_Co_root_i    ( S1_co_root_s     ),
    .S2_root_high_i  ( S1_root_h_s      ),

    .S2_N_o          ( N_o              ),
    .S2_square_sum_o ( S2_o_square_s    ),
    .S2_Co_square_o  ( S2_o_co_square_s ),
    .S2_A_high_o     ( S2_o_A_s         ),
    .S2_B_high_o     ( S2_o_B_s         ),
    .S2_root_sum_o   ( S2_o_root_s      ),
    .S2_Co_root_o    ( S2_o_co_root_s   ),
    .S2_root_high_o  ( S2_o_root_h_s    )
);

assign S2_A_l_s    = S2_o_A_s[3:0];
assign S2_A_h_s    = S2_o_A_s[11:4];
assign S2_B_l_s    = S2_o_B_s[3:0];
assign S2_B_h_s    = S2_o_B_s[11:4];
assign S2_root_B_s = {4{mux_root_i}}; 

CLA #(
    .WIDTH(4)
) S2_SQUARE_ADDER (
    .A_i  ( S2_A_l_s         ),
    .B_i  ( S2_B_l_s         ),
    .Ci_i ( S2_o_co_square_s ),
    .S_o  ( S2_square_sum_s  ),
    .Co_o ( S2_co_square_s   )
);

// S2_A_h_s
// S2_B_h_s

CLA #(
    .WIDTH(4)
) S2_ROOT_ADDER (
    .A_i  ( S2_o_root_h_s   ),
    .B_i  ( S2_root_B_s     ),
    .Ci_i ( S2_o_co_root_s  ),
    .S_o  ( S2_root_sum_s   ),
    .Co_o ( carry_unused1_s )
);


assign S2_square_s = { S2_square_sum_s, S2_o_square_s };
assign S2_root_s   = { S2_root_sum_s, S2_o_root_s };




Stage3 PIPELINE_STAGE3 (
    .clk             ( clk              ),
    .rst_n           ( rst_n            ),
    .en_pipe_i       ( en_pipe_i        ),
    .S3_square_sum_i ( S2_square_s      ),
    .S3_Co_square_i  ( S2_co_square_s   ),
    .S3_A_high_i     ( S2_A_h_s         ),
    .S3_B_high_i     ( S2_B_h_s         ),
 
    .S3_square_sum_o ( S3_o_square_s    ),
    .S3_Co_square_o  ( S3_o_co_square_s ),
    .S3_A_high_o     ( S3_o_A_s         ),
    .S3_B_high_o     ( S3_o_B_s         )
);


assign S3_A_l_s = S3_o_A_s[3:0];
assign S3_A_h_s = S3_o_A_s[7:4];
assign S3_B_l_s = S3_o_B_s[3:0];
assign S3_B_h_s = S3_o_B_s[7:4];

CLA #(
    .WIDTH(4)
) S3_SQUARE_ADDER (
    .A_i  ( S3_A_l_s         ),
    .B_i  ( S3_B_l_s         ),
    .Ci_i ( S3_o_co_square_s ),
    .S_o  ( S3_square_sum_s  ),
    .Co_o ( S3_co_square_s   )
);

// S2_A_h_s
// S2_B_h_s

assign S3_square_s = { S3_square_sum_s, S3_o_square_s};




Stage4 PIPELINE_STAGE4 (
    .clk             ( clk              ),
    .rst_n           ( rst_n            ),
    .en_pipe_i       ( en_pipe_i        ),
    .S4_ready_i      ( ready_i          ),
    .S4_square_sum_i ( S3_square_s      ),
    .S4_Co_square_i  ( S3_co_square_s   ),
    .S4_A_high_i     ( S3_A_h_s         ),
    .S4_B_high_i     ( S3_B_h_s         ),

    .S4_ready_o      ( ready_o          ),
    .S4_square_sum_o ( S4_o_square_s    ),
    .S4_Co_square_o  ( S4_o_co_square_s ),
    .S4_A_high_o     ( S4_o_A_s         ),
    .S4_B_high_o     ( S4_o_B_s         )
);


CLA #(
    .WIDTH(4)
) S4_SQUARE_ADDER (
    .A_i  ( S4_o_A_s         ),
    .B_i  ( S4_o_B_s         ),
    .Ci_i ( S4_o_co_square_s ),
    .S_o  ( S4_square_sum_s  ),
    .Co_o ( carry_unused2_s  )
);

assign S4_square_s = {S4_square_sum_s, S4_o_square_s};
assign root_o = S1_o_root_s;

endmodule