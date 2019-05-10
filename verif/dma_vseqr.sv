
`ifndef __dma_vseqr__
`define __dma_vseqr__

class dma_vseqr extends uvm_sequencer_base;
  `uvm_component_utils_begin(dma_vseqr)
  `uvm_component_utils_end

  dma_env p_env;

  function new(string name = "dma_vseqr", uvm_component parent = null);
    super.new(name, parent);
    if (parent == null) begin
      `uvm_fatal("new", "Null parent is not legal for this component")
    end
    if (! $cast(p_env, parent)) begin
      p_env = new();
      `uvm_fatal("new", $sformatf("Parent object type=%s name=%s is not legal for this component, must be cast-compatible with %s type", parent.get_type_name(), parent.get_name(), p_env.get_type_name()))
    end
    set_arbitration(SEQ_ARB_RANDOM);
  endfunction
endclass

`endif

