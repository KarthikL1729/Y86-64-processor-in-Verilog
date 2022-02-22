module write_back(clk, cnd, icode, rA, rB, regmem0, regmem1, regmem2, regmem3, regmem4, regmem5, regmem6, regmem7, regmem8, regmem9, regmem10, regmem11, regmem12, regmem13, regmem14, valA, valB, valM, valE);

    input clk, cnd;
    input [3:0] icode, rA, rB;
    input [63:0] regmem0, regmem1, regmem2, regmem3, regmem4, regmem5, regmem6, regmem7, regmem8, regmem9, regmem10, regmem11, regmem12, regmem13, regmem14;
    input [63:0] valA, valB, valM, valE;

    reg [63:0] regArr[14:0];

    initial begin
        
        regArr[0] = regmem0;
        regArr[1] = regmem1;
        regArr[2] = regmem2;
        regArr[3] = regmem3;
        regArr[4] = regmem4;
        regArr[5] = regmem5;
        regArr[6] = regmem6;
        regArr[7] = regmem7;
        regArr[8] = regmem8;
        regArr[9] = regmem9;
        regArr[10] = regmem10;
        regArr[11] = regmem11;
        regArr[12] = regmem12;
        regArr[13] = regmem13; 
        regArr[14] = regmem14;
         
    end
   
    always @(*) begin
        
        if (icode == 2 && cnd == 1) begin                                           //cmovXXX 
            regArr[rB] = valE;
        end
        else if (icode == 3 || icode == 6) begin                        //irmovq, OPq
            
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