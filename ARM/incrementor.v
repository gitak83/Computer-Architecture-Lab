module INC #(parameter SIZE = 32) (pc, out):
    input wire [SIZE - 1 : 0] pc;
    output wire [SIZE - 1 : 0] out;

    assign out = pc + 1'b1;
endmodule