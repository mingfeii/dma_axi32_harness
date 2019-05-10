/////////////////////////////////////////////////////////////////////
////                                                             ////
////  Author: Eyal Hochberg                                      ////
////          eyal@provartec.com                                 ////
////                                                             ////
////  Downloaded from: http://www.opencores.org                  ////
/////////////////////////////////////////////////////////////////////
////                                                             ////
//// Copyright (C) 2010 Provartec LTD                            ////
//// www.provartec.com                                           ////
//// info@provartec.com                                          ////
////                                                             ////
//// This source file may be used and distributed without        ////
//// restriction provided that this copyright statement is not   ////
//// removed from the file and that any derivative work contains ////
//// the original copyright notice and the associated disclaimer.////
////                                                             ////
//// This source file is free software; you can redistribute it  ////
//// and/or modify it under the terms of the GNU Lesser General  ////
//// Public License as published by the Free Software Foundation.////
////                                                             ////
//// This source is distributed in the hope that it will be      ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied  ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR     ////
//// PURPOSE.  See the GNU Lesser General Public License for more////
//// details. http://www.gnu.org/licenses/lgpl.html              ////
////                                                             ////
/////////////////////////////////////////////////////////////////////
//---------------------------------------------------------
//-- File generated by RobustVerilog parser
//-- Version: 1.0
//-- Invoked Fri Mar 25 23:34:53 2011
//--
//-- Source file: dma_ch_offsets.v
//---------------------------------------------------------


  
module dma_axi32_core0_ch_offsets(clk,reset,ch_update,burst_start,burst_last,burst_size,load_req_in_prog,x_size,y_size,x_offset,y_offset,x_remain,clr_remain,ch_end,go_next_line,incr,clr_line,line_empty,empty,start_align,width_align,align);

   input             clk;
   input             reset;

   input             ch_update;
   input             burst_start; 
   input             burst_last; 
   input [7-1:0]   burst_size;
   input             load_req_in_prog;
   
   input [10-1:0]    x_size;
   input [10-`X_BITS-1:0]         y_size;

   output [10-1:0]   x_offset;
   output [10-`X_BITS-1:0]         y_offset;        
   output [10-1:0]   x_remain;
   output [10-`X_BITS-1:0]         clr_remain;
   output             ch_end;
   output             go_next_line;
   input             incr;
   input             clr_line;            
   output             line_empty;
   output             empty;
   
   input [2-1:0]    start_align;
   input [2-1:0]    width_align;
   output [2-1:0]   align;
   
   
   wire             update_line;             
   wire             go_next_line;
   wire             line_end_pre;
   wire             line_empty;
   reg [10-1:0]         x_remain;
   wire             ch_end_pre;
   reg                 ch_end;
   wire             ch_update_d;
   


   assign             ch_end_pre   = burst_start & burst_last;
   assign             go_next_line = 1'b0;
   assign             line_empty   = 1'b0;
   assign             empty        = ch_end_pre | ch_end;

   
   always @(posedge clk or posedge reset)
     if (reset)
       ch_end <= #1 1'b0;
     else if (ch_update)
       ch_end <= #1 1'b0;
     else if (ch_end_pre)
       ch_end <= #1 1'b1;

   always @(posedge clk or posedge reset)
     if (reset)
       x_remain <= #1 {10{1'b0}};
     else if (ch_update | go_next_line)
       x_remain <= #1 x_size;
     else if (burst_start & (~load_req_in_prog))
       x_remain <= #1 x_remain - burst_size;
       
   
   assign             x_offset   = {10{1'b0}};
   assign             y_offset   = {10-`X_BITS{1'b0}};
   assign             clr_remain = {10-`X_BITS{1'b0}};
   assign             align      = start_align;
   
   
   
endmodule




