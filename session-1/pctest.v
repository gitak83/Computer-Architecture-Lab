`timescale 1ns/1ps

module PC_tb;

    reg clk = 1'b0;
    reg rst = 1'b1;
    wire freeze = 1'b0;
    ProgramCounter dut (.clk(clk), .rst(rst), .freeze(freeze), .inval(inval), .outval(outval));

    always #5 clk = ~clk;          // 10 ns clock

    initial begin
        assign inval = 32'b0;
        #22 rst = 0;               // release reset, PC starts counting
        #200 $stop;
    end

endmodule