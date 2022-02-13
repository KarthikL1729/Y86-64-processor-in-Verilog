module decode(clk, icode, rA, rB, memA, memB, valA, valB, stk);

    input clk;
    input reg [3:0] icode, rA, rB;
    input reg [63:0] memA, memB, stk;       //8 byte values in the registers, stk is (%rsp)
    output reg [63:0] valA, valB;           

    always @(posedge clk) begin
        
        if (icode == 2) begin               //cmovxx instruction encountered
            valA = memA;
            valB = 0;
        end
        if (icode == 3) begin
            
        end
    end

endmodule