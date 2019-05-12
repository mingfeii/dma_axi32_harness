
`ifndef __axi_pharness_base__
`define __axi_pharness_base__

class axi_pharness_base;
  string name;

  function new(string name = "axi_pharness_base");
    this.name = name;
  endfunction

  virtual function string get_name();
    return name;
  endfunction
endclass

`endif
