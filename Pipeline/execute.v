`include "ALU/ALU_64.v"

module execute(E_stat, E_icode, E_ifun, E_valA, E_valB, E_valC, E_dstE, E_dstM, e_icode, e_valE, e_stat, e_dstE, e_dstM, e_valA, zf, of, sf, e_cnd, W_stat, m_stat);

    input [2:0] E_stat, W_stat, m_stat;
    input [3:0] E_icode, E_ifun, E_dstE, E_dstM;
    input [63:0] E_valA, E_valB, E_valC;
    output reg [3:0] e_icode;
    output reg [63:0] e_valE, e_valA;
    output reg e_cnd, zf, of, sf;                                     // e_cnd is conditional move/jump flag
    output reg [2:0] e_stat;

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

    always @(E_stat, E_icode, E_ifun, E_valA, E_valB, E_valC, E_dstE, E_dstM, W_stat, m_stat, e_cnd) begin                                           // Setting condition flags
        if(E_icode == 6 && W_stat[1] == 0 && m_stat[1] == 0 && W_stat[2] == 0 && m_stat[2] == 0) begin      // Set CC with forwarding
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
        // Actual ALU part                                     // Execution
            if (E_icode == 2) begin                               //cmovXX
                opcode = 2'b00;
                a = E_valA;
                b = 0;
                e_valE = res;
                if (E_ifun == 0) begin
                    e_cnd = 1;
                end
                else if (E_ifun == 1) begin
                    e_cnd = (sf^of) | zf;
                end
                else if (E_ifun == 2) begin
                    e_cnd = sf^of;
                end
                else if (E_ifun == 3) begin
                    e_cnd = zf;
                end
                else if (E_ifun == 4) begin
                    e_cnd = ~zf;
                end
                else if (E_ifun == 5) begin
                    e_cnd = ~(sf^of);
                end
                else if (E_ifun == 6) begin
                    e_cnd = ~(sf^of)&(~zf);
                end
            end
            if (E_icode == 3) begin                               //irmovq
                e_valE = E_valC;
            end

            if (E_icode == 4 || E_icode == 5) begin                 //rmmovq and mrmovq
                opcode = 2'b00;
                a = E_valC;
                b = E_valB;
                e_valE = res;
            end

            if(E_icode == 6) begin                                // OPq
                if (E_ifun == 0) begin                            // Add                          
                    opcode = 2'b00;
                    a = E_valA;
                    b = E_valB;
                end
                if (E_ifun == 1) begin                            // Sub
                    opcode = 2'b01;
                    a = E_valA;
                    b = E_valB;
                end
                if (E_ifun == 2) begin                            // And
                    opcode = 2'b10;
                    a = E_valA;
                    b = E_valB;
                end
                if (E_ifun == 3) begin                            // Xor
                    opcode = 2'b11;
                    a = E_valA;
                    b = E_valB;
                end
                e_valE = res;
            end

            if (E_icode == 7) begin                               //jXX
                if (E_ifun == 0) begin
                    e_cnd = 1;
                end
                else if (E_ifun == 1) begin
                    e_cnd = (sf^of) | zf;
                end
                else if (E_ifun == 2) begin
                    e_cnd = sf^of;
                end
                else if (E_ifun == 3) begin
                    e_cnd = zf;
                end
                else if (E_ifun == 4) begin
                    e_cnd = ~zf;
                end
                else if (E_ifun == 5) begin
                    e_cnd = ~(sf^of);
                end
                else if (E_ifun == 6) begin
                    e_cnd = ~(sf^of)&(~zf);
                end
            end
            if (E_icode == 8 || E_icode == 10) begin            //call and pushq
                opcode = 2'b01;
                a = E_valB;
                b = 8;
                e_valE = res;
            end
            if (E_icode == 9 || E_icode == 11) begin            //ret and popq
                opcode = 2'b00;
                a = E_valB;
                b = 8;
                e_valE = res;
            end

        e_icode = E_icode;
        e_stat = E_stat;
        e_valA = E_valA;
        e_dstM = E_dstM;
 
        if (e_icode == 2 && e_cnd == 0) begin
            e_dstE = 15;
        end 
    end

endmodule
