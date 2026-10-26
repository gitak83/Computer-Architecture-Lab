module INC (
    input wire [31 : 0] pc, 
    output wire [31 : 0] out);

    assign out = pc + 1'b1;
endmodule