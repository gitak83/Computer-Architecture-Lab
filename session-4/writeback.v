module WriteBackStage(
    input  [31:0] ALU_res,
    input  [31:0] Mem_data,
    input         MEM_R_EN,
    input         WB_EN,
    input  [3:0]  Dest,

    output [31:0] WriteData,
    output        WB_EN_out,
    output [3:0]  Dest_out
);
    assign WriteData = MEM_R_EN ? Mem_data : ALU_res;

    assign WB_EN_out = WB_EN;
    assign Dest_out = Dest;

endmodule