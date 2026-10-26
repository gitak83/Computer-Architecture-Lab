module ProgramCounter(input wire clk,rst,freeze,
                      input wire [31:0] inval,
                      output wire [31:0] outval
                      );
    
    reg [31 : 0] outval_reg;
    always @(posedge clk,posedge rst) begin
        if(rst) outval_reg <= 0;
        else if(~freeze) outval_reg <= inval;
    end
    
    assign outval = outval_reg;
endmodule