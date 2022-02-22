`include "ALU/ALU_64.v"

module execute(clk, icode, ifun, valA, valB, valC, valE, zf, of, sf, cnd);

    input clk;
    input [3:0] icode, ifun;
    input [63:0] valA, valB, valC;
    output reg [63:0] valE;
    output reg cnd, zf, of, sf;                                     // cnd is conditional move/jump flag

    reg signed [63:0] a, b;
    reg [1:0] opcode;
    wire signed [63:0] res;
    wire overflow, zero;

    ALU_64 alu(opcode, a, b, res, overflow, zero);

    initial begin
        opcode = 2'b0;
        a = 0;
        b = 0;
    end

    always @(*) begin                                           // Setting condition flags
        if(clk == 1 && icode == 6) begin
            if(zero == 0) begin                                 // Zero flag
                zf = 1;
            end
            if (res < 0) begin                                  // Sign flag
                sf = 1;
            end
            if ((a < 0 == b < 0) && (res < 0 != a < 0)) begin   // Overflow flag
                of = 1;
            end
        end
        // Actual ALU part
        if (clk == 1) begin                                     // Execution
            if (icode == 2) begin                               //cmovXX
                opcode = 2'b00;
                a = valA;
                b = valB;
                valE = res;
                if (ifun == 0) begin
                    cnd = 1;
                end
                else if (ifun == 1) begin
                    cnd = (sf^of) | zf;
                end
                else if (ifun == 2) begin
                    cnd = sf^of;
                end
                else if (ifun == 3) begin
                    cnd = zf;
                end
                else if (ifun == 4) begin
                    cnd = ~zf;
                end
                else if (ifun == 5) begin
                    cnd = ~(sf^of);
                end
                else if (ifun == 6) begin
                    cnd = ~(sf^of)&(~zf);
                end
            end
            if (icode == 3) begin                               //irmovq
                opcode = 2'b00;
                a = valC;
                b = 0;
                valE = res;
            end

            if (icode == 4 || icode == 5) begin                 //rmmovq and mrmovq
                opcode = 2'b00;
                a = valC;
                b = valB;
                valE = res;
            end

            if(icode == 6) begin                                // OPq
                if (ifun == 0) begin                            // Add                          
                    opcode = 2'b00;
                    a = valA;
                    b = valB;
                end
                if (ifun == 1) begin                            // Sub
                    opcode = 2'b01;
                    a = valA;
                    b = valB;
                end
                if (ifun == 2) begin                            // And
                    opcode = 2'b10;
                    a = valA;
                    b = valB;
                end
                if (ifun == 3) begin                            // Xor
                    opcode = 2'b11;
                    a = valA;
                    b = valB;
                end
                valE = res;
            end

            if (icode == 7) begin                               //jXX
                if (ifun == 0) begin
                    cnd = 1;
                end
                else if (ifun == 1) begin
                    cnd = (sf^of) | zf;
                end
                else if (ifun == 2) begin
                    cnd = sf^of;
                end
                else if (ifun == 3) begin
                    cnd = zf;
                end
                else if (ifun == 4) begin
                    cnd = ~zf;
                end
                else if (ifun == 5) begin
                    cnd = ~(sf^of);
                end
                else if (ifun == 6) begin
                    cnd = ~(sf^of)&(~zf);
                end
            end
            if (icode == 8 || icode == 10) begin            //call and pushq
                opcode = 2'b01;
                a = valB;
                b = 8;
                valE = res;
            end
            if (icode == 9 || icode == 11) begin            //ret and popq
                opcode = 2'b00;
                a = valB;
                b = 8;
                valE = res;
            end
        end
    end

endmodule
