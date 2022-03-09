`include "/home/sane/Y86-64-processor-in-Verilog/Pipeline/ALU/And/and_64.v"
`include "/home/sane/Y86-64-processor-in-Verilog/Pipeline/ALU/Sub/sub_64.v"
`include "/home/sane/Y86-64-processor-in-Verilog/Pipeline/ALU/Xor/xor_64.v"
module ALU_64(opcode, a, b, res, overflow, zero); 

    input signed [63:0] a, b;
    input [1:0] opcode;     
    wire signed [63:0] res1, res2, res3, res4;
    reg signed [63:0] resmid;   //Final result intermediate because it gave error
    reg zeromid, overflowmid;   //Flags intermediate because it gave error
    output signed [63:0] res;
    output zero, overflow;

    add_64 m1(a, b, res1, overflowadd);
    sub_64 m2(a, b, res2, overflowsub);
    and_64 m3(a, b, res3);
    xor_64 m4(a, b, res4);

    parameter [1:0]         //Assigning 2 bit values to operations
        ADD = 2'b00,
        SUB = 2'b01,
        AND = 2'b10,
        XOR = 2'b11;
    
    always @(*) begin        
        case (opcode)       //Cases for each opcode with their respective operations
            ADD : begin
                resmid = res1;
                overflowmid = overflowadd;
                zeromid = (res == 64'b0);
            end 

            SUB : begin 
                resmid = res2;
                overflowmid = overflowsub;
                zeromid = (res == 64'b0);
            end

            AND : begin
                resmid = res3;
                overflowmid = 1'b0;
                zeromid = (res == 64'b0);
            end
            
            XOR : begin
                resmid = res4;
                overflowmid = 1'b0;
                zeromid = (res == 64'b0);
            end
        endcase
    end

    assign res = resmid;
    assign overflow = overflowmid;
    assign zero = zeromid;

endmodule


















