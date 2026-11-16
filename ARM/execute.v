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
    output [31:0] Val_Rm,
    output [3:0] Dest,
    output O_WB_EN,
    output [31 : 0] branch_address
);




    wire [31:0] extended_signed_imm;
    assign  extended_signed_imm = {{8{signed_imm_24[23]}}, signed_imm_24};
    assign branch_address = extended_signed_imm + PC_in;
    
endmodule