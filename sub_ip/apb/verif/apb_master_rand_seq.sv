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

`ifndef __apb_master_rand_seq__
`define __apb_master_rand_seq__

class apb_master_rand_seq extends apb_base_seq;

  int unsigned item_limit = 0; // By default, run forever.

  `uvm_object_utils_begin(apb_master_rand_seq)
  `uvm_object_utils_end

  apb_seq_item incomplete[$];

  function new(string name = "apb_master_rand_seq");
    super.new(name);
  endfunction

  virtual task body();
    apb_policy_list plist = new($sformatf("%s.plist", get_full_name())); // A policy object name can be anything, a seq item will query the cfg db by *its own* name.
    uvm_config_db#(apb_policy)::set(null, $sformatf("%s.item[*]", get_full_name()), "policy", plist);

    fork
      wait_complete();
    join_none

    for (int unsigned i = 0; (item_limit == 0) || (i < item_limit); ++i) begin
      req = apb_seq_item::type_id::create($sformatf("item[%0d]", ++serial_num));
      `uvm_rand_send(req)
      incomplete.push_back(req);
    end

    wait (incomplete.size() == 0);
  endtask

  virtual task wait_complete();
    apb_seq_item item;
    forever begin
      wait (incomplete.size() > 0);
      item = incomplete[0];
      wait (item.pready);
      item = incomplete.pop_front();
    end
  endtask
endclass

`endif

