module decode(clk, icode, valAin, valBin, stkPt, valAout, valBout);

    input clk;
    input [3:0] icode;
    input [63:0] valAin, valBin, stkPt;                           
    //8 byte values in the registers, stk is (%rsp)
    output reg [63:0] valAout, valBout;                           // regArr[14] is stack pointer  


    always @(icode, valAin, valBin, stkPt) begin
        
        if (icode == 2) begin                               //cmovxx instruction encountered
            valAout = valAin;
            valBout = 0;
        end
        else if (icode == 3 || icode == 7) begin            //irmovq, jXX
        end
        else if(icode == 4 || icode == 6) begin             //rmmovq, OPq
            valAout = valAin;
            valBout = valBin;
        end
        else if(icode == 5) begin                           //mrmovq
            valBout = valBin;
        end
        else if(icode == 8) begin                           //call
            valBout = stkPt;                                //stk
        end          
        else if (icode == 9 || icode == 11) begin           //ret, popq
            valAout = stkPt;
            valBout = stkPt;
        end
        else if (icode == 10) begin                         //pushq
            valAout = valAin;
            valBout = stkPt;
        end

    end
endmodule