`ifndef __dma_verif_pkg__
`define __dma_verif_pkg__

package dma_verif_pkg;

  import uvm_pkg::*;
  import clk_rst_pkg::*;
  import apb_agent_pkg::*;
  import demo_pkg::*;

  typedef enum int {BLIND, JUST_LOOKING, ACTING_AS, ACTING_ON} env_role;

  typedef class dma_env;

  `include "dma_env_cfg.sv"
  `include "dma_pharness_base.sv"
  `include "dma_vseqr.sv"
  `include "dma_env.sv"
endpackage

`endif

