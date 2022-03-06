module rwback(clk, M_stat, M_icode, M_valE, M_valA, M_dstE, M_dstM, m_stat, m_icode, m_valE, m_valA, m_dstE, m_dstM);

    input [1:0] W_stat;
    input [3:0] W_icode;
    input [63:0] W_valE, W_valA;
    input [3:0] W_dstE, W_dstM;
    output [1:0] w_stat;
    output [3:0] w_icode;  
    output [63:0] w_valE, w_valA;
    output [3:0] w_dstE, w_dstM;

    always @(posedge clk) begin
        w_stat <= W_stat;
        w_icode <= W_icode;
        w_valA <= W_valA;
        w_valE <= W_valE;
        w_dstE <= W_dstE;
        w_dstM <= W_dstM;
    end

endmodule