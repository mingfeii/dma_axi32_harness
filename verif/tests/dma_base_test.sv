
`ifndef __dma_base_test__
`define __dma_base_test__

class dma_base_test extends uvm_test;

  dma_env_cfg   dma_env_cfgs[string];
  dma_env       dma_envs[string];

  `uvm_component_utils_begin(dma_base_test)
  `uvm_component_utils_end

  function new(string name = "dma_base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    dma_env_cfgs["dut"] = dma_env_cfg::type_id::create("dut");
    dma_envs["dut"] = dma_env::type_id::create("dut", this); dma_envs["dut"].cfg = dma_env_cfgs["dut"];
  endfunction
endclass

`endif

