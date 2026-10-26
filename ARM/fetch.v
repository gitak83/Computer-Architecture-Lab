module IF_Stage(
    input clk, rst, freeze, Branch_taken,
    input [31 : 0] BranchAddr,
    output [31 : 0] PC, Instruction
);

wire [31:0] mux_out;
Mux mux2to1(PC, BranchAddr, Branch_taken, mux_out);

wire [31:0] pcoutval;
ProgramCounter pcreg(clk, rst, freeze, mux_out, pcoutval);

wire [10:0] memin;

assign memin = pcoutval[10:1];

dist_mem_gen_0 inst_mem(
        .a(memin),      // input wire [10 : 0] a
        .spo(Instruction)  // output wire [31 : 0] spo
);

INC incrementor (pcoutval, PC);


endmodule