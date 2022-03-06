module pipereg(F, D, E, M, W);
    
    reg [217:0] F;                     // Only predPC
    reg [217:0] D;                    // stat, icode, ifun, rA, rB, valC, valP
    reg [217:0] E;                    // stat, icode, ifun, valC, valA, valB, dstE, dstM, srcA, srcB
    reg [217:0] M;                    // stat, icode, Cnd, valE, valA, dstE, dstM
    reg [217:0] W;                    // stat, icode, valE, valA, dstE, dstM

    //reg [63:0] F;                     // Only predPC
    //reg [146:0] D;                    // stat, icode, ifun, rA, rB, valC, valP
    //reg [217:0] E;                    // stat, icode, ifun, valC, valA, valB, dstE, dstM, srcA, srcB
    //reg [142:0] M;                    // stat, icode, Cnd, valE, valA, dstE, dstM
    //reg [143:0] W;                    // stat, icode, valE, valA, dstE, dstM
    
    input F_predPC;
    output f_predPC;

    input D_stat;
    input D_icode, D_ifun, D_rA, D_rB;
    input D_valC, D_valP;
    output d_stat;
    output d_icode, d_ifun, d_rA, d_rB;
    output d_valC, d_valP;

    input E_stat;
    input E_icode, E_ifun;
    input E_valC, E_valA, E_valB;
    input E_dstE, E_dstM, E_srcA, E_srcB;
    output e_stat;
    output e_icode, e_ifun;
    output e_valC, e_valA, e_valB;
    output e_dstE, e_dstM, e_srcA, e_srcB;

    input M_stat;
    input M_icode;
    input M_Cnd;
    input M_valE, M_valA;
    input M_dstE, M_dstM;
    output m_stat;
    output m_icode; 
    output m_Cnd; 
    output m_valE, m_valA;
    output m_dstE, m_dstM;

    input W_stat;
    input W_icode;
    input W_valE, W_valA; 
    input W_dstE, W_dstM;
    output w_stat;
    output w_icode; 
    output w_valE, w_valA;
    output w_dstE, w_dstM;


    always @(*) begin
        $display("F: %d\nD: %d\nE: %d\nM: %d\nW: %d\n", F, D, E, M, W);
    end

    // Should probably use a register array to be able to index into whatever we need, in which case we need
    //to designate certain specific blocks of the register to certain inputs and leave the rest unused.
    //ALL EXECUTION IN THE STAGE NEEDS TO BE DONE ONE THE INPUT WITH CAPITAL LETTER BEFORE THE SUBSCRIPT. I guess. Or else it might not make sense.
    //assign reg0 = regArr[0];
    //assign reg3 = regArr[3];
endmodule