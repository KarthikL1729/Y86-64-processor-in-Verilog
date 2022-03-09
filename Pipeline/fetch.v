//`include "pc_predict.v"
`include "pc_select.v"

module fetch(f_stat, F_PC, f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, inst_valid, imem_er, hlt_er, predPC, M_icode, W_icode, M_valA, W_valM);

  input [63:0] F_PC;
  input clk, M_cnd;
  input [3:0] M_icode, W_icode;
  input [63:0] M_valA, W_valM;
  wire [63:0] f_PC; 
  output reg [3:0] f_stat;
  output reg [3:0] f_icode;
  output reg [3:0] f_ifun;
  output reg [3:0] f_rA;
  output reg [3:0] f_rB; 
  output reg [63:0] f_valC, predPC;
  output reg [63:0] f_valP;
  output reg inst_valid;         //f_status condition for instruction invalidity
  output reg imem_er;            //f_status condition for invalid address
  output reg hlt_er;             //f_status condition for halt
  output reg dmem_er;            //f_status condition for data memory error 
  reg [7:0] insmem[2047:0];      //2kB of instruction memory cause why not
  reg [0:79] inst;               //10 byte max length for instruction

  //pc_predict pc_predict1(.f_icode(f_icode), .f_valP(f_valP), .f_valC(f_valC), .predPC(predPC));  
  pc_select pc_select1(.M_icode(M_icode), .M_cnd(M_cnd), .M_valA(M_valA), .W_icode(W_icode), .W_valM(W_valM), .F_predPC(F_PC), .f_PC(f_PC));
   

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

      insmem[20] = 16;


      insmem[21] = 16;


      insmem[22] = 16;


      insmem[23] = 96;
      insmem[24] = 3;

      // insmem[28] = 96;
      // insmem[29] = 3;

      // insmem[30] = 64;
      // insmem[31] = 48;
      // insmem[32] = 0;
      // insmem[33] = 0;
      // insmem[34] = 0;
      // insmem[35] = 0;
      // insmem[36] = 0;
      // insmem[37] = 0;
      // insmem[38] = 0;
      // insmem[39] = 5;

      // insmem[40] =80;
      // insmem[41] = 32;
      // insmem[42] = 0;
      // insmem[43] = 0;
      // insmem[44] = 0;
      // insmem[45] = 0;
      // insmem[46] = 0;
      // insmem[47] = 0;
      // insmem[48] = 0;
      // insmem[49] = 5;

      // insmem[50] = 96;
      // insmem[51] = 2;

      // insmem[52] = 33;
      // insmem[53] = 32;

      // insmem[54] = 96;
      // insmem[55] = 32;

      // insmem[56] = 33;
      // insmem[57] = 0;

      predPC = 0;

  end

  always @(f_PC) begin

      if(f_PC > 2047) begin
        imem_er = 1;               //Invalid address, out of scope
      end
        dmem_er = 0;               //Data memory error, initialised to zero

      inst = {insmem[f_PC], insmem[f_PC + 1], insmem[f_PC + 2], insmem[f_PC + 3], insmem[f_PC + 4], insmem[f_PC + 5], insmem[f_PC + 6], insmem[f_PC + 7], insmem[f_PC + 8], insmem[f_PC + 9]};   //Fetching 10 bytes
      
      f_icode = inst[0:3];          //Instruction specifier
      f_ifun = inst[4:7];           //Function specifier for xx instructions
      
      inst_valid = 1;                 //Assume instruction is valid, default case will invalidate
      
      if(f_icode == 0) begin        //halt instruction encountered
        hlt_er = 1;
        f_valP = f_PC + 1;
      end          
      else if (f_icode == 1) begin  //nop instruction encountered
        f_valP = f_PC + 1;
      end
      else if (f_icode == 2) begin  //cmovxx instruction encountered
        f_valP = f_PC + 2; 
        f_rA = inst[8:11];
        f_rB = inst[12:15];         //Register specifiers
      end     
      else if (f_icode == 3 || f_icode == 4 || f_icode == 5) begin  
                                  //irmovq/rmmovq/mrmovq instruction encountered
        f_valP = f_PC + 10;
        f_rA = inst[8:11];
        f_rB = inst[12:15];         //Register specifiers
        f_valC = inst[16:79];       //Constant value
      end
      else if (f_icode == 6) begin  //OPq instruction encountered
        f_valP = f_PC + 2;
        f_rA = inst[8:11];
        f_rB = inst[12:15];         //Register specifiers
      end
      else if (f_icode == 7 || f_icode == 8) begin  
                                  //jxx/call instruction encountered
        f_valP = f_PC + 9;
        f_valC = inst[8:71];
      end
      else if (f_icode == 9) begin  //ret instruction encountered
        f_valP = f_PC + 1;
      end
      else if (f_icode == 10 || f_icode == 11) begin 
                                  //pushq/popq instruction encountered
        f_valP = f_PC + 2;
        f_rA = inst[8:11];
        f_rB = inst[12:15];
      end
      else begin
        inst_valid = 0;               //Invalid f_icode, hence invalid instruction
      end
  end

  always @(f_icode, f_valP, f_valC) begin
      if (f_icode == 0 || f_icode == 1 || f_icode == 2 || f_icode == 3 || f_icode == 4 || f_icode == 5 || f_icode == 6 || f_icode == 10 || f_icode == 11) begin                                                                          //cmovXX, irmovq, rmmovq, mrmovq, OPq, pushq, popq
         predPC = f_valP;
      end
      else if (f_icode == 7) begin                                                   //jXX
         predPC = f_valC;
      end
      else if (f_icode == 8) begin                                                  //call
         predPC = f_valC;
      end
  end

  always @(f_PC) begin
      
      //$display("Hibro");
      if (inst_valid) begin
          f_stat[1] = ~inst_valid;
          f_stat[3] = 0;
          f_stat[2] = 0;
          f_stat[0] = 0;
      end
      else if(hlt_er) begin
          f_stat[2] = hlt_er;
          f_stat[3] = 0;         
          f_stat[1] = 0;
          f_stat[0] = 0;
      end
      else begin
          f_stat[0] = 1;
          f_stat[3] = 0;
          f_stat[1] = 0;
          f_stat[2] = 0;
      end


      if (f_stat[1] == 1 || f_stat[2] == 1 || f_stat[3] == 1) begin
         $finish;                                                //Instruction invalid error or halt encountered, stop everything.
      end

  end

  initial begin
        if (f_icode == 0 || f_icode == 1 || f_icode == 2 || f_icode == 3 || f_icode == 4 || f_icode == 5 || f_icode == 6 || f_icode == 10 || f_icode == 11) begin                                                                          //cmovXX, irmovq, rmmovq, mrmovq, OPq, pushq, popq
            predPC = f_valP;
        end
        else if (f_icode == 7) begin                                                   //jXX
            predPC = f_valC;
        end
        else if (f_icode == 8) begin                                                  //call
            predPC = f_valC;
        end
    end

  always @(*) begin
    $display("Bits fetched = %b", inst);
  end

endmodule