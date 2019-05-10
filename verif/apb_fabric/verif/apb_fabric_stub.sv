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

`ifndef __apb_fabric_stub__
`define __apb_fabric_stub__
// A stub module def file is always read before its real counterpart, so a predefined __module_name__ token allows the stub to be compiled instead. Unless the __module_name_stub__ token is also predefined, in which case
// no module def is compiled at all. That might be appropriate if e.g. a parent module higher in the design hierarchy is stubbed out, and then either def of the lower module would be a nuisance implicit top-level instance.
`ifdef __apb_fabric__

module apb_fabric#(MST = 1, SLV = 1, MST_ADDR = 32, SLV_ADDR = 32, DATA = 32) (
  input preset_n,
  input pclk,
  input  [MST-1:0] mst_psel,
  input  [MST-1:0] mst_penable,
  input  [MST-1:0][2:0] mst_pprot,
  input  [MST-1:0][apb_fabric_verif_param_pkg::PADDR-1:0] mst_paddr,
  input  [MST-1:0] mst_pwrite,
  input  [MST-1:0][(apb_fabric_verif_param_pkg::PDATA)-1:0] mst_pstrb,
  input  [MST-1:0][apb_fabric_verif_param_pkg::PDATA-1:0] mst_pwdata,
  output [MST-1:0][apb_fabric_verif_param_pkg::PDATA-1:0] mst_prdata,
  output [MST-1:0] mst_pslverr,
  output [MST-1:0] mst_pready,
  output [SLV-1:0] slv_psel,
  output [SLV-1:0] slv_penable,
  output [SLV-1:0][2:0] slv_pprot,
  output [SLV-1:0][apb_fabric_verif_param_pkg::PADDR-1:0] slv_paddr,
  output [SLV-1:0] slv_pwrite,
  output [SLV-1:0][(apb_fabric_verif_param_pkg::PDATA>>3)-1:0] slv_pstrb,
  output [SLV-1:0][apb_fabric_verif_param_pkg::PDATA-1:0] slv_pwdata,
  input  [SLV-1:0][apb_fabric_verif_param_pkg::PDATA-1:0] slv_prdata,
  input  [SLV-1:0] slv_pslverr,
  input  [SLV-1:0] slv_pready
);

  assign (pull1, pull0) mst_prdata = '0;
  assign (pull1, pull0) mst_pslverr = '0;
  assign (pull1, pull0) mst_pready = '1;
  assign (pull1, pull0) slv_psel = '0;
  assign (pull1, pull0) slv_penable = '0;
  assign (pull1, pull0) slv_pprot = '0;
  assign (pull1, pull0) slv_paddr = '0;
  assign (pull1, pull0) slv_pwrite = '0;
  assign (pull1, pull0) slv_pstrb = '0;
  assign (pull1, pull0) slv_pwdata = '0;

`ifdef __apb_fabric_stub_lumpy__
  arb #(.WAY(MST)) arb_0 ();
`endif
endmodule

`endif
`endif
