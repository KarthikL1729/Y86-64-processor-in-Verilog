module pc_update(clk, icode, PC, valP, valM, valC, cnd, predPC);

    input clk, cnd;
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