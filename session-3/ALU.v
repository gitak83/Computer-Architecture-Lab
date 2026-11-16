
module ALU (
    input [3:0] EXE_CMD,
    input [31:0] Val1,
    input [31:0] Val2,
    input C,

    output reg [31:0] ALU_res,
    output [3:0] status_bits;
);

    always @(*) begin

        case (EXE_CMD)

            4'b0001: ALU_res = Val2;
            4'b1001: ALU_res = ~Val2;
            4'b0010: ALU_res = Val1 + Val2;
            4'b0011: ALU_res = Val1 + Val2 + C;
            4'b0100: ALU_res = Val1 - Val2;
            4'b0101: ALU_res = Val1 - Val2 - ~C;
            4'b0110: ALU_res = Val1 & Val2;
            4'b0111: ALU_res = Val1 | Val2;
            4'b1000: ALU_res = Val1 ^ Val2;

            default: ALU_res = 32'b0;

        endcase

    end

    assign N = ALU_res[31];
    assign ~Z |= ALU_res;
    assign status_bits[3] = {Z,C,N,V};

endmodule
