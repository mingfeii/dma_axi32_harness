// Copyright 2017 Verilab Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

`ifndef __clk_rst_base_seq__
`define __clk_rst_base_seq__

class clk_rst_base_seq extends uvm_sequence#(clk_rst_seq_item);
  `uvm_object_utils_begin(clk_rst_base_seq)
  `uvm_object_utils_end
  `uvm_declare_p_sequencer(clk_rst_sequencer)

  function new(string name = "clk_rst_base_seq");
    super.new(name);
  endfunction
endclass

`endif

