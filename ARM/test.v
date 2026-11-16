`timescale 1ns/1ps

module ARM_tb;

    reg clk = 0;
    reg rst = 1;

    ARM dut (.clk(clk), .rst(rst));

    always #1 clk = ~clk;          // 10 ns clock

    initial begin
        #5 rst = 0;               // release reset, PC starts counting
        #800 $stop;
    end

endmodule