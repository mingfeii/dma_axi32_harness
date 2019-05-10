//------------------------------------------------------------------
//-- File generated by RobustVerilog parser
//-- RobustVerilog version 1.2 (limited free version)
//-- Invoked Sun May 05 12:20:58 2019
//-- Source file: axi_slave_mem.v
//-- Parent file: axi_slave.v
//-- Run directory: E:/vlsi/axi_slave/run/
//-- Target directory: out/
//-- Command flags: ../src/base/axi_slave.v -od out -I ../src/gen -list list.txt -listpath -header -gui 
//-- www.provartec.com/edatools ... info@provartec.com
//------------------------------------------------------------------






module axi_slave_mem (clk,reset,WR,RD,ADDR_WR,ADDR_RD,DIN,BSEL,DOUT);

   parameter                    MEM_WORDS = 1073741824;
   parameter                    ADDR_LSB  = 2;
      
   input                        clk;
   input                        reset;
   input                        WR;
   input                        RD;
   input [31:0]                 ADDR_WR;
   input [31:0]                 ADDR_RD;
   input [31:0]                 DIN;
   input [32/8-1:0]             BSEL;
   output [31:0]                DOUT;
   
   reg [32-1:0]          Mem [MEM_WORDS-1:0];
   reg [32-1:0]          DOUT;
   wire [32-1:0]         BitSEL;
   wire [32-1:ADDR_LSB]  ADDR_WR_word = ADDR_WR[32-1:ADDR_LSB];
   wire [32-1:ADDR_LSB]  ADDR_RD_word = ADDR_RD[32-1:ADDR_LSB];

   
   assign                       BitSEL = {{8{BSEL[3]}} , {8{BSEL[2]}} , {8{BSEL[1]}} , {8{BSEL[0]}}};
   
   always @(posedge clk)
     if (WR)
       Mem[ADDR_WR_word] <= #1 (Mem[ADDR_WR_word] & ~BitSEL) | (DIN & BitSEL);
   
   always @(posedge clk or posedge reset)
     if (reset)
       DOUT <= #1 {32{1'b0}};
     else if (RD) 
       DOUT <= #1 Mem[ADDR_RD_word];

   
endmodule


