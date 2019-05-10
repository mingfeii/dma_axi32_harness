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

`ifndef __apb_base_seq__
`define __apb_base_seq__

class apb_base_seq extends uvm_sequence#(apb_seq_item);
  `uvm_object_utils_begin(apb_base_seq)
  `uvm_object_utils_end
  `uvm_declare_p_sequencer(apb_sequencer)

  int unsigned serial_num = '1;

  function new(string name = "apb_base_seq");
    super.new(name);
  endfunction
endclass

`endif

