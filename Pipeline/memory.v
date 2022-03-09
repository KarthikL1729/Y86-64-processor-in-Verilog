module memory(M_stat, M_icode, M_cnd, M_valE, M_valA, M_dstE, M_dstM, m_stat, m_icode, m_valE, m_valM, m_dstE, m_dstM, M_cndfwd, M_valAfwd, M_valEfwd);

    input M_cnd;
    input [3:0] M_stat;
    input [3:0] M_icode, M_dstE, M_dstM;
    input [63:0] M_valA, M_valE;

    output reg [63:0] m_valE, m_valM, M_valAfwd, M_valEfwd; 
    output reg [3:0] m_dstE, m_dstM, m_icode;
    output reg [3:0] m_stat;
    output reg M_cndfwd;
                                                        
    reg [63:0] datamem [2047:0];                                               //Data memory 2048*8 bytes

    always @(M_stat, M_icode, M_cnd, M_valE, M_valA, M_dstE, M_dstM) begin

        m_icode = M_icode;
        m_valE = M_valE;
        m_dstE = M_dstE;
        m_dstM = M_dstM;
        M_valAfwd = M_valA;
        M_valEfwd = M_valE;
        M_cndfwd = M_cnd;
        m_stat = M_stat;

       
            
        if (M_icode == 2 || M_icode == 3 || M_icode == 6 || M_icode == 7) begin           //cmovXXX, irmovq, OPq, jXX
        end
        else if (M_icode == 4 || M_icode == 10) begin   //rmmovq, pushq
            if(M_valE>=0 && M_valE <=2047) begin
                datamem[M_valE] = M_valA;
            end    
            else begin
                m_stat[3] = 1;
            end                            
        end
        else if (M_icode == 5) begin                                                //mrmovq
            if(M_valE>=0 && M_valE <=2047) begin
                m_valM = datamem[M_valE];
            end    
            else begin
                m_stat[3] = 1;
            end
        end
        else if (M_icode == 8) begin                                                //call                  
            if(M_valE>=0 && M_valE <=2047) begin
                datamem[M_valE] = M_valA;
            end    
            else begin
                m_stat[3] = 1;
            end
        end
        else if (M_icode == 9 || M_icode == 11) begin                                   //ret, popq          
           if(M_valA>=0 && M_valA <=2047) begin
                m_valM = datamem[M_valA]; 
            end    
            else begin
                m_stat[3] = 1;
            end
        end

    end

    

endmodule