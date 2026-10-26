module ARM(input clk, input rst);
    wire [31:0] IF_pc, IF_instruction;
    wire [31:0] ID_pc, ID_instruction;
    wire [31:0] EXE_pc, MEM_pc, WB_pc;

    IF_Stage IF (.clk(clk), .rst(rst), .freeze(1'b0), .Branch_taken(1'b0),
                 .BranchAddr(32'b0), .PC(IF_pc), .Instruction(IF_instruction));

    IF_Stage_Reg IF_reg (.clk(clk), .rst(rst), .freeze(1'b0), .flush(1'b0),
                         .PC_in(IF_pc), .Instruction_in(IF_instruction),
                         .PC(ID_pc), .Instruction(ID_instruction));

    ID_Stage ID (.clk(clk), .rst(rst), .PC_in(ID_pc), .PC(EXE_pc));

    ID_Stage_Reg ID_reg (.clk(clk), .rst(rst), .PC_in(EXE_pc), .PC(MEM_pc));

    MEM_Stage MEM (.clk(clk), .rst(rst), .PC_in(MEM_pc), .PC(WB_pc));

    MEM_Stage_Reg MEM_reg (.clk(clk), .rst(rst), .PC_in(WB_pc), .PC(WB_pc));

    WB_Stage WB (.clk(clk), .rst(rst), .PC_in(WB_pc), .PC(WB_pc));

    WB_Stage_Reg WB_reg (.clk(clk), .rst(rst), .PC_in(WB_pc), .PC(WB_pc));

endmodule