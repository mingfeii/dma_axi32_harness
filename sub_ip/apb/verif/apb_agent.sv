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

`ifndef __apb_agent__
`define __apb_agent__

class apb_agent extends uvm_agent;

  apb_monitor   monitor;
  apb_sequencer sequencer;
  apb_driver    driver;
  apb_mem       mem;
  apb_vip_cfg   cfg;
  virtual apb_interface vif;

  `uvm_component_utils_begin(apb_agent)
  `uvm_component_utils_end

  function new(string name = "apb_agent", uvm_component parent = null);
    super.new(name, parent);
    if (parent == null) begin
      `uvm_fatal("new", "Null parent is not legal for this component")
    end
    is_active = UVM_PASSIVE; // uvm_agent.is_active defaults to UVM_ACTIVE; I think that's the wrong default.
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (mem == null) begin // If we haven't been given a mem object to share...
      mem = new("mem"); // ... then make our own private one.
    end

    monitor = apb_monitor::type_id::create("monitor", this); monitor.cfg = cfg; monitor.vif = vif;
    if (is_active == UVM_ACTIVE) begin
      driver = apb_driver::type_id::create("driver", this); driver.cfg = cfg; driver.cfg = cfg; driver.vif = vif;
      sequencer = apb_sequencer::type_id::create("sequencer", this); sequencer.cfg = cfg; sequencer.vif = vif;
      sequencer.mem = mem; // Available to slave/reactive/RESPONDER sequences. They don't have to use it.
    end
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    vif.cfg = cfg;
    if (is_active == UVM_ACTIVE) begin
      driver.seqr = sequencer;
      driver.seq_item_port.connect(sequencer.seq_item_export);
      if (cfg.role == RESPONDER) begin
        monitor.react_item_port.connect(sequencer.react_item_export);
      end
    end
  endfunction
endclass

`endif

