module fetch(clk, PC, icode, ifun, rA, rB, valC, valP, ins_er, adr_er, hlt_er);

  input clk;                    
  input [63:0] PC;
  output reg [3:0] icode;
  output reg [3:0] ifun;
  output reg [3:0] rA;
  output reg [3:0] rB; 
  output reg [63:0] valC;
  output reg [63:0] valP;
  output reg ins_er;           //Status condition for instruction invalidity
  output reg adr_er;           //Status condition for invalid address
  output reg hlt_er;           //Status condition for halt

  reg [7:0] insmem[0:2047]; // 2kB of instruction memory cause why not

  reg [0:79] inst;           // 10 byte max length for instruction

  initial begin
    
    //Memory shiz

  end

  always @(posedge clk) begin

    if(PC > 2047) begin
      adr_er = 1;            // Invalid address, out of scope
    end

    inst = insmem[PC:PC + 9]; //Fetching 10 bytes

    icode = inst[0:3];
    ifun = inst[4:7];
    ins_er = 0;               //

    if(icode == 0) begin       //Halt instruction encountered
      hlt_er = 1;
      valP = PC + 1;
    end          
    else if (icode == 1) begin  //nop instruction encountered
      valP = PC + 1;
    end
    

  end