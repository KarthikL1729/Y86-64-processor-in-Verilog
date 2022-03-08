module rwback(clk, W_stat, W_icode, W_valE, W_valA, W_dstE, W_dstM, m_stat, m_icode, m_valE, m_valA, m_dstE, m_dstM);

    input [1:0] m_stat;
    input [3:0] m_icode;
    input [63:0] m_valE, m_valA;
    input [3:0] m_dstE, m_dstM;
    output reg [1:0] W_stat;
    output reg [3:0] W_icode;  
    output reg [63:0] W_valE, W_valA;
    output reg [3:0] W_dstE, W_dstM;

    always @(posedge clk) begin
        W_stat <= m_stat;
        W_icode <= m_icode;
        W_valA <= m_valA;
        W_valE <= m_valE;
        W_dstE <= m_dstE;
        W_dstM <= m_dstM;
    end

endmodule