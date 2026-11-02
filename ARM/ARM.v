module ARM(input clk, input rst);
    wire [31:0] IF_pc, IF_instruction;
    wire [31:0] ID_pc, ID_instruction;
    wire [31:0] ID_pc_out;
    wire [31:0] EXE_pc, MEM_pc, WB_pc;


    wire [31:0] ID_Val_Rn, ID_Val_Rm;
    wire        ID_imm, ID_Two_src;
    wire [11:0] ID_shift_operand;
    wire [23:0] ID_signed_imm_24;
    wire [3:0]  ID_Dest, ID_src1, ID_src2;
    wire        ID_WB_EN, ID_MEM_R_EN, ID_MEM_W_EN, ID_B, ID_S;
    wire [3:0]  ID_EXE_CMD;
    wire        ID_uncond_MEM_R_EN, ID_uncond_MEM_W_EN;

    wire [31:0] EXE_Val_Rn, EXE_Val_Rm;
    wire        EXE_imm, EXE_Two_src;
    wire [11:0] EXE_shift_operand;
    wire [23:0] EXE_signed_imm_24;
    wire [3:0]  EXE_Dest, EXE_src1, EXE_src2, EXE_SR;
    wire        EXE_WB_EN, EXE_MEM_R_EN, EXE_MEM_W_EN, EXE_B, EXE_S;
    wire [3:0]  EXE_EXE_CMD;

    wire [3:0] SR = 4'b0;

    IF_Stage IF (.clk(clk), .rst(rst), .freeze(1'b0), .Branch_taken(1'b0),
                 .BranchAddr(32'b0), .PC(IF_pc), .Instruction(IF_instruction));

    IF_Stage_Reg IF_reg (.clk(clk), .rst(rst), .freeze(1'b0), .flush(1'b0),
                         .PC_in(IF_pc), .Instruction_in(IF_instruction),
                         .PC(ID_pc), .Instruction(ID_instruction));

    ID_Stage ID (
        .clk(clk), .rst(rst),
        .PC_in(ID_pc),
        .Instruction(ID_instruction),
        .SR(SR),
        .Hazard(1'b0),
        .Dest_WB(4'b0), .Result_WB(32'b0), .writeBackEN(1'b0),
        .Val_Rn(ID_Val_Rn), .Val_Rm(ID_Val_Rm),
        .imm(ID_imm),
        .shift_operand(ID_shift_operand),
        .signed_imm_24(ID_signed_imm_24),
        .Dest(ID_Dest),
        .Two_src(ID_Two_src),
        .WB_EN(ID_WB_EN), .MEM_R_EN(ID_MEM_R_EN), .MEM_W_EN(ID_MEM_W_EN),
        .B(ID_B), .S_out(ID_S), .EXE_CMD(ID_EXE_CMD),
        .uncond_MEM_R_EN(ID_uncond_MEM_R_EN),
        .uncond_MEM_W_EN(ID_uncond_MEM_W_EN),
        .PC(ID_pc_out)
    );

    ID_Stage_Reg ID_reg (
        .clk(clk), .rst(rst), .flush(1'b0),
        .PC_in(ID_pc_out),
        .WB_EN_in(ID_WB_EN), .MEM_R_EN_in(ID_MEM_R_EN), .MEM_W_EN_in(ID_MEM_W_EN),
        .B_in(ID_B), .S_in(ID_S), .EXE_CMD_in(ID_EXE_CMD),
        .Val_Rn_in(ID_Val_Rn), .Val_Rm_in(ID_Val_Rm),
        .imm_in(ID_imm),
        .shift_operand_in(ID_shift_operand),
        .signed_imm_24_in(ID_signed_imm_24),
        .Dest_in(ID_Dest),
        .src1_in(ID_src1), .src2_in(ID_src2),
        .Two_src_in(ID_Two_src),
        .SR_in(SR),

        .PC(EXE_pc),
        .WB_EN(EXE_WB_EN), .MEM_R_EN(EXE_MEM_R_EN), .MEM_W_EN(EXE_MEM_W_EN),
        .B(EXE_B), .S(EXE_S), .EXE_CMD(EXE_EXE_CMD),
        .Val_Rn(EXE_Val_Rn), .Val_Rm(EXE_Val_Rm),
        .imm(EXE_imm),
        .shift_operand(EXE_shift_operand),
        .signed_imm_24(EXE_signed_imm_24),
        .Dest(EXE_Dest),
        .src1(EXE_src1), .src2(EXE_src2),
        .Two_src(EXE_Two_src),
        .SR(EXE_SR)
    );

endmodule