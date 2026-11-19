module Val2Generator (
    input [31:0] Val_Rm,
    input [11:0] shift_operand,
    input imm,
    input load_store,
    output [31:0] out_val
);

    wire [31:0] sign_extended;
    wire [3:0] rotate_imm;
    wire [7:0] immed_8;
    wire [31:0] immediate_value;
    wire [63:0] rotated_value;
    wire [4:0] shift_imm;
    wire [1:0] shift_type;
    wire [31:0] lsl_value, lsr_value, asr_value, ror_value, shifted_value;
    wire [63:0] rotated_register;
    wire signed [31:0] signed_Rm, arithmetic_shift;

    assign rotate_imm = shift_operand[11:8];
    assign immed_8 = shift_operand[7:0];
    assign sign_extended = {{20{shift_operand[11]}}, shift_operand};

    assign immediate_value = {24'b0, immed_8};
    assign rotated_value = {immediate_value, immediate_value}
                           >> {rotate_imm, 1'b0};

    assign shift_imm = shift_operand[11:7];
    assign shift_type = shift_operand[6:5];
    assign lsl_value = Val_Rm << shift_imm;
    assign lsr_value = (shift_imm == 0) ? 32'b0 : Val_Rm >> shift_imm;
    assign signed_Rm = Val_Rm;
    assign arithmetic_shift = signed_Rm >>> shift_imm;
    assign asr_value = (shift_imm == 0) ? {32{Val_Rm[31]}} : arithmetic_shift;
    assign rotated_register = {Val_Rm, Val_Rm} >> shift_imm;
    assign ror_value = rotated_register[31:0];
    assign shifted_value = (shift_type == 2'b00) ? lsl_value :
                           (shift_type == 2'b01) ? lsr_value :
                           (shift_type == 2'b10) ? asr_value : ror_value;

    assign out_val = load_store ? sign_extended :
                     imm ? rotated_value[31:0] :
                     shift_operand[4] ? Val_Rm : shifted_value;
endmodule
