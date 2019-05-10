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

`ifndef __clk_rst_seq_item__
`define __clk_rst_seq_item__

class clk_rst_seq_item extends uvm_sequence_item;

  clk_rst_vip_cfg cfg;

  rand int rst_make;
  rand int rst_break;
  rand int clk_break;
  rand int clk_make;
  rand bit rst_make_before_clk_break; // Assert reset before stopping the running clock.
  rand bit clk_make_before_rst_break; // Start new clock before releasing reset.

  `uvm_declare_p_sequencer(clk_rst_sequencer)
  `uvm_object_utils_begin(clk_rst_seq_item)
    `uvm_field_int(rst_make, UVM_ALL_ON)
    `uvm_field_int(rst_break, UVM_ALL_ON)
    `uvm_field_int(clk_break, UVM_ALL_ON)
    `uvm_field_int(clk_make, UVM_ALL_ON)
    `uvm_field_int(rst_make_before_clk_break, UVM_ALL_ON)
    `uvm_field_int(clk_make_before_rst_break, UVM_ALL_ON)
  `uvm_object_utils_end

  constraint rst_make_dist {
    rst_make dist { [1:3] := 1,
                    [4:9] :/ 1 };
  }

  constraint rst_break_dist {
    rst_break dist { [1:3] := 1,
                     [4:9] :/ 1 };
  }

  constraint rst_make_before_break {
    rst_make < rst_break;
  }

  constraint clk_break_dist {
    clk_break dist { [1:3] := 1,
                     [4:9] :/ 1 };
  }

  constraint clk_make_dist {
    clk_make dist { [1:3] := 1,
                    [4:9] :/ 1 };
  }

  constraint clk_break_before_make {
    clk_break < clk_make;
  }

  constraint r_mk_b4_c_bk {
    rst_make_before_clk_break == (rst_make <= clk_break);
  }

  constraint c_mk_b4_r_bk {
    clk_make_before_rst_break == (clk_make <= rst_break);
  }

  function new(string name = "clk_rst_seq_item");
    super.new(name);
  endfunction

endclass

`endif

