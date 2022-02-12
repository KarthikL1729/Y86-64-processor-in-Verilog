`include "ALU_64.v"
module ALU_64_tb();

    reg signed [63:0] a, b;
    reg [1:0] opcode;
    wire signed [63:0] res;
    wire overflow, zero;

    ALU_64 uut(.opcode(opcode), .a(a), .b(b), .res(res), .overflow(overflow), .zero(zero));

    initial begin
        $dumpfile("ALU_64.vcd");
        $dumpvars(0, ALU_64_tb);
        opcode = 2'b11;
        a = 11;          //Number of bits'Binary system Value
        b = 42;
        #100 $finish;       //global reset, # is time delay (in nanoseconds)
    end

    always #1 begin
        $display("a = %b\nb = %b\nres = %b\noverflow = %b\nzero = %b", a, b, res, overflow, zero);
        $display("Check: %d\n", res-(a^b));
        a = $random;
        b = $random;
    end


endmodule