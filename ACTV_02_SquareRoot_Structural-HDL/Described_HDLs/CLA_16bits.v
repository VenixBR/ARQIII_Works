module CLA #(
    parameter WIDTH = 16
)(
    input  wire [WIDTH-1:0] A_i,
    input  wire [WIDTH-1:0] B_i,
    input  wire             Ci_i,
    output wire [WIDTH-1:0] S_o,
    output wire             Co_o
);

// Internal signals
wire g[WIDTH-1:0];
wire p[WIDTH-1:0];
wire c[WIDTH:0];
wire t[361:0]; // temporary nets

// Generate g and p functions and the sum out
genvar i;
generate
    for(i=0 ; i<WIDTH ; i=i+1)begin
        assign g[i]   = A_i[i] & B_i[i];
        assign p[i]   = A_i[i] ^ B_i[i];
        assign S_o[i] = p[i] ^ c[i];
    end
endgenerate

//######### Carries logic #########

assign Co_o = c[WIDTH];

generate
    // Carry 0
    assign c[0]  = Ci_i;

    // Carry 1
    if(WIDTH >= 1) begin
        assign t[0]  = p[0] & c[0];
        assign c[1]  = g[0] | t[0];
    end

    // Carry 2
    if(WIDTH >= 2) begin
        assign t[1]  = p[1] & p[0] & c[0];
        assign t[2]  = p[1] & g[0];
        assign c[2]  = g[1] | t[2] | t[1];
    end

    // Carry 3
    if(WIDTH >= 3) begin
        assign t[3]  = p[2] & p[1] & p[0] & c[0];
        assign t[4]  = p[2] & p[1] & g[0];
        assign t[5]  = p[2] & g[1];
        assign c[3]  = g[2] | t[5] | t[4] | t[3];
    end

    // Carry 4
    if(WIDTH >= 4) begin
        assign t[6]  = p[3]  & p[2]  & p[1] & p[0];      // vv - And5 
        assign t[7]  = t[6]  & c[0];                     //
        assign t[8]  = p[3]  & p[2]  & p[1] & g[0];
        assign t[9]  = p[3]  & p[2]  & g[1];
        assign t[10] = p[3]  & g[2];
        assign t[11] = g[3]  | t[10] | t[9] | t[8];      // vv - Or5
        assign c[4]  = t[11] | t[7];                     //
    end

    // Carry 5
    if(WIDTH >= 5) begin
        assign t[12] = p[4]  & p[3]  & p[2]  & p[1];     // vv - And6
        assign t[13] = t[12] & p[0]  & c[0];             //
        assign t[14] = p[4]  & p[3]  & p[2]  & p[1];     // vv - And5
        assign t[15] = t[14] & g[0];                     //
        assign t[16] = p[4]  & p[3]  & p[2]  & g[1];
        assign t[17] = p[4]  & p[3]  & g[2];
        assign t[18] = p[4]  & g[3];
        assign t[19] = g[4]  | t[18] | t[17] | t[16];    // vv - Or6
        assign c[5]  = t[19] | t[15] | t[13];            //
    end

    // Carry 6
    if(WIDTH >= 6) begin
        assign t[20] = p[5]  & p[4]  & p[3]  & p[2];     // vv - And7
        assign t[21] = t[20] & p[1]  & p[0]  & c[0];     //
        assign t[22] = p[5]  & p[4]  & p[3]  & p[2];     // vv - And6
        assign t[23] = t[22] & p[1]  & g[0];             //
        assign t[24] = p[5]  & p[4]  & p[3]  & p[2];     // vv - And5
        assign t[25] = t[24] & g[1];                     //
        assign t[26] = p[5]  & p[4]  & p[3]  & g[2];
        assign t[27] = p[5]  & p[4]  & g[3];
        assign t[28] = p[5]  & g[4];
        assign t[29] = g[5]  | t[28] | t[27] | t[26];    // vv - Or7
        assign c[6]  = t[29] | t[25] | t[23] | t[21];    //
    end

    // Carry 7
    if(WIDTH >= 7) begin
        assign t[30] = p[6]  & p[5]  & p[4]  & p[3];     // vv - And8
        assign t[31] = p[2]  & p[1]  & p[0]  & c[0];     // 
        assign t[32] = t[30] & t[31];                    //
        assign t[33] = p[6]  & p[5]  & p[4]  & p[3];     // vv - And7
        assign t[34] = t[33] & p[2]  & p[1]  & g[0];     //
        assign t[35] = p[6]  & p[5]  & p[4]  & p[3];     // vv - And6
        assign t[36] = t[35] & p[2]  & g[1];             //
        assign t[37] = p[6]  & p[5]  & p[4]  & p[3];     // vv - And5
        assign t[38] = t[37] & g[2];                     //
        assign t[39] = p[6]  & p[5]  & p[4]  & g[3];
        assign t[40] = p[6]  & p[5]  & g[4];
        assign t[41] = p[6]  & g[5];
        assign t[42] = t[38] | t[36] | t[34] | t[32];    // vv - Or8
        assign t[43] = g[6]  | t[41] | t[40] | t[39];    //
        assign c[7]  = t[42] | t[43];                    //
    end

    // Carry 8
    if(WIDTH >= 8) begin
        assign t[44] = p[7]  & p[6]  & p[5]  & p[4];     // vv - And9
        assign t[45] = p[3]  & p[2]  & p[1]  & p[0];     //
        assign t[46] = t[44] & t[45] & c[0];             //
        assign t[47] = p[7]  & p[6]  & p[5]  & p[4];     // vv - And8
        assign t[48] = p[3]  & p[2]  & p[1]  & g[0];     // 
        assign t[49] = t[47] & t[48];                    //
        assign t[50] = p[7]  & p[6]  & p[5]  & p[4];     // vv - And7
        assign t[51] = t[50] & p[3]  & p[2]  & g[1];     //
        assign t[52] = p[7]  & p[6]  & p[5]  & p[4];     // vv - And6
        assign t[53] = t[52] & p[3]  & g[2];             //
        assign t[54] = p[7]  & p[6]  & p[5]  & p[4];     // vv - And5
        assign t[55] = t[54] & g[3];                     //
        assign t[56] = p[7]  & p[6]  & p[5]  & g[4];
        assign t[57] = p[7]  & p[6]  & g[5];
        assign t[58] = p[7]  & g[6];
        assign t[59] = t[46] | t[49]  | t[51]  | t[53];  // vv - Or9
        assign t[60] = t[55] | t[56]  | t[57]  | t[58];  //
        assign c[8]  = t[59] | t[60]  | g[7];            //
    end

    // Carry 9
    if(WIDTH >= 9) begin
        assign t[61] = p[8]  & p[7]  & p[6]  & p[5];     // vv - And10
        assign t[62] = p[4]  & p[3]  & p[2]  & p[1];     //
        assign t[63] = t[61] & t[62] & p[0]  & c[0];     //
        assign t[64] = p[8]  & p[7]  & p[6]  & p[5];     // vv - And9
        assign t[65] = p[4]  & p[3]  & p[2]  & p[1];     //
        assign t[66] = t[64] & t[65] & g[0];             //
        assign t[67] = p[8]  & p[7]  & p[6]  & p[5];     // vv - And8
        assign t[68] = p[4]  & p[3]  & p[2]  & g[1];     // 
        assign t[69] = t[67] & t[68];                    //
        assign t[70] = p[8]  & p[7]  & p[6]  & p[5];     // vv - And7
        assign t[71] = t[70] & p[4]  & p[3]  & g[2];     //
        assign t[72] = p[8]  & p[7]  & p[6]  & p[5];     // vv - And6
        assign t[73] = t[72] & p[4]  & g[3];             //
        assign t[74] = p[8]  & p[7]  & p[6]  & p[5];     // vv - And5
        assign t[75] = t[74] & g[4];                     //
        assign t[76] = p[8]  & p[7]  & p[6]  & g[5];
        assign t[77] = p[8]  & p[7]  & g[6];
        assign t[78] = p[8]  & g[7];
        assign t[79] = t[63] | t[66] | t[69] | t[71];    // vv - And10
        assign t[80] = t[73] | t[75] | t[76] | t[77];    //
        assign c[9]  = t[79] | t[80] | t[78] | g[8];     //
    end

    // Carry 10
    if(WIDTH >= 10) begin
        assign t[81]  = p[9]   & p[8]   & p[7]  & p[6];     // vv - And11
        assign t[82]  = p[5]   & p[4]   & p[3]  & p[2];     //
        assign t[83]  = p[1]   & p[0]   & c[0];             //
        assign t[84]  = t[81]  & t[82]  & t[83];            //
        assign t[85]  = p[9]   & p[8]   & p[7]  & p[6];     // vv - And10
        assign t[86]  = p[5]   & p[4]   & p[3]  & p[2];     //
        assign t[87]  = t[85]  & t[86]  & p[1]  & g[0];     //
        assign t[88]  = p[9]   & p[8]   & p[7]  & p[6];     // vv - And9
        assign t[89]  = p[5]   & p[4]   & p[3]  & p[2];     //
        assign t[90]  = t[88]  & t[89]  & g[1];             //
        assign t[91]  = p[9]   & p[8]   & p[7]  & p[6];     // vv - And8
        assign t[92]  = p[5]   & p[4]   & p[3]  & g[2];     // 
        assign t[93]  = t[91]  & t[92];                     //
        assign t[94]  = p[9]   & p[8]   & p[7]  & p[6];     // vv - And7
        assign t[95]  = t[94]  & p[5]   & p[4]  & g[3];     //
        assign t[96]  = p[9]   & p[8]   & p[7]  & p[6];     // vv - And6
        assign t[97]  = t[96]  & p[5]   & g[4];             //
        assign t[98]  = p[9]   & p[8]   & p[7]  & p[6];     // vv - And5
        assign t[99]  = t[98]  & g[5];                      //
        assign t[100] = p[9]   & p[8]   & p[7]  & g[6];
        assign t[101] = p[9]   & p[8]   & g[7];
        assign t[102] = p[9]   & g[8];
        assign t[103] = t[84]  | t[87]  | t[90] | t[93];    // vv - Or11
        assign t[104] = t[95]  | t[97]  | t[99] | t[100];   //
        assign t[105] = t[101] | t[102] | g[9];             //
        assign c[10]  = t[103] | t[104] | t[105];           //
    end

    // Carry 11
    if(WIDTH >= 11) begin
        assign t[106] = p[10]  & p[9]   & p[8]   & p[7];    // vv - And12
        assign t[107] = p[6]   & p[5]   & p[4]   & p[3];    //
        assign t[108] = p[2]   & p[1]   & p[0]   & c[0];    // 
        assign t[109] = t[106] & t[107] & t[108];           //
        assign t[110] = p[10]  & p[9]   & p[8]   & p[7];    // vv - And11
        assign t[111] = p[6]   & p[5]   & p[4]   & p[3];    //
        assign t[112] = p[2]   & p[1]   & g[0];             //
        assign t[113] = t[110] & t[111] & t[112];           //
        assign t[114] = p[10]  & p[9]   & p[8]   & p[7];    // vv - And10
        assign t[115] = p[6]   & p[5]   & p[4]   & p[3];    //
        assign t[116] = t[114] & t[115] & p[2]   & g[1];    //
        assign t[117] = p[10]  & p[9]   & p[8]   & p[7];    // vv - And9
        assign t[118] = p[6]   & p[5]   & p[4]   & p[3];    //
        assign t[119] = t[117] & t[118] & g[2];             //
        assign t[120] = p[10]  & p[9]   & p[8]   & p[7];    // vv - And8
        assign t[121] = p[6]   & p[5]   & p[4]   & g[3];    // 
        assign t[122] = t[120] & t[121];                    //
        assign t[123] = p[10]  & p[9]   & p[8]   & p[7];    // vv - And7
        assign t[124] = t[123] & p[6]   & p[5]   & g[4];    //
        assign t[125] = p[10]  & p[9]   & p[8]   & p[7];    // vv - And6
        assign t[126] = t[125] & p[6]   & g[5];             //
        assign t[127] = p[10]  & p[9]   & p[8]   & p[7];    // vv - And5
        assign t[128] = t[127] & g[6];                      //
        assign t[129] = p[10]  & p[9]   & p[8]   & g[7];
        assign t[130] = p[10]  & p[9]   & g[8];
        assign t[131] = p[10]  & g[9];
        assign t[132] = t[109] | t[113] | t[116] | t[119];  // vv - Or12
        assign t[133] = t[122] | t[124] | t[126] | t[128];  //
        assign t[134] = t[129] | t[130] | t[131] | g[10];   // 
        assign c[11]  = t[132] | t[133] | t[134];           //
    end
    
    // Carry 12
    if(WIDTH >= 12) begin
        assign t[135] = p[11]  & p[10]  & p[9]   & p[8];    // vv - And13
        assign t[136] = p[7]   & p[6]   & p[5]   & p[4];    //
        assign t[137] = p[3]   & p[2]   & p[1]   & p[0];    //
        assign t[138] = t[135] & t[136] & t[137] & c[0];    //
        assign t[139] = p[11]  & p[10]  & p[9]   & p[8];    // vv - And12
        assign t[140] = p[7]   & p[6]   & p[5]   & p[4];    //
        assign t[141] = p[3]   & p[2]   & p[1]   & g[0];    // 
        assign t[142] = t[139] & t[140] & t[141];           //
        assign t[143] = p[11]  & p[10]  & p[9]   & p[8];    // vv - And11
        assign t[144] = p[7]   & p[6]   & p[5]   & p[4];    //
        assign t[145] = p[3]   & p[2]   & g[1];             //
        assign t[146] = t[143] & t[144] & t[145];           //
        assign t[147] = p[11]  & p[10]  & p[9]   & p[8];    // vv - And10
        assign t[148] = p[7]   & p[6]   & p[5]   & p[4];    //
        assign t[149] = t[147] & t[148] & p[3]   & g[2];    //
        assign t[150] = p[11]  & p[10]  & p[9]   & p[8];    // vv - And9
        assign t[151] = p[7]   & p[6]   & p[5]   & p[4];    //
        assign t[152] = t[150] & t[151] & g[3];             //
        assign t[153] = p[11]  & p[10]  & p[9]   & p[8];    // vv - And8
        assign t[154] = p[7]   & p[6]   & p[5]   & g[4];    // 
        assign t[155] = t[153] & t[154];                    //
        assign t[156] = p[11]  & p[10]  & p[9]   & p[8];    // vv - And7
        assign t[157] = t[156] & p[7]   & p[6]   & g[5];    //
        assign t[158] = p[11]  & p[10]  & p[9]   & p[8];    // vv - And6
        assign t[159] = t[158] & p[7]   & g[6];             //
        assign t[160] = p[11]  & p[10]  & p[9]   & p[8];    // vv - And5
        assign t[161] = t[160] & g[7];                      //
        assign t[162] = p[11]  & p[10]  & p[9]   & g[8];
        assign t[163] = p[11]  & p[10]  & g[9];
        assign t[164] = p[11]  & g[10];
        assign t[165] = t[138] | t[142] | t[146] | t[149];  // vv - Or13
        assign t[166] = t[152] | t[155] | t[157] | t[159];  //
        assign t[167] = t[161] | t[162] | t[163] | t[164];  //
        assign c[12]  = t[165] | t[166] | t[167] | g[11];   //
    end


    // Carry 13
    if(WIDTH >= 13) begin
        assign t[168] = p[12]  & p[11]  & p[10]  & p[9];    // vv - And14
        assign t[169] = p[8]   & p[7]   & p[6]   & p[5];    //
        assign t[170] = p[4]   & p[3]   & p[2];             //
        assign t[171] = p[1]   & p[0]   & c[0];             //
        assign t[172] = t[168] & t[169] & t[170] & t[171];  //
        assign t[173] = p[12]  & p[11]  & p[10]  & p[9];    // vv - And13
        assign t[174] = p[8]   & p[7]   & p[6]   & p[5];    //
        assign t[175] = p[4]   & p[3]   & p[2]   & p[1];    //
        assign t[176] = t[173] & t[174] & t[175] & g[0];    //
        assign t[177] = p[12]  & p[11]  & p[10]  & p[9];    // vv - And12
        assign t[178] = p[8]   & p[7]   & p[6]   & p[5];    //
        assign t[179] = p[4]   & p[3]   & p[2]   & g[1];    // 
        assign t[180] = t[177] & t[178] & t[179];           //
        assign t[181] = p[12]  & p[11]  & p[10]  & p[9];    // vv - And11
        assign t[182] = p[8]   & p[7]   & p[6]   & p[5];    //
        assign t[183] = p[4]   & p[3]   & g[2];             //
        assign t[184] = t[181] & t[182] & t[183];           //
        assign t[185] = p[12]  & p[11]  & p[10]  & p[9];    // vv - And10
        assign t[186] = p[8]   & p[7]   & p[6]   & p[5];    //
        assign t[187] = t[185] & t[186] & p[4]   & g[3];    //
        assign t[188] = p[12]  & p[11]  & p[10]  & p[9];    // vv - And9
        assign t[189] = p[8]   & p[7]   & p[6]   & p[5];    //
        assign t[190] = t[188] & t[189] & g[4];             //
        assign t[191] = p[12]  & p[11]  & p[10]  & p[9];    // vv - And8
        assign t[192] = p[8]   & p[7]   & p[6]   & g[5];    //
        assign t[193] = t[191] & t[192];                    //
        assign t[194] = p[12]  & p[11]  & p[10]  & p[9];    // vv - And7
        assign t[195] = t[194] & p[8]   & p[7]   & g[6];    //
        assign t[196] = p[12]  & p[11]  & p[10]  & p[9];    // vv - And6
        assign t[197] = t[196] & p[8]   & g[7];             //
        assign t[198] = p[12]  & p[11]  & p[10]  & p[9];    // vv - And5
        assign t[199] = t[198] & g[8];                      //
        assign t[200] = p[12]  & p[11]  & p[10]  & g[9];
        assign t[201] = p[12]  & p[11]  & g[10];
        assign t[202] = p[12]  & g[11];
        assign t[203] = t[172] | t[176] | t[180] | t[184];  // vv - Or14
        assign t[204] = t[187] | t[190] | t[193] | t[195];  //
        assign t[205] = t[197] | t[199] | t[200];           //
        assign t[206] = t[201] | t[202] | g[12];            //
        assign c[13]  = t[203] | t[204] | t[205] | t[206];  //
    end


    // Carry  14 _CHECK
    if(WIDTH >= 14) begin
        assign t[207] = p[13]  & p[12]  & p[11]  & p[10];   // vv - And15
        assign t[208] = p[9]   & p[8]   & p[7]   & p[6];    //
        assign t[209] = p[5]   & p[4]   & p[3]   & p[2];    //
        assign t[210] = p[1]   & p[0]   & c[0];             //
        assign t[211] = t[207] & t[208] & t[209] & t[210];  //
        assign t[212] = p[13]  & p[12]  & p[11]  & p[10];   // vv - And14
        assign t[213] = p[9]   & p[8]   & p[7]   & p[6];    //
        assign t[214] = p[5]   & p[4]   & p[3];             //
        assign t[215] = p[2]   & p[1]   & g[0];             //
        assign t[216] = t[212] & t[213] & t[214] & t[215];  //
        assign t[217] = p[13]  & p[12]  & p[11]  & p[10];   // vv - And13
        assign t[218] = p[9]   & p[8]   & p[7]   & p[6];    //
        assign t[219] = p[5]   & p[4]   & p[3]   & p[2];    //
        assign t[220] = t[217] & t[218] & t[219] & g[1];    //
        assign t[221] = p[13]  & p[12]  & p[11]  & p[10];   // vv - And12
        assign t[222] = p[9]   & p[8]   & p[7]   & p[6];    //
        assign t[223] = p[5]   & p[4]   & p[3]   & g[2];    //
        assign t[224] = t[221] & t[222] & t[223];           //
        assign t[225] = p[13]  & p[12]  & p[11]  & p[10];   // vv - And11
        assign t[226] = p[9]   & p[8]   & p[7]   & p[6];    //
        assign t[227] = p[5]   & p[4]   & g[3];             //
        assign t[228] = t[225] & t[226] & t[227];           //
        assign t[229] = p[13]  & p[12]  & p[11]  & p[10];   // vv - And10
        assign t[230] = p[9]   & p[8]   & p[7]   & p[6];    //
        assign t[231] = t[229] & t[230] & p[5]   & g[4];    //
        assign t[232] = p[13]  & p[12]  & p[11]  & p[10];   // vv - And9
        assign t[233] = p[9]   & p[8]   & p[7]   & p[6];    //
        assign t[234] = t[232] & t[233] & g[5];             //
        assign t[235] = p[13]  & p[12]  & p[11]  & p[10];   // vv - And8
        assign t[236] = p[9]   & p[8]   & p[7]   & g[6];   // 
        assign t[237] = t[235] & t[236];                    //
        assign t[238] = p[13]  & p[12]  & p[11]  & p[10];   // vv - And7
        assign t[239] = t[238] & p[9]   & p[8]   & g[7];    //
        assign t[240] = p[13]  & p[12]  & p[11]  & p[10];   // vv - And6
        assign t[241] = t[240] & p[9]   & g[8];             //
        assign t[242] = p[13]  & p[12]  & p[11]  & p[10];   // vv - And5
        assign t[243] = t[242] & g[9];                      //
        assign t[244] = p[13]  & p[12]  & p[11]  & g[10];
        assign t[245] = p[13]  & p[12]  & g[11];
        assign t[246] = p[13]  & g[12];
        assign t[247] = t[211] | t[216] | t[220] | t[224];  // vv - Or15
        assign t[248] = t[228] | t[231] | t[234] | t[237];  //
        assign t[249] = t[239] | t[241] | t[243] | t[244];  //
        assign t[250] = t[245] | t[246] | g[13];            //
        assign c[14]  = t[247] | t[248] | t[249] | t[250];  //
    end

    // Carry 15
    if(WIDTH >= 15) begin
        assign t[251] = p[14]  & p[13]  & p[12]  & p[11];   // vv - And16
        assign t[252] = p[10]  & p[9]   & p[8]   & p[7];    //
        assign t[253] = p[6]   & p[5]   & p[4]   & p[3];    //
        assign t[254] = p[2]   & p[1]   & p[0]   & c[0];    //
        assign t[255] = t[251] & t[252] & t[253] & t[254];  //
        assign t[256] = p[14]  & p[13]  & p[12]  & p[11];   // vv - And15
        assign t[257] = p[10]  & p[9]   & p[8]   & p[7];    //
        assign t[258] = p[6]   & p[5]   & p[4]   & p[3];    //
        assign t[259] = p[2]   & p[1]   & g[0];             //
        assign t[260] = t[256] & t[257] & t[258] & t[259];  //
        assign t[261] = p[14]  & p[13]  & p[12]  & p[11];   // vv - And14
        assign t[262] = p[10]  & p[9]   & p[8]   & p[7];    //
        assign t[263] = p[6]   & p[5]   & p[4];             //
        assign t[264] = p[3]   & p[2]   & g[1];             //
        assign t[265] = t[261] & t[262] & t[263] & t[264];  //
        assign t[266] = p[14]  & p[13]  & p[12]  & p[11];   // vv - And13
        assign t[267] = p[10]  & p[9]   & p[8]   & p[7];    //
        assign t[268] = p[6]   & p[5]   & p[4]   & p[3];    //
        assign t[269] = t[266] & t[267] & t[268] & g[2];    //
        assign t[270] = p[14]  & p[13]  & p[12]  & p[11];   // vv - And12
        assign t[271] = p[10]  & p[9]   & p[8]   & p[7];    //
        assign t[272] = p[6]   & p[5]   & p[4]   & g[3];    // 
        assign t[273] = t[270] & t[271] & t[272];           //
        assign t[274] = p[14]  & p[13]  & p[12]  & p[11];   // vv - And11
        assign t[275] = p[10]  & p[9]   & p[8]   & p[7];    //
        assign t[276] = p[6]   & p[5]   & g[4];             //
        assign t[277] = t[274] & t[275] & t[276];           //
        assign t[278] = p[14]  & p[13]  & p[12]  & p[11];   // vv - And10
        assign t[279] = p[10]  & p[9]   & p[8]   & p[7];    //
        assign t[280] = t[278] & t[279] & p[6]   & g[5];    //
        assign t[281] = p[14]  & p[13]  & p[12]  & p[11];   // vv - And9
        assign t[282] = p[10]  & p[9]   & p[8]   & p[7];    //
        assign t[283] = t[281] & t[282] & g[6];             //
        assign t[284] = p[14]  & p[13]  & p[12]  & p[11];   // vv - And8
        assign t[285] = p[10]  & p[9]   & p[8]   & g[7];    // 
        assign t[286] = t[284] & t[285];                    //
        assign t[287] = p[14]  & p[13]  & p[12]  & p[11];   // vv - And7
        assign t[288] = t[287] & p[10]  & p[9]   & g[8];    //
        assign t[289] = p[14]  & p[13]  & p[12]  & p[11];   // vv - And6
        assign t[290] = t[289] & p[10]  & g[9];             //
        assign t[291] = p[14]  & p[13]  & p[12]  & p[11];   // vv - And5
        assign t[292] = t[291] & g[10];                     //
        assign t[293] = p[14]  & p[13]  & p[12]  & g[11];
        assign t[294] = p[14]  & p[13]  & g[12];
        assign t[295] = p[14]  & g[13];
        assign t[296] = t[255] | t[260] | t[265] | t[269];  // vv - Or16
        assign t[297] = t[273] | t[277] | t[280] | t[283];  //
        assign t[298] = t[286] | t[288] | t[290] | t[292];  //
        assign t[299] = t[293] | t[294] | t[295] | g[14];   //
        assign c[15]  = t[296] | t[297] | t[298] | t[299];  //
    end


    // Carry 16
    if(WIDTH >= 16) begin
        assign t[300] = p[15]  & p[14]  & p[13];            //vv - And17
        assign t[301] = p[12]  & p[11]  & p[10];            //
        assign t[302] = p[9]   & p[8]   & p[7];             //
        assign t[303] = p[6]   & p[5]   & p[4];             //
        assign t[304] = p[3]   & p[2]   & p[1];             //
        assign t[305] = p[0]   & c[0];                      //
        assign t[306] = t[300] & t[301] & t[302];           //
        assign t[307] = t[303] & t[304] & t[305];           //
        assign t[308] = t[306] & t[307];                    //
        assign t[309] = p[15]  & p[14]  & p[13]  & p[12];   // vv - And16
        assign t[310] = p[11]  & p[10]  & p[9]   & p[8];    //
        assign t[311] = p[7]   & p[6]   & p[5]   & p[4];    //
        assign t[312] = p[3]   & p[2]   & p[1]   & g[0];    //
        assign t[313] = t[309] & t[310] & t[311] & t[312];  //
        assign t[314] = p[15]  & p[14]  & p[13]  & p[12];   // vv - And15
        assign t[315] = p[11]  & p[10]  & p[9]   & p[8];    //
        assign t[316] = p[7]   & p[6]   & p[5]   & p[4];    //
        assign t[317] = p[3]   & p[2]   & g[1];             //
        assign t[318] = t[314] & t[315] & t[316] & t[317];  //
        assign t[319] = p[15]  & p[14]  & p[13]  & p[12];   // vv - And14
        assign t[320] = p[11]  & p[10]  & p[9]   & p[8];    //
        assign t[321] = p[7]   & p[6]   & p[5];             //
        assign t[322] = p[4]   & p[3]   & g[2];             //
        assign t[323] = t[319] & t[320] & t[321] & t[322];  //
        assign t[324] = p[15]  & p[14]  & p[13]  & p[12];   // vv - And13
        assign t[325] = p[11]  & p[10]  & p[9]   & p[8];    //
        assign t[326] = p[7]   & p[6]   & p[5]   & p[4];    //
        assign t[327] = t[324] & t[325] & t[326] & g[3];    //
        assign t[328] = p[15]  & p[14]  & p[13]  & p[12];   // vv - And12
        assign t[329] = p[11]  & p[10]  & p[9]   & p[8];    //
        assign t[330] = p[7]   & p[6]   & p[5]   & g[4];    // 
        assign t[331] = t[328] & t[329] & t[330];           //
        assign t[332] = p[15]  & p[14]  & p[13]  & p[12];   // vv - And11
        assign t[333] = p[11]  & p[10]  & p[9]   & p[8];    //
        assign t[334] = p[7]   & p[6]   & g[5];             //
        assign t[335] = t[332] & t[333] & t[334];           //
        assign t[336] = p[15]  & p[14]  & p[13]  & p[12];   // vv - And10
        assign t[337] = p[11]  & p[10]  & p[9]   & p[8];    //
        assign t[338] = t[336] & t[337] & p[7]   & g[6];    //
        assign t[339] = p[15]  & p[14]  & p[13]  & p[12];   // vv - And9
        assign t[340] = p[11]  & p[10]  & p[9]   & p[8];    //
        assign t[341] = t[339] & t[340] & g[7];             //
        assign t[342] = p[15]  & p[14]  & p[13]  & p[12];   // vv - And8
        assign t[343] = p[11]  & p[10]  & p[9]   & g[8];    // 
        assign t[344] = t[342] & t[343];                    //
        assign t[345] = p[15]  & p[14]  & p[13]  & p[12];   // vv - And7
        assign t[346] = t[345] & p[11]  & p[10]  & g[9];    //
        assign t[347] = p[15]  & p[14]  & p[13]  & p[12];   // vv - And6
        assign t[348] = t[347] & p[11]  & g[10];            //
        assign t[349] = p[15]  & p[14]  & p[13]  & p[12];   // vv - And5
        assign t[350] = t[349] & g[11];                     //
        assign t[351] = p[15]  & p[14]  & p[13]  & g[12];
        assign t[352] = p[15]  & p[14]  & g[13];
        assign t[353] = p[15]  & g[14];
        assign t[354] = t[308] | t[313] | t[318];            //vv - And17
        assign t[355] = t[323] | t[327] | t[331];            //
        assign t[356] = t[335] | t[338] | t[341];            //
        assign t[357] = t[344] | t[346] | t[348];            //
        assign t[358] = t[350] | t[351] | t[352];            //
        assign t[359] = t[353] | g[15];                      //
        assign t[360] = t[354] | t[355] | t[356];            //
        assign t[361] = t[357] | t[358] | t[359];            //
        assign c[16]  = t[360] | t[361];                     //
    end

endgenerate

endmodule