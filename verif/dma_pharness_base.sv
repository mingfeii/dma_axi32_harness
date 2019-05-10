
`ifndef __dma_pharness_base__
`define __dma_pharness_base__

class dma_pharness_base;
  string name;

  function new(string name = "dma_pharness_base");
    this.name = name;
  endfunction

  virtual function string get_name();
    return name;
  endfunction
endclass

`endif
