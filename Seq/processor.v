`include "fetch.v"
`include "decode.v"
`include "execute.v"
`include "memory.v"
`include "write_back.v"
`include "pc_update.v"

module processor;

    reg clk;
    reg [2:0] stat;                                             // AOK, Halt, Inst error
    reg [63:0] PC;
    wire [63:0] valA, valB, valC, valE, valP, valM, newPC;
    wire cnd, inst_valid, imem_er, hlt_er, zf, sf, of;
    wire [3:0] icode, ifun, rA, rB;
    wire [63:0] regArr[14:0];
    wire [63:0] datamem[2047:0];
    wire [7:0] insmem[2047:0];

    fetch fetch1(.clk(clk), .PC(PC), .icode(icode), .ifun(ifun), .rA(rA), .rB(rB), .valC(valC), .valP(valP), .inst_valid(inst_valid), .imem_er(imem_er), .hlt_er(hlt_er));
    decode decode1(.clk(clk), .icode(icode), .rA(rA), .rB(rB), .memA(memA), .memB(memB), .regArr(regArr), .valA(valA), .valB(valB));
    execute execute1(.clk(clk), .PC(PC), .icode(icode), .ifun(ifun), .valA(valA), .valB(valB), .valC(valC), .valE(valE), .zf(zf), .of(of), .sf(sf), .cnd(cnd));
    memory memory1(.clk(clk), .icode(icode), .valP(valP), .valA(valA), .valB(valB), .valE(valE), .valM(valM), .datamem(datamem));
    write_back write_back1(.clk(clk), .icode(icode), .rA(rA), .rB(rB), .valA(valA), .valB(valB), .valM(valM), .valE(valE));
    pc_update pc_update1(.clk(clk), .icode(icode), .PC(PC), .valP(valP), .valM(valM), .valC(valC), .cnd(cnd), .newPC(newPC));

    initial begin

        $dumpfile("processor.vcd");
        $dumpvars(0, processor);

        clk = 0;
        stat[0] = 1;
        stat[1] = 0;
        stat[2] = 0;
        PC = 0;

    end

    always @(*) begin
        PC=newPC;

        if (inst_valid) begin
            stat[1] = inst_valid;
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

    initial begin
        $monitor("clk=%d, icode=%d, ifun=%d, rA=%d, rB=%d, valA=%d, valB=%d, valC=%d, valE=%d, valM=%d, valP=%d, inst_valid=%d, mem_er=%d, hlt_er=%d, cnd=%d", clk, icode, ifun, rA, rB, valA, valB, valC, valE, valM, valP, inst_valid, mem_er, hlt_er, cnd);
    end

endmodule