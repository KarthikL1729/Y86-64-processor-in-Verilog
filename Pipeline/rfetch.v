module rfetch(clk, predPC, F_predPC);
    
    input clk;
    input [63:0] predPC;
    output [63:0] F_predPC;

    always @(posedge clk) begin
        F_predPC <= predPC        // Moving the value into the register
    end 

endmodule