
module pc_select(M_icode, M_cnd, M_valA, W_icode, W_valM, F_predPC, PC);

    input M_cnd;
    input [3:0] M_icode, W_icode;
    input [63:0] M_valA, W_valM, F_predPC;
    output reg[63:0] PC;

    always @(M_icode, M_cnd, M_valA, W_icode, W_valM, F_predPC) begin
        if(M_icode == 7 && ~M_cnd) begin                // jXX instruction
            PC = M_valA;
        end
        else if (W_icode == 9) begin                    // ret instruction
            PC = W_valM;
        end
        else begin
            PC = F_predPC;
        end

    end
        
endmodule