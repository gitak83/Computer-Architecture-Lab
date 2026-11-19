module INC (
    input wire [31 : 0] pc, 
    output wire [31 : 0] inc_out);

    assign inc_out = pc + 1'b1;
endmodule