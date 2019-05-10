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

`ifndef __apb_fabric_env__
`define __apb_fabric_env__

class apb_fabric_env extends uvm_env;

  arb_env arb_envs[string];

  clk_rst_agent clk_rst_agents[string];
  apb_agent mst_apb_agents[string];
  apb_agent slv_apb_agents[string];

  apb_fabric_env_cfg cfg;
  apb_fabric_pharness_base harness;
  apb_fabric_vseqr vseqr;

  `uvm_component_utils_begin(apb_fabric_env)
  `uvm_component_utils_end

  function new(string name = "apb_fabric_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (cfg.role != BLIND) begin
      if (! uvm_config_db#(apb_fabric_pharness_base)::get(this, "", "harness", harness)) begin
        `uvm_fatal("build_phase", "No apb_fabric_pharness_base 'harness' in uvm_config_db")
      end
      vseqr = apb_fabric_vseqr::type_id::create("vseqr", this);

      clk_rst_agents["clk_rst_if"] = clk_rst_agent::type_id::create("clk_rst_if", this);
      if (! uvm_config_db#(virtual clk_rst_interface)::get(this, "", "clk_rst_if", clk_rst_agents["clk_rst_if"].vif)) begin
        `uvm_fatal("build_phase", "No virtual clk_rst_interface 'clk_rst_if' in uvm_config_db")
      end
      clk_rst_agents["clk_rst_if"].cfg = clk_rst_vip_cfg::type_id::create("clk_rst_if_cfg");

      for (int a = 0; a < harness.MST; ++a) begin
        string name = $sformatf("mst_apb_if[%0d]", a);
        mst_apb_agents[name] = apb_agent::type_id::create(name, this);
        if (! uvm_config_db#(virtual apb_interface)::get(this, "", name, mst_apb_agents[name].vif)) begin
          `uvm_fatal("build_phase", $sformatf("No virtual apb_interface '%s' in uvm_config_db", name))
        end
        mst_apb_agents[name].cfg = apb_vip_cfg::type_id::create($sformatf("mst_apb_if_cfg[%0d]", a));
        mst_apb_agents[name].cfg.actual_addr_bus_bits = harness.MST_ADDR; mst_apb_agents[name].cfg.actual_data_bus_bits = harness.DATA;
      end

      for (int a = 0; a < harness.SLV; ++a) begin
        string name = $sformatf("slv_apb_if[%0d]", a);
        slv_apb_agents[name] = apb_agent::type_id::create(name, this);
        if (! uvm_config_db#(virtual apb_interface)::get(this, "", name, slv_apb_agents[name].vif)) begin
          `uvm_fatal("build_phase", $sformatf("No virtual apb_interface '%s' in uvm_config_db", name))
        end
        slv_apb_agents[name].cfg = apb_vip_cfg::type_id::create($sformatf("slv_apb_if_cfg[%0d]", a));
        slv_apb_agents[name].cfg.actual_addr_bus_bits = harness.SLV_ADDR; slv_apb_agents[name].cfg.actual_data_bus_bits = harness.DATA;
      end

      if (cfg.role == ACTING_AS) begin
        foreach (mst_apb_agents[a]) begin
          mst_apb_agents[a].is_active = UVM_ACTIVE; mst_apb_agents[a].cfg.role = apb_pkg::RESPONDER;
        end
        foreach (slv_apb_agents[a]) begin
          slv_apb_agents[a].is_active = UVM_ACTIVE; slv_apb_agents[a].cfg.role = apb_pkg::REQUESTER;
        end
      end
      else if (cfg.role == ACTING_ON) begin
        clk_rst_agents["clk_rst_if"].is_active = UVM_ACTIVE; clk_rst_agents["clk_rst_if"].cfg.freq = cfg.clk_freq;
        foreach (mst_apb_agents[a]) begin
          mst_apb_agents[a].is_active = UVM_ACTIVE; mst_apb_agents[a].cfg.role = apb_pkg::REQUESTER;
        end
        foreach (slv_apb_agents[a]) begin
          slv_apb_agents[a].is_active = UVM_ACTIVE; slv_apb_agents[a].cfg.role = apb_pkg::RESPONDER;
        end
      end
    end

    foreach (cfg.arb_env_cfgs[e]) begin arb_envs[e] = arb_env::type_id::create(e, this); arb_envs[e].cfg = cfg.arb_env_cfgs[e]; end
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  virtual task run_phase(uvm_phase phase);
  endtask
endclass

`endif

