module pipectrl(d_srcA, d_srcB, D_icode, E_dstM, E_icode, e_cnd, M_icode, m_stat, W_stat, F_stall, D_bubble, D_stall, E_bubble, M_bubble, W_stall);

    input e_Cnd;
    input [3:0] d_srcA, d_srcB, D_icode, E_dstM, E_icode, M_icode, m_stat, W_stat; 
    output reg F_stall, D_bubble, D_stall, E_bubble, M_bubble, W_stall;



endmodule