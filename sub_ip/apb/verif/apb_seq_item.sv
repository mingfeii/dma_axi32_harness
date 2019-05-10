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

`ifndef __apb_seq_item__
`define __apb_seq_item__

class apb_seq_item extends uvm_sequence_item;

  apb_vip_cfg cfg;
  rand bit [2:0] pprot = PPROT_DATA_SECURE_PRIV;
  rand ADDR_t paddr;
  rand bit pwrite;
  rand STRB_t pstrb;
  rand DATA_t pxdata;
  rand bit pslverr;
       bit pready;
  rand int unsigned idle_cyc;
  rand int unsigned wait_cyc;

  `uvm_declare_p_sequencer(apb_sequencer)
  `uvm_object_utils_begin(apb_seq_item)
    `uvm_field_int(pprot, UVM_ALL_ON)
    `uvm_field_int(paddr, UVM_ALL_ON)
    `uvm_field_int(pwrite, UVM_ALL_ON)
    `uvm_field_int(pstrb, UVM_ALL_ON)
    `uvm_field_int(pxdata, UVM_ALL_ON)
    `uvm_field_int(pslverr, UVM_ALL_ON)
    `uvm_field_int(pready, UVM_ALL_ON)
    `uvm_field_int(idle_cyc, UVM_ALL_ON)
    `uvm_field_int(wait_cyc, UVM_ALL_ON)
  `uvm_object_utils_end

  constraint paddr_max {
    (paddr & ((ADDR_t'(1) << cfg.actual_addr_bus_bits) - 1)) == paddr;
  }

  constraint pxdata_max {
    (pxdata & ((DATA_t'(1) << cfg.actual_data_bus_bits) - 1)) == pxdata;
  }

  constraint pstrb_read {
    (pwrite == PWRITE_READ) -> (pstrb == '0);
  }

  constraint pstrb_paddr {
    ((pstrb & ((1 << paddr[1:0]) - 1)) == '0);
  }

  constraint requester {
    (cfg.role == REQUESTER) -> idle_cyc dist {    0     :/ 4'b1111,
                                              [  1:  3] :/ 4'b1000,
                                              [  4: 15] :/ 4'b0100,
                                              [ 16: 63] :/ 4'b0010,
                                              [ 64:255] :/ 4'b0001
                                             };
    (cfg.role == REQUESTER) -> ((wait_cyc == 0) && (pslverr == PSLVERR_OKAY));
  }

  constraint requester_read {
    ((cfg.role == REQUESTER) && (pwrite == PWRITE_READ)) -> (pxdata == '0);
  }

  constraint responder {
    (cfg.role == RESPONDER) -> wait_cyc dist {    0     :/ 4'b1111,
                                              [  1:  3] :/ 4'b1000,
                                              [  4: 15] :/ 4'b0100,
                                              [ 16: 63] :/ 4'b0010,
                                              [ 64:255] :/ 4'b0001
                                             };
  }

  //rand apb_ad_hoc_policy_list ad_hoc_plist = new("ad_hoc_plist"); // A seq item can be given ad hoc policy constraints by anyone who has its handle. Ad hoc policies are specific to a single seq item. Ad hoc policies would typically be used to create a more-or-less directed item.
  //rand apb_policy_list plist = new("plist"); // A seq item will usually check the uvm_config_db for any policy constraints registered on the sequence that sent it, and for any policy constraints registered on the sequencer it is sent to. But setting plist.rand_mode(0) disables both.
  // Sequence policies would typically constrain the kind of traffic (small burst, large burst, no burst, ...). Sequencer policies would typically constrain the item to structural parameters of the dut (legal addr range for the specific block/port where an agent is attached, ...).

  function new(string name = "apb_seq_item");
    super.new(name);
   // ad_hoc_plist.set_item(this);
    //plist.set_item(this);
  endfunction

  function void pre_randomize();
    apb_policy policy; // NON-RAND.
    super.pre_randomize();
    if (cfg == null) begin
      if (! uvm_config_db#(apb_vip_cfg)::get(p_sequencer, get_name(), "cfg", cfg)) begin
        cfg = p_sequencer.cfg;
      end
    end
    if (cfg.role == RESPONDER) begin
      pprot.rand_mode(0);
      paddr.rand_mode(0);
      pwrite.rand_mode(0);
      pstrb.rand_mode(0);
      idle_cyc.rand_mode(0);
      if (pwrite == PWRITE_WRITE) begin
        pxdata.rand_mode(0);
      end
    end
    // As best I can tell, the pre_randomize() of a child rand object can be called from parent pre_randomize() the *very instant* the child is non-null,
    // so getting from the cfg db directly into a class rand policy creates a race between child.pre_randomize() and trying to call child.set_item().
    // Instead, get from the cfg db into a non-rand intermediate, set_item on the intermediate, then pass the intermediate to the class policy.
    /*if (plist.rand_mode()) begin
      if (m_parent_sequence != null) begin
        if (uvm_config_db#(apb_policy)::get(null, get_full_name(), "policy", policy)) begin
          policy.set_item(this);
          plist.add('{policy});
        end
      end
      if (uvm_config_db#(apb_policy)::get(p_sequencer, get_name(), "policy", policy)) begin
        policy.set_item(this);
        plist.add('{policy});
      end
    end*/
  endfunction
endclass

`endif

