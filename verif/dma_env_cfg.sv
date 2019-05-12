
`ifndef __dma_env_cfg__
`define __dma_env_cfg__

class dma_env_cfg extends uvm_object;

  dma_verif_pkg::env_role role;
  Demo_conf m_demo_conf;
  string clk_freq;

  
  `uvm_object_utils_begin(dma_env_cfg)
  `uvm_object_utils_end

  function new(string name = "dma_env_cfg");
    super.new(name);
  endfunction
endclass

`endif

