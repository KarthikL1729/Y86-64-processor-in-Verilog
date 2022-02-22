module regarr(PC, rA, rB, valA, valB, valStk, dstA, dstB, wrtA, wrtB);
    input [63:0] PC;
    input [3:0] rA, rB, dstA, dstB;
    input [63:0] wrtA, wrtB;
    //output [63:0] reg0, reg3;
    //input rw;       //0 for read and 1 for write

    output reg [63:0] valA, valB, valStk;

    reg [63:0] regArr[14:0];

    always @(rA, rB, PC) begin
        valA = regArr[rA];
        valB = regArr[rB];
        valStk = regArr[14];
    end

    always @(dstA, wrtA, dstB, wrtB) begin
        regArr[dstA] <= wrtA;
        regArr[dstB] <= wrtB;

    end

    always @(PC) begin
        $display("0: %d\n1: %d\n2: %d\n3: %d\n4: %d\n5: %d\n6: %d\n7: %d\n8: %d\n9: %d\n10: %d\n11: %d\n12: %d\n13: %d\n14: %d\n",regArr[0],regArr[1],regArr[2],regArr[3],regArr[4],regArr[5],regArr[6],regArr[7],regArr[8],regArr[9],regArr[10],regArr[11],regArr[12],regArr[13],regArr[14]);
    end

    //assign reg0 = regArr[0];
    //assign reg3 = regArr[3];
endmodule