/*
    +------+--------+-------------+------+------+------+------+-------+
    | bits | layers | fan out max | 4 in | 3 in | 2 in | 1 in | gates |
    +------+--------+-------------+------+------+------+------+-------+
    |  1   |   3    |     3       |  0   |  0   |  6   |  1   |  7    |
    |  2   |   4    |     3       |  0   |  2   |  11  |  2   |  15   |
    |  3   |   4    |     4       |  2   |  3   |  16  |  3   |  24   |
    |  4   |   5    |     5       |  3   |  6   |  28  |  4   |  41   |
    |  5   |   5    |     8       |  5   |  10  |  36  |  4   |  55   |
    |  6   |   6    |     11      |  9   |  13  |  45  |  4   |  71   |
    |  7   |   6    |     11      |  13  |  18  |  59  |  4   |  94   |
    |  8   |   6    |     11      |  14  |  29  |  70  |  4   |  117  |
    |  9   |   6    |     13      |  17  |  41  |  80  |  4   |  142  |
    |  10  |   6    |     14      |  22  |  52  |  91  |  4   |  169  |
    |  11  |   6    |     15      |  30  |  59  |  104 |  4   |  197  |
    |  12  |   6    |     18      |  40  |  67  |  116 |  4   |  227  |
    |  13  |   6    |     20      |  51  |  76  |  129 |  4   |  260  |
    |  14  |   6    |     22      |  64  |  83  |  142 |  4   |  293  |
    |  15  |   6    |     25      |  79  |  93  |  155 |  4   |  331  |
    |  16  |   7    |     25      |  92  |  105 |  177 |  4   |  378  |
    |  17  |   7    |     25      |  106 |  116 |  202 |  4   |  428  |
    +------+--------+-------------+------+------+------+------+-------+
*/

module Carry_Look_Ahead #(
    parameter WIDTH = 17
)(
    input  wire clk_i,
    input  wire rst_i,
    input  wire [WIDTH-1:0] A_i,
    input  wire [WIDTH-1:0] B_i,
    input  wire             Ci_i,
    output wire [WIDTH-1:0] S_o,
    output wire             Co_o
);

// Internal signals
wire pn[WIDTH-1:0];
wire gn[WIDTH-1:0];
wire g[WIDTH-1:0];
wire p[WIDTH-1:0];
wire c[WIDTH:0];
wire t[423:0]; // temporary nets

//######### Carries logic #########

assign Co_o = c[WIDTH];

