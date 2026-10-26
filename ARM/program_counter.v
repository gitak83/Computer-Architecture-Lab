module ProgramCounter(input wire clk,rst,freeze,
                      output wire [31:0] outval,
                      input wire [31:0] inval);
    
    reg [31 : 0] outval_reg;
    always @(posedge clk,posedge rst) begin
        if(rst) outval_reg <= 0;
        else if(freeze) outval_reg <= inval + 1;
        else outval_reg <= inval;
    end
    
    assign outval = outval_reg;
endmodule