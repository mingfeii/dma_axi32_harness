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

`ifndef __apb_fabric_harness__
`define __apb_fabric_harness__
// Harness files are read before stub files. The only reason a stub compile token would already be defined is if the real and stub module defs are both being suppressed, in which case the harness def must also be suppressed, since it will have nowhere to bind.
`ifndef __apb_fabric_stub__

interface apb_fabric_harness#(MST = 1, SLV = 1, MST_ADDR = 32, SLV_ADDR = 32, DATA = 32) ();

  import apb_fabric_pkg::*;

  initial begin // Parameter legality checks.
    if (MST_ADDR < (SLV_ADDR + $clog2(SLV))) begin // I don't think the file will even compile if this condition isn't satisfied, but the message text could still help someone understand the compile failure.
      `uvm_fatal($sformatf("%m"), $sformatf("Master addr width MST_ADDR (%0d) must be greater-or-equal slave addr width + bits to decode any target slave, SLV_ADDR + clog2(SLV) (%0d + clog2(%0d) = %0d)", MST_ADDR, SLV_ADDR, $clog2(SLV), SLV_ADDR + $clog2(SLV)))
    end
    if (SLV_ADDR < $clog2(DATA >> 3)) begin // No need to check MST_ADDR vs DATA explicitly, the check above addresses MST_ADDR vs SLV_ADDR.
      `uvm_fatal($sformatf("%m"), $sformatf("Master MST_ADDR (%0d) and slave SLV_ADDR (%0d) addr width both must be at least enough bits to address every byte of data bus width, clog2(DATA >> 3) (clog2(%0d) = %0d)", MST_ADDR, SLV_ADDR, DATA >> 3, $clog2(DATA >> 3)))
    end
    if ((DATA < 8) || ((DATA & (DATA - 1)) != 0)) begin
      `uvm_fatal($sformatf("%m"), $sformatf("Data bus width DATA (%0d) must be a power-of-2 and greater-or-equal 8", DATA))
    end
  end

  clk_rst_interface clk_rst_if (
    .reset_n (apb_fabric.preset_n),
    .clk (apb_fabric.pclk)
  );

  for (genvar m = 0; m < MST; ++m) begin : mst
    apb_interface apb_if (
      .preset_n (apb_fabric.preset_n),
      .pclk     (apb_fabric.pclk),
      .psel     (apb_fabric.mst_psel[m]),
      .penable  (apb_fabric.mst_penable[m]),
      .pprot    (apb_fabric.mst_pprot[m]),
      .paddr    (apb_fabric.mst_paddr[m]),
      .pwrite   (apb_fabric.mst_pwrite[m]),
      .pstrb    (apb_fabric.mst_pstrb[m]),
      .pwdata   (apb_fabric.mst_pwdata[m]),
      .prdata   (apb_fabric.mst_prdata[m]),
      .pslverr  (apb_fabric.mst_pslverr[m]),
      .pready   (apb_fabric.mst_pready[m])
    );
    if (m > 0) begin : vif
      function automatic void publish(string path);
        uvm_config_db#(virtual apb_interface)::set(null, path, $sformatf("mst_apb_if[%0d]", m), mst[m].apb_if);
        mst[m-1].vif.publish(path);
      endfunction
    end
    else begin : vif
      function automatic void publish(string path);
        uvm_config_db#(virtual apb_interface)::set(null, path, $sformatf("mst_apb_if[%0d]", m), mst[m].apb_if);
      endfunction
    end
  end

  for (genvar s = 0; s < SLV; ++s) begin : slv
    apb_interface apb_if (
      .preset_n (apb_fabric.preset_n),
      .pclk     (apb_fabric.pclk),
      .psel     (apb_fabric.slv_psel[s]),
      .penable  (apb_fabric.slv_penable[s]),
      .pprot    (apb_fabric.slv_pprot[s]),
      .paddr    (apb_fabric.slv_paddr[s]),
      .pwrite   (apb_fabric.slv_pwrite[s]),
      .pstrb    (apb_fabric.slv_pstrb[s]),
      .pwdata   (apb_fabric.slv_pwdata[s]),
      .prdata   (apb_fabric.slv_prdata[s]),
      .pslverr  (apb_fabric.slv_pslverr[s]),
      .pready   (apb_fabric.slv_pready[s])
    );
    if (s > 0) begin : vif
      function automatic void publish(string path);
        uvm_config_db#(virtual apb_interface)::set(null, path, $sformatf("slv_apb_if[%0d]", s), slv[s].apb_if);
        slv[s-1].vif.publish(path);
      endfunction
    end
    else begin : vif
      function automatic void publish(string path);
        uvm_config_db#(virtual apb_interface)::set(null, path, $sformatf("slv_apb_if[%0d]", s), slv[s].apb_if);
      endfunction
    end
  end

  class apb_fabric_pharness extends apb_fabric_pharness_base;
    function new(string name = "apb_fabric_pharness");
      super.new(name);
      MST = apb_fabric_harness.MST;
      SLV = apb_fabric_harness.SLV;
      MST_ADDR = apb_fabric_harness.MST_ADDR;
      SLV_ADDR = apb_fabric_harness.SLV_ADDR;
      DATA = apb_fabric_harness.DATA;
    endfunction
  endclass
  apb_fabric_pharness pharness = new($sformatf("%m"));

  initial begin
    automatic string path = autopublish_path(pharness.get_name());
    publish_vifs(path);
  end

  function automatic void publish_vifs(string path);
    uvm_config_db#(virtual clk_rst_interface)::set(null, path, "clk_rst_if", clk_rst_if);
    mst[MST-1].vif.publish(path);
    slv[SLV-1].vif.publish(path);
    uvm_config_db#(apb_fabric_pkg::apb_fabric_pharness_base)::set(null, path, "harness", pharness);
  endfunction
endinterface

bind apb_fabric apb_fabric_harness#(.MST(MST), .SLV(SLV), .MST_ADDR(MST_ADDR), .SLV_ADDR(SLV_ADDR), .DATA(DATA)) harness();

`endif
`endif

