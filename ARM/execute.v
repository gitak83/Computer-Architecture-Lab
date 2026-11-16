module EXE_Stage (
    input clk, rst,
    input C,
    input [31 : 0] PC_in,
    input WB_EN,
    input MEM_R_EN,
    input MEM_W_EN,
    input [3:0] EXE_CMD,
    input S,
    input [31:0] Val_Rn,
    input [31:0] Val_Rm,
    input [11:0] shift_operand,
    input imm,
    input [23:0] signed_imm_24, 
    
    output [31:0] ALU_res,
    output [31 : 0] branch_address,
    output SR

);




    wire [31:0] val2;
    wire [3:0] stat_bits;
    assign load_store = MEM_R_EN | MEM_W_EN;
    Val2Generator val2gen (.Val_Rm(Val_Rm), .shift_operand(shift_operand), .imm(imm), .load_store(load_store), .out_val(val2));
    wire [31:0] extended_signed_imm;
    assign  extended_signed_imm = {{8{signed_imm_24[23]}}, signed_imm_24};
    assign branch_address = extended_signed_imm + PC_in;
    ALU alu(.EXE_CMD(EXE_CMD), .Val1(Val_Rn), .Val2(val2), .C_in(C), .ALU_res(ALU_res), .status_bits(stat_bits));
    status_register statreg(.clk(clk), .rst(rst), .status_bits(stat_bits), .S(S), .SR(SR));
    
endmodule