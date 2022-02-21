module memory(clk, icode, valP, valA, valB, valE, valM, datamem);

    input clk;
    input [3:0] icode;
    input [63:0] valA, valB, valE, valP;

    output [63:0] valM;                                                         
    output [63:0] datamem [2047:0];                                               //Data memory 2048*8 bytes

    always @(*) begin
        
        if (icode == 2 || icode == 3 || icode == 6 || icode == 7) begin           //cmovXXX, irmovq, OPq, jXX
        end
        else if (icode == 4 || icode == 10) begin                                 //rmmovq, pushq
            datamem[valE] = valA;
        end
        else if (icode == 5) begin                                                //mrmovq
            valM = datamem[valE];
        end
        else if (icode == 8) begin                                                //call                  
            datamem[valE] = valP;
        end
        else if (icode == 9, icode == 11) begin                                   //ret, popq          
           valM = datamem[valA]; 
        end

    end

endmodule