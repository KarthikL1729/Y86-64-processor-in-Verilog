module write_back(W_stat, W_icode, W_valE, W_valM, W_dstE, W_dstM, w_stat, w_icode, w_valE, w_valM, w_dstE, w_dstM);
    input [3:0] W_stat, W_icode, W_dstE, W_dstM;
    input [63:0] W_valE, W_valM;

    output reg [3:0] w_stat, w_icode, w_dstE, w_dstM;
    output reg [63:0] w_valE, w_valM;

    always @(W_stat, W_icode, W_valE, W_valM, W_dstE, W_dstM) begin
        w_stat = W_stat;  
        w_icode = W_icode;
        w_valE = W_valE;
        w_valM = W_valM;
        w_dstE = W_dstE;
        w_dstM = W_dstM;
    end
   

endmodule