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
                    end else
                        expected = Val_Rm;
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
