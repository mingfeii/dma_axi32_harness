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

`ifndef __apb_fabric__
`define __apb_fabric__

import apb_names_pkg::*;

module apb_fabric#(MST = 1, SLV = 1, MST_ADDR = 32, SLV_ADDR = 32, DATA = 32) (
  input preset_n,
  input pclk,
  input  [MST-1:0] mst_psel,
  input  [MST-1:0] mst_penable,
  input  [MST-1:0][2:0] mst_pprot,
  input  [MST-1:0][MST_ADDR-1:0] mst_paddr,
  input  [MST-1:0] mst_pwrite,
  input  [MST-1:0][3:0] mst_pstrb,
  input  [MST-1:0][DATA-1:0] mst_pwdata,
  output [MST-1:0][DATA-1:0] mst_prdata,
  output [MST-1:0] mst_pslverr,
  output [MST-1:0] mst_pready,
  output [SLV-1:0] slv_psel,
  output [SLV-1:0] slv_penable,
  output [SLV-1:0][2:0] slv_pprot,
  output [SLV-1:0][SLV_ADDR-1:0] slv_paddr,
  output [SLV-1:0] slv_pwrite,
  output [SLV-1:0][3:0] slv_pstrb,
  output [SLV-1:0][DATA-1:0] slv_pwdata,
  input  [SLV-1:0][DATA-1:0] slv_prdata,
  input  [SLV-1:0] slv_pslverr,
  input  [SLV-1:0] slv_pready
  // Every slave port is arbitrated in common, that is, a master owns all slaves at once and all master accesses are
  // serialized.
  // Because of this serialization, several of the ports don't actually need to be replicated for every MST or every
  // SLV: E.g. every master could be connected to a single mst_prdata bus, every slave could be connected to a single
  // slv_pwdata bus. But by providing all ports independently to all connected components, we get some other benefits.
  // If we replace this module with a stub, we can attach interfaces (and thus VIP agents) to completely independent
  // signal bundles, which allows us to exercise every port in parallel. As far as synthesis, all the shareable ports
  // *do* derive from single sources internally, it doesn't matter whether the source wire is branched inside or outside
  // the module.
);

  wire gnt_psel;
  wire [2:0] gnt_pprot;
  wire [MST_ADDR-1:0] gnt_paddr;
  wire gnt_pwrite;
  wire [3:0] gnt_pstrb;
  wire [DATA-1:0] gnt_pdata;
  wire [MST_ADDR:0] pad_paddr;
  wire [DATA-1:0]  psel_prdata;
  wire psel_pready;
  wire psel_pslverr;
  wire [MST-1:0] arb_ack;
  wire [MST-1:0] arb_gnt;
  wire [$clog2(MST)-1:0] owner;
  wire decerr;

  arb #(.WAY(MST)) arb_0 (
    .req (mst_psel),
    .lock ({MST{1'b0}}),
    .ack (arb_ack),
    .gnt (arb_gnt),
    .owner (owner)
  );

  aomux #(.WAYS(MST), .BITS(1)) aomux_psel (
    .in (mst_psel),
    .sel (arb_gnt),
    .out (gnt_psel)
  );

  aomux #(.WAYS(MST), .BITS(3)) aomux_pprot (
    .in (mst_pprot),
    .sel (arb_gnt),
    .out (gnt_pprot)
  );

  aomux #(.WAYS(MST), .BITS(MST_ADDR)) aomux_paddr (
    .in (mst_paddr),
    .sel (arb_gnt),
    .out (gnt_paddr)
  );

  aomux #(.WAYS(MST), .BITS(1)) aomux_pwrite (
    .in (mst_pwrite),
    .sel (arb_gnt),
    .out (gnt_pwrite)
  );

  aomux #(.WAYS(MST), .BITS(4)) aomux_pstrb (
    .in (mst_pstrb),
    .sel (arb_gnt),
    .out (gnt_pstrb)
  );

  aomux #(.WAYS(MST), .BITS(DATA)) aomux_pwdata (
    .in (mst_pwdata),
    .sel (arb_gnt),
    .out (gnt_pwdata)
  );

  reg penable;
  always @(posedge pclk or negedge preset_n) begin
    if (preset_n == 1'b0) begin
      penable <= 1'b0;
    end
    else begin
      penable <= gnt_psel && !(|arb_ack);
    end
  end

  assign arb_ack = mst_psel & mst_penable & mst_pready;

  assign pad_paddr = {1'b0, gnt_paddr}; // For the MST_ADDR == SLV_ADDR case, MST masters, 1 slave.

  assign slv_psel = {{SLV{1'b0}}, gnt_psel} << pad_paddr[MST_ADDR:SLV_ADDR];
  assign slv_penable = {{SLV{1'b0}}, penable} << pad_paddr[MST_ADDR:SLV_ADDR];

  assign slv_pprot = {SLV{gnt_pprot}};
  assign slv_paddr = {SLV{gnt_paddr[SLV_ADDR-1:0]}};
  assign slv_pwrite = {SLV{gnt_pwrite}};
  assign slv_pstrb = {SLV{gnt_pstrb}};
  assign slv_pwdata = {SLV{gnt_pwdata}};

  assign decerr = gnt_psel && !(|slv_psel);

  aomux #(.WAYS(SLV), .BITS(DATA)) aomux_prdata (
    .in (slv_prdata),
    .sel (slv_psel),
    .out (psel_prdata)
  );

  aomux #(.WAYS(SLV), .BITS(1)) aomux_pslverr (
    .in (slv_pslverr),
    .sel (slv_psel),
    .out (psel_pslverr)
  );

  aomux #(.WAYS(SLV), .BITS(1)) aomux_pready (
    .in (slv_pready),
    .sel (slv_psel),
    .out (psel_pready)
  );

  assign mst_prdata = {MST{psel_prdata}};
  assign mst_pslverr = {MST{psel_pslverr || decerr}};
  assign mst_pready = {MST{psel_pready || decerr}} & arb_gnt;
endmodule

`endif

