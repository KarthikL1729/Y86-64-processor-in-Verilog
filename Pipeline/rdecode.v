module rdecode(clk, f_stat, f_icode, f_ifun ,f_rA, f_rB, f_valC, f_valP, D_stat, D_icode, D_ifun ,D_rA, D_rB, D_valC, D_valP);

    input clk;
    input [2:0] f_stat;
    input [3:0] f_icode, f_ifun, f_rA, f_rB;
    input [63:0] f_valC, f_valP;
    output reg [1:0] D_stat;
    output reg [3:0] D_icode, D_ifun, D_rA, D_rB;
    output reg [63:0] D_valC, D_valP;

    always @(posedge clk) begin
        D_stat <= f_stat;
        D_icode <= f_icode;
        D_ifun <= f_ifun;
        D_rA <= f_rA;
        D_rB <= f_rB;
        D_valC <= f_valC;
        D_valP <= f_valP;
    end

endmodule