
module RegisterFile(
    input clk,
    input rst,
    input [3:0] src_1,
    input [3:0] src_2,
    input [3:0] Dest_WB,
    input [31:0] Result_WB,
    input writeBackEN,
    output reg [31:0] reg_out_1,
    output reg [31:0] reg_out_2
);
    reg [31:0] registers [0:14];

    integer i;

    always @(negedge clk or posedge rst) begin

        if (rst) begin
            for (i = 0; i < 15; i = i + 1) begin
                registers[i] <= i;
            end
        end

        else begin
            if (writeBackEN && Dest_WB < 4'd15) begin
                registers[Dest_WB] <= Result_WB;
            end
        end

    end

    always @(*) begin
        if (src_1 < 4'd15)
            reg_out_1 = registers[src_1];
        else
            reg_out_1 = 32'd0;
    end

    always @(*) begin
        if (src_2 < 4'd15)
            reg_out_2 = registers[src_2];
        else
            reg_out_2 = 32'd0;
    end

endmodule
