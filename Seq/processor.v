`include "fetch.v"
`include "decode.v"
`include "execute.v"
`include "memory.v"
`include "write_back.v"
`include "pc_update.v"
`include "regarr.v"

module processor;

    reg clk;
    reg [2:0] stat;                                             // AOK, Halt, Inst error
    reg [63:0] PC;
    wire [63:0] valA, valB, valC, valE, valP, valM, newPC, stkpt, dataA, dataB, valAout, valBout, valAin, valBin;// reg0, reg3;
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

    fetch fetch1(.clk(clk), .PC(PC), .icode(icode), .ifun(ifun), .rA(rA), .rB(rB), .valC(valC), .valP(valP), .inst_valid(inst_valid), .imem_er(imem_er), .hlt_er(hlt_er));
    regarr regArr(.PC(PC), .rA(rA), .rB(rB), .valA(valA), .valB(valB), .valStk(stkpt), .dstA(dstA), .dstB(dstB), .wrtA(dataA), .wrtB(dataB));
    decode decode1(.clk(clk), .icode(icode), .valAin(valA), .valBin(valB), .stkPt(stkpt), .valAout(valAout), .valBout(valBout));
    execute execute1(.clk(clk), .icode(icode), .ifun(ifun), .valA(valAout), .valB(valBout), .valC(valC), .valE(valE), .zf(zf), .of(of), .sf(sf), .cnd(cnd));
    memory memory1(.clk(clk), .icode(icode), .valP(valP), .valA(valAout), .valB(valBout), .valE(valE), .valM(valM));
    write_back write_back1(.clk(clk), .cnd(cnd), .icode(icode), .rA(rA), .rB(rB), .valM(valM), .valE(valE), .dstA(dstA), .dstB(dstB), .dataA(dataA), .dataB(dataB));
    pc_update pc_update1(.clk(clk), .icode(icode), .PC(PC), .valP(valP), .valM(valM), .valC(valC), .cnd(cnd), .newPC(newPC));

    always @(posedge clk) begin
        
        //$display("Hibro");
        PC = newPC;

        if (inst_valid) begin
            stat[1] = ~inst_valid;
            stat[2] = 0;
            stat[0] = 0;
        end
        else if(hlt_er) begin
            stat[2] = hlt_er;
            stat[1] = 0;
            stat[0] = 0;
        end
        else begin
            stat[0] = 1;
            stat[1] = 0;
            stat[2] = 0;
        end

        if (stat[1] == 1 || stat[2] == 1) begin
            $finish;                                                //Instruction invalid error or halt encountered, stop everything.
        end
    end

    always #1 clk=~clk;

    always @(*) begin
        $monitor("clk=%d, icode=%d, ifun=%d, rA=%d, rB=%d, valA=%d, valB=%d, valC=%d, valE=%d, valM=%d, valP=%d, inst_valid=%d, imem_er=%d, hlt_er=%d, cnd=%d, dstA = %d, wrtA=%d, dstB = %d, wrtB = %d", clk, icode, ifun, rA, rB, valAout, valBout, valC, valE, valM, valP, inst_valid, imem_er, hlt_er, cnd, dstA, dataA, dstB, dataB);//, reg0, reg3);
        //$monitor("inst1_1 = %b, 2 = %b, 3 = %b, 4 = %b, 5 = %b, 6 = %b, 7 = %b, 8 = %b, 9 =  %b, 10 = %b", insmem[0], insmem[1], insmem[2], insmem[3], insmem[4], insmem[5], insmem[6], insmem[7], insmem[8], insmem[9]);
    end

endmodule