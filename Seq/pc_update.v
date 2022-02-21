module pc_update(clk, icode, PC, valP, valM, valC, cnd, newPC);

    input clk, cnd;
    input [3:0] icode;
    input [63:0] valP, valM, valC, PC;

    output [63:0] newPC;                                                            //Updated PC value

    always @(*) begin
        
        if (icode == 2 || icode == 3 || icode == 4 || icode == 5 || icode == 6 || icode == 10 || icode == 11) begin     
                                                                                    //cmovXX, irmovq, rmmovq, mrmovq, OPq, pushq, popq
            newPC = valP;
        end
        else if (icode = 7) begin                                                   //jXX
            if (cnd == 1) begin
                newPC = valC;
            end
            else begin
                newPC = valP;
            end
        end
        else if (icode == 8) begin                                                  //call
            newPC = valC;
        end
        else if (icode == 9) begin                                                  //ret
            newPC = valM;
        end

    end

endmodule