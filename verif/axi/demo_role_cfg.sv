
`ifndef __demo_role_cfg__
`define __demo_role_cfg__

class demo_role_cfg extends uvm_object;

  dma_verif_pkg::env_role role;

 
  `uvm_object_utils_begin(demo_role_cfg)
  `uvm_object_utils_end

  function new(string name = "demo_role_cfg");
    super.new(name);
  endfunction
endclass

`endif

