module fetch(clk, PC, icode, ifun, rA, rB, valC, valP, inst_valid, imem_er, hlt_er);

  input clk;                    
  input [63:0] PC;
  output reg [3:0] icode;
  output reg [3:0] ifun;
  output reg [3:0] rA;
  output reg [3:0] rB; 
  output reg [63:0] valC;
  output reg [63:0] valP;
  output reg inst_valid;            //Status condition for instruction invalidity
  output reg imem_er;            //Status condition for invalid address
  output reg hlt_er;            //Status condition for halt
  reg [7:0] insmem[2047:0];     //2kB of instruction memory cause why not
  reg [0:79] inst;              //10 byte max length for instruction

  initial begin
      insmem[0] = 48;
      insmem[1] = 240;
      insmem[2] = 0;
      insmem[3] = 0;
      insmem[4] = 0;
      insmem[5] = 0;
      insmem[6] = 0;
      insmem[7] = 0;
      insmem[8] = 0;
      insmem[9] = 4;

      insmem[10] = 48;
      insmem[11] = 243;
      insmem[12] = 0;
      insmem[13] = 0;
      insmem[14] = 0;
      insmem[15] = 0;
      insmem[16] = 0;
      insmem[17] = 0;
      insmem[18] = 0;
      insmem[19] = 10;

      insmem[20] = 96;
      insmem[21] = 3;

      insmem[22] = 96;
      insmem[23] = 3;

      insmem[24] = 64;
      insmem[25] = 48;
      insmem[26] = 0;
      insmem[27] = 0;
      insmem[28] = 0;
      insmem[29] = 0;
      insmem[30] = 0;
      insmem[31] = 0;
      insmem[32] = 0;
      insmem[33] = 5;

      insmem[34] =80;
      insmem[35] = 32;
      insmem[36] = 0;
      insmem[37] = 0;
      insmem[38] = 0;
      insmem[39] = 0;
      insmem[40] = 0;
      insmem[41] = 0;
      insmem[42] = 0;
      insmem[43] = 5;

      insmem[44] = 96;
      insmem[45] = 2;

      insmem[46] = 33;
      insmem[47] = 32;

      insmem[48] = 96;
      insmem[49] = 32;

      insmem[50] = 33;
      insmem[51] = 0;

      
  end

  always @(*) begin

      if(PC > 2047) begin
        imem_er = 1;               //Invalid address, out of scope
      end

      inst = {insmem[PC], insmem[PC + 1], insmem[PC + 2], insmem[PC + 3], insmem[PC + 4], insmem[PC + 5], insmem[PC + 6], insmem[PC + 7], insmem[PC + 8], insmem[PC + 9]};   //Fetching 10 bytes
      
      icode = inst[0:3];          //Instruction specifier
      ifun = inst[4:7];           //Function specifier for xx instructions
      
      inst_valid = 1;                 //Assume instruction is valid, default case will invalidate
      
      if(icode == 0) begin        //halt instruction encountered
        hlt_er = 1;
        valP = PC + 1;
      end          
      else if (icode == 1) begin  //nop instruction encountered
        valP = PC + 1;
      end
      else if (icode == 2) begin  //cmovxx instruction encountered
        valP = PC + 2; 
        rA = inst[8:11];
        rB = inst[12:15];         //Register specifiers
      end     
      else if (icode == 3 || icode == 4 || icode == 5) begin  
                                  //irmovq/rmmovq/mrmovq instruction encountered
        valP = PC + 10;
        rA = inst[8:11];
        rB = inst[12:15];         //Register specifiers
        valC = inst[16:79];       //Constant value
      end
      else if (icode == 6) begin  //OPq instruction encountered
        valP = PC + 2;
        rA = inst[8:11];
        rB = inst[12:15];         //Register specifiers
      end
      else if (icode == 7 || icode == 8) begin  
                                  //jxx/call instruction encountered
        valP = PC + 9;
        valC = inst[8:71];
      end
      else if (icode == 9) begin  //ret instruction encountered
        valP = PC + 1;
      end
      else if (icode == 10 || icode == 11) begin 
                                  //pushq/popq instruction encountered
        valP = PC + 2;
        rA = inst[8:11];
        rB = inst[12:15];
      end
      else begin
        inst_valid = 0;               //Invalid icode, hence invalid instruction
      end
  end

  always @(*) begin
    $display("Instructions = %b", inst);
  end

endmodule