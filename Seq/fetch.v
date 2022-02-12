module fetch(clk, PC, icode, ifun, rA, rB, valC, valP, ins, adr, hlt);

  input clk;                    
  input [63:0] PC;
  output reg [3:0] icode;
  output reg [3:0] ifun;
  output reg [3:0] rA;
  output reg [3:0] rB; 
  output reg [63:0] valC;
  output reg [63:0] valP;
  output reg ins;           //Status condition for instruction invalidity
  output reg adr;           //Status condition for invalid address
  output reg hlt;           //Status condition for halt

  reg [7:0] insmem[0:];

  reg [0:79] ins;