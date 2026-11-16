module Unit_Detection_Hazard(
    input  [3:0] src1,
    input  [3:0] src2,
    input        Two_src,

    input  [3:0] EXE_Dest,
    input        EXE_WB_EN,

    input  [3:0] MEM_Dest,
    input        MEM_WB_EN,

    output       Detected_Hazard
);

    assign Detected_Hazard =
        ((src1 == EXE_Dest) && EXE_WB_EN) ||
        ((src2 == EXE_Dest) && EXE_WB_EN && Two_src) ||

        ((src1 == MEM_Dest) && MEM_WB_EN) ||
        ((src2 == MEM_Dest) && MEM_WB_EN && Two_src);

endmodule
