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

    assign rotate_imm = shift_operand[11:8];
    assign immed_8 = shift_operand[7:0];
    assign sign_extended = {{20{shift_operand[11]}}, shift_operand};

    // Zero-extend the immediate, then rotate right by 2 * rotate_imm.
    // Duplicating the word preserves the bits that wrap around, even at zero.
    assign immediate_value = {24'b0, immed_8};
    assign rotated_value = {immediate_value, immediate_value}
                           >> {rotate_imm, 1'b0};

    // Memory offsets take priority over imm. Register shifts are omitted
    // as specified in the EXE session handout, page 2.
    assign out_val = load_store ? sign_extended :
                     imm ? rotated_value[31:0] : Val_Rm;
endmodule
