module ControlUnit(
    input S_in,
    input [3:0] Opcode,
    input [1:0] Mode,

    output reg WB_EN,
    output reg MEM_R_EN,
    output reg MEM_W_EN,
    output reg [3:0] EXE_CMD,
    output reg B,
    output reg S_out,

    output reg uncond_MEM_R_EN,
    output reg uncond_MEM_W_EN
);

always @(*) begin
    WB_EN = 0;
    MEM_R_EN = 0;
    MEM_W_EN = 0;
    EXE_CMD = 4'b0000;
    B = 0;
    S_out = 0;

    uncond_MEM_R_EN = 0;
    uncond_MEM_W_EN = 0;

    case (Mode)
        2'b00: begin

            case (Opcode)
                4'b1101: begin
                    WB_EN = 1;
                    EXE_CMD = 4'b0001;
                    S_out = S_in;
                end

                4'b1111: begin
                    WB_EN = 1;
                    EXE_CMD = 4'b1001;
                    S_out = S_in;
                end

                4'b0100: begin
                    WB_EN = 1;
                    EXE_CMD = 4'b0010;
                    S_out = S_in;
                end

                4'b0101: begin
                    WB_EN = 1;
                    EXE_CMD = 4'b0011;
                    S_out = S_in;
                end

                4'b0010: begin
                    WB_EN = 1;
                    EXE_CMD = 4'b0100;
                    S_out = S_in;
                end

                4'b0110: begin
                    WB_EN = 1;
                    EXE_CMD = 4'b0101;
                    S_out = S_in;
                end

                4'b0000: begin
                    WB_EN = 1;
                    EXE_CMD = 4'b0110;
                    S_out = S_in;
                end

                4'b1100: begin
                    WB_EN = 1;
                    EXE_CMD = 4'b0111;
                    S_out = S_in;
                end

                4'b0001: begin
                    WB_EN = 1;
                    EXE_CMD = 4'b1000;
                    S_out = S_in;
                end

                4'b1010: begin
                    WB_EN = 0;
                    EXE_CMD = 4'b0100;
                    S_out = 1;
                end
                4'b1000: begin
                    WB_EN = 0;
                    EXE_CMD = 4'b0110;
                    S_out = 1;
                end

            endcase
        end

        2'b01: begin

            if (Opcode == 4'b0100) begin

                if (S_in == 1'b1) begin
                    WB_EN = 1;
                    MEM_R_EN = 1;
                    EXE_CMD = 4'b0010;
                    uncond_MEM_R_EN = 1;
                end

                else begin
                    MEM_W_EN = 1;
                    EXE_CMD = 4'b0010;
                    uncond_MEM_W_EN = 1;
                end

            end
        end
        2'b10: begin
            B = 1;
        end

    endcase

end

endmodule
