module status_register (
    input clk, rst,
    input [3:0] status_bits,
    input S;
    output reg [3:0] SR
);

    always @(negedge clk or posedge rst) begin
        if (rst) status <= 4'b0;
        else if (S) SR <= status_bits;
    end
    
endmodule