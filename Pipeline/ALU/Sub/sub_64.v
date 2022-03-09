`include "/home/karthik/Y86-64-processor-in-Verilog/Pipeline/ALU/Add/add_64.v"
module sub_64(a, b, diff, overflow);
    
    input signed [63:0] a, b;
    output signed [63:0] diff;
    output overflow;
    wire [63:0] bn, bcomp;
    wire [63:0] addc;
    genvar i;
    generate for(i = 0; i < 64; i = i+1) begin
        not(bn[i], b[i]);
    end
    endgenerate
    assign addc = 64'b1;

    add_64 comp(bn, addc, bcomp, ov1);
    add_64 sub(a, bcomp, diff, overflow);
    
endmodule
