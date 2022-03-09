module pc_select(PC, M_icode, M_cnd, M_valA, W_icode, W_valM, F_predPC, f_PC);

    input M_cnd;
    input [3:0] M_icode, W_icode;
    input [63:0] M_valA, W_valM, F_predPC, PC;
    output reg[63:0] f_PC;

    always @(M_icode, M_cnd, M_valA, W_icode, W_valM, F_predPC) begin
        if(M_icode == 7 && ~M_cnd) begin                // jXX instruction
            f_PC = M_valA;
        end
        else if (W_icode == 9) begin                    // ret instruction
            f_PC = W_valM;
        end
        else begin
            f_PC = F_predPC;
        end

    end
        
endmodule