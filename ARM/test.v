`timescale 1ns/1ps

module ARM_tb;

    reg clk = 0;
    reg rst = 1;

    ARM dut (.clk(clk), .rst(rst));

    always #5 clk = ~clk;          // 10 ns clock

    initial begin
        #22 rst = 0;               // release reset, PC starts counting
        #500 rst = 1;              // reset in the middle: PC should go back
        #20 rst = 0;               // release again, counting restarts
        #200 $finish;
    end

endmodule