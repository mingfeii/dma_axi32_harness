

`ifndef __dma_axi32_stub__
`define __dma_axi32_stub__
// A stub module def file is always read before its real counterpart, so a predefined __module_name__ token allows the stub to be compiled instead. Unless the __module_name_stub__ token is also predefined, in which case
// no module def is compiled at all. That might be appropriate if e.g. a parent module higher in the design hierarchy is stubbed out, and then either def of the lower module would be a nuisance implicit top-level instance.
`ifdef __dma_axi32__  
  
module dma_axi32(clk,reset,scan_en,idle,INT,periph_tx_req,periph_tx_clr,periph_rx_req,periph_rx_clr,pclken,psel,penable,paddr,pwrite,pwdata,prdata,pslverr,pready,AWID0,AWADDR0,AWLEN0,AWSIZE0,AWVALID0,AWREADY0,WID0,WDATA0,WSTRB0,WLAST0,WVALID0,WREADY0,BID0,BRESP0,BVALID0,BREADY0,ARID0,ARADDR0,ARLEN0,ARSIZE0,ARVALID0,ARREADY0,RID0,RDATA0,RRESP0,RLAST0,RVALID0,RREADY0);
`include "dma_axi32_defines.v"
   
   input                                clk;
   input                 reset;
   input                 scan_en;

   output                 idle;
   output [1-1:0]                INT;
   
   input [31:1]             periph_tx_req;
   output [31:1]             periph_tx_clr;
   input [31:1]             periph_rx_req;
   output [31:1]             periph_rx_clr;

   input                                pclken;
   input                                psel;
   input                                penable;
   input [12:0]                         paddr;
   input                                pwrite;
   input [31:0]                         pwdata;
   output [31:0]                        prdata;
   output                               pslverr;
   output                               pready;
   
    output [`ID_BITS-1:0]               AWID0;
    output [32-1:0]             AWADDR0;
    output [`LEN_BITS-1:0]              AWLEN0;
    output [`SIZE_BITS-1:0]      AWSIZE0;
    output                              AWVALID0;
    input                               AWREADY0;
    output [`ID_BITS-1:0]               WID0;
    output [32-1:0]             WDATA0;
    output [32/8-1:0]           WSTRB0;
    output                              WLAST0;
    output                              WVALID0;
    input                               WREADY0;
    input [`ID_BITS-1:0]                BID0;
    input [1:0]                         BRESP0;
    input                               BVALID0;
    output                              BREADY0;
    output [`ID_BITS-1:0]               ARID0;
    output [32-1:0]             ARADDR0;
    output [`LEN_BITS-1:0]              ARLEN0;
    output [`SIZE_BITS-1:0]      ARSIZE0;
    output                              ARVALID0;
    input                               ARREADY0;
    input [`ID_BITS-1:0]                RID0;
    input [32-1:0]              RDATA0;
    input [1:0]                         RRESP0;
    input                               RLAST0;
    input                               RVALID0;
    output                              RREADY0;

   
  
   
   
endmodule




`endif
`endif
