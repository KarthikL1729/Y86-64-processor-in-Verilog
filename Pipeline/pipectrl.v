module pipectrl(d_srcA, d_srcB, D_icode, E_dstM, E_icode, e_cnd, M_icode, m_stat, W_stat, F_stall, D_bubble, D_stall, E_bubble);

    input e_cnd;
    input [3:0] d_srcA, d_srcB, D_icode, E_dstM, E_icode, M_icode, m_stat, W_stat; 
    output reg F_stall, D_bubble, D_stall, E_bubble;
    reg luhaz, inret, misbranch;
    initial begin
        F_stall = 0;
        D_bubble = 0;
        D_stall = 0;
        E_bubble = 0;

    end

    always @(e_cnd, d_srcA, d_srcB, D_icode, E_dstM, E_icode, M_icode, m_stat, W_stat) begin

        luhaz = (E_icode == 5 || E_icode == 11) && (E_dstM == d_srcA || E_dstM == d_srcB);
        inret = (D_icode == 9 || E_icode == 9 || M_icode == 9);
        misbranch = (E_icode == 7 && e_cnd == 0);
        
        F_stall = (inret || luhaz);
        D_bubble = ((inret || misbranch) && ~luhaz);
        D_stall = luhaz;
        E_bubble = (misbranch || luhaz);

    end

endmodule