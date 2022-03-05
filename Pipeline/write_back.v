module write_back(clk, cnd, icode, rA, rB, valM, valE, dstA, dstB, dataA, dataB);

    input clk, cnd;
    input [3:0] icode, rA, rB;
    input [63:0] valM, valE;
    output reg [3:0] dstA, dstB;
    output reg [63:0] dataA, dataB;

   
    always @(*) begin
        
        if (icode == 2 && cnd == 1) begin                               //cmovXXX 
            //regArr[rB] = valE;
            dstA = rB;
            dataA = valE;
            dstB = 15;
        end
        else if (icode == 3 || icode == 6) begin                        //irmovq, OPq
            //regArr[rB] = valE;
            dstA = rB;
            dataA = valE;
            dstB = 15;
        end
        else if (icode == 4 || icode == 7) begin                         //rmmovq, jXX
        end
        else if (icode == 5) begin                                       //mrmovq
            //regArr[rA] = valM;
            dstA = rA;
            dataA = valM;
            dstB = 15;
        end
        else if (icode == 8 || icode == 9 || icode == 10) begin          //call
            //regArr[14] = valE;
            dstA = 14;
            dataA = valE;
            dstB = 15;
        end
        else if (icode == 11) begin                                      //popq
            //regArr[14] = valE;
            //regArr[rA] = valM;

            dstA = 14;
            dataA = valE;

            dstB = rA;
            dataB = valM;
        end
    end

endmodule