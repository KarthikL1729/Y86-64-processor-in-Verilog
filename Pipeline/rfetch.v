module rfetch(clk, F_predPC, f_predPC);
    
    input clk;
    input [63:0] F_predPC;
    output [63:0] f_predPC;

    always @(posedge clk) begin
        f_predPC <= F_predPC        // Moving the value into the register
    end 

endmodule