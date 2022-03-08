module rexecute(clk, d_stat, d_icode, d_ifun, d_valC, d_valA, d_valB, d_dstE, d_dstM, d_srcA, d_srcB, E_stat, E_icode, E_ifun, E_valC, E_valA, E_valB, E_dstE, E_dstM, E_srcA, E_srcB);
    
    input clk;
    input [1:0] d_stat;
    input [3:0] d_icode, d_ifun;
    input [63:0] d_valC, d_valA, d_valB;
    input [3:0] d_dstE, d_dstM, d_srcA, d_srcB;
    output reg [1:0] E_stat;
    output reg [3:0] E_icode, E_ifun;
    output reg [63:0] E_valC, E_valA, E_valB;    
    output reg [3:0] E_dstE, E_dstM, E_srcA, E_srcB;

    always @(posedge clk) begin
        E_stat <= d_stat;
        E_icode <= d_icode;
        E_ifun <= d_ifun;
        E_valA <= d_valA;
        E_valB <= d_valB;
        E_valC <= d_valC;
        E_dstE <= d_dstE;
        E_dstM <= d_dstM;
        E_srcA <= d_srcA;
        E_srcB <= d_srcB;
    end

endmodule