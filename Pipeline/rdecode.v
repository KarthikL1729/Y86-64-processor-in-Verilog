module rdecode(clk, D_stat, D_icode, D_ifun ,D_rA, D_rB, D_valC, D_valP, d_stat, d_icode, d_ifun ,d_rA, d_rB, d_valC, d_valP);

    input clk;
    input [1:0] D_stat;
    input [3:0] D_icode, D_ifun, D_rA, D_rB;
    input [63:0] D_valC, D_valP;
    output [1:0] d_stat;
    output [3:0] d_icode, d_ifun, d_rA, d_rB;
    output [63:0] d_valC, d_valP;

    always @(posedge clk) begin
        d_stat <= D_stat;
        d_icode <= D_icode;
        d_ifun <= D_ifun;
        d_rA <= D_rA;
        d_rB <= D_rB;
        d_valC <= D_valC;
        d_valP <= D_valP;
    end

endmodule