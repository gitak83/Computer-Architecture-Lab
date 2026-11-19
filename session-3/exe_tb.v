`timescale 1ns/1ps
module EXE_tb;
    reg clk, rst, S, C;
    reg [31:0] a, b, pc;
    reg [3:0] cmd, cond, condition_SR;
    reg [23:0] branch_offset;
    reg [11:0] shift_operand;
    reg imm, load_store;
    wire [31:0] result, branch_address;
    wire [3:0] flags, SR;
    wire cond_out;
    reg [31:0] expected_result;
    reg expected_C, expected_V, expected_condition;
    reg n, z, c, v;
    reg [32:0] unsigned_result;
    reg signed [63:0] signed_a, signed_b, signed_result;
    reg [31:0] carry_mask;
    integer i, op, flag_value, condition_value, checks;

    EXE_Stage dut (
        .clk(clk), .rst(rst), .C(C), .PC_in(pc), .WB_EN(1'b0),
        .MEM_R_EN(load_store), .MEM_W_EN(1'b0), .EXE_CMD(cmd), .S(S),
        .Val_Rn(a), .Val_Rm(b), .shift_operand(shift_operand), .imm(imm),
        .signed_imm_24(branch_offset), .ALU_res(result),
        .branch_address(branch_address), .SR(SR)
    );
    assign flags = dut.stat_bits;
    condition_Check conditionmodule (.cond(cond), .SR(condition_SR), .cond_out(cond_out));

    task check;
        input [31:0] actual, expected;
        begin
            checks = checks + 1;
            if (actual !== expected) begin
                $display("FAIL check=%0d cmd=%h A=%h B=%h C=%b actual=%h expected=%h",
                         checks, cmd, a, b, C, actual, expected);
                $stop;
            end
        end
    endtask

    initial begin
        checks = 0; clk = 0; rst = 0; S = 0; C = 0;
        a = 0; b = 0; pc = 100; cmd = 0; branch_offset = 0;
        shift_operand = 0; imm = 0; load_store = 0; cond = 0; condition_SR = 0;
        #1; rst = 1; #1; check({28'b0, SR}, 0); rst = 0;
        // Each pass mixes arithmetic and logical instructions to detect stale flags.
        for (i = 0; i < 1000; i = i + 1) begin
            a = $random; b = $random; C = i % 2;
            // Directed carry, borrow, zero and signed overflow boundaries.
            if (i < 4) begin
                a = (i == 0) ? 32'hffffffff : (i == 1) ? 32'h7fffffff :
                    (i == 2) ? 32'h80000000 : 0;
                b = 1;
            end
            for (op = 0; op < 16; op = op + 1) begin
                cmd = op; expected_C = 0; expected_V = 0; expected_result = 0;
                signed_a = $signed(a); signed_b = $signed(b);
                case (cmd)
                    1: expected_result = b;
                    9: expected_result = ~b;
                    2, 3: begin
                        unsigned_result = {1'b0, a} + {1'b0, b} + ((cmd == 3) ? C : 0);
                        signed_result = signed_a + signed_b + ((cmd == 3) ? C : 0);
                        expected_result = unsigned_result[31:0];
                        expected_C = unsigned_result[32];
                        expected_V = (signed_result > 64'sh7fffffff) ||
                                     (signed_result < -64'sh80000000);
                    end
                    4, 5: begin
                        // Presentation compatibility: SUB reports borrow;
                        // SBC subtracts a 32-bit inverted carry word.
                        carry_mask = (cmd == 5) ? (C ? 32'hfffffffe : 32'hffffffff) : 0;
                        unsigned_result = {1'b0, a} - {1'b0, b} - {1'b0, carry_mask};
                        expected_result = unsigned_result[31:0];
                        signed_result = $signed({1'b0, a}) - $signed({1'b0, b})
                                        - $signed({1'b0, carry_mask});
                        expected_C = signed_result[32];
                        expected_V = (a[31] != b[31]) && (expected_result[31] != a[31]);
                    end
                    6: expected_result = a & b;
                    7: expected_result = a | b;
                    8: expected_result = a ^ b;
                endcase
                #1;
                check(result, expected_result);
                check({28'b0, flags}, {28'b0, (expected_result == 0), expected_C,
                                       expected_result[31], expected_V});
            end
        end
        // All conditions and all flag combinations, using {Z,C,N,V}.
        for (flag_value = 0; flag_value < 16; flag_value = flag_value + 1) begin
            condition_SR = flag_value; {z,c,n,v} = condition_SR;
            for (condition_value = 0; condition_value < 16; condition_value = condition_value + 1) begin
                cond = condition_value;
                case (cond)
                    0: expected_condition = z;
                    1: expected_condition = !z;
                    2: expected_condition = c;
                    3: expected_condition = !c;
                    4: expected_condition = n;
                    5: expected_condition = !n;
                    6: expected_condition = v;
                    7: expected_condition = !v;
                    8: expected_condition = c && !z;
                    9: expected_condition = !c || z;
                    10: expected_condition = n == v;
                    11: expected_condition = n != v;
                    12: expected_condition = !z && (n == v);
                    13: expected_condition = z || (n != v);
                    14: expected_condition = 1;
                    15: expected_condition = 0;
                endcase
                #1; check({31'b0, cond_out}, {31'b0, expected_condition});
            end
        end
        branch_offset = 24'hfffff7; #1; check(branch_address, 91);
        branch_offset = 7; #1; check(branch_address, 107);
        cmd = 1; imm = 1; shift_operand = 12'h103; #1; check(result, 32'hc0000000);
        imm = 0; b = 32'h80000000; shift_operand = 12'h142; #1; check(result, 32'he0000000);
        load_store = 1; shift_operand = 12'hfff; #1; check(result, 32'hffffffff);
        load_store = 0; shift_operand = 0; b = 0; S = 1;
        clk = 1; #1; check({28'b0, SR}, 0);
        clk = 0; #1; check({28'b0, SR}, 8);
        S = 0; b = 32'h80000000; clk = 1; #1; clk = 0; #1;
        check({28'b0, SR}, 8);
        rst = 1; #1; check({28'b0, SR}, 0);
        $display("PASS: %0d EXE/flag/condition checks", checks);
        $finish;
    end
endmodule
