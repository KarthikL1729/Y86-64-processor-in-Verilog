module xor_64(a, b, out);

input [63:0] a,b;
output [63:0] out;

genvar i;
    generate for(i = 0; i < 64; i = i+1) begin
        xor x(out[i], a[i], b[i]);
    end
    endgenerate

endmodule