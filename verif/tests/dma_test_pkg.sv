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

`ifndef __dma_test_pkg__
`define __dma_test_pkg__

package dma_test_pkg;

  import uvm_pkg::*;
  
  import apb_agent_pkg::*;
  import dma_verif_pkg::*;
  import demo_pkg::*;

  `include "dma_base_vseq.sv"


  `include "dma_clk_rst_vseq.sv"
  `include "axi_slave_vseq.sv"


  `include "dma_base_test.sv"
  `include "dma_clk_rst_test.sv"
  `include "axi_slave_test.sv"

endpackage

`endif

