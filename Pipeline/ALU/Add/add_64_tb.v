`include "add_64.v"
module add_64_tb();

    reg signed [63:0] a, b;
    wire overflow;
    wire signed [63:0] sum;
    wire signed [64:0] carry;

    add_64 uut(.a(a), .b(b), .sum(sum), .overflow(overflow));

    initial begin
        $dumpfile("add_64.vcd");
        $dumpvars(0, add_64_tb);
        a = 9223372036854775807;
        b = 9223372036854775807;
        //a = 20;
        //b = 30;
        #100 $finish;
    end

    always #1 a = a+1;
    always #2 b = b+1;
    
    initial begin
        $monitor("time = %0t, a = %d, b = %d, sum = %d, overflow = %b", $time, a, b, sum, overflow);
    end
endmodule