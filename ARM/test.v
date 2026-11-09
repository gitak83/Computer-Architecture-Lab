`timescale 1ns/1ps

module ARM_tb;

    reg clk = 0;
    reg rst = 1;

    ARM dut (.clk(clk), .rst(rst));

    always #5 clk = ~clk;          // 10 ns clock

    initial begin
        rst = 0;               // release reset, PC starts counting
        #200 $stop;
    end

endmodule