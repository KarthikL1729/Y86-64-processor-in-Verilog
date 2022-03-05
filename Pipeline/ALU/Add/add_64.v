module half_adder(a, b, s, c); 
  input a,b;
  output s,c;

  xor x1(s,a,b);
  and a1(c,a,b);
endmodule

module full_adder(a, b, sum, cin, cout);
  input a,b,cin;
  output sum,cout;
  wire x,y,z;
  
  half_adder h1(a, b, x, y);
  half_adder h2(x, cin, sum, z);
  or o1(cout,y,z);
endmodule

module add_64 (a, b, sum, overflow);
    
    input signed [63:0] a, b;
    output signed [63:0] sum;
    output overflow; 
    wire [64:0] carry;
    assign carry[0] = 1'b0;
    //assign overflow = 1'b0;
    genvar i;
    generate for(i = 0; i < 64; i = i+1) begin
        full_adder n(a[i], b[i], sum[i], carry[i], carry[i+1]);
    end
    endgenerate
    xor x1(overflow, carry[64], carry[63]);
    
endmodule
/*
module CLA(a, b, res, cin, carry, g, p);

    n = 64;
    input [63:0] a, b;
    input cin, Clk;
    output cout;
    output [63:0] res, g, p, carry;
    wire [2079:0] w;

    always @(posedge Clk) begin
        
        for(i = 0; i < n; i = i+1) begin
            and (g[i], a[i], b[i]);
            xor (p[i], a[i], b[i]);
        end

        and(w[0], p[0], cin);
        or(carry[0], g[0], w[0]);

        and(w[1], p[1], p[0], cin);
        and(w[2], p[1], g[0]);
        or(carry[1], w[1], w[2], g[1]);

        and(w[3], p[2], p[1], p[0], cin);
        and(w[4], p[2], p[1], g[0]);
        and(w[5], p[2], g[1]);
        or(carry[2], w[3], w[4], w[5], g[2]);

        and(w[6], p[3], p[2], p[1], p[0], cin);
        and(w[7], p[3], p[2], p[1], g[0]);
        and(w[8], p[3], p[2], g[1]);
        and(w[9], p[3], g[2]);
        or(carry[3], w[6], w[7], w[8], w[9], g[3]);

        and(w[10], p[4], p[3], p[2], p[1], p[0], cin);
        and(w[11], p[4], p[3], p[2], p[1], g[0]);
        and(w[12], p[4], p[3], p[2], g[1]);
        and(w[13], p[4], p[3], g[2]);
        and(w[14], p[4], g[3]);
        or(carry[4], w[10], w[11], w[12], w[13], w[14], g[4]);

        and(w[15], p[5], p[4], p[3], p[2], p[1], p[0], cin);
        and(w[16], p[5], p[4], p[3], p[2], p[1], g[0]);
        and(w[17], p[5], p[4], p[3], p[2], g[1]);
        and(w[18], p[5], p[4], p[3], g[2]);
        and(w[19], p[5], p[4], g[3]);
        and(w[20], p[5], g[4]);
        or(carry[5], w[15], w[16], w[17], w[18], w[19], w[20], g[5]);

        xor(res[0], p[0], cin);
        xor(res[1], p[1], carry[0]);
        xor(res[2], p[2], carry[1]);
        xor(res[3], p[3], carry[2]);
    end
endmodule
*/

