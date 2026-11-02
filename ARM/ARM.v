module ARM(input clk, input rst);
    wire [31:0] IF_pc, IF_instruction;
    wire [31:0] ID_pc, ID_instruction;
    wire [31:0] EXE_pc, MEM_pc, WB_pc;

    IF_Stage IF (.clk(clk), .rst(rst), .freeze(1'b0), .Branch_taken(1'b0),
                 .BranchAddr(32'b0), .PC(IF_pc), .Instruction(IF_instruction));

    IF_Stage_Reg IF_reg (.clk(clk), .rst(rst), .freeze(1'b0), .flush(1'b0),
                         .PC_in(IF_pc), .Instruction_in(IF_instruction),
                         .PC(ID_pc), .Instruction(ID_instruction));

endmodule