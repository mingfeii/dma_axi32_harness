

`ifndef __dma_base_vseq__
`define __dma_base_vseq__

class dma_base_vseq extends uvm_sequence;

  `uvm_object_utils_begin(dma_base_vseq)
  `uvm_object_utils_end


  function new(string name = "dma_base_vseq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_error("body", "This is an empty base class method, you must specify a factory override vseq with a +VSEQ=... plusarg")
  endtask
endclass

`endif

