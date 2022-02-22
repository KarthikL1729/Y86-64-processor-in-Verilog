module decode(clk, icode, rA, rB, regmem0, regmem1, regmem2, regmem3, regmem4, regmem5, regmem6, regmem7, regmem8, regmem9, regmem10, regmem11, regmem12, regmem13, regmem14, valA, valB);

    input clk;
    input [3:0] icode, rA, rB;   
    input [63:0] regmem0, regmem1, regmem2, regmem3, regmem4, regmem5, regmem6, regmem7, regmem8, regmem9, regmem10, regmem11, regmem12, regmem13, regmem14;
    reg [63:0] regArr[14:0];                         
    //8 byte values in the registers, stk is (%rsp)
    output reg [63:0] valA, valB;                           // regArr[14] is stack pointer  

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
        
        if (icode == 2) begin                               //cmovxx instruction encountered
            valA = regArr[rA];
            valB = 0;
        end
        else if (icode == 3 || icode == 7) begin            //irmovq, jXX
        end
        else if(icode == 4 || icode == 6) begin             //rmmovq, OPq
            valA = regArr[rA];
            valB = regArr[rB];
        end
        else if(icode == 5) begin                           //mrmovq
            valB = regArr[rB];
        end
        else if(icode == 8) begin                           //call
            valB = regArr[14];                              //stk;
        end          
        else if (icode == 9 || icode == 11) begin           //ret, popq
            valA = regArr[14];
            valB = regArr[14];
        end
        else if (icode == 10) begin                         //pushq
            valA = regArr[rA];
            valB = regArr[14];
        end
        
    end
endmodule