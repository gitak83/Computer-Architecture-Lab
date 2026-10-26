module MUX #(parameter SIZE = 32) (a, b, sel, out);

    input wire sel;
    input wire [SIZE-1 : 0] a, b;
    output reg [SIZE-1 : 0] out;

    assign out = ~sel ? a : b;

endmodule
