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

`ifndef __apb_driver__
`define __apb_driver__

class apb_driver extends uvm_driver#(apb_seq_item);

  apb_vip_cfg cfg;
  virtual apb_interface vif;
  apb_sequencer seqr;
  int unsigned wait_cyc;
  apb_time0_seq_item_policy time0_policy = new();
  apb_idle_seq_item_policy idle_policy = new();
  apb_seq_item ad_hoc_item;
  apb_seq_item item;

  `uvm_component_utils_begin(apb_driver)
  `uvm_component_utils_end

  function new(string name = "apb_driver", uvm_component parent = null);
    super.new(name, parent);
    if (parent == null) begin
      `uvm_fatal("new", "Null parent is not legal for this component")
    end
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  virtual task run_phase(uvm_phase phase);
    if (cfg.role == REQUESTER) begin
      run_requester();
    end
    else begin
      run_responder();
    end
  endtask

  virtual task run_requester();
    ad_hoc_item = apb_seq_item::type_id::create("time0_item");
    ad_hoc_item.set_sequencer(seqr);
    ad_hoc_item.cfg = cfg;
    //ad_hoc_item.ad_hoc_plist.set('{time0_policy});
    if (! ad_hoc_item.randomize()) begin
      `uvm_error("run_requester", "Unable to randomize time0_item")
    end
    vif.ocb.psel <= $urandom();
    vif.ocb.penable <= $urandom();
    vif.ocb.pprot <= ad_hoc_item.pprot;
    vif.ocb.paddr <= ad_hoc_item.paddr;
    vif.ocb.pwrite <= ad_hoc_item.pwrite;
    vif.ocb.pstrb <= ad_hoc_item.pstrb;
    vif.ocb.pwdata <= ad_hoc_item.pxdata;
    vif.ad_hoc_ocb();
    wait (vif.time0 == 1'b0);

    fork
      forever begin
        ad_hoc_item = apb_seq_item::type_id::create("idle_item");
        ad_hoc_item.set_sequencer(seqr);
        ad_hoc_item.cfg = cfg;
       // ad_hoc_item.ad_hoc_plist.set('{idle_policy});
       // ad_hoc_item.ad_hoc_plist.set_item(ad_hoc_item);
        if (! ad_hoc_item.randomize()) begin
          `uvm_error("run_requester", "Unable to randomize idle_item")
        end
        vif.ocb.psel <= 1'b0;
        vif.ocb.penable <= 1'b0;
        vif.ocb.pprot <= ad_hoc_item.pprot;
        vif.ocb.paddr <= ad_hoc_item.paddr;
        vif.ocb.pwrite <= ad_hoc_item.pwrite;
        vif.ocb.pstrb <= ad_hoc_item.pstrb;
        vif.ocb.pwdata <= ad_hoc_item.pxdata;
        vif.ad_hoc_ocb();
        wait (vif.icb.preset_n == 1'b0);
        seqr.set_reset(1'b0);

        /*fork
          forever begin
            seq_item_port.get_next_item(item);
			$display("item rec");
            vif.sync_icb();
            seq_item_port.item_done();
            repeat (item.idle_cyc) begin
              @vif.icb;
            end

            // Setup phase.
            vif.ocb.psel <= 1'b1;
            vif.ocb.pprot <= item.pprot;
            vif.ocb.paddr <= item.paddr;
            vif.ocb.pwrite <= item.pwrite;
            vif.ocb.pstrb <= item.pstrb;
            if (item.pwrite == PWRITE_WRITE) begin
              vif.ocb.pwdata <= item.pxdata;
            end
            @vif.icb;

            // Access phase.
            vif.ocb.penable <= 1'b1;
            @vif.icb;
            wait_cyc = 0;
            while (vif.icb.pready == 1'b0) begin
              @vif.icb;
              ++wait_cyc;
            end
            item.wait_cyc = wait_cyc;
            if (item.pwrite == PWRITE_READ) begin
              item.pxdata = vif.icb.prdata;
            end
            item.pslverr = vif.icb.pslverr;
            item.pready = vif.icb.pready;

            if (! ad_hoc_item.randomize()) begin // ad_hoc_item remains idle_item until another reset. The easiest way to randomize bus fields that might be wider than $urandom, and also respect any idle bus rules, is to re-randomize idle_item each time.
              `uvm_error("run_requester", "Unable to randomize idle_item")
            end
            vif.ocb.psel <= 1'b0; // If there is a new item available immediately back at the top of the loop, this can all be overwritten and never appear on the interface.
            vif.ocb.penable <= 1'b0;
            vif.ocb.pprot <= ad_hoc_item.pprot;
            vif.ocb.paddr <= ad_hoc_item.paddr;
            vif.ocb.pwrite <= ad_hoc_item.pwrite;
            vif.ocb.pstrb <= ad_hoc_item.pstrb;
            vif.ocb.pwdata <= ad_hoc_item.pxdata;
          end

          wait (vif.preset_n == 1'b1);
        join_any
        disable fork;*/
        seqr.set_reset(1'b1);
      end
    join
  endtask

  virtual task run_responder();
    ad_hoc_item = apb_seq_item::type_id::create("time0_item");
    ad_hoc_item.set_sequencer(seqr);
    ad_hoc_item.cfg = cfg;
   // ad_hoc_item.ad_hoc_plist.set('{time0_policy});
   // ad_hoc_item.ad_hoc_plist.set_item(ad_hoc_item);
    if (! ad_hoc_item.randomize()) begin
      `uvm_error("run_responder", "Unable to randomize time0_item")
    end
    vif.ocb.prdata <= ad_hoc_item.pxdata;
    vif.ocb.pslverr <= ad_hoc_item.pslverr;
    vif.ocb.pready <= $urandom();
    vif.ad_hoc_ocb();
    wait (vif.time0 == 1'b0);

    fork
      forever begin
        ad_hoc_item = apb_seq_item::type_id::create("idle_item");
        ad_hoc_item.set_sequencer(seqr);
        ad_hoc_item.cfg = cfg;
        //ad_hoc_item.ad_hoc_plist.set('{idle_policy});
        //ad_hoc_item.ad_hoc_plist.set_item(ad_hoc_item);
        if (! ad_hoc_item.randomize()) begin
          `uvm_error("run_requester", "Unable to randomize idle_item")
        end
        vif.ocb.prdata <= ad_hoc_item.pxdata;
        vif.ocb.pslverr <= ad_hoc_item.pslverr;
        vif.ocb.pready <= $urandom();
        vif.ad_hoc_ocb();
        wait (vif.icb.preset_n == 1'b1);
        seqr.set_reset(1'b0);

        fork
          forever begin
            seq_item_port.get_next_item(item); // Response txn MUST be provided EXACTLY at the start of the Access Phase, or the protocol may be violated.
            vif.sync_icb(); // If the seq got the req from the monitor as intended, this will always fall straight through.
            seq_item_port.item_done();

            // Access phase.
            vif.ocb.pready <= 1'b0;
            repeat (item.wait_cyc) begin
              @vif.icb;
            end
            if (item.pwrite == PWRITE_READ) begin
              vif.ocb.prdata <= item.pxdata;
            end
            vif.ocb.pslverr <= item.pslverr;
            vif.ocb.pready <= 1'b1;
            @vif.icb;

            if (! ad_hoc_item.randomize()) begin
              `uvm_error("run_requester", "Unable to randomize idle_item")
            end
            vif.ocb.prdata <= ad_hoc_item.pxdata;
            vif.ocb.pslverr <= ad_hoc_item.pslverr;
            vif.ocb.pready <= $urandom();
          end

          wait (vif.preset_n === 1'b0); // Not icb.preset_n!
        join_any
        disable fork;
        seqr.set_reset(1'b1);
      end
    join
  endtask
endclass

`endif

