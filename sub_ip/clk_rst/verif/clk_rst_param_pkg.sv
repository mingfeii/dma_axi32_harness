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

`ifndef __clk_rst_param_pkg__
`define __clk_rst_param_pkg__

package clk_rst_param_pkg;

  // Global parameters.
  parameter FANOUT // Set to project-wide max clk_rst width.
            = proj_param_pkg::PROJ_CLK_RST_FANOUT;

  // Local parameters.
  typedef bit [FANOUT-1:0] FANOUT_t;
endpackage

`endif

