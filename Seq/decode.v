module decode(clk, icode, rA, rB, memA, memB, regArr, valA, valB);

    input clk;
    input reg [3:0] icode, rA, rB;    
    input reg [63:0] regArr[14:0];                          //8 byte values in the registers, stk is (%rsp)
    output reg [63:0] valA, valB;                           // regArr[14] is stack pointer  

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