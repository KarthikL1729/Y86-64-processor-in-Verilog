module rmem(clk, e_stat, e_icode, e_cnd, e_valE, e_valA, e_dstE, e_dstM, M_stat, M_icode, M_cnd, M_valE, M_valA, M_dstE, M_dstM);

    input clk;
    input [3:0] e_stat;
    input [3:0] e_icode;
    input e_cnd;
    input [63:0] e_valE, e_valA;
    input [3:0] e_dstE, e_dstM;
    output reg [3:0] M_stat;
    output reg [3:0] M_icode; 
    output reg M_cnd; 
    output reg [63:0] M_valE, M_valA;
    output reg [3:0] M_dstE, M_dstM;

    always @(posedge clk) begin
        M_stat <= e_stat;
        M_icode <= e_icode;
        M_cnd <= e_cnd;
        M_valA <= e_valA;
        M_valE <= e_valE;
        M_dstE <= e_dstE;
        M_dstM <= e_dstM;
    end

endmodule