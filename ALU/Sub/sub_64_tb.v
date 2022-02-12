`include "sub_64.v"
module sub_64_tb();

    reg signed [63:0] a, b;
    wire overflow;
    wire signed [63:0] diff;

    sub_64 uut(.a(a), .b(b), .diff(diff), .overflow(overflow));

    initial begin
        $dumpfile("sub_64.vcd");
        $dumpvars(0, sub_64_tb);
        //a = 9223372036854775807;
        //b = 9223372036854775807;
        a = 64'b1;
        b = 64'b1;
        #10 $finish;
    end

    always #1 a = a+1;
    always #2 b = b+1;
    
    initial begin
        $monitor("time = %0t, a = %d, b = %d, diff = %d, overflow = %b", $time, a, b, diff, overflow);
    end
endmodule