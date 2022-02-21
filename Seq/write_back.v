`include "decode.v"
module write_back(clk, icode, rA, rB, valA, valB, valM, valE);

    input clk;
    input [3:0] icode, rA, rB;
    input [63:0] valA, valB, valM, valE;

    always @(*) begin
        
        if (icode == 2 || icode == 3 || icode == 6)) begin               //cmovXXX, irmovq, OPq
            regArr[rB] = valE;
        end
        else if (icode == 4 || icode == 7) begin                         //rmmovq, jXX
        end
        else if (icode == 5) begin                                       //mrmovq
            regArr[rA] = valM;
        end
        else if (icode == 8 || icode == 9 || icode == 10) begin          //call
            regArr[14] = valE;
        end
        else if (icode == 11) begin                                      //popq
            regArr[14] = valE;
            regArr[rA] = valM;
        end
        
    end

endmodule