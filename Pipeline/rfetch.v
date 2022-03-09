module rfetch(clk, predPC, F_predPC, F_stall);
    
    input clk, F_stall;
    input [63:0] predPC;
    output reg [63:0] F_predPC;

    always @(posedge clk) begin
        if(~F_stall) begin
            F_predPC <= predPC;      // Moving the value into the register
        end
    end 

endmodule