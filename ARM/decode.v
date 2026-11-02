module ID_Stage (
    input clk, rst,
    input [31 : 0] PC_in,
    input [3:0] SR,
    input Hazard,
    input [3:0] Dest_WB,
    input [31:0] Result_WB,
    input writeBackEN,
    output [31:0] Val_Rn,
    output [31:0] Val_Rm,
    output imm,
    output [11:0] shift_operand,
    output [23:0] signed_imm_24,
    output [3:0] Dest,
    output Two_src,
    output WB_EN,
    output MEM_R_EN,
    output MEM_W_EN,
    output B,
    output S_out,
    output [3:0] EXE_CMD,
    output uncond_MEM_R_EN,
    output uncond_MEM_W_EN,
    output [31 : 0] PC,
    input [31:0] Instruction,
);

    assign PC = PC_in;

    wire [3:0] cond;
    wire [1:0] Mode;
    wire [3:0] opcode;
    wire S;
    wire [3:0] Rn;
    wire [3:0] Rd;
    wire [3:0] Rm;

    assign cond   = Instruction[31:28];
    assign Mode   = Instruction[27:26];
    assign imm    = Instruction[25];
    assign opcode = Instruction[24:21];
    assign S      = Instruction[20];
    assign Rn = Instruction[19:16];
    assign Rd = Instruction[15:12];
    assign Rm = Instruction[3:0];
    assign shift_operand = Instruction[11:0];
    assign signed_imm_24 = Instruction[23:0];

    assign Dest = Rd;
    
    wire cond_out;

    conditioncheck conditionmodule(.cond(cond), .SR(SR), .cond_out(cond_out));

    
    wire [8:0] controlout;

    ControlUnit controlmodule (
    .S_in(S),
    .Opcode(opcode),
    .Mode(Mode),
    .control_word(controlout),
    .uncond_MEM_R_EN(uncond_MEM_R_EN),
    .uncond_MEM_W_EN(uncond_MEM_W_EN)
    );

    wire [8:0] allzero = 9'b0;
    wire [8:0] muxout;

    // we do not have hazard so no and gate.
    wire controlsel = cond_out;

    assign muxout = controlsel ? controlout : allzero;


    assign WB_EN    = muxout[8];
    assign MEM_R_EN = muxout[7];
    assign MEM_W_EN = muxout[6];
    assign B        = muxout[5];
    assign S_out    = muxout[4];
    assign EXE_CMD  = muxout[3:0];
    
    wire [3:0] src2mux;


    assign src2mux = uncond_MEM_W_EN ? Rd : Rm;
     
    RegisterFile regfile (.clk(clk), .rst(rst), .src_1(Rn), .src_2(src2mux), .Dest_WB(Dest_WB), .Result_WB(Result_WB), .writeBackEN(writeBackEN), .reg_out_1(Val_Rn), .reg_out_2(Val_Rm));

    assign Two_src = ~(imm | uncond_MEM_R_EN);

endmodule