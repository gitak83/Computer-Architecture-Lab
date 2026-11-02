module ID_Stage (
    input clk, rst,
    input [31 : 0] PC_in,
    output [31 : 0] PC
);

    wire [3:0] cond = PC_in[31:28];
    wire [1:0] Mode = PC_in[27:26];
    wire I =  PC_in [25];
    wire [3:0] opcode = PC_in[24:21];
    wire S =  PC_in [20];
    wire [3:0] Rn = PC_in[19:16];
    wire [3:0] Rd = PC_in[15:12];
    wire [3:0] rotate_imm = PC_in[11:8];
    wire [7:0] immed_8 = PC_in[7:0];
    wire [3:0] Rm = PC_in[3:0];
    wire [8:0] controlout;

    wire SR = 4'b0000;
    wire cond_out;

    conditioncheck conditionmodule(.cond(cond), .SR(SR), .cond_out(cond_out));

    wire conditionresult = ~cond_out;
    wire [8:0] allzero = 9'b0;
    wire [8:0] muxout;

    ControlUnit controlmodule (
    .S_in(S),
    .Opcode(opcode),
    .Mode(Mode),
    .control_word(controlout),
    .uncond_MEM_R_EN(uncond_MEM_R_EN),
    .uncond_MEM_W_EN(uncond_MEM_W_EN)
    );


    assign muxout = conditionresult ? controlout : allzero;


    wire WB_EN    = muxout[8];
    wire MEM_R_EN = muxout[7];
    wire MEM_W_EN = muxout[6];
    wire B        = muxout[5];
    wire S_out    = muxout[4];
    wire [3:0] EXE_CMD = muxout[3:0];
        


endmodule