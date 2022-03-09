module pc_predict(f_icode, f_valP, f_valC, predPC);

    input [3:0] f_icode;
    input [63:0] f_valP, f_valC;

    output reg [63:0] predPC;                                                            //Updated PC value

    initial begin
        if (f_icode == 2 || f_icode == 3 || f_icode == 4 || f_icode == 5 || f_icode == 6 || f_icode == 10 || f_icode == 11) begin                                                                          //cmovXX, irmovq, rmmovq, mrmovq, OPq, pushq, popq
            predPC = f_valP;
        end
        else if (f_icode == 7) begin                                                   //jXX
            predPC = f_valC;
        end
        else if (f_icode == 8) begin                                                  //call
            predPC = f_valC;
        end
    end

    always @(f_icode, f_valP, f_valC) begin
        
        if (f_icode == 2 || f_icode == 3 || f_icode == 4 || f_icode == 5 || f_icode == 6 || f_icode == 10 || f_icode == 11) begin                                                                          //cmovXX, irmovq, rmmovq, mrmovq, OPq, pushq, popq
            predPC = f_valP;
        end
        else if (f_icode == 7) begin                                                   //jXX
            predPC = f_valC;
        end
        else if (f_icode == 8) begin                                                  //call
            predPC = f_valC;
        end

    end

endmodule
