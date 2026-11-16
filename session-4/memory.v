module MemoryStage(
    input  [31:0] ALU_res,
    input  [31:0] Data,
    input         WB_EN,
    input         MEM_R_EN,
    input         MEM_W_EN,
    input  [3:0]  Dest,
    input         clk,

    output [31:0] ALU_res_out,
    output        WB_EN_out,
    output        MEM_R_EN_out,
    output [3:0]  Dest_out,
    output [31:0] Mem_data
);

    wire [10:0] memin;

    assign memin = ALU_res[10:0];

    dist_mem_gen_1 data_mem(
        .a(memin),
        .d(Data),
        .we(MEM_W_EN),
        .clk(clk),
        .spo(Mem_data)
    );
    assign ALU_res_out = ALU_res;
    assign WB_EN_out = WB_EN;
    assign MEM_R_EN_out = MEM_R_EN;
    assign Dest_out = Dest;

endmodule