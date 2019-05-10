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

`ifndef __apb_policy_lib__
`define __apb_policy_lib__

class apb_ad_hoc_policy#(type I = apb_seq_item); // The base policy class. A apb_ad_hoc_policy can only be added to a apb_ad_hoc_policy_list. Ad hoc policies are not pulled from the uvm_config_db.
  string name;
  rand I item;

  function new(string name = "apb_ad_hoc_policy");
    this.name = name;
  endfunction

  virtual function void set_item(I item);
    this.item = item;
  endfunction

  function void pre_randomize();
    if (item == null) begin
      `uvm_fatal("pre_randomize", $sformatf("%s: 'item' must be set before randomization", name))
    end
  endfunction
endclass

class apb_ad_hoc_policy_list#(type I = apb_seq_item) extends apb_ad_hoc_policy#(I); // The policy list extends the policy, so a list can hold both individual policies and nested lists of policies.
  rand apb_ad_hoc_policy#(I) plist[$];
  int plist_size; // I want the objects on the plist to be rand, but I don't want the list size to be rand.

  constraint keep_plist_size {
    plist.size() == plist_size;
  }

  function new(string name = "apb_ad_hoc_policy_list");
    super.new(name);
  endfunction

  virtual function void set_item(I item);
    super.set_item(item);
    foreach (plist[p]) begin
      plist[p].set_item(item);
    end
  endfunction

  virtual function void delete();
    plist.delete();
    plist_size = plist.size();
  endfunction

  virtual function void set(apb_ad_hoc_policy#(I) policy[$]); // Notice the arg is a queue: You can set a list (array literal) of policies all at once. But even for just a single policy, you must make a list, e.g. '{policy}. An empty list '{} is equivalent to delete().
    plist = policy;
    plist_size = plist.size();
  endfunction

  virtual function void add(apb_ad_hoc_policy#(I) policy[$]);
    plist = {plist, policy};
    plist_size = plist.size();
  endfunction
endclass

class apb_time0_seq_item_policy extends apb_ad_hoc_policy#(apb_seq_item); // This policy should only be added to a REQUESTER seq_item.
  function new(string name = "apb_time0_seq_item_policy");
    super.new(name);
  endfunction

  virtual function void set_item(apb_seq_item item);
    super.set_item(item);
   // item.plist.rand_mode(0);
    item.constraint_mode(0);
    item.paddr_max.constraint_mode(1);
    item.pxdata_max.constraint_mode(1);
  endfunction
endclass

class apb_idle_seq_item_policy extends apb_time0_seq_item_policy; // This policy should only be added to a REQUESTER seq_item.
  function new(string name = "apb_idle_seq_item_policy");
    super.new(name);
  endfunction

  virtual function void set_item(apb_seq_item item);
    super.set_item(item);
    item.pstrb_read.constraint_mode(1);
    item.pstrb_paddr.constraint_mode(1);
  endfunction
endclass

class apb_policy#(type I = apb_seq_item) extends apb_ad_hoc_policy#(I);
  function new(string name = "apb_policy");
    super.new(name);
  endfunction
endclass

class apb_policy_list#(type I = apb_seq_item, type P = apb_policy#(I)) extends apb_policy#(I); // The policy list extends the policy, so a list can hold both individual policies and nested lists of policies.
  rand P plist[$]; // Any list always extends the base policy type, but policies in the list don't have to be base policy type. See e.g. apb_addr_range_policy_list.
  int plist_size; // I want the objects on the plist to be rand, but I don't want the list size to be rand.

  constraint keep_plist_size {
    plist.size() == plist_size;
  }

  function new(string name = "apb_policy_list");
    super.new(name);
  endfunction

  virtual function void set_item(I item);
    super.set_item(item);
    foreach (plist[p]) begin
      plist[p].set_item(item);
    end
  endfunction

  virtual function void delete();
    plist.delete();
    plist_size = plist.size();
  endfunction

  virtual function void set(P policy[$]); // Notice the arg is a queue: You can set a list (array literal) of policies all at once. But even for just a single policy, you must make a list, e.g. '{policy}. An empty list '{} is equivalent to delete().
    plist = policy;
    plist_size = plist.size();
  endfunction

  virtual function void add(P policy[$]);
    plist = {plist, policy};
    plist_size = plist.size();
  endfunction
endclass

class apb_addr_range_policy extends apb_policy#(apb_seq_item);
  apb_param_pkg::ADDR_t addr_lo; // Not rand.
  apb_param_pkg::ADDR_t addr_hi; // Not rand.
  // We don't need two different kinds of addr range object, for keep-in vs keep-out regions. To create a keep-out hole in a larger keep-in addr range, just create an addr_range object for the keep-in range and another for the keep-out range.
  // An address that falls in no addr_range at all is a keep-out. An address that falls in *exactly one* addr_range is a keep-in. An address that falls in *multiple overlapping* addr_ranges is a keep-out.

  function new(string name = "apb_addr_range_policy");
    super.new(name);
  endfunction
endclass

class apb_addr_range_policy_list extends apb_policy_list#(apb_seq_item, apb_addr_range_policy);
  rand int range_select;

  function new(string name = "apb_addr_range_policy_list");
    super.new(name);
  endfunction

  constraint addr_range {
    range_select inside {[0 : plist.size() - 1]}; // plist.size() better be > 0. Don't create a apb_addr_range_policy_list without putting at least one apb_addr_range_policy in it. #WeShouldntHaveToTellYouThis.
    foreach (plist[i]) {
      (i == range_select) == (item.paddr inside {[plist[i].addr_lo : plist[i].addr_hi]});
    }
  }
endclass

`endif

