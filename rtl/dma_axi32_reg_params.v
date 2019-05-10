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
//-- Invoked Fri Mar 25 23:34:50 2011
//--
//-- Source file: dma_reg_params.v
//---------------------------------------------------------


  
   
   parameter              PROC0_STATUS     = 8'h00;
   parameter              PROC1_STATUS     = 8'h04;
   parameter              PROC2_STATUS     = 8'h08;
   parameter              PROC3_STATUS     = 8'h0C;
   parameter              PROC4_STATUS     = 8'h10;
   parameter              PROC5_STATUS     = 8'h14;
   parameter              PROC6_STATUS     = 8'h18;
   parameter              PROC7_STATUS     = 8'h1C;
   parameter              CORE0_JOINT      = 8'h30;
   parameter              CORE1_JOINT      = 8'h34;
   parameter              CORE0_PRIO       = 8'h38;
   parameter              CORE1_PRIO       = 8'h3C;
   parameter              CORE0_CLKDIV     = 8'h40;
   parameter              CORE1_CLKDIV     = 8'h44;
   parameter              CORE0_START      = 8'h48;
   parameter              CORE1_START      = 8'h4C;
   parameter              PERIPH_RX_CTRL   = 8'h50;
   parameter              PERIPH_TX_CTRL   = 8'h54;
   parameter              IDLE             = 8'hD0;
   parameter              USER_DEF_STAT    = 8'hE0;
   parameter              USER_DEF0_STAT0  = 8'hF0;
   parameter              USER_DEF0_STAT1  = 8'hF4;
   parameter              USER_DEF1_STAT0  = 8'hF8;
   parameter              USER_DEF1_STAT1  = 8'hFC;

















