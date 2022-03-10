`include "regarr.v"


module decode(D_stat, D_icode, D_ifun, rA, rB, D_valC, D_valP, e_dstE, e_valE, M_dstE, M_valE, M_dstM, m_valM, W_dstM, W_valM, W_dstE, W_valE, d_stat, d_icode, d_ifun, d_valC, d_valA, d_valB, d_dstE, d_dstM, d_srcA, d_srcB);

    input [3:0] D_stat;
    input [3:0] D_icode, D_ifun;
    input [3:0] rA, rB, e_dstE, M_dstE, M_dstM, W_dstM, W_dstE;  
    input [63:0] D_valC, D_valP, e_valE, M_valE, m_valM, W_valM, W_valE;                         
    //8 byte values in the registers, stk is (%rsp)
    output reg [3:0] d_stat, d_icode, d_ifun;
    output reg [63:0] d_valC, d_valA, d_valB;
    output reg [3:0] d_dstE, d_dstM, d_srcA, d_srcB;                          // regArr[14] is stack pointer  

    wire [63:0] d_rvalA, d_rvalB, valStk;

    regarr regfile(.srcA(d_srcA), .srcB(d_srcB), .valA(d_rvalA), .valB(d_rvalB), .valStk(valStk), .dstM(W_dstM), .dstE(W_dstE), .M(W_valM), .E(W_valE));

    always @(D_icode, D_ifun, rA, rB, D_valC, D_valP, d_rvalA, d_rvalB) begin
        
        d_stat = D_stat;
        d_icode = D_icode;
        d_ifun = D_ifun;
        d_valC = D_valC;

        case (D_icode)
            2: begin    //cmovxx
                d_dstE = 15;
                d_dstM = rB;
                d_srcA = rA;
                d_srcB = 15;
            end
            3: begin    //irmovq
                d_dstE = rB;
                d_dstM = 15;
                d_srcA = 15;
                d_srcB = 15;
            end
            4: begin    //rmmovq
                d_dstE = 15;
                d_dstM = 15;
                d_srcA = rA;
                d_srcB = rB;
            end
            5: begin    //mrmovq
                d_dstE = 15;
                d_dstM = rA;
                d_srcA = 15;
                d_srcB = rB;
            end
            6: begin    //opq
                d_dstE = rB;
                d_dstM = 15;
                d_srcA = rA;
                d_srcB = rB;
            end
            8: begin    //call  
                d_dstE = 14;
                d_dstM = 15;
                d_srcA = 15;
                d_srcB = 14;
            end
            9: begin    //ret
                d_dstE = 14;
                d_dstM = 15;
                d_srcA = 14;
                d_srcB = 14;
            end
            10: begin   //pushq
                d_dstE = 14;
                d_dstM = 15;
                d_srcA = rA;
                d_srcB = 14;
            end
            11: begin //popq
                d_dstE = 14;
                d_dstM = rA;
                d_srcA = 14;
                d_srcB = 14;
            end
            default: begin
                d_dstE = 15;
                d_dstM = 15;
                d_srcA = 15;
                d_srcB = 15;
            end
        endcase

        d_valA = d_rvalA;

        if(D_icode == 8 || D_icode == 7) begin
            d_valA = D_valP;
        end
        else if(d_srcA == e_dstE && e_dstE != 15) begin
            d_valA = e_valE;
        end
        else if(d_srcA == M_dstM && M_dstM != 15) begin
            d_valA = m_valM;
        end
        else if(d_srcA == M_dstE && M_dstE != 15) begin
            d_valA = M_valE;
        end
        else if(d_srcA == W_dstM && W_dstM != 15) begin
            d_valA = W_valM;
        end
        else if(d_srcA == W_dstE && W_dstE != 15) begin
            d_valA = W_valE;
        end

        d_valB = d_rvalB;

        if(d_srcB == e_dstE && e_dstE != 15) begin
            d_valB = e_valE;
        end
        else if(d_srcB == M_dstM && M_dstM != 15) begin
            d_valB = m_valM;
        end
        else if(d_srcB == M_dstE && M_dstE != 15) begin
            d_valB = M_valE;
        end
        else if(d_srcB == W_dstM && W_dstM != 15) begin
            d_valB = W_valM;
        end
        else if(d_srcB == W_dstE && W_dstE != 15) begin
            d_valB = W_valE;
        end
         
    end

endmodule