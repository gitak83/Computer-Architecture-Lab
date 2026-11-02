module ControlUnit(
    input S_in,
    input [3:0] Opcode,
    input [1:0] Mode,

    output reg [8:0] control_word,

    output reg uncond_MEM_R_EN,
    output reg uncond_MEM_W_EN
);

always @(*) begin

    control_word = 9'b000000000;

    uncond_MEM_R_EN = 0;
    uncond_MEM_W_EN = 0;

    case (Mode)

        2'b00: begin

            case (Opcode)

                4'b1101: begin
                    control_word = {1'b1, 1'b0, 1'b0, 1'b0, S_in, 4'b0001};
                end

                4'b1111: begin
                    control_word = {1'b1, 1'b0, 1'b0, 1'b0, S_in, 4'b1001};
                end

                4'b0100: begin
                    control_word = {1'b1, 1'b0, 1'b0, 1'b0, S_in, 4'b0010};
                end

                4'b0101: begin
                    control_word = {1'b1, 1'b0, 1'b0, 1'b0, S_in, 4'b0011};
                end

                4'b0010: begin
                    control_word = {1'b1, 1'b0, 1'b0, 1'b0, S_in, 4'b0100};
                end

                4'b0110: begin
                    control_word = {1'b1, 1'b0, 1'b0, 1'b0, S_in, 4'b0101};
                end

                4'b0000: begin
                    control_word = {1'b1, 1'b0, 1'b0, 1'b0, S_in, 4'b0110};
                end

                4'b1100: begin
                    control_word = {1'b1, 1'b0, 1'b0, 1'b0, S_in, 4'b0111};
                end

                4'b0001: begin
                    control_word = {1'b1, 1'b0, 1'b0, 1'b0, S_in, 4'b1000};
                end

                4'b1010: begin
                    control_word = {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 4'b0100};
                end

                4'b1000: begin
                    control_word = {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 4'b0110};
                end

            endcase
        end

        2'b01: begin

            if (Opcode == 4'b0100) begin

                if (S_in == 1'b1) begin
                    control_word = {1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 4'b0010};
                    uncond_MEM_R_EN = 1;
                end

                else begin
                    control_word = {1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 4'b0010};
                    uncond_MEM_W_EN = 1;
                end

            end
        end

        2'b10: begin
            control_word = {1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 4'b0000};
        end

    endcase

end

endmodule
