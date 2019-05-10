
`timescale 1ns/1ps

`ifndef __tb_top__
`define __tb_top__

module tb_top();
    // include and import uvm_pkg
    `include "uvm_macros.svh"
    import uvm_pkg::*;    
    
    // import test pkg
    import dma_test_pkg::*;
    

	dma_axi32_wrap dut();                

	assign dut.u_dma_axi32.scan_en = 0;
	assign dut.u_dma_axi32.periph_tx_req = 'h7FFF_FFFF;
	assign dut.u_dma_axi32.periph_rx_req = 'h7FFF_FFFF;
	
	initial begin
	   // start the test
       run_test();
    end
	
	// Dump waves
    initial $dumpvars(0, tb_top);
    
endmodule: tb_top

`endif