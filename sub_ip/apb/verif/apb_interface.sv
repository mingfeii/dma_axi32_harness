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

`ifndef __apb_interface__
`define __apb_interface__

interface apb_interface #(ADDR = apb_param_pkg::ADDR, DATA = apb_param_pkg::DATA) (
  input preset_n,
  input pclk,
  input psel,
  input penable,
  input [2:0] pprot,
  input [ADDR-1:0] paddr,
  input pwrite,
  input [(DATA>>3)-1:0] pstrb,
  input [DATA-1:0] pwdata,
  input [DATA-1:0] prdata,
  input pslverr,
  input pready
);

  import apb_param_pkg::*;
  import apb_names_pkg::*;
  import apb_pkg::*;
  apb_vip_cfg cfg;

  event sync_icb_ev;
  event ad_hoc_ocb_ev;

  clocking icb @(posedge pclk);
    input preset_n;
    input psel;
    input penable;
    input pprot;
    input paddr;
    input pwrite;
    input pstrb;
    input pwdata;
    input prdata;
    input pslverr;
    input pready;
  endclocking

  clocking ocb @(posedge pclk or ad_hoc_ocb_ev);
    output psel;
    output penable;
    output pprot;
    output paddr;
    output pwrite;
    output pstrb;
    output pwdata;
    output prdata;
    output pslverr;
    output pready;
  endclocking

  always @(icb) begin
    -> sync_icb_ev;
  end

  task sync_icb();
    wait (sync_icb_ev.triggered);
  endtask

  function void ad_hoc_ocb();
    -> ad_hoc_ocb_ev;
  endfunction

  bit time0 = 1;

  initial begin
    wait ($isunknown({preset_n, pclk}) == 1'b0);
    fork
      forever @({preset_n, pclk}) begin
        assert ($isunknown({preset_n, pclk}) == 1'b0); // From the moment both preset_n and pclk become valid, they can never again be unknown.
      end

      forever begin
        wait (preset_n == 1'b0);
        time0 = 0;
        wait (preset_n == 1'b1);
        assert ({psel, penable} == '0); // Coming out of reset, psel and penable must both be low.
      end
    join
  end

  bit kill_valid_psel = 0;
  bit kill_valid_penable = 0;
  bit kill_valid_pprot = 0;
  bit kill_valid_paddr = 0;
  bit kill_valid_pwrite = 0;
  bit kill_valid_pstrb = 0;
  bit kill_valid_pwdata = 0;
  bit kill_valid_pready = 0;
  bit kill_valid_prdata = 0;
  bit kill_valid_pslverr = 0;
  bit kill_stable_psel = 0;
  bit kill_stable_penable = 0;
  bit kill_stable_pprot = 0;
  bit kill_stable_paddr = 0;
  bit kill_stable_pwrite = 0;
  bit kill_stable_pstrb = 0;
  bit kill_stable_pwdata = 0;
  bit kill_penable_idle = 0;
  bit kill_penable_setup = 0;
  bit kill_penable_pready = 0;
  bit kill_pstrb_read = 0;
  bit kill_pstrb_paddr = 0;

  initial begin
    wait (cfg != null);
    if (cfg.actual_addr_bus_bits > ADDR) begin
      `uvm_fatal($sformatf("apb_interface %m"), $sformatf("config data width %0d greater than inst param addr width %0d (bits)", cfg.actual_addr_bus_bits, ADDR))
    end
    if (cfg.actual_data_bus_bits > DATA) begin
      `uvm_fatal($sformatf("apb_interface %m"), $sformatf("config data width %0d greater than inst param data width %0d (bits)", cfg.actual_data_bus_bits, DATA))
    end
    kill_valid_psel = cfg.kill_valid_psel;
    kill_valid_penable = cfg.kill_valid_penable;
    kill_valid_pprot = cfg.kill_valid_pprot;
    kill_valid_paddr = cfg.kill_valid_paddr;
    kill_valid_pwrite = cfg.kill_valid_pwrite;
    kill_valid_pstrb = cfg.kill_valid_pstrb;
    kill_valid_pwdata = cfg.kill_valid_pwdata;
    kill_valid_pready = cfg.kill_valid_pready;
    kill_valid_prdata = cfg.kill_valid_prdata;
    kill_valid_pslverr = cfg.kill_valid_pslverr;
    kill_stable_psel = cfg.kill_stable_psel;
    kill_stable_penable = cfg.kill_stable_penable;
    kill_stable_pprot = cfg.kill_stable_pprot;
    kill_stable_paddr = cfg.kill_stable_paddr;
    kill_stable_pwrite = cfg.kill_stable_pwrite;
    kill_stable_pstrb = cfg.kill_stable_pstrb;
    kill_stable_pwdata = cfg.kill_stable_pwdata;
    kill_penable_idle = cfg.kill_penable_idle;
    kill_penable_setup = cfg.kill_penable_setup;
    kill_penable_pready = cfg.kill_penable_pready;
    kill_pstrb_read = cfg.kill_pstrb_read;
    kill_pstrb_paddr = cfg.kill_pstrb_paddr;
  end

  property valid(signal, precondition, kill);
    @(posedge pclk) disable iff (time0 || (preset_n == 1'b0) || kill)
    precondition |-> !$isunknown(signal);
  endproperty
  valid_psel: assert property (valid(psel, 1, kill_valid_psel)); // psel must be valid always.
  valid_penable: assert property (valid(penable, 1, kill_valid_penable)); // penable must be valid always.
  valid_pprot: assert property (valid(pprot, psel, kill_valid_pprot)); // pprot must be valid whenever psel true.
  valid_paddr: assert property (valid(paddr, psel, kill_valid_paddr)); // paddr must be valid whenever psel true.
  valid_pwrite: assert property (valid(pwrite, psel, kill_valid_pwrite)); // pwrite must be valid whenever psel true.
  valid_pstrb: assert property (valid(pstrb, psel, kill_valid_pstrb)); // pstrb must be valid whenever psel true.
  valid_pwdata: assert property (valid(pwdata, psel, kill_valid_pwdata)); // pwdata must be valid whenever psel true.
  valid_pready: assert property (valid(pready, (psel && penable), kill_valid_pready)); // pready must be valid whenever psel and penable true.
  valid_prdata: assert property (valid(prdata, (psel && penable && pready), kill_valid_prdata)); // prdata must be valid whenever psel and penable and pready true.
  valid_pslverr: assert property (valid(pslverr, (psel && penable && pready), kill_valid_pslverr)); // pslverr must be valid whenever psel and penable and pready true.

  property stable(signal, precondition, kill);
    @(posedge pclk) disable iff (time0 || (preset_n == 1'b0) || kill)
    precondition |-> ##1 $stable(signal);
  endproperty
  stable_psel: assert property (stable(psel, (psel && !(penable && pready)), kill_stable_psel)); // psel must be stable from the cycle it goes high until penable and pready also high.
  stable_penable: assert property (stable(penable, (penable && !pready), kill_stable_penable)); // penable must be stable from the cycle it goes high until pready also high.
  stable_pprot: assert property (stable(pprot, (psel && !(penable && pready)), kill_stable_pprot)); // pprot must be stable throughout Setup and Access phases.
  stable_paddr: assert property (stable(paddr, (psel && !(penable && pready)), kill_stable_paddr)); // paddr must be stable throughout Setup and Access phases.
  stable_pwrite: assert property (stable(pwrite, (psel && !(penable && pready)), kill_stable_pwrite)); // pwrite must be stable throughout Setup and Access phases.
  stable_pstrb: assert property (stable(pstrb, (psel && !(penable && pready)), kill_stable_pstrb)); // pstrb must be stable throughout Setup and Access phases.
  stable_pwdata: assert property (stable(pwdata, (psel && !(penable && pready)), kill_stable_pwdata)); // pwdata must be stable throughout Setup and Access phases.
  // There are no stability requirements on any slave signals: prdata, pslverr, pready.

  property penable_idle;
    @(posedge pclk) disable iff (time0 || (preset_n == 1'b0) || kill_penable_idle)
    (psel == 1'b0) |-> (penable == 1'b0) ##1 (penable == 1'b0);
  endproperty
  assert_penable_idle: assert property (penable_idle);

  property penable_setup;
    @(posedge pclk) disable iff (time0 || (preset_n == 1'b0) || kill_penable_setup)
    ((psel == 1'b1) && (penable == 1'b0)) |-> ##1 (penable == 1'b1);
  endproperty
  assert_penable_setup: assert property (penable_setup);

  property penable_pready;
    @(posedge pclk) disable iff (time0 || (preset_n == 1'b0) || kill_penable_pready)
    ((psel == 1'b1) && (penable == 1'b1) && (pready == 1'b1)) |-> ##1 (penable == 1'b0);
  endproperty
  assert_penable_pready: assert property (penable_pready);

  // The spec (3.1 Write transfers) says "The select signal PSEL, is also deasserted [at the end of the transfer] unless the transfer is to be followed immediately by another transfer to the same peripheral".
  // But there is no generally defined way for a master to know whether two addresses decode to the same peripheral, and there is no single bus connection where such a restriction can be checked,
  // and the restriction would appear to be met at any one peripheral, if the next address decodes to a different peripheral, even if psel at the master were held continuously true.
  // I don't think this is a rule that needs to be checked, I think it is merely a commentary, an observation, that psel at a slave will always be deasserted after one transfer completes, unless a new transfer begins immediately to the same slave.

  property pstrb_read;
    @(posedge pclk) disable iff (time0 || (preset_n == 1'b0) || kill_pstrb_read)
    ((psel == 1'b1) && (pwrite == PWRITE_READ)) |-> (pstrb == '0);
  endproperty
  assert_pstrb_read: assert property (pstrb_read);

  property pstrb_paddr;
    @(posedge pclk) disable iff (time0 || (preset_n == 1'b0) || kill_pstrb_paddr)
    (psel == 1'b1) |-> ((pstrb & ((1 << paddr[1:0]) - 1)) == '0);
  endproperty
  assert_pstrb_paddr: assert property (pstrb_paddr);
endinterface

`endif

