`timescale 1ns/1ps

module ARM_tb;

    reg clk = 0;
    reg rst = 1;

    ARM dut (.clk(clk), .rst(rst));

    always #5 clk = ~clk;         
    initial begin
        #12 rst = 0;              
        #1000 $stop;
    end

endmodule