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

`ifndef __apb_monitor__
`define __apb_monitor__

class apb_monitor extends uvm_monitor;

  apb_vip_cfg cfg;
  virtual apb_interface vif;
  uvm_analysis_port#(apb_seq_item) mon_item_port; // Completed transactions.
  uvm_analysis_port#(apb_seq_item) react_item_port; // Incomplete transactions, request information only, for reactive sequence.
  apb_seq_item mon_item;
  apb_seq_item react_item;
  int unsigned idle_cyc;
  int unsigned wait_cyc;
  int unsigned serial_num = '1;

  `uvm_component_utils_begin(apb_monitor)
  `uvm_component_utils_end

  function new(string name = "apb_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_item_port = new("mon_item_port", this);
    react_item_port = new("react_item_port", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  virtual task run_phase(uvm_phase phase);
    wait (vif.time0 == 1'b0);
    fork
      forever begin
        wait (vif.icb.preset_n == 1'b0);
        fork
          forever begin
            mon_item = apb_seq_item::type_id::create($sformatf("mon_item[%0d]", ++serial_num));
            idle_cyc = 0;
            while (vif.icb.psel == 1'b0) begin
              @(vif.icb);
              ++idle_cyc;
            end
            // Setup phase.
            mon_item.idle_cyc = idle_cyc;
            mon_item.pprot = vif.icb.pprot;
            mon_item.paddr = vif.icb.paddr;
            mon_item.pwrite = vif.icb.pwrite;
            mon_item.pstrb = vif.icb.pstrb;
            if (vif.icb.pwrite == PWRITE_WRITE) begin
              mon_item.pxdata = vif.icb.pwdata;
            end
            $cast(react_item, mon_item.clone());
            react_item.set_name($sformatf("react_item[%0d]", serial_num));
            react_item_port.write(react_item); // Once we hand off react_item to a reactive slave seq, we don't own it anymore, the seq and the driver can do anything they want to it.
            @(vif.icb);
            // Access phase.
            wait_cyc = 0;
            while (vif.icb.pready == 1'b0) begin
              @(vif.icb);
              ++wait_cyc;
            end
            mon_item.wait_cyc = wait_cyc;
            if (vif.icb.pwrite == PWRITE_READ) begin
              mon_item.pxdata = vif.icb.prdata;
            end
            mon_item.pslverr = vif.icb.pslverr;
            mon_item.pready = vif.icb.pready;
            mon_item_port.write(mon_item);
            @(vif.icb);
          end

          wait (vif.preset_n == 1'b1);
        join_any
        disable fork;
      end
    join
  endtask
endclass

`endif

