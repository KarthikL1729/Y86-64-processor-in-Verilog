module pc_predict(icode, PC, valP, valM, valC, predPC);

    input [3:0] icode;
    input [63:0] valP, valM, valC, PC;

    output reg [63:0] predPC;                                                            //Updated PC value

    always @(*) begin
        
        if (icode == 2 || icode == 3 || icode == 4 || icode == 5 || icode == 6 || icode == 10 || icode == 11) begin                                                                          //cmovXX, irmovq, rmmovq, mrmovq, OPq, pushq, popq
            predPC = valP;
        end
        else if (icode == 7) begin                                                   //jXX
            predPC = valC;
        end
        else if (icode == 8) begin                                                  //call
            predPC = valC;
        end
        else if (icode == 9) begin                                                  //ret
            predPC = valM;
        end

    end

endmodule

module pc_select(M_icode, M_Cnd, M_valA, W_icode, W_valM, F_predPC, f_PC);

    input M_Cnd;
    input [3:0] M_icode, W_icode;
    input [63:0] M_valA, W_valM, F_predPC;
    output reg[63:0] f_PC;

    if(M_icode == 7 && !M_Cnd) begin                // jXX instruction
        f_PC = M_valA;
    end
    else if (W_icode == 9) begin                    // ret instruction
        f_PC = W_valM;
    end
    else begin
      f_PC = F_predPC;
    end

endmodule