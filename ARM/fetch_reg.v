module IF_Stage_Reg(
    input clk, rst, freeze, flush,
    input [31 : 0] PC_in, Instruction_in,
    output reg [31 : 0] PC, Instruction
);

    always @(posedge clk or posedge rst) begin
        if (rst) PC <= 32'b0;
        else PC <= PC_in;

    end

endmodule