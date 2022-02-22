`include "xor_64.v"

module xor_64_tb();

    reg [63:0] a,b;
    wire [63:0] out;

    xor_64 uut(a, b, out);

    initial begin
        $dumpfile("xor_64.vcd");
        $dumpvars(0, xor_64_tb);
        a = 64'b0;          //Number of bits'Binary system Value
        b = 64'b0;
        //opcode = 4'b0;

        #10 $finish;       //global reset, # is time delay (in nanoseconds)
    end

    always #1 a = a + 1;
    always #2 b = b + 1;

    initial begin
        $monitor("a = %b \nb = %b \no = %b\n",a,b,out);
    end




endmodule