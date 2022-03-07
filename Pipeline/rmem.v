module rmem(clk, e_stat, e_icode, e_Cnd, e_valE, e_valA, e_dstE, e_dstM, M_stat, M_icode, M_Cnd, M_valE, M_valA, M_dstE, M_dstM);

    input [1:0] e_stat;
    input [3:0] e_icode;
    input e_Cnd;
    input [63:0] e_valE, e_valA;
    input [3:0] e_dstE, e_dstM;
    output [1:0] M_stat;
    output [3:0] M_icode; 
    output M_Cnd; 
    output [63:0] M_valE, M_valA;
    output [3:0] M_dstE, M_dstM;

    always @(posedge clk) begin
        M_stat <= e_stat;
        M_icode <= e_icode;
        M_Cnd <= e_Cnd;
        M_valA <= e_valA;
        M_valE <= e_valE;
        M_dstE <= e_dstE;
        M_dstM <= e_dstM;
    end

endmodule