module rmem(clk, M_stat, M_icode, M_Cnd, M_valE, M_valA, M_dstE, M_dstM, m_stat, m_icode, m_Cnd, m_valE, m_valA, m_dstE, m_dstM);

    input [1:0] M_stat;
    input [3:0] M_icode;
    input M_Cnd;
    input [63:0] M_valE, M_valA;
    input [3:0] M_dstE, M_dstM;
    output [1:0] m_stat;
    output [3:0] m_icode; 
    output m_Cnd; 
    output [63:0] m_valE, m_valA;
    output [3:0] m_dstE, m_dstM;

    always @(posedge clk) begin
        m_stat <= M_stat;
        m_icode <= M_icode;
        m_Cnd <= M_Cnd;
        m_valA <= M_valA;
        m_valE <= M_valE;
        m_dstE <= M_dstE;
        m_dstM <= M_dstM;
    end

endmodule