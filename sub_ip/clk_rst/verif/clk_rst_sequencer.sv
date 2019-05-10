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

`ifndef __clk_rst_sequencer__
`define __clk_rst_sequencer__

class clk_rst_sequencer extends uvm_sequencer#(clk_rst_seq_item);

  clk_rst_vip_cfg cfg;
  virtual clk_rst_interface vif;

  bit reset = 0; // 1 = Reset, 0 = Not reset.

  `uvm_component_utils_begin(clk_rst_sequencer)
  `uvm_component_utils_end

  function new(string name = "clk_rst_sequencer", uvm_component parent = null);
    super.new(name, parent);
    if (parent == null) begin
      `uvm_fatal("new", "Null parent is not legal for this component")
    end
    set_arbitration(SEQ_ARB_RANDOM);
    uvm_config_db#(clk_rst_sequencer)::set(parent, "", "sequencer", this); // Put myself in cfg db so others can get access to my reset set/get methods. Look me up by agent + "sequencer".
  endfunction

  virtual task wait_reset_exit();
    wait (reset == 0);
  endtask

  virtual task wait_reset_entry();
    wait (reset == 1);
  endtask

  virtual function void set_reset(bit value);
    reset = value;
  endfunction

  virtual function bit get_reset();
    return reset;
  endfunction
endclass

`endif

