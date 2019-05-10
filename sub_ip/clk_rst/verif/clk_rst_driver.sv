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

`ifndef __clk_rst_driver__
`define __clk_rst_driver__

class clk_rst_driver extends uvm_driver#(clk_rst_seq_item);

  clk_rst_vip_cfg cfg;
  virtual clk_rst_interface vif;
  clk_rst_sequencer seqr;
  clk_rst_seq_item item;
  real period;
  real t1;
  real t0;

  `uvm_component_utils_begin(clk_rst_driver)
  `uvm_component_utils_end

  function new(string name = "clk_rst_driver", uvm_component parent = null);
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
    if (cfg.freq == "") begin
      cfg.freq = "500MHz";
    end
    period = freq2period(cfg.freq, 1ps);
    t1 = (period * 1ps) / 2;
    t0 = (period * 1ps) - t1;
    run_requester();
  endtask

  virtual task run_requester();
    fork
      forever begin
        @(negedge vif.reset_n);
        seqr.set_reset(1'b1);
      end
      forever begin
        @(posedge vif.reset_n);
        seqr.set_reset(1'b0);
      end
    join_none

    forever begin
      vif.driver_clk = '1;
      #(t1);
      vif.driver_clk = '0;
      #(t0);
      seq_item_port.try_next_item(item);
      if (item != null) begin
        seq_item_port.item_done();
        fork
          begin
            fork
              begin
                repeat (item.rst_make) begin
                  #(t1);
                  #(t0);
                end
                vif.driver_reset_n = '0;
              end
              begin
                repeat (item.rst_break) begin
                  #(t1);
                  #(t0);
                end
                vif.driver_reset_n = '1;
              end
              begin
                repeat (item.clk_break) begin
                  vif.driver_clk = '1;
                  #(t1);
                  vif.driver_clk = '0;
                  #(t0);
                end
              end
              begin
                repeat (item.clk_make) begin
                  #(t1);
                  #(t0);
                end
                fork
                  forever begin
                    vif.driver_clk = '1;
                    #(t1);
                    vif.driver_clk = '0;
                    #(t0);
                  end
                join_none
              end
            join
            disable fork;
          end
        join
        item = null;
      end
    end
  endtask
endclass

`endif

