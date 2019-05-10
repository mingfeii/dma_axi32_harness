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

`ifndef __apb_pkg__
`define __apb_pkg__

package apb_pkg;

  import uvm_pkg::*;
  import apb_param_pkg::*;
  import apb_names_pkg::*;

  typedef enum bit { REQUESTER, RESPONDER } agent_role;

  typedef bit kill_aa[string];

  typedef class apb_seq_item;

  `include "apb_mem.sv"
  `include "apb_policy_lib.sv"
  `include "apb_vip_cfg.sv"
  `include "apb_sequencer.sv"
  `include "apb_driver.sv"
  `include "apb_monitor.sv"
  `include "apb_agent.sv"
  `include "apb_seq_item.sv"

  `include "apb_base_seq.sv"
  `include "apb_master_rand_seq.sv"
  `include "apb_slave_mem_seq.sv"
endpackage

`endif

