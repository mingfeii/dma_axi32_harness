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

`ifndef __apb_fabric_vseqr__
`define __apb_fabric_vseqr__

class apb_fabric_vseqr extends uvm_sequencer_base;
  `uvm_component_utils_begin(apb_fabric_vseqr)
  `uvm_component_utils_end

  apb_fabric_env p_env;

  function new(string name = "apb_fabric_vseqr", uvm_component parent = null);
    super.new(name, parent);
    if (parent == null) begin
      `uvm_fatal("new", "Null parent is not legal for this component")
    end
    if (! $cast(p_env, parent)) begin
      p_env = new();
      `uvm_fatal("new", $sformatf("Parent object type=%s name=%s is not legal for this component, must be cast-compatible with %s type", parent.get_type_name(), parent.get_name(), p_env.get_type_name()))
    end
    set_arbitration(SEQ_ARB_RANDOM);
  endfunction
endclass

`endif
