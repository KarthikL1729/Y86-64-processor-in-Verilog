module rdecode(clk, D_stall, D_bubble, f_stat, f_icode, f_ifun ,f_rA, f_rB, f_valC, f_valP, D_stat, D_icode, D_ifun ,D_rA, D_rB, D_valC, D_valP);

    input clk, D_stall, D_bubble;
    input [3:0] f_stat;
    input [3:0] f_icode, f_ifun, f_rA, f_rB;
    input [63:0] f_valC, f_valP;
    output reg [3:0] D_stat;
    output reg [3:0] D_icode, D_ifun, D_rA, D_rB;
    output reg [63:0] D_valC, D_valP;

    always @(posedge clk) begin

        if(D_stall) begin
            
        end
        else if(D_bubble) begin
            D_stat <= f_stat;
            D_icode <= 1;
            D_ifun <= 0;
           
        end
        else begin
            D_stat <= f_stat;
            D_icode <= f_icode;
            D_ifun <= f_ifun;
            D_rA <= f_rA;
            D_rB <= f_rB;
            D_valC <= f_valC;
            D_valP <= f_valP;
        end
            
    end

endmodule