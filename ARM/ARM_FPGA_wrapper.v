module ARM_FPGA_wrapper(
    input clk,
    input key1
);

    wire deb_out, rst;

    debouncer deb_inst (
        .SIGNAL_I(key1),
        .CLK_I(clk),
        .SIGNAL_O(deb_out)
    );
    assign rst = ~deb_out;

    ARM ARM_inst (
        .clk(clk),
        .rst(rst)
    );

    ila_0 ila_inst (
        .clk(clk),

        .probe0(rst),                      // 1 bit  (DATA AND TRIGGER)
        .probe1(ARM_inst.IF_pc),           // 32 bit
        .probe2(ARM_inst.ID_pc),           // 32 bit
        .probe3(ARM_inst.EXE_pc),          // 32 bit
        .probe4(ARM_inst.MEM_pc),          // 32 bit
        .probe5(ARM_inst.WB_pc),           // 32 bit
        .probe6(ARM_inst.ID_instruction)   // 32 bit
    );

endmodule