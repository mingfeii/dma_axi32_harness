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

`ifndef __apb_vip_cfg__
`define __apb_vip_cfg__

class apb_vip_cfg extends uvm_object;

  agent_role role;
  int unsigned actual_addr_bus_bits;
  int unsigned actual_data_bus_bits;

  bit kill_valid_psel = 0;
  bit kill_valid_penable = 0;
  bit kill_valid_pprot = 0;
  bit kill_valid_paddr = 0;
  bit kill_valid_pwrite = 0;
  bit kill_valid_pstrb = 0;
  bit kill_valid_pwdata = 0;
  bit kill_valid_pready = 0;
  bit kill_valid_prdata = 0;
  bit kill_valid_pslverr = 0;
  bit kill_stable_psel = 0;
  bit kill_stable_penable = 0;
  bit kill_stable_pprot = 0;
  bit kill_stable_paddr = 0;
  bit kill_stable_pwrite = 0;
  bit kill_stable_pstrb = 0;
  bit kill_stable_pwdata = 0;
  bit kill_penable_idle = 0;
  bit kill_penable_setup = 0;
  bit kill_penable_pready = 0;
  bit kill_pstrb_read = 0;
  bit kill_pstrb_paddr = 0;

  `uvm_object_utils_begin(apb_vip_cfg)
    `uvm_field_enum(agent_role, role, UVM_ALL_ON)
    `uvm_field_int(actual_addr_bus_bits, UVM_ALL_ON)
    `uvm_field_int(actual_data_bus_bits, UVM_ALL_ON)
    `uvm_field_int(kill_valid_psel, UVM_ALL_ON)
    `uvm_field_int(kill_valid_penable, UVM_ALL_ON)
    `uvm_field_int(kill_valid_pprot, UVM_ALL_ON)
    `uvm_field_int(kill_valid_paddr, UVM_ALL_ON)
    `uvm_field_int(kill_valid_pwrite, UVM_ALL_ON)
    `uvm_field_int(kill_valid_pstrb, UVM_ALL_ON)
    `uvm_field_int(kill_valid_pwdata, UVM_ALL_ON)
    `uvm_field_int(kill_valid_pready, UVM_ALL_ON)
    `uvm_field_int(kill_valid_prdata, UVM_ALL_ON)
    `uvm_field_int(kill_valid_pslverr, UVM_ALL_ON)
    `uvm_field_int(kill_stable_psel, UVM_ALL_ON)
    `uvm_field_int(kill_stable_penable, UVM_ALL_ON)
    `uvm_field_int(kill_stable_pprot, UVM_ALL_ON)
    `uvm_field_int(kill_stable_paddr, UVM_ALL_ON)
    `uvm_field_int(kill_stable_pwrite, UVM_ALL_ON)
    `uvm_field_int(kill_stable_pstrb, UVM_ALL_ON)
    `uvm_field_int(kill_stable_pwdata, UVM_ALL_ON)
    `uvm_field_int(kill_penable_idle, UVM_ALL_ON)
    `uvm_field_int(kill_penable_setup, UVM_ALL_ON)
    `uvm_field_int(kill_penable_pready, UVM_ALL_ON)
    `uvm_field_int(kill_pstrb_read, UVM_ALL_ON)
    `uvm_field_int(kill_pstrb_paddr, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "apb_vip_cfg", uvm_component parent = null);
    super.new(name);
  endfunction

  virtual function void set_kills(kill_aa aa);
    if (aa.exists("kill_valid_psel")) begin kill_valid_psel = aa["kill_valid_psel"]; end
    if (aa.exists("kill_valid_penable")) begin kill_valid_penable = aa["kill_valid_penable"]; end
    if (aa.exists("kill_valid_pprot")) begin kill_valid_pprot = aa["kill_valid_pprot"]; end
    if (aa.exists("kill_valid_paddr")) begin kill_valid_paddr = aa["kill_valid_paddr"]; end
    if (aa.exists("kill_valid_pwrite")) begin kill_valid_pwrite = aa["kill_valid_pwrite"]; end
    if (aa.exists("kill_valid_pstrb")) begin kill_valid_pstrb = aa["kill_valid_pstrb"]; end
    if (aa.exists("kill_valid_pwdata")) begin kill_valid_pwdata = aa["kill_valid_pwdata"]; end
    if (aa.exists("kill_valid_pready")) begin kill_valid_pready = aa["kill_valid_pready"]; end
    if (aa.exists("kill_valid_prdata")) begin kill_valid_prdata = aa["kill_valid_prdata"]; end
    if (aa.exists("kill_valid_pslverr")) begin kill_valid_pslverr = aa["kill_valid_pslverr"]; end
    if (aa.exists("kill_stable_psel")) begin kill_stable_psel = aa["kill_stable_psel"]; end
    if (aa.exists("kill_stable_penable")) begin kill_stable_penable = aa["kill_stable_penable"]; end
    if (aa.exists("kill_stable_pprot")) begin kill_stable_pprot = aa["kill_stable_pprot"]; end
    if (aa.exists("kill_stable_paddr")) begin kill_stable_paddr = aa["kill_stable_paddr"]; end
    if (aa.exists("kill_stable_pwrite")) begin kill_stable_pwrite = aa["kill_stable_pwrite"]; end
    if (aa.exists("kill_stable_pstrb")) begin kill_stable_pstrb = aa["kill_stable_pstrb"]; end
    if (aa.exists("kill_stable_pwdata")) begin kill_stable_pwdata = aa["kill_stable_pwdata"]; end
    if (aa.exists("kill_penable_idle")) begin kill_penable_idle = aa["kill_penable_idle"]; end
    if (aa.exists("kill_penable_setup")) begin kill_penable_setup = aa["kill_penable_setup"]; end
    if (aa.exists("kill_penable_pready")) begin kill_penable_pready = aa["kill_penable_pready"]; end
    if (aa.exists("kill_pstrb_read")) begin kill_pstrb_read = aa["kill_pstrb_read"]; end
    if (aa.exists("kill_pstrb_paddr")) begin kill_pstrb_paddr = aa["kill_pstrb_paddr"]; end
  endfunction

  virtual function kill_aa get_kills();
    get_kills["kill_valid_psel"] = kill_valid_psel;
    get_kills["kill_valid_penable"] = kill_valid_penable;
    get_kills["kill_valid_pprot"] = kill_valid_pprot;
    get_kills["kill_valid_paddr"] = kill_valid_paddr;
    get_kills["kill_valid_pwrite"] = kill_valid_pwrite;
    get_kills["kill_valid_pstrb"] = kill_valid_pstrb;
    get_kills["kill_valid_pwdata"] = kill_valid_pwdata;
    get_kills["kill_valid_pready"] = kill_valid_pready;
    get_kills["kill_valid_prdata"] = kill_valid_prdata;
    get_kills["kill_valid_pslverr"] = kill_valid_pslverr;
    get_kills["kill_stable_psel"] = kill_stable_psel;
    get_kills["kill_stable_penable"] = kill_stable_penable;
    get_kills["kill_stable_pprot"] = kill_stable_pprot;
    get_kills["kill_stable_paddr"] = kill_stable_paddr;
    get_kills["kill_stable_pwrite"] = kill_stable_pwrite;
    get_kills["kill_stable_pstrb"] = kill_stable_pstrb;
    get_kills["kill_stable_pwdata"] = kill_stable_pwdata;
    get_kills["kill_penable_idle"] = kill_penable_idle;
    get_kills["kill_penable_setup"] = kill_penable_setup;
    get_kills["kill_penable_pready"] = kill_penable_pready;
    get_kills["kill_pstrb_read"] = kill_pstrb_read;
    get_kills["kill_pstrb_paddr"] = kill_pstrb_paddr;
    return get_kills;
  endfunction
endclass

`endif

