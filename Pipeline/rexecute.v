module rexecute(clk, E_stat, E_icode, E_ifun, E_valC, E_valA, E_valB, E_dstE, E_dstM, E_srcA, E_srcB, e_stat, e_icode, e_ifun, e_valC, e_valA, e_valB, e_dstE, e_dstM, e_srcA, e_srcB);
    
    input clk;
    input [1:0] E_stat;
    input [3:0] E_icode, E_ifun;
    input [63:0] E_valC, E_valA, E_valB;
    input [3:0] E_dstE, E_dstM, E_srcA, E_srcB;
    output [1:0] e_stat;
    output [3:0] e_icode, e_ifun;
    output [63:0] e_valC, e_valA, e_valB;    
    output [3:0] e_dstE, e_dstM, e_srcA, e_srcB;

    always @(posedge clk) begin
        e_stat <= E_stat;
        e_icode <= E_icode;
        e_ifun <= E_ifun;
        e_valA <= E_valA;
        e_valB <= E_valB;
        e_valC <= E_valC;
        e_dstE <= E_dstE;
        e_dstM <= E_dstM;
        e_srcA <= E_srcA;
        e_srcB <= E_srcB;
    end

endmodule