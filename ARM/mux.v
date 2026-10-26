module MUX (
    input wire [31 : 0] a, b, 
    input wire sel, 
    output wire [31 : 0] mux_out);

    assign mux_out = sel ? a : b;
endmodule
