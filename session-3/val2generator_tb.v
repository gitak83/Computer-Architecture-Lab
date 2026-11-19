`timescale 1ns/1ps

module Val2Generator_tb;
    reg [31:0] Val_Rm;
    reg [11:0] shift_operand;
    reg imm, load_store;
    wire [31:0] out_val;
    reg [31:0] expected;
    integer operand, mode, pattern, bit_index, amount, checks;

    Val2Generator dut (
        .Val_Rm(Val_Rm), .shift_operand(shift_operand),
        .imm(imm), .load_store(load_store), .out_val(out_val)
    );

    initial begin
        checks = 0;
        // All encodings and control combinations, with varied register data.
        for (pattern = 0; pattern < 4; pattern = pattern + 1) begin
            Val_Rm = (pattern == 0) ? 32'h00000000 :
                     (pattern == 1) ? 32'hffffffff :
                     (pattern == 2) ? 32'h80000001 : 32'h12345678;
            for (operand = 0; operand < 4096; operand = operand + 1) begin
                shift_operand = operand;
                for (mode = 0; mode < 4; mode = mode + 1) begin
                    {load_store, imm} = mode;
                    if (load_store)
                        expected = (operand < 2048) ? operand : operand - 4096;
                    else if (imm) begin
                        // Reference rotation by bit positions, independent of
                        // the DUT's duplicated-word shift implementation.
                        expected = 0;
                        amount = 2 * (operand / 256);
                        for (bit_index = 0; bit_index < 8; bit_index = bit_index + 1)
                            expected[(bit_index + 32 - amount) % 32] = shift_operand[bit_index];
                    end else if (shift_operand[4])
                        expected = Val_Rm; // Unsupported register-controlled shifts.
                    else begin
                        // Bit-by-bit reference: independent of the DUT shifts.
                        expected = 0;
                        amount = shift_operand[11:7];
                        case (shift_operand[6:5])
                            2'b00: for (bit_index = 0; bit_index < 32; bit_index = bit_index + 1)
                                if (bit_index >= amount)
                                    expected[bit_index] = Val_Rm[bit_index - amount];
                            2'b01: begin
                                if (amount == 0) amount = 32;
                                for (bit_index = 0; bit_index < 32; bit_index = bit_index + 1)
                                    if (bit_index + amount < 32)
                                        expected[bit_index] = Val_Rm[bit_index + amount];
                            end
                            2'b10: begin
                                if (amount == 0) amount = 32;
                                for (bit_index = 0; bit_index < 32; bit_index = bit_index + 1)
                                    expected[bit_index] = (bit_index + amount < 32) ?
                                        Val_Rm[bit_index + amount] : Val_Rm[31];
                            end
                            2'b11: begin
                                for (bit_index = 0; bit_index < 32; bit_index = bit_index + 1)
                                    expected[bit_index] = Val_Rm[(bit_index + amount) % 32];
                            end
                        endcase
                    end
                    #1;
                    if (out_val !== expected) begin
                        $display("FAIL operand=%h mode=%b Rm=%h got=%h expected=%h",
                                 shift_operand, {load_store, imm}, Val_Rm, out_val, expected);
                        $stop;
                    end
                    checks = checks + 1;
                end
            end
        end
        $display("PASS: %0d checks", checks);
        
        $finish;
    end
endmodule
