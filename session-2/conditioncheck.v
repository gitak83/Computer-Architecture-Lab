
module condition_Check (
    input  [3:0] cond,
    input  [3:0] SR,
    output reg   cond_out
);

    wire N = SR[3];
    wire Z = SR[2];
    wire C = SR[1];
    wire V = SR[0];

    always @(*) begin
        case (cond)
            4'b0000: cond_out = Z;
            4'b0001: cond_out = ~Z;
            4'b0010: cond_out = C;
            4'b0011: cond_out = ~C;
            4'b0100: cond_out = N;
            4'b0101: cond_out = ~N;
            4'b0110: cond_out = V;
            4'b0111: cond_out = ~V;
            4'b1000: cond_out = C & ~Z;
            4'b1001: cond_out = ~C | Z;
            4'b1010: cond_out = ~(N ^ V);
            4'b1011: cond_out = N ^ V; 
            4'b1100: cond_out = ~Z & ~(N ^ V);
            4'b1101: cond_out = Z | (N ^ V);
            4'b1110: cond_out = 1'b1;
            4'b1111: cond_out = 1'b0;
            default: cond_out = 1'b0;
        endcase
    end

endmodule
