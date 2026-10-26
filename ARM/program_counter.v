module ProgramCounter #(parameter SIZE = 32) (clk,rst,freeze,outval,inval);

    input wire clk,rst,freeze;
    input wire [SIZE - 1:0] inval;
    output wire [SIZE - 1 : 0] outval;
    
    reg [SIZE - 1 : 0] outval_reg;
    always @(posedge clk,posedge rst) begin
        if(rst) outval_reg <= 0;
        if(~freeze) outval_reg <= inval;
    end
    
    assign outval = outval_reg;
endmodule