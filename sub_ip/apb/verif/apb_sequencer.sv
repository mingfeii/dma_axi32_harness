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

`ifndef __apb_sequencer__
`define __apb_sequencer__

class apb_sequencer extends uvm_sequencer#(apb_seq_item);

  apb_mem mem;
  apb_vip_cfg cfg;
  virtual apb_interface vif;
  uvm_analysis_export#(apb_seq_item) react_item_export;
  uvm_tlm_analysis_fifo#(apb_seq_item) react_item_fifo;
  uvm_sequence#(apb_seq_item) auto_seq;
  apb_policy_list plist = new($sformatf("%s.plist", get_full_name())); // A policy object name can be anything, a seq item will query the cfg db by *its own* name.

  bit reset = 1; // 1 = Reset, 0 = Not reset. At reset assertion, kill all running sequences. At reset negation, start a new default sequence (mandatory in RESPONDER mode, optional in REQUESTER mode).

  `uvm_component_utils_begin(apb_sequencer)
  `uvm_component_utils_end

  function new(string name = "apb_sequencer", uvm_component parent = null);
    super.new(name, parent);
    if (parent == null) begin
      `uvm_fatal("new", "Null parent is not legal for this component")
    end
    set_arbitration(SEQ_ARB_RANDOM);
    uvm_config_db#(apb_sequencer)::set(parent, "", "sequencer", this); // Put myself in cfg db so others can get access to my reset set/get methods. Look me up by agent + "sequencer".
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg.role == RESPONDER) begin
      react_item_export = new("react_item_export", this);
      react_item_fifo = new("react_item_fifo", this);
    end
    uvm_config_db#(apb_policy)::set(this, "*", "policy", plist);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (cfg.role == RESPONDER) begin
      react_item_export.connect(react_item_fifo.analysis_export);
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    // You shouldn't need to override this task in a derived class. You can change the reset exit, auto sequence, and reset re-entry behaviors any way you please.
    // If you do decide to override this task, don't call super unless you fork it off! It will never come back.
    fork
      forever begin
        wait_reset_exit(); // Expected to stall until the end of reset.
        fork
          run_auto_seq(); // Never expected to return.

          wait_reset_entry(); // Expected to stall until a new reset.
        join_any
        disable fork;
      end
    join
  endtask

  virtual task wait_reset_exit();
    wait (reset == 0);
  endtask

  virtual task run_auto_seq();
    if (! uvm_config_db#(uvm_sequence#(apb_seq_item))::get(this, "", "auto_seq", auto_seq)) begin // The auto_seq can be changed during reset.
      if (cfg.role == RESPONDER) begin
        `uvm_fatal("run_auto_seq", "No uvm_sequence#(apb_seq_item) 'auto_seq' in uvm_config_db. In RESPONDER mode, this sequencer must have a responder sequence to run")
      end
      else begin
        wait (0); // Not an error. A sequencer can have a default sequence in REQUESTER mode, or not.
      end
    end
    $cast(auto_seq, auto_seq.clone());
    auto_seq.start(this); // auto_seq is expected to be immortal, and never return.
  endtask

  virtual task wait_reset_entry();
    wait (reset == 1);
    stop_sequences();
  endtask

  virtual function void set_reset(bit value);
    reset = value;
  endfunction

  virtual function bit get_reset();
    return reset;
  endfunction
endclass

`endif

