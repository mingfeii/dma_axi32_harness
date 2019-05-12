
`ifndef __axi_harness__
`define __axi_harness__
// Harness files are read before stub files. The only reason a stub compile token would already be defined is if the real and stub module defs are both being suppressed, in which case the harness def must also be suppressed, since it will have nowhere to bind.

interface axi_harness ();

  import demo_pkg::*;

   AXI_vif axi_if(

	 	.AXI_ACLK           (axi_slave.clk),
		.AXI_ARESET_N       (axi_slave.reset),

		// AXI write address channel
		.AXI_AWADDR     (axi_slave.AWADDR),
		.AXI_AWID       (axi_slave.AWID),
		.AXI_AWLEN      (axi_slave.AWLEN),
		.AXI_AWVALID    (axi_slave.AWVALID),
		.AXI_AWREADY    (axi_slave.AWREADY),
        .AXI_AWSIZE		(axi_slave.AWSIZE),
	    .AXI_AWBURST    (axi_slave.AWBURST),
	    .AXI_AWCACHE    (axi_slave.AWCACHE),
	    .AXI_AWPROT     (axi_slave.AWPROT),
	    .AXI_AWLOCK		(axi_slave.AWLOCK),	
	     
		// AXI write data channel
		.AXI_WDATA      (axi_slave.WDATA),
		.AXI_WID         (axi_slave.WID),
		.AXI_WSTRB       (axi_slave.WSTRB),
		.AXI_WLAST       (axi_slave.WLAST),
		.AXI_WVALID     (axi_slave.WVALID),
		.AXI_WREADY      (axi_slave.WREADY),
		.AXI_BRESP      (axi_slave.BRESP),
		.AXI_BID        (axi_slave.BID),
		.AXI_BVALID      (axi_slave.BVALID),
		.AXI_BREADY      (axi_slave.BREADY),
         
		// AXI read address channel
		.AXI_ARADDR       (axi_slave.ARADDR),
		.AXI_ARID         (axi_slave.ARID),
		.AXI_ARLEN       (axi_slave.ARLEN),
		.AXI_ARVALID      (axi_slave.ARVALID),
		.AXI_ARREADY      (axi_slave.ARREADY),
		.AXI_ARSIZE		(axi_slave.ARSIZE),
	    .AXI_ARBURST    (axi_slave.ARBURST),
	    .AXI_ARCACHE    (axi_slave.ARCACHE),
	    .AXI_ARPROT     (axi_slave.ARPROT),
	    .AXI_ARLOCK		(axi_slave.ARLOCK),	
		
		// AXI read data channel
		.AXI_RDATA        (axi_slave.RDATA),
		.AXI_RID          (axi_slave.RID),
		.AXI_RRESP       (axi_slave.RRESP),
		.AXI_RLAST       (axi_slave.RLAST),
		.AXI_RVALID       (axi_slave.RVALID),
		.AXI_RREADY       (axi_slave.RREADY)
);
  
  clk_rst_interface clk_rst_if (
    .reset_n (axi_slave.reset),
    .clk (axi_slave.clk)
  );

  
  class axi_pharness extends axi_pharness_base;
    function new(string name = "axi_pharness");
      super.new(name);
    endfunction
  endclass
  axi_pharness pharness = new($sformatf("%m"));

  initial begin
    automatic string path = autopublish_path(pharness.get_name());
    publish_vifs(path);
  end

  function automatic void publish_vifs(string path);
    $display(path);
    uvm_config_db#(virtual clk_rst_interface)::set(null, path, "clk_rst_if", clk_rst_if);
	uvm_config_db#(virtual AXI_vif)::set(null, "*", "m_vif", axi_if);
    uvm_config_db#(axi_pharness_base)::set(null, path, "pharness", pharness);
  endfunction
endinterface

bind axi_slave axi_harness harness();

`endif
