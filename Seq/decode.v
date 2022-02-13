module decode(clk, icode, srcA, srcB, memA, memB, regArr);

    input clk;
    input reg [3:0] icode, srcA, srcB;    
    input reg [63:0] regArr[14:0];       //8 byte values in the registers, stk is (%rsp)
    output reg [63:0] valA, valB;        // regArr[14] is stack pointer  

    always @(posedge clk) begin
        
        if (icode == 2) begin               //cmovxx instruction encountered
            valA = regArr[srcA];
            valB = 0;
        end
        else if (icode == 3) begin         //irmovq
            
        end
        else if(icode == 4) begin         //rmmovq
            valA = regArr[srcA];
            valB = regArr[srcB];
        end
        else if(icode == 5) begin        //mrmovq
            valB = regArr[srcB];
        end
        else if(icode == 6) begin
            valA = regArr[srcA];
            valB = regArr[srcB];
        end
        else if(icode == 7) begin       //jxx
            
        end
        else if(icode == 8) begin       //call
            valB = regArr[14];          //stk;
        end          
        else if (icode == 9) begin      //ret
            valA = regArr[14];
            valB = regArr[14];
        end
        else if (icode == 10) begin     //pushq
            valA = regArr[srcA];
            valB = regArr[14];
        end
        else if (icode == 11) begin     //popq
            valA = regArr[14];
            valB = regArr[14];
        end

    end
endmodule