generate
wire t2[423:0];
    

    // Carry 0
    assign c[0]  = Ci_i;

    // Carry 1 (3 layers)
    and  and2_1 (g[0],   A_i[0], B_i[0]); // g function
    xnor xnor2_1(pn[0],  A_i[0], B_i[0]); // pn function
    xor  xor2_1 (p[0],   A_i[0], B_i[0]); // p function
    xnor xnor2_2(S_o[0], pn[0],  c[0]);   // S output

    nand nand2_1 (t[0], p[0], c[0]);
    not  not_1   (t2[0], g[0]);
    nand nand2_2 (c[1], t[0], t2[0]);


    // Carry 2 (3 layers)
    if(WIDTH >= 2) begin

        and  and2_2 (g[1],   A_i[1], B_i[1]); // g function
        xnor xnor2_3(pn[1],  A_i[1], B_i[1]); // pn function
        xor  xor2_2 (p[1],   A_i[1], B_i[1]); // p function
        xnor xnor2_4(S_o[1], pn[1],  c[1]);   // S output

        nand nand3_1(t[1], p[1], p[0], c[0]);
        nand nand2_3(t[2], p[1], g[0]);
        not  not_2  (t2[1], g[1]);
        nand nand3_2(c[2], t2[1], t[2], t[1]);
    end

    // Carry 3 (3 layers)
    if(WIDTH >= 3) begin
        and  and2_3 (g[2],   A_i[2], B_i[2]); // g function
        xnor xnor2_5(pn[2],  A_i[2], B_i[2]); // pn function
        xor  xor2_3 (p[2],   A_i[2], B_i[2]); // p function
        xnor xnor2_6(S_o[2], pn[2],  c[2]);   // S output

        nand nand4_1(t[3], p[2], p[1], p[0], c[0]);
        nand nand3_3(t[4], p[2], p[1], g[0]);
        nand nand2_4(t[5], p[2], g[1]);
        not  not_3  (t2[2], g[2]);
        nand nand4_2(c[3], t2[2], t[5], t[4], t[3]);
    end

    // Carry 4 (4 layers)
    if(WIDTH >= 4) begin

        nand nand2_5(gn[0],  A_i[0], B_i[0]);  // gn function
        nand nand2_6(gn[1],  A_i[1], B_i[1]);  // gn function
        nand nand2_7(gn[2],  A_i[2], B_i[2]);  // gn function
        nand nand2_8(gn[3],  A_i[3], B_i[3]);  // gn function
        and  and2_4 (g[3],   A_i[3], B_i[3]);  // g function
        xnor xnor2_7(pn[3],  A_i[3], B_i[3]);  // pn function
        xnor xnor2_8(S_o[3], pn[3],  c[3]);    // S output

        not  not_4  (t2[3], c[0]);                // !C_in
        nor  nor3_1 (t[6], pn[3], pn[2], pn[1]);
        nor  nor2_1 (t[7], pn[0], t2[3]);
        nand nand2_9(t2[4], t[6], t[7]);
        nor  nor4_1 (t[8], pn[3], pn[2], pn[1], gn[0]);
        nor  nor3_2 (t[9], pn[3], pn[2], gn[1]);
        nor  nor2_2 (t[10], pn[3], gn[2]);
        nor  nor2_3 (t[11], t[8], t[9]);
        nor  nor2_4 (t2[5], t[10], g[3]);
        nand nand3_4(c[4], t2[4], t[11], t2[5]);
    end

    // Carry 5 (4 layers)
    if(WIDTH >= 5) begin

        nand nand2_10(gn[4],  A_i[4], B_i[4]); // gn function
        and  and2_5  (g[4],   A_i[4], B_i[4]); // g function
        xnor xnor2_9 (pn[4],  A_i[4], B_i[4]); // pn function
        xnor xnor2_10(S_o[4], pn[4],  c[4]);   // S output

        nor  nor3_3  (t[12], pn[4], pn[3], pn[2]);
        nor  nor3_4  (t[13], pn[1], pn[0], t2[3]);
        nand nand2_11(t2[6], t[12], t[13]);
        nor  nor2_5  (t[14], pn[1], gn[0]);
        nand nand2_12(t2[7], t[12], t[14]);
        nor  nor4_2  (t[15], pn[4], pn[3], pn[2], gn[1]);
        nor  nor3_6  (t[16], pn[4], pn[3], gn[2]);
        nor  nor2_6  (t[17], pn[4], gn[3]);
        nor  nor4_3  (t[18], t[15], t[16], t[17], g[4]);
        nand nand3_5 (c[5], t2[6], t2[7], t[18]);
    end

    // Carry 6 (4 layers)
    if(WIDTH >= 6) begin

        nand nand2_13(gn[5],  A_i[5], B_i[5]);  // gn function
        and  and2_6  (g[5],   A_i[5], B_i[5]);  // g function
        xnor xnor2_11(pn[5],  A_i[5], B_i[5]);  // pn function
        xnor xnor2_12(S_o[5], pn[5],  c[5]);    // S output

        nor  nor3_7  (t[19], pn[5], pn[4], pn[3]);
        nor  nor4_4  (t[20], pn[2], pn[1], pn[0], t2[3]);
        nand nand2_14(t[21], t[19], t[20]);
        nor  nor3_8  (t[22], pn[2], pn[1], gn[0]);
        nand nand2_15(t[23], t[19], t[22]);
        nor  nor2_7  (t[24], pn[2], gn[1]);
        nand nand2_16(t[25], t[19], t[24]);
        nor  nor4_5  (t[26], pn[5], pn[4], pn[3], gn[2]);
        nor  nor3_9  (t[27], pn[5], pn[4], gn[3]);
        nor  nor2_8   (t[28], pn[5], gn[4]);
        nor  nor4_6  (t[29], t[26], t[27], t[28], g[5]);
        nand nand4_3 (c[6], t[21], t[23], t[25], t[29]);
    end

    // Carry 7 (5 layers)
    if(WIDTH >= 7) begin

        xor  xor2_4  (p[3], A_i[3], B_i[3]); // p functio
        xor  xor2_5  (p[4], A_i[4], B_i[4]); // p function
        xor  xor2_6  (p[5], A_i[5], B_i[5]); // p function
        xor  xor2_7  (p[6], A_i[6], B_i[6]); // p function
        and  and2_7  (g[6],   A_i[6], B_i[6]);  // g function
        xnor xnor2_13(pn[6],  A_i[6], B_i[6]);  // pn function
        xnor xnor2_14(S_o[6], pn[6],  c[6]);    // S output

        nand nand4_4 (t[30], p[6], p[5], p[4], p[3]);
        nand nand4_5 (t[31], p[2], p[1], p[0], c[0]);
        nor  nor2_9  (t[32], t[30], t[31]);
        nand nand3_5 (t[33], p[2], p[1], g[0]);
        nor  nor2_10  (t[34], t[30], t[33]);
        nand nand2_17(t[35], p[2], g[1]);
        nor  nor2_11 (t[36], t[30], t[35]); 
        nor  nor2_12 (t[37], t[30], gn[2]);
        nand nand4_6 (t[38], p[6], p[5], p[4], g[3]);
        nand nand3_6(t[39], p[6], p[5], g[4]);
        nand nand2_18(t[40], p[6], g[5]);
        nand nand3_7 (t[41], t[38], t[39], t[40]);
        nor  nor3_10 (t[42], t[32], t[34], t[36]);
        nor  nor3_11 (t[43], t[37], t[41], g[6]);
        nand nand2_19(c[7], t[42], t[43]);
    end

    // Carry 8 (5 layers)
    if(WIDTH >= 8) begin

        xor  xor2_8  (p[7],   A_i[7], B_i[7]);  // p function
        and  and2_8  (g[7],   A_i[7], B_i[7]);  // g function
        xnor xnor2_15(pn[7],  A_i[7], B_i[7]);  // pn function
        nand nand2_20(gn[6],  A_i[6], B_i[6]);  // gn function
        xnor xnor2_16(S_o[7], pn[7],  c[7]);    // S output

        nand nand4_7 (t[44], p[7], p[6], p[5], p[4]);
        nand nand3_8 (t[45], p[3], p[2], p[1]);
        nand nand2_21(t[46], p[0], c[0]);
        nor  nor3_12 (t[47], t[44], t[45], t[46]);
        nor  nor3_13 (t[48], t[44], t[45], gn[0]);
        nand nand3_9 (t[49], p[3], p[2], g[1]);
        nor  nor2_13 (t[50], t[44], t[49]);
        nand nand3_10(t[51], p[7], p[6], p[5]);
        nand nand3_11(t[52], p[4], p[3], g[2]);
        nor  nor2_14 (t[53], t[51], t[52]);
        nand nand2_22(t[54], p[4], g[3]);
        nor  nor2_15 (t[55], t[51], t[54]);
        nor  nor4_7 (t[56], pn[7], pn[6], pn[5], gn[4]);
        nor  nor3_14(t[57], pn[7], pn[6], gn[5]);
        nor  nor2_16(t[58], pn[7], gn[6]);
        nor  nor3_15 (t[59], t[47], t[48], t[50]);
        nor  nor3_16 (t[60], t[53], t[55], t[56]);
        nor  nor3_17 (t2[8], t[57], t[58], g[7]);
        nand nand3_12(c[8], t[59], t[60], t2[8]);
    end

    // Carry 9 (5 layers)
    if(WIDTH >= 9) begin

        xor  xor2_9  (p[8],   A_i[8], B_i[8]);  // p function
        and  and2_9  (g[8],   A_i[8], B_i[8]);  // g function
        xnor xnor2_17(pn[8],  A_i[8], B_i[8]);  // pn function
        nand nand2_23(gn[7],  A_i[7], B_i[7]);  // gn function
        xnor xnor2_18(S_o[8], pn[8],  c[8]);    // S output

        nand nand4_8 (t[61], p[8], p[7], p[6], p[5]);
        nand nand3_13(t[62], p[4], p[3], p[2]);
        nand nand3_14(t[63], p[1], p[0], c[0]);
        nor  nor3_18 (t[64], t[61], t[62], t[63]);
        nand nand2_24(t[65], p[1], g[0]);
        nor  nor3_19 (t[66], t[61], t[62], t[65]);
        nor  nor3_20 (t[67], t[61], t[62], gn[1]);
        nand nand3_15(t[68], p[4], p[3], g[2]);
        nor  nor2_17 (t[69], t[61], t[68]);
        nand nand3_16(t[70], p[8], p[7], p[6]);
        nand nand3_17(t[71], p[5], p[4], g[3]);
        nor  nor2_18 (t[72], t[70], t[71]);
        nand nand2_25(t[73], p[5], g[4]);
        nor  nor2_19 (t[74], t[70], t[73]);
        nor  nor4_8  (t[75], pn[8], pn[7], pn[6], gn[5]);
        nor  nor3_21 (t[76], pn[8], pn[7], gn[6]);
        nor  nor2_20 (t[77], pn[8], gn[7]);
        nor  nor3_22 (t[78], t[64], t[66], t[67]);
        nor  nor3_23 (t[79], t[69], t[72], t[74]);
        nor  nor4_9  (t[80], t[75], t[76], t[77], g[8]);
        nand nand3_18(c[9], t[78], t[79], t[80]);
    end

    // Carry 10 (5 layers)
    if(WIDTH >= 10) begin

        xor  xor2_10  (p[9],   A_i[9], B_i[9]);  // p function
        and  and2_10   (g[9],   A_i[9], B_i[9]);  // g function
        xnor xnor2_19(pn[9],  A_i[9], B_i[9]);  // pn function
        nand nand2_26(gn[8],  A_i[8], B_i[8]);  // gn function
        xnor xnor2_20(S_o[9], pn[9],  c[9]);    // S output

        nand nand4_9 (t[81], p[9], p[8], p[7], p[6]);
        nand nand3_19(t[82], p[5], p[4], p[3]);
        nand nand4_10(t[83], p[2], p[1], p[0], c[0]);
        nor  nor3_24 (t[84], t[81], t[82], t[83]);
        nand nand3_20(t[85], p[2], p[1], g[0]);
        nor  nor3_25 (t[86], t[81], t[82], t[85]);
        nand nand2_27(t[87], p[2], g[1]);
        nor  nor3_26 (t[88], t[81], t[82], t[87]);
        nor  nor3_27 (t[90], t[81], t[82], gn[2]);
        nand nand3_21(t[91], p[5], p[4], g[3]);
        nor  nor2_21 (t[92], t[81], t[91]);
        nand nand3_22(t[93], p[9], p[8], p[7]);
        nand nand3_23(t[94], p[6], p[5], g[4]);
        nor  nor2_22 (t[95], t[93], t[94]);
        nand nand2_28(t[96], p[6], g[5]);
        nor  nor2_23 (t[97], t[93], t[96]);
        nor  nor4_10 (t[98], pn[9], pn[8], pn[7], gn[6]);
        nor  nor3_28 (t[99], pn[9], pn[8], gn[7]);
        nor  nor2_24 (t[100], pn[9], gn[8]);
        nor  nor3_29 (t[101], t[84], t[86], t[88]);
        nor  nor4_11 (t[102], t[90], t[92], t[95], t[97]);
        nor  nor4_12 (t[103], t[98], t[99], t[100], g[9]);
        nand nand3_24(c[10], t[101], t[102], t[103]);

    end

    // Carry 11 (5 layers)
    if(WIDTH >= 11) begin

        xor  xor2_11 (p[10],   A_i[10], B_i[10]);  // p function
        xnor xnor2_21(pn[10],  A_i[10], B_i[10]);  // pn function
        xnor xnor2_22(S_o[10], pn[10],  c[10]);    // S output
        and  and2_11 (g[10],   A_i[10], B_i[10]);  // g function
        nand nand2_26(gn[9],   A_i[9],  B_i[9]);   // gn function
        
        nand nand4_11(t[104], p[10], p[9], p[8], p[7]);
        nand nand4_12(t[105], p[6], p[5], p[4], p[3]);
        nand nand4_13(t[106], p[2], p[1], p[0], c[0]);
        nor  nor2_25 (t[107], t[104], t[105], t[106]);
        nand nand3_25(t[108], p[2], p[1], g[0]);
        nor  nor3_29 (t[109], t[104], t[105], t[108]);
        nand nand2_29(t[110], p[2], g[1]);
        nor  nor3_30 (t[111], t[104], t[105], t[110]);
        nor  nor3_31 (t[112], t[104], t[105], gn[2]);
        nand nand4_14(t[113], p[6], p[5], p[4], g[3]);
        nor  nor2_26 (t[114], t[104], t[113]);
        nand nand3_26(t[115], p[6], p[5], g[4]);
        nor  nor2_27 (t[116], t[104], t[115]);
        nand nand2_30(t[117], p[6], g[5]);
        nor  nor2_28 (t[118], t[104], t[117]);
        nor  nor2_29 (t[119], t[104], gn[6]);
        nor  nor4_13 (t[120], pn[10], pn[9], pn[8], gn[7]);
        nor  nor3_32 (t[121], pn[10], pn[9], gn[8]);
        nor  nor2_30 (t[122], pn[10], gn[9]);
        nor  nor4_14 (t[123], t[107], t[109], t[111], t[112]);
        nor  nor4_15 (t[124], t[114], t[116], t[118], t[119]);
        nor  nor4_16 (t[125], t[120], t[121], t[122], g[10]);
        nand nand3_27(c[11], t[123], t[124], t[125]);
    end
    
    // Carry 12 (5 layers)
    if(WIDTH >= 12) begin

        xor  xor2_12 (p[11],   A_i[11], B_i[11]);  // p function
        xnor xnor2_23(pn[11],  A_i[11], B_i[11]);  // pn function
        xnor xnor2_24(S_o[11], pn[11],  c[11]);    // S output
        and  and2_12 (g[11],   A_i[11], B_i[11]);  // g function
        nand nand2_21(gn[10],   A_i[10],  B_i[10]);   // gn function
        
        nand nand4_15(t[126], p[11], p[10], p[9], p[8]);
        nand nand4_16(t[127], p[7], p[6], p[5], p[4]);
        nand nand4_17(t[128], p[3], p[2], p[1], p[0]);
        nor  nor4_17 (t[130], t[126], t[127], t[128], t2[3]);
        nand nand4_18(t[131], p[3], p[2], p[1], g[0]);
        nor  nor3_33 (t[132], t[126], t[127], t[131]);
        nand nand3_28(t[133], p[3], p[2], g[1]);
        nor  nor3_34 (t[134], t[126], t[127], t[133]);
        nand nand2_31(t[135], p[3], g[2]);
        nor  nor3_35 (t[136], t[126], t[127], t[135]);
        nor  nor3_36 (t[137], t[126], t[127], gn[3]);
        nand nand4_19(t[139], p[7], p[6], p[5], g[4]);
        nor  nor2_30 (t[140], t[126], t[139]);
        nand nand3_29(t[141], p[7], p[6], g[5]);
        nor  nor2_31 (t[142], t[126], t[141]);
        nand nand2_32(t[143], p[7], g[6]);
        nor  nor2_32 (t[144], t[126], t[143]);
        nor  nor2_33 (t[145], t[126], gn[7]);
        nor  nor4_18 (t[146], pn[11], pn[10], pn[9], gn[8]);
        nor  nor3_37 (t[147], pn[11], pn[10], gn[9]);
        nor  nor2_34 (t[148], pn[11], gn[10]);
        nor  nor2_35 (t[149], t[130], t[132]);
        nor  nor3_38 (t[150], t[134], t[136], t[137]);
        nor  nor4_19 (t[151], t[140], t[142], t[144], t[145]);
        nor  nor4_20 (t[152], t[146], t[147], t[148], g[11]);
        nand nand4_20(c[12], t[149], t[150], t[151], t[152]);
    end


    // Carry 13 (5 layers)
    if(WIDTH >= 13) begin

        xor  xor2_13 (p[12],   A_i[12], B_i[12]);  // p function
        xnor xnor2_25(pn[12],  A_i[12], B_i[12]);  // pn function
        xnor xnor2_26(S_o[12], pn[12],  c[12]);    // S output
        and  and2_13 (g[12],   A_i[12], B_i[12]);  // g function
        nand nand2_33(gn[11],   A_i[11],  B_i[11]);   // gn function

        nand nand4_21(t[153], p[12], p[11], p[10], p[9]);
        nand nand4_22(t[154], p[8], p[7], p[6], p[5]);
        nand nand4_23(t[155], p[4], p[3], p[2], p[1]);
        nand nand2_34(t[156], p[0], c[0]);
        nor  nor4_21 (t[157], t[153], t[154], t[155], t[156]);
        nor  nor4_22 (t[158], t[153], t[154], t[155], gn[0]);
        nand nand4_24(t[159], p[4], p[3], p[2], g[1]);
        nor  nor3_39 (t[160], t[153], t[154], t[159]);
        nand nand3_29(t[161], p[4], p[3], g[2]);
        nor  nor3_40 (t[162], t[153], t[154], t[161]);
        nand nand2_35(t[163], p[4], g[3]);
        nor  nor3_41 (t[164], t[153], t[154], t[163]);
        nor  nor3_42 (t[165], t[153], t[154], gn[4]);
        nand nand4_25(t[166], p[8], p[7], p[6], g[5]);
        nor  nor2_36 (t[167], t[153], t[166]);
        nand nand3_30(t[168], p[8], p[7], g[6]);
        nor  nor2_37 (t[169], t[153], t[168]);
        nand nand2_36(t[170], p[8], g[7]);
        nor  nor2_38 (t[171], t[153], t[170]);
        nor  nor2_39 (t[172], t[153], gn[8]);
        nor  nor4_23 (t[173], pn[12], pn[11], pn[10], gn[9]);
        nor  nor3_43 (t[174], pn[12], pn[11], gn[10]);
        nor  nor2_40 (t[175], pn[12], gn[11]);
        nor  nor3_44 (t[176], t[157], t[158], t[160]);
        nor  nor3_45 (t[177], t[162], t[164], t[165]);
        nor  nor4_24 (t[178], t[167], t[169], t[171], t[172]);
        nor  nor4_25 (t[179], t[173], t[174], t[175], g[12]);
        nand nand4_26(c[13], t[176], t[177], t[178], t[179]);

    end


    // Carry  14 (5 layers)
    if(WIDTH >= 14) begin

        xor  xor2_14 (p[13],   A_i[13], B_i[13]);  // p function
        xnor xnor2_27(pn[13],  A_i[13], B_i[13]);  // pn function
        xnor xnor2_28(S_o[13], pn[13],  c[13]);    // S output
        and  and2_14 (g[13],   A_i[13], B_i[13]);  // g function
        nand nand2_37(gn[12],   A_i[12],  B_i[12]);   // gn function

        nand nand4_27(t[180], p[13], p[12], p[11], p[10]);
        nand nand4_28(t[181], p[9], p[8], p[7], p[6]);
        nand nand4_29(t[182], p[5], p[4], p[3], p[2]);
        nand nand3_31(t[183], p[1], p[0], c[0]);
        nor  nor4_26 (t[184], t[180], t[181], t[182], t[183]);
        nand nand2_38(t[185], p[1], g[0]);
        nor  nor4_27 (t[186], t[180], t[181], t[182], t[185]);
        nor  nor4_28 (t[187], t[180], t[181], t[182], gn[1]);
        nand nand4_30(t[188], p[5], p[4], p[3], g[2]);
        nor  nor3_46 (t[189], t[180], t[181], t[188]);
        nand nand3_32(t[190], p[5], p[4], g[3]);
        nor  nor3_47 (t[191], t[180], t[181], t[190]);
        nand nand2_39(t[192], p[5], g[4]);
        nor  nor3_48 (t[193], t[180], t[181], t[192]);
        nor  nor3_49 (t[194], t[180], t[181], gn[5]);
        nand nand4_31(t[195], p[9], p[8], p[7], g[6]);
        nor  nor2_41 (t[196], t[180], t[195]);
        nand nand3_33(t[197], p[9], p[8], g[7]);
        nor  nor2_37 (t[198], t[180], t[197]);
        nand nand2_40(t[199], p[9], g[8]);
        nor  nor2_38 (t[200], t[180], t[199]);
        nor  nor2_42 (t[201], t[180], gn[9]);
        nor  nor4_30 (t[202], pn[13], pn[12], pn[11], gn[10]);
        nor  nor3_50 (t[203], pn[13], pn[12], gn[11]);
        nor  nor2_43 (t[204], pn[13], gn[12]);
        nor  nor4_31 (t[205], t[184], t[186], t[187], t[189]);
        nor  nor3_51 (t[206], t[191], t[193], t[194]);
        nor  nor4_32 (t[207], t[196], t[198], t[200], t[201]);
        nor  nor4_33 (t[208], t[202], t[203], t[204], g[13]);
        nand nand4_32(c[14], t[205], t[206], t[207], t[208]);
    end

    // Carry 15 (5 layers)
    if(WIDTH >= 15) begin

        xor  xor2_15 (p[14],   A_i[14], B_i[14]);  // p function
        xnor xnor2_29(pn[14],  A_i[14], B_i[14]);  // pn function
        xnor xnor2_30(S_o[14], pn[14],  c[14]);    // S output  
        and  and2_15 (g[14],   A_i[14], B_i[14]);  // g function
        nand nand2_41(gn[13],   A_i[13],  B_i[13]);   // gn function

        nand nand4_33(t[209], p[14], p[13], p[12], p[11]);
        nand nand4_34(t[210], p[10], p[9], p[8], p[7]);
        nand nand4_35(t[211], p[6], p[5], p[4], p[3]);
        nand nand4_36(t[212], p[2], p[1], p[0], c[0]);
        nor  nor4_34 (t[213], t[209], t[210], t[211], t[212]);
        nand nand3_34(t[214], p[2], p[1], g[0]);
        nor  nor4_26 (t[215], t[209], t[210], t[211], t[214]);
        nand nand2_42(t[216], p[2], g[1]);
        nor  nor4_35 (t[217], t[209], t[210], t[211], t[216]);
        nor  nor4_36 (t[218], t[209], t[210], t[211], gn[2]);
        nand nand4_37(t[219], p[6], p[5], p[4], g[3]);
        nor  nor3_52 (t[220], t[209], t[210], t[219]);
        nand nand3_35(t[221], p[6], p[5], g[4]);
        nor  nor3_53 (t[222], t[209], t[210], t[221]);
        nand nand2_43(t[223], p[6], g[5]);
        nor  nor3_54 (t[224], t[209], t[210], t[223]);
        nor  nor3_55 (t[225], t[209], t[210], gn[6]);
        nand nand4_38(t[226], p[10], p[9], p[8], g[7]);
        nor  nor2_41 (t[227], t[209], t[226]);
        nand nand3_36(t[228], p[10], p[9], g[8]);
        nor  nor2_44 (t[229], t[209], t[228]);
        nand nand2_44(t[230], p[10], g[9]);
        nor  nor2_45 (t[231], t[209], t[230]);
        nor  nor2_46 (t[232], t[209], gn[10]);
        nor  nor4_38 (t[233], pn[14], pn[13], pn[12], gn[11]);
        nor  nor3_56 (t[234], pn[14], pn[13], gn[12]);
        nor  nor2_47 (t[235], pn[14], gn[13]);
        nor  nor4_39 (t[236], t[213], t[215], t[217], t[218]);
        nor  nor4_40 (t[237], t[220], t[222], t[224], t[225]);
        nor  nor4_41 (t[238], t[227], t[229], t[231], t[232]);
        nor  nor4_42 (t[239], t[233], t[234], t[235], g[14]);
        nand nand4_39(c[15], t[236], t[237], t[238], t[239]);
        
    end


    // Carry 16 (6 layers)
    if(WIDTH >= 16) begin

        xor  xor2_16 (p[15],   A_i[15], B_i[15]);  // p function
        xnor xnor2_31(pn[15],  A_i[15], B_i[15]);  // pn function
        xnor xnor2_32(S_o[15], pn[15],  c[15]);    // S output  
        and  and2_16 (g[15],   A_i[15], B_i[15]);  // g function
        nand nand2_45(gn[14],   A_i[14],  B_i[14]);   // gn function

        nor  nor4_42 (t[240], pn[15], pn[14], pn[13], pn[12]);
        nor  nor4_43 (t[241], pn[11], pn[10], pn[9], pn[8]);
        nor  nor4_44 (t[242], pn[7], pn[6], pn[5], pn[4]);
        nor  nor4_45 (t[243], pn[3], pn[2], pn[1], pn[0]);
        nand nand2_47(t[244], t[240], t[241]);
        nand nand3_37(t[245], t[242], t[243], c[0]);
        nor  nor2_48 (t[246], t[244], t[245]);
        nor  nor4_46 (t[247], pn[3], pn[2], pn[1], gn[0]);
        nand nand4_40(t[248], t[240], t[241], t[242], t[247]);
        nor  nor3_57 (t[249], pn[3], pn[2], gn[1]);
        nand nand4_41(t[250], t[240], t[241], t[242], t[249]);
        nor  nor2_49 (t[251], pn[3], gn[2]);
        nand nand4_42(t[252], t[240], t[241], t[242], t[251]);
        nand nand3_38(t[253], t[248], t[250], t[252]);
        nand nand4_43(t[254], t[240], t[241], t[242], g[3]);
        nor  nor4_47 (t[255], pn[7], pn[6], pn[5], gn[4]);
        nand nand3_39(t[256], t[240], t[241], t[255]);
        nand nand2_48(t[257], t[254], t[256]);
        nor  nor3_58 (t[258], pn[7], pn[6], gn[5]);
        nand nand3_40(t[259], t[240], t[241], t[258]);
        nor  nor2_50 (t[260], pn[7], gn[6]);
        nand nand3_41(t[261], t[240], t[241], t[260]);
        nand nand2_49(t[262], t[259], t[261]);
        nand nand3_42(t[263], t[240], t[241], g[7]);
        nor  nor4_48 (t[264], pn[11], pn[10], pn[9], gn[8]);
        nand nand2_50(t[265], t[240], t[264]);
        nor  nor3_59 (t[266], pn[11], pn[10], gn[9]);
        nand nand2_51(t[267], t[240], t[266]);
        nand nand3_43(t[268], t[263], t[265], t[267]);
        nor  nor2_52 (t[269], pn[11], gn[10]);
        nand nand2_52(t[270], t[240], t[269]);
        nand nand2_53(t[271], t[240], g[11]);
        nand nand2_54(t[272], t[270], t[271]);
        nor  nor4_49 (t[273], pn[15], pn[14], pn[13], gn[12]);
        nor  nor3_60 (t[274], pn[15], pn[14], gn[13]);
        nor  nor2_54 (t[275], t[273], t[274]);
        nor  nor2_55 (t[276], pn[15], gn[14]);
        nor  nor2_56 (t[277], t[276], g[15]);
        nand nand2_55(t[278], t[275], t[277]);
        nor  nor3_61 (t[279], t[246], t[253], t[257]);
        nor  nor4_50 (t[280], t[262], t[268], t[272], t[278]);
        nand nand2_56(c[16], t[279], t[280]);
    end


    // Carry 17 (6 layers)
    if(WIDTH >= 17) begin
        
        xor  xor2_17 (p[16],   A_i[16], B_i[16]);  // p function
        xnor xnor2_33(pn[16],  A_i[16], B_i[16]);  // pn function
        xnor xnor2_34(S_o[16], pn[16],  c[16]);    // S output  
        and  and2_17 (g[16],   A_i[16], B_i[16]);  // g function
        nand nand2_57(gn[15],   A_i[15],  B_i[15]);   // gn function

        nor  nor4_51 (t[281], pn[16], pn[15], pn[14], pn[13]);
        nor  nor4_52 (t[282], pn[12], pn[11], pn[10], pn[9]);
        nor  nor4_53 (t[283], pn[8], pn[7], pn[6], pn[5]);
        nor  nor4_54 (t[284], pn[4], pn[3], pn[2], pn[1]);
        nor  nor2_57 (t[285], pn[0], t2[3]);
        nand nand3_44(t[286], t[281], t[282], t[283]);
        nand nand2_58(t[287], t[284], t[285]);
        nor  nor2_58 (t[288], t[286], t[287]);
        nand nand2_59(t[289], t[284], g[0]);
        nor  nor2_59 (t[290], t[286], t[289]);
        nor  nor4_55 (t[291], pn[4], pn[3], pn[2], gn[1]);
        nand nand4_44(t[292], t[281], t[282], t[283], t[291]);
        nor  nor3_62 (t[293], pn[4], pn[3], gn[2]);
        nand nand4_45(t[294], t[281], t[282], t[283], t[293]);
        nor  nor2_60 (t[295], pn[4], gn[3]);
        nand nand4_46(t[296], t[281], t[282], t[283], t[295]);
        nand nand3_45(t[297], t[292], t[294], t[296]);
        nand nand4_47(t[298], t[281], t[282], t[283], g[4]);
        nor  nor4_56 (t[299], pn[8], pn[7], pn[6], gn[5]);
        nand nand3_46(t[300], t[281], t[282], t[299]);
        nand nand2_60(t[301], t[298], t[300]);
        nor  nor3_63 (t[302], pn[8], pn[7], gn[6]);
        nand nand3_47(t[303], t[281], t[282], t[302]);
        nor  nor2_61 (t[304], pn[8], gn[7]);
        nand nand3_48(t[305], t[281], t[282], t[304]);
        nand nand2_61(t[306], t[303], t[305]);
        nand nand3_49(t[307], t[281], t[282], g[8]);
        nor  nor4_57 (t[308], pn[12], pn[11], pn[10], gn[9]);
        nand nand2_62(t[309], t[281], t[308]);
        nor  nor3_64 (t[310], pn[12], pn[11], gn[10]);
        nand nand2_63(t[311], t[281], t[310]);
        nand nand3_50(t[312], t[307], t[309], t[311]);
        nor  nor2_62 (t[313], pn[12], gn[11]);
        nand nand2_64(t[314], t[281], t[313]);
        nand nand2_65(t[315], t[281], g[12]);
        nand nand2_66(t[316], t[314], t[315]);
        nor  nor4_58 (t[317], pn[16], pn[15], pn[14], gn[13]);
        nor  nor3_65 (t[318], pn[16], pn[15], gn[14]);
        nor  nor2_63 (t[319], t[317], t[318]);
        nor  nor2_64 (t[320], pn[16], gn[15]);
        nor  nor2_65 (t[321], t[320], g[16]);
        nand nand2_67(t[322], t[319], t[321]);
        nor  nor4_59 (t[323], t[288], t[290], t[297], t[301]);
        nor  nor4_60 (t[324], t[306], t[312], t[316], t[322]);
        nand nand2_68(c[17], t[323], t[324]);
    end

endgenerate

endmodule
