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
    wire [63:0] regmem0, regmem1, regmem2, regmem3, regmem4, regmem5, regmem6, regmem7, regmem8, regmem9, regmem10, regmem11, regmem12, regmem13, regmem14;
    wire [63:0] valA, valB, valC, valE, valP, valM, newPC;
    wire cnd, inst_valid, imem_er, hlt_er, zf, sf, of;
    wire [3:0] icode, ifun, rA, rB;
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

        //regmem0 = 0;
        //regmem1 = 0;
        //regmem2 = 0;
        //regmem3 = 0;
        //regmem4 = 0;
        //regmem5 = 0;
        //regmem6 = 0;
        //regmem7 = 0;
        //regmem8 = 0;
        //regmem9 = 0;
        //regmem10 = 0;
        //regmem11 = 0;
        //regmem12 = 0;
        //regmem13 = 0;
        //regmem14 = 0;

        insmem[0] = 48;
        insmem[1] = 240;
        insmem[2] = 0;
        insmem[3] = 0;
        insmem[4] = 0;
        insmem[5] = 0;
        insmem[6] = 0;
        insmem[7] = 0;
        insmem[8] = 0;
        insmem[9] = 4;

        insmem[10] = 48;
        insmem[11] = 243;
        insmem[12] = 0;
        insmem[13] = 0;
        insmem[14] = 0;
        insmem[15] = 0;
        insmem[16] = 0;
        insmem[17] = 0;
        insmem[18] = 0;
        insmem[19] = 10;

        insmem[20] = 96;
        insmem[21] = 3;

        #10 $finish;

    end

    fetch fetch1(.clk(clk), .PC(PC), .icode(icode), .ifun(ifun), .rA(rA), .rB(rB), .valC(valC), .valP(valP), .inst_valid(inst_valid), .imem_er(imem_er), .hlt_er(hlt_er));
    decode decode1(.clk(clk), .icode(icode), .rA(rA), .rB(rB), .regmem0(regmem0), .regmem1(regmem1), .regmem2(regmem2), .regmem3(regmem3), .regmem4(regmem4), .regmem5(regmem5), .regmem6(regmem6), .regmem7(regmem7), .regmem8(regmem8), .regmem9(regmem9), .regmem10(regmem10), .regmem11(regmem11), .regmem12(regmem12), .regmem13(regmem13), .regmem14(regmem14), .valA(valA), .valB(valB));
    execute execute1(.clk(clk), .icode(icode), .ifun(ifun), .valA(valA), .valB(valB), .valC(valC), .valE(valE), .zf(zf), .of(of), .sf(sf), .cnd(cnd));
    memory memory1(.clk(clk), .icode(icode), .valP(valP), .valA(valA), .valB(valB), .valE(valE), .valM(valM));
    write_back write_back1(.clk(clk), .cnd(cnd), .icode(icode), .rA(rA), .rB(rB), .regmem0(regmem0), .regmem1(regmem1), .regmem2(regmem2), .regmem3(regmem3), .regmem4(regmem4), .regmem5(regmem5), .regmem6(regmem6), .regmem7(regmem7), .regmem8(regmem8), .regmem9(regmem9), .regmem10(regmem10), .regmem11(regmem11), .regmem12(regmem12), .regmem13(regmem13), .regmem14(regmem14), .valA(valA), .valB(valB), .valM(valM), .valE(valE));
    pc_update pc_update1(.clk(clk), .icode(icode), .PC(PC), .valP(valP), .valM(valM), .valC(valC), .cnd(cnd), .newPC(newPC));

    always @(posedge clk) begin
        
        $display("Hibro");
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
        $monitor("clk=%d, icode=%d, ifun=%d, rA=%d, rB=%d, valA=%d, valB=%d, valC=%d, valE=%d, valM=%d, valP=%d, inst_valid=%d, imem_er=%d, hlt_er=%d, cnd=%d", clk, icode, ifun, rA, rB, valA, valB, valC, valE, valM, valP, inst_valid, imem_er, hlt_er, cnd);
        //$monitor("inst1_1 = %b, 2 = %b, 3 = %b, 4 = %b, 5 = %b, 6 = %b, 7 = %b, 8 = %b, 9 =  %b, 10 = %b", insmem[0], insmem[1], insmem[2], insmem[3], insmem[4], insmem[5], insmem[6], insmem[7], insmem[8], insmem[9]);
    end

endmodule