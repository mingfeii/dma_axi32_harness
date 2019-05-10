
`ifndef __dma_harness__
`define __dma_harness__
// Harness files are read before stub files. The only reason a stub compile token would already be defined is if the real and stub module defs are both being suppressed, in which case the harness def must also be suppressed, since it will have nowhere to bind.

interface dma_harness ();

  import dma_verif_pkg::*;

  clk_rst_interface clk_rst_if (
    .reset_n (dma_axi32_wrap.reset),
    .clk (dma_axi32_wrap.clk)
  );

  apb_interface apb_if (
      .presetn  (dma_axi32_wrap.reset),
      .pclk     (dma_axi32_wrap.clk),
	  .pclken   (dma_axi32_wrap.pclken),
      .psel     (dma_axi32_wrap.psel),
      .penable  (dma_axi32_wrap.penable),
      .pwrite   (dma_axi32_wrap.pwrite),
	  .paddr    (dma_axi32_wrap.paddr),
      .pwdata   (dma_axi32_wrap.pwdata),
      .prdata   (dma_axi32_wrap.prdata),
      .pready   (dma_axi32_wrap.pready),
      .pslverr  (dma_axi32_wrap.pslverr)
    );
  
  
  class dma_pharness extends dma_pharness_base;
    function new(string name = "dma_pharness");
      super.new(name);
    endfunction
  endclass
  dma_pharness pharness = new($sformatf("%m"));

  initial begin
    automatic string path = autopublish_path(pharness.get_name());
    publish_vifs(path);
  end

  function automatic void publish_vifs(string path);
    $display(path);
    uvm_config_db#(virtual clk_rst_interface)::set(null, path, "clk_rst_if", clk_rst_if);
	uvm_config_db#(virtual apb_interface)::set(null, "*", "APB_INTF", apb_if);
    uvm_config_db#(dma_pharness_base)::set(null, path, "harness", pharness);
  endfunction
endinterface

bind dma_axi32_wrap dma_harness harness();

`endif


