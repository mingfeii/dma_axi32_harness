
module dut_dummy( input clock, input reset);

axi_slave axi_slave_0
(
	 	.clk           (clock),
		.reset         (!reset),

		// AXI write address channel
		.AWADDR      (axi_vif_0.AXI_AWADDR),
		.AWID        (axi_vif_0.AXI_AWID),
		.AWLEN      (axi_vif_0.AXI_AWLEN),
		.AWVALID    (axi_vif_0.AXI_AWVALID),
		.AWREADY    (axi_vif_0.AXI_AWREADY),
        .AWSIZE		(axi_vif_0.AXI_AWSIZE),
	    .AWBURST    (axi_vif_0.AXI_AWBURST),
	    .AWCACHE    (axi_vif_0.AXI_AWCACHE),
	    .AWPROT     (axi_vif_0.AXI_AWPROT),
	    .AWLOCK		(axi_vif_0.AXI_AWLOCK),	
	
	
		// AXI write data channel
		.WDATA      (axi_vif_0.AXI_WDATA),
		.WID         (axi_vif_0.AXI_WID),
		.WSTRB       (axi_vif_0.AXI_WSTRB),
		.WLAST       (axi_vif_0.AXI_WLAST),
		.WVALID     (axi_vif_0.AXI_WVALID),
		.WREADY      (axi_vif_0.AXI_WREADY),
		.BRESP      (axi_vif_0.AXI_BRESP),
		.BID        (axi_vif_0.AXI_BID),
		.BVALID      (axi_vif_0.AXI_BVALID),
		.BREADY      (axi_vif_0.AXI_BREADY),

		// AXI read address channel
		.ARADDR       (axi_vif_0.AXI_ARADDR),
		.ARID         (axi_vif_0.AXI_ARID),
		.ARLEN       (axi_vif_0.AXI_ARLEN),
		.ARVALID      (axi_vif_0.AXI_ARVALID),
		.ARREADY      (axi_vif_0.AXI_ARREADY),
		.ARSIZE		(axi_vif_0.AXI_ARSIZE),
	    .ARBURST    (axi_vif_0.AXI_ARBURST),
	    .ARCACHE    (axi_vif_0.AXI_ARCACHE),
	    .ARPROT     (axi_vif_0.AXI_ARPROT),
	    .ARLOCK		(axi_vif_0.AXI_ARLOCK),	
		
		// AXI read data channel
		.RDATA        (axi_vif_0.AXI_RDATA),
		.RID          (axi_vif_0.AXI_RID),
		.RRESP       (axi_vif_0.AXI_RRESP),
		.RLAST       (axi_vif_0.AXI_RLAST),
		.RVALID       (axi_vif_0.AXI_RVALID),
		.RREADY       (axi_vif_0.AXI_RREADY)
);



endmodule
