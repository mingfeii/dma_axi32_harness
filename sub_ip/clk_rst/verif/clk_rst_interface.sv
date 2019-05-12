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

`ifndef __clk_rst_interface__
`define __clk_rst_interface__

interface clk_rst_interface#(FANOUT = clk_rst_param_pkg::FANOUT) (
  input [FANOUT-1:0] reset_n,
  input [FANOUT-1:0] clk
);

  import clk_rst_param_pkg::*;
  import clk_rst_pkg::*;
  clk_rst_vip_cfg cfg;

  event sync_icb_ev;
  event ad_hoc_ocb_ev;

  clocking icb @(posedge clk[0]);
    input reset_n;
  endclocking

  //clocking ocb @(ad_hoc_ocb_ev);
  //  output #1ps reset_n;
  //  output clk;
  //endclocking
  logic driver_reset_n = 'z;
  logic driver_clk = 'z;
  assign #(1ps) reset_n = driver_reset_n;
  assign clk = driver_clk;

  always @(icb) begin
    -> sync_icb_ev;
  end

  task sync_icb();
    wait (sync_icb_ev.triggered);
  endtask

  function void ad_hoc_ocb();
    if (! ad_hoc_ocb_ev.triggered) begin
      -> ad_hoc_ocb_ev;
    end
  endfunction
  
  bit time0 = 1;

  initial begin
    wait ($isunknown({reset_n, clk}) == 1'b0);
    fork
      forever @({reset_n, clk}) begin
        assert ($isunknown({reset_n, clk}) == 1'b0); // From the moment both reset_n and clk become valid, they can never again be unknown.
      end

      begin
        wait (reset_n == 1'b0);
        time0 = 0;
      end
    join
  end
endinterface

`endif

