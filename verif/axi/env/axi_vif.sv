
/*--------------------------------------
// AXI virtual interface
// description : axi virtual interface which is a connection pool interface for DUT and Virtual test
// file : axi_vif.sv
// author : SeanChen
// date : 2013/04/10
---------------------------------------*/

`timescale 1ns/10ps

interface AXI_vif #(
				parameter integer C_AXI_ID_WIDTH 	  = 10, // default 4
				parameter integer C_AXI_ADDR_WIDTH 	= 32,
        parameter integer C_AXI_REG_WITH    = 4,
				parameter integer C_AXI_DATA_WIDTH 	= 32,
				parameter integer C_AXI_LEN_WIDTH 	= 8,  // default 4
				parameter integer C_AXI_SIZE_WIDTH 	= 3,
				parameter integer C_AXI_BURST_WIDTH = 2,
				parameter integer C_AXI_CACHE_WIDTH = 4,
				parameter integer C_AXI_PROT_WIDTH 	= 3,
				parameter integer C_AXI_QOS_WIDTH	  = 4,
				parameter integer C_AXI_STRB_WIDTH 	= 4,
				parameter integer C_AXI_RESP_WIDTH 	= 2,
        parameter integer C_AXI_LOCK_WIDTH  = 1,
        parameter integer C_AXI_VALID_WIDTH = 1,
        parameter integer C_AXI_READY_WIDTH = 1,
        parameter integer C_AXI_LAST_WIDTH  = 1,
        parameter string name = "vif"

)( input AXI_ACLK, 
   input AXI_ARESET_N,
   // AXI address write phase
   input [C_AXI_ID_WIDTH-1:0]	 	AXI_AWID, 
   input [C_AXI_ADDR_WIDTH-1:0]	AXI_AWADDR,
   input [C_AXI_REG_WITH-1:0]      AXI_AWREG,
   input [C_AXI_LEN_WIDTH-1:0]		AXI_AWLEN,
   input [C_AXI_SIZE_WIDTH-1:0]	AXI_AWSIZE,
   input [C_AXI_BURST_WIDTH-1:0]	AXI_AWBURST,
   input [C_AXI_LOCK_WIDTH-1:0]	AXI_AWLOCK,
   input [C_AXI_CACHE_WIDTH-1:0]	AXI_AWCACHE,
   input [C_AXI_PROT_WIDTH-1:0]	AXI_AWPROT,
   input [C_AXI_QOS_WIDTH-1:0]		AXI_AWQOS,
   input [C_AXI_VALID_WIDTH-1:0]	AXI_AWVALID,
   input [C_AXI_READY_WIDTH-1:0]	AXI_AWREADY,
   
   // AXI data write phase
   input [C_AXI_ID_WIDTH-1:-0]     AXI_WID,
   input [C_AXI_DATA_WIDTH-1:0]	AXI_WDATA,
   input [C_AXI_STRB_WIDTH-1:0]	AXI_WSTRB,
   input [C_AXI_LAST_WIDTH-1:0]	AXI_WLAST,
   input [C_AXI_VALID_WIDTH-1:0]   AXI_WVALID,
   input [C_AXI_READY_WIDTH-1:0]	AXI_WREADY,
   
   // AXI response write phase
   input [C_AXI_ID_WIDTH-1:0]		AXI_BID,
   input [C_AXI_RESP_WIDTH-1:0]	AXI_BRESP,
   input [C_AXI_VALID_WIDTH-1:0]	AXI_BVALID,
   input [C_AXI_READY_WIDTH-1:0]	AXI_BREADY,
   
   // AXI address read phase
   input [C_AXI_ID_WIDTH-1:0]		AXI_ARID,
   input [C_AXI_ADDR_WIDTH-1:0]	AXI_ARADDR,
   input [C_AXI_REG_WITH-1:0]      AXI_ARREG,
   input [C_AXI_LEN_WIDTH-1:0]		AXI_ARLEN,
   input [C_AXI_SIZE_WIDTH-1:0]	AXI_ARSIZE,
   input [C_AXI_BURST_WIDTH-1:0]	AXI_ARBURST,
   input [C_AXI_LOCK_WIDTH-1:0]	AXI_ARLOCK,
   input [C_AXI_CACHE_WIDTH-1:0]	AXI_ARCACHE,
   input [C_AXI_PROT_WIDTH-1:0]	AXI_ARPROT,
   input [C_AXI_QOS_WIDTH-1:0]		AXI_ARQOS,
   input [C_AXI_VALID_WIDTH-1:0]	AXI_ARVALID,
   input [C_AXI_READY_WIDTH-1:0]	AXI_ARREADY,
   
   // AXI data read phase
   input [C_AXI_ID_WIDTH-1:0]		AXI_RID,
   input [C_AXI_DATA_WIDTH-1:0]	AXI_RDATA,
   input [C_AXI_RESP_WIDTH-1:0]	AXI_RRESP,
   input [C_AXI_LAST_WIDTH-1:0]	AXI_RLAST,
   input [C_AXI_VALID_WIDTH-1:0]	AXI_RVALID,
   input [C_AXI_READY_WIDTH-1:0]	AXI_RREADY
  
  );

	// control flags
	  bit has_checks 		= 1;
	  bit has_coverage	= 1;

  event sync_icb_ev;
  event ad_hoc_ocb_ev;

  clocking icb @(posedge AXI_ACLK);
   input AXI_ARESET_N;
   input AXI_AWID; 
   input AXI_AWADDR;
   input   AXI_AWREG;
   input AXI_AWLEN;
   input AXI_AWSIZE;
   input AXI_AWBURST;
   input AXI_AWLOCK;
   input AXI_AWCACHE;
   input AXI_AWPROT;
   input AXI_AWQOS;
   input AXI_AWVALID;
   input AXI_AWREADY;
          
   input   AXI_WID;
   input AXI_WDATA;
   input AXI_WSTRB;
   input AXI_WLAST;
   input   AXI_WVALID;
   input AXI_WREADY;
          
   input AXI_BID;
   input AXI_BRESP;
   input AXI_BVALID;
   input AXI_BREADY;
          
   input AXI_ARID;
   input AXI_ARADDR;
   input   AXI_ARREG;
   input AXI_ARLEN;
   input AXI_ARSIZE;
   input AXI_ARBURST;
   input AXI_ARLOCK;
   input AXI_ARCACHE;
   input AXI_ARPROT;
   input AXI_ARQOS;
   input AXI_ARVALID;
   input AXI_ARREADY;
          
   input AXI_RID;
   input AXI_RDATA;
   input AXI_RRESP;
   input AXI_RLAST;
   input AXI_RVALID;
   input AXI_RREADY;
  endclocking

  clocking ocb @(posedge AXI_ACLK or ad_hoc_ocb_ev);
   output AXI_AWID; 
   output AXI_AWADDR;
   output   AXI_AWREG;
   output AXI_AWLEN;
   output AXI_AWSIZE;
   output AXI_AWBURST;
   output AXI_AWLOCK;
   output AXI_AWCACHE;
   output AXI_AWPROT;
   output AXI_AWQOS;
   output AXI_AWVALID;
   output AXI_AWREADY;
          
   output   AXI_WID;
   output AXI_WDATA;
   output AXI_WSTRB;
   output AXI_WLAST;
   output   AXI_WVALID;
   output AXI_WREADY;
          
   output AXI_BID;
   output AXI_BRESP;
   output AXI_BVALID;
   output AXI_BREADY;
          
   output AXI_ARID;
   output AXI_ARADDR;
   output   AXI_ARREG;
   output AXI_ARLEN;
   output AXI_ARSIZE;
   output AXI_ARBURST;
   output AXI_ARLOCK;
   output AXI_ARCACHE;
   output AXI_ARPROT;
   output AXI_ARQOS;
   output AXI_ARVALID;
   output AXI_ARREADY;
          
   output AXI_RID;
   output AXI_RDATA;
   output AXI_RRESP;
   output AXI_RLAST;
   output AXI_RVALID;
   output AXI_RREADY;
  endclocking

  always @(icb) begin
    -> sync_icb_ev;
  end

  task sync_icb();
    wait (sync_icb_ev.triggered);
  endtask

  function void ad_hoc_ocb();
    -> ad_hoc_ocb_ev;
  endfunction  
	  
	  
	  

    // write data count
    // read data count

	/*-------------------------------------------
	// modport for each module type, like master, slave...
	// please add your modports here
	---------------------------------------------*/

	/* modports in slave interfaces
	modport Slave ();

	// modports in master interfaces
	modport Master ();

	// modports in monitor interface
	modport Monitor ();

	/*-----------------------------------------------
	// Assertions -> axi_assertioms.sv
	// please add your assertion rules here
	------------------------------------------------*/

always @(negedge AXI_ACLK)
begin

// write address must not be X or Z during address write phase
assertWriteAddrUnknown:assert property (
    disable iff(!has_checks)
		  ($onehot(AXI_AWVALID) && $onehot(AXI_AWREADY) |-> !$isunknown(AXI_AWADDR)))
		else
		  $error({$psprintf("ERR_AXI_AWADDR %s went to X or Z during address write phase when AXI_AWVALID=1", name)});

// write data must not be X or Z during data write phase
assertWriteDataUnknown:assert property (
    disable iff(!has_checks)
		  ($onehot(AXI_WVALID) && $onehot(AXI_WREADY) |-> !$isunknown(AXI_WDATA)))
		else
		  $error({$psprintf("ERR_AXI_WDATA %s went to X or Z during data write phase when AXI_WVALID=1", name)});

// write resp must not be X or Z during resp write phase
assertWriteRespUnKnown:assert property (
    disable iff(!has_checks)
      ($onehot(AXI_BVALID) && $onehot(AXI_BREADY) |-> !$isunknown(AXI_BRESP)))
    else
      $error({$psprintf("ERR_AXI_BRESP %s went to X or Z during response write phase when AXI_BVALID=1", name)});

// read address must not be X or Z during address read phase
assertReadAddrUnKnown:assert property (
    disable iff(!has_checks)
      ($onehot(AXI_ARVALID) && $onehot(AXI_ARREADY) |-> !$isunknown(AXI_ARADDR)))
    else
      $error({$psprintf("ERR_AXI_ARADDR %s went to X or Z during address read phase when AXI_ARVALID=1", name)});

// read data must not be X or Z during read data phase
assertReadDataUnKnown:assert property (
    disable iff(!has_checks)
      ($onehot(AXI_RVALID) && $onehot(AXI_RREADY) |-> !$isunknown(AXI_RDATA)))
    else
      $error({$psprintf("ERR_AXI_AWDATA %s went to X or Z during data read phase when AXI_RVALID=1", name)});

// assert each pin has value not unknown

end

endinterface : AXI_vif

