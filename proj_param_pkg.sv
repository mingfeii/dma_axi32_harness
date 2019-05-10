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

`ifndef __proj_param_pkg__
`define __proj_param_pkg__

package proj_param_pkg;

  parameter PROJ_HADDR = 32; // The max HADDR width project-wide.
  parameter PROJ_HDATA = 32; // The max HxDATA width project-wide.

  parameter PROJ_PADDR = 12; // The max PADDR width project-wide.
  parameter PROJ_PDATA = 32; // The max PxDATA width project-wide.

  parameter PROJ_CLK_RST_FANOUT = 1; // The max fanout of any clk_rst_interface project-wide.
  parameter PROJ_ARB_WAY = 2; // The max arb width project-wide.
  parameter PROJ_GPIO = 32;  // The max GPIO width project-wide.

  parameter MST_HADDR = 32; // HADDR width for ahb fabric connections to Master devices.
  parameter SLV_HADDR = 24; // HADDR width for ahb fabric connections to Slave devices.
  parameter AHB2APB_ADDR = SLV_HADDR;
  parameter MST_PADDR = AHB2APB_ADDR; // PADDR width for apb fabric connections to Master devices.
  parameter SLV_PADDR = 16; // PADDR width for apb fabric connections to Slave devices.

  // One canonical harness-path-manglement function
  function automatic string autopublish_path(string m);
    int l, r;
    for (l = 0; l < m.len(); ++l) begin
      if (m[l] == ".") begin
        break;
      end
    end
    for (r = m.len() - 1; r >= 0; --r) begin
      if (m[r] == ".") begin
        break;
      end
    end
    return ({"*", m.substr(l, r-1), "*"}); // Keep the "." on the left, strip the "." on the right.
  endfunction

  // Module IP from VendorA needs the same function, but they call it by a different function proto
  function  automatic string harness_path(string hier);
    return autopublish_path(hier);
  endfunction

  // Module IP from VendorB also needs the same function, but with another function proto again
  function automatic string harness_cfg_db_path(string module_path);
    return autopublish_path(module_path);
  endfunction
endpackage

// Compilation-unit scope.
`include "uvm_macros.svh"
import uvm_pkg::*;
import proj_param_pkg::*;

`endif

