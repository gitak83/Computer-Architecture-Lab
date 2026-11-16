
module ALU (
    input [3:0] EXE_CMD,
    input [31:0] Val1,
    input [31:0] Val2,

    input C_in,

    output reg [31:0] ALU_res,
    output [3:0] status_bits
);

    reg C;
    reg V;
    wire N;
    wire Z;

    always @(*) begin
        C = C_in;
        case (EXE_CMD)
            4'b0001:
                ALU_res = Val2;
            4'b1001:
                ALU_res = ~Val2;
            4'b0010: begin
                {C, ALU_res} =
                    {1'b0, Val1} + {1'b0, Val2};

                V = (~(Val1[31] ^ Val2[31]))
                         & (ALU_res[31] ^ Val1[31]);
            end
            4'b0011: begin
                {C, ALU_res} =
                    {1'b0, Val1} + {1'b0, Val2} + C_in;

                V = (~(Val1[31] ^ Val2[31]))
                         & (ALU_res[31] ^ Val1[31]);
            end
            4'b0100: begin
                {C, ALU_res} =
                    {1'b0, Val1} + {1'b0, ~Val2} + 33'd1;

                V = (Val1[31] ^ Val2[31])
                         & (ALU_res[31] ^ Val1[31]);
            end
            4'b0101: begin
                {C, ALU_res} =
                    {1'b0, Val1} + {1'b0, ~Val2} + C_in;

                V = (Val1[31] ^ Val2[31])
                         & (ALU_res[31] ^ Val1[31]);
            end
            4'b0110:
                ALU_res = Val1 & Val2;
            4'b0111:
                ALU_res = Val1 | Val2;
            4'b1000:
                ALU_res = Val1 ^ Val2;
            default:
            begin
                ALU_res = 32'b0;
                V = 1'b0; // not sure
            end
        endcase
    end

    assign N = ALU_res[31];
    assign Z = (ALU_res == 32'b0);
    assign status_bits = {Z, C, N, V};

endmodule
