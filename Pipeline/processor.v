`include "fetch.v"
`include "decode.v"
`include "execute.v"
`include "memory.v"
`include "write_back.v"
`include "regarr.v"
`include "pc_predict.v"
`include "rfetch.v"
`include "rdecode.v"
`include "rexecute.v"
`include "rmem.v"
`include "rwback.v"

module processor;

    reg clk;
    reg [3:0] stat;                                             // AOK, Halt, Inst error
    reg [63:0] PC;
    wire [63:0] valA, valB, valC, valE, valP, valM, newPC, stkpt, dataA, dataB, valAout, valBout, valAin, valBin;
    wire cnd, inst_valid, imem_er, hlt_er, zf, sf, of;
    wire [3:0] icode, ifun, rA, rB, dstA, dstB;
    wire [63:0] datamem[2047:0];
    reg [7:0] insmem[2047:0];

    initial begin

        $dumpfile("processor.vcd");
        $dumpvars(0, processor);

        clk = 1;
        stat[0] = 1;
        stat[1] = 0;
        stat[2] = 0;
        PC = 0;

        #20 $finish;

    end

    fetch fetch1(.f_stat(), .PC(), .f_icode(), .f_ifun(), .f_rA(), .f_rB(), .valC(), .valP(), .inst_valid(), .imem_er(), .hlt_er());
    rfetch rfetch1(.clk(), .predPC(), .F_predPC());
    decode decode1(.D_stat(), .D_icode(), .D_ifun(), .rA(), .rB(), .valC(), .valP(), .e_dstE(), .e_valE(), .M_dstE(), .M_valE(), .M_dstM(), .m_valM(), .W_dstM(), .W_valM(), .W_dstE(), .W_valE(), .d_stat(), .d_icode(), .d_ifun(), .d_valC(), .d_valA(), .d_valB(), .d_dstE(), .d_dstM(), .d_srcA(), .d_srcB());
    rdecode rdecode1(.clk(), .f_stat(), .f_icode(), .f_ifun(), .f_rA(), .f_rB(), .f_valC(), .f_valP(), .D_stat(), .D_icode(), .D_ifun(), .D_rA(), .D_rB(), .D_valC(), .D_valP());
    execute execute1(.E_stat(), .E_icode(), .E_ifun(), .E_valA(), .E_valB(), .E_valC(), .E_dstE(), .E_dstM(), .e_icode(), .e_valE(), .e_stat(), .e_dstE(), .e_dstM(), .e_valA(), .zf(), .of(), .sf(), .e_cnd(), .W_stat(), .m_stat());
    rexecute rexecute1(.clk(), .d_stat(), .d_icode(), .d_ifun(), .d_valC(), .d_valA(), .d_valB(), .d_dstE(), .d_dstM(), .d_srcA(), .d_srcB(), .E_stat(), .E_icode(), .E_ifun(), .E_valC(), .E_valA(), .E_valB(), .E_dstE(), .E_dstM(), .E_srcA(), .E_srcB());
    memory memory1(.M_stat(), .M_icode(), .M_cnd(), .M_valE(), .M_valA(), .M_dstE(), .M_dstM(), .m_stat(), .m_icode(), .m_valE(), .m_valM(), .m_dstE(), .m_dstM(), .M_cndfwd(), .M_valAfwd(), .M_valEfwd());
    rmem rmem1(.clk(), .e_stat(), .e_icode(), .e_cnd(), .e_valE,() .e_valA(), .e_dstE(), .e_dstM(), .M_stat(), .M_icode(), .M_cnd(), .M_valE(), .M_valA(), .M_dstE(), .M_dstM());
    write_back write_back1(.W_stat(), .W_icode(), .W_valE(), .W_valM(), .W_dstE(), .W_dstM(), .w_stat(), .w_icode(), .w_valE(), .w_valM(), .w_dstE(), .w_dstM());
    rwback rwback1(.clk(), .W_stat(), .W_icode(), .W_valE(), .W_valA(), .W_dstE(), .W_dstM(), .m_stat(), .m_icode(), .m_valE(), .m_valA(), .m_dstE(), .m_dstM());
    pc_predict pc_predict1(.icode(), .PC(), .valP(), .valM(), .valC(), .predPC());  
            
    always #1 clk=~clk;

    always @(*) begin
        $monitor("clk=%d, icode=%d, ifun=%d, rA=%d, rB=%d, valA=%d, valB=%d, valC=%d, valE=%d, valM=%d, valP=%d, inst_valid=%d, imem_er=%d, hlt_er=%d, cnd=%d, dstA = %d, wrtA=%d, dstB = %d, wrtB = %d", clk, icode, ifun, rA, rB, valAout, valBout, valC, valE, valM, valP, inst_valid, imem_er, hlt_er, cnd, dstA, dataA, dstB, dataB);//, reg0, reg3);
        //$monitor("inst1_1 = %b, 2 = %b, 3 = %b, 4 = %b, 5 = %b, 6 = %b, 7 = %b, 8 = %b, 9 =  %b, 10 = %b", insmem[0], insmem[1], insmem[2], insmem[3], insmem[4], insmem[5], insmem[6], insmem[7], insmem[8], insmem[9]);
    end

endmodule