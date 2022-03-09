`include "fetch.v"
`include "decode.v"
`include "execute.v"
`include "memory.v"
`include "write_back.v"
`include "rfetch.v"
`include "rdecode.v"
`include "rexecute.v"
`include "rmem.v"
`include "rwback.v"
`include "pipectrl.v"

module processor;

    reg clk;
    reg [63:0] PC;
    wire [63:0] f_PC;
    wire F_stall, D_bubble, D_stall, E_bubble;
    wire [3:0] f_stat, D_stat, d_stat, E_stat, e_stat, M_stat, m_stat, W_stat, w_stat, e_dstE, e_dstM, M_dstE, M_dstM, W_dstM, W_dstE, d_dstE, d_dstM, d_srcA, d_srcB, E_dstE, E_dstM, E_srcA, E_srcB, m_dstE, m_dstM, w_dstE, w_dstM, rA, rB;                                             // AOK, Halt, Inst error
    wire [63:0] predPC, F_predPC;
    wire [63:0] valP, valM, valC;           //Only for pc_predict
    wire [63:0] f_valP, f_valC, D_valC, D_valP, e_valA, e_valE, M_valE, M_valA, m_valE, m_valM, W_valM, W_valE, d_valC, d_valA, d_valB, E_valA, E_valB, E_valC, w_valE, w_valM, W_valA, m_valA;
    wire inst_valid, imem_er, hlt_er, zf, sf, of, e_cnd, M_cnd;
    wire [3:0] icode, f_icode, D_icode, d_icode, E_icode, e_icode, M_icode, m_icode, W_icode, w_icode, f_ifun, D_ifun, d_ifun, E_ifun, f_rA, f_rB, D_rA, D_rB, dstA, dstB;
    wire [63:0] datamem[2047:0];
    reg [7:0] insmem[2047:0];

    initial begin

        $dumpfile("processor.vcd");
        $dumpvars(0, processor);

        clk = 1;
        PC = 0;
        #50 $finish;

    end

    rfetch rfetch1(.clk(clk), .F_stall(F_stall), .predPC(predPC), .F_predPC(F_predPC));
    fetch fetch1(.f_stat(f_stat), .F_PC(F_predPC), .f_icode(f_icode), .f_ifun(f_ifun), .f_rA(f_rA), .f_rB(f_rB), .f_valC(f_valC), .f_valP(f_valP), .inst_valid(inst_valid), .imem_er(imem_er), .hlt_er(hlt_er), .predPC(predPC));
    
    rdecode rdecode1(.clk(clk), .D_stall(D_stall), .D_bubble(D_bubble), .f_stat(f_stat), .f_icode(f_icode), .f_ifun(f_ifun), .f_rA(f_rA), .f_rB(f_rB), .f_valC(f_valC), .f_valP(f_valP), .D_stat(D_stat), .D_icode(D_icode), .D_ifun(D_ifun), .D_rA(D_rA), .D_rB(D_rB), .D_valC(D_valC), .D_valP(D_valP));
    decode decode1(.D_stat(D_stat), .D_icode(D_icode), .D_ifun(D_ifun), .rA(rA), .rB(rB), .D_valC(D_valC), .D_valP(D_valP), .e_dstE(e_dstE), .e_valE(e_valE), .M_dstE(M_dstE), .M_valE(M_valE), .M_dstM(M_dstM), .m_valM(m_valM), .W_dstM(W_dstM), .W_valM(W_valM), .W_dstE(W_dstE), .W_valE(W_valE), .d_stat(d_stat), .d_icode(d_icode), .d_ifun(d_ifun), .d_valC(d_valC), .d_valA(d_valA), .d_valB(d_valB), .d_dstE(d_dstE), .d_dstM(d_dstM), .d_srcA(d_srcA), .d_srcB(d_srcB));
    
    rexecute rexecute1(.clk(clk), .E_bubble(E_bubble), .d_stat(d_stat), .d_icode(d_icode), .d_ifun(d_ifun), .d_valC(d_valC), .d_valA(d_valA), .d_valB(d_valB), .d_dstE(d_dstE), .d_dstM(d_dstM), .d_srcA(d_srcA), .d_srcB(d_srcB), .E_stat(E_stat), .E_icode(E_icode), .E_ifun(E_ifun), .E_valC(E_valC), .E_valA(E_valA), .E_valB(E_valB), .E_dstE(E_dstE), .E_dstM(E_dstM), .E_srcA(E_srcA), .E_srcB(E_srcB));
    execute execute1(.E_stat(E_stat), .E_icode(E_icode), .E_ifun(E_ifun), .E_valA(E_valA), .E_valB(E_valB), .E_valC(E_valC), .E_dstE(E_dstE), .E_dstM(E_dstM), .e_icode(e_icode), .e_valE(e_valE), .e_stat(e_stat), .e_dstE(e_dstE), .e_dstM(e_dstM), .e_valA(e_valA), .zf(zf), .of(of), .sf(sf), .e_cnd(e_cnd), .W_stat(W_stat), .m_stat(m_stat));
    
    rmem rmem1(.clk(clk), .e_stat(e_stat), .e_icode(e_icode), .e_cnd(e_cnd), .e_valE(e_valE), .e_valA(e_valA), .e_dstE(e_dstE), .e_dstM(e_dstM), .M_stat(M_stat), .M_icode(M_icode), .M_cnd(M_cnd), .M_valE(M_valE), .M_valA(M_valA), .M_dstE(M_dstE), .M_dstM(M_dstM));
    memory memory1(.M_stat(M_stat), .M_icode(M_icode), .M_cnd(M_cnd), .M_valE(M_valE), .M_valA(M_valA), .M_dstE(M_dstE), .M_dstM(M_dstM), .m_stat(m_stat), .m_icode(m_icode), .m_valE(m_valE), .m_valM(m_valM), .m_dstE(), .m_dstM(m_dstM), .M_cndfwd(M_cnd), .M_valAfwd(M_valA), .M_valEfwd(M_valE));
    
    rwback rwback1(.clk(clk), .W_stat(W_stat), .W_icode(W_icode), .W_valE(W_valE), .W_valA(W_valA), .W_dstE(W_dstE), .W_dstM(W_dstM), .m_stat(m_stat), .m_icode(m_icode), .m_valE(m_valE), .m_valA(m_valA), .m_dstE(m_dstE), .m_dstM(m_dstM));
    write_back write_back1(.W_stat(W_stat), .W_icode(W_icode), .W_valE(W_valE), .W_valM(W_valM), .W_dstE(W_dstE), .W_dstM(W_dstM), .w_stat(w_stat), .w_icode(w_icode), .w_valE(w_valE), .w_valM(w_valM), .w_dstE(w_dstE), .w_dstM(w_dstM));
    
    pipectrl pipectrl1(.d_srcA(d_srcA), .d_srcB(d_srcB), .D_icode(D_icode), .E_dstM(E_dstM), .E_icode(E_icode), .e_cnd(e_cnd), .M_icode(M_icode), .m_stat(m_stat), .W_stat(W_stat), .F_stall(F_stall), .D_bubble(D_bubble), .D_stall(D_stall), .E_bubble(E_bubble));

    always #1 clk=~clk;

    //always @(*) begin
        //$monitor("clk=%d, icode=%d, ifun=%d, rA=%d, rB=%d, valA=%d, valB=%d, valC=%d, valE=%d, valM=%d, valP=%d, inst_valid=%d, imem_er=%d, hlt_er=%d, cnd=%d, dstA = %d, wrtA=%d, dstB = %d, wrtB = %d", clk, icode, ifun, rA, rB, valAout, valBout, valC, valE, valM, valP, inst_valid, imem_er, hlt_er, cnd, dstA, dataA, dstB, dataB);//, reg0, reg3);
        //$monitor("inst1_1 = %b, 2 = %b, 3 = %b, 4 = %b, 5 = %b, 6 = %b, 7 = %b, 8 = %b, 9 =  %b, 10 = %b", insmem[0], insmem[1], insmem[2], insmem[3], insmem[4], insmem[5], insmem[6], insmem[7], insmem[8], insmem[9]);
    //end

endmodule