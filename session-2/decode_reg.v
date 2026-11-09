module ID_Stage_Reg (
    input clk, rst, flush,
    input [31:0] PC_in,
    input WB_EN_in, MEM_R_EN_in, MEM_W_EN_in, B_in, S_in,
    input [3:0] EXE_CMD_in,
    input [31:0] Val_Rn_in, Val_Rm_in,
    input imm_in,
    input [11:0] shift_operand_in,
    input [23:0] signed_imm_24_in,
    input [3:0] Dest_in,
    input [3:0] src1_in, src2_in,
    input Two_src_in,
    input [3:0] SR_in,

    output reg [31:0] PC,
    output reg WB_EN, MEM_R_EN, MEM_W_EN, B, S,
    output reg [3:0] EXE_CMD,
    output reg [31:0] Val_Rn, Val_Rm,
    output reg imm,
    output reg [11:0] shift_operand,
    output reg [23:0] signed_imm_24,
    output reg [3:0] Dest,
    output reg [3:0] src1, src2,
    output reg Two_src,
    output reg [3:0] SR
);
    always @(posedge clk or posedge rst) begin
        if (rst || flush) begin
            PC <= 0; WB_EN <= 0; MEM_R_EN <= 0; MEM_W_EN <= 0; B <= 0; S <= 0;
            EXE_CMD <= 0; Val_Rn <= 0; Val_Rm <= 0; imm <= 0;
            shift_operand <= 0; signed_imm_24 <= 0; Dest <= 0;
            src1 <= 0; src2 <= 0; Two_src <= 0; SR <= 0;
        end else begin
            PC <= PC_in; WB_EN <= WB_EN_in; MEM_R_EN <= MEM_R_EN_in;
            MEM_W_EN <= MEM_W_EN_in; B <= B_in; S <= S_in;
            EXE_CMD <= EXE_CMD_in; Val_Rn <= Val_Rn_in; Val_Rm <= Val_Rm_in;
            imm <= imm_in; shift_operand <= shift_operand_in;
            signed_imm_24 <= signed_imm_24_in; Dest <= Dest_in;
            src1 <= src1_in; src2 <= src2_in; Two_src <= Two_src_in; SR <= SR_in;
        end
    end
endmodule