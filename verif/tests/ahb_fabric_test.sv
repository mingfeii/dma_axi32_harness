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

`ifndef __ahb_fabric_test__
`define __ahb_fabric_test__

class ahb_fabric_test extends verilab_chip_base_test;
  ahb_fabric_test_base_vseq vseq; // Only vseqs that extend this base can be run with this test.

  `uvm_component_utils_begin(ahb_fabric_test)
  `uvm_component_utils_end

  function new(string name = "ahb_fabric_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    verilab_chip_env_cfgs["dut"].verilab_core_env_cfgs["verilab_core_0"] = verilab_core_env_cfg::type_id::create("verilab_core_0");
    verilab_chip_env_cfgs["dut"].verilab_core_env_cfgs["verilab_core_0"].role = verilab_core_pkg::BLIND;

    verilab_chip_env_cfgs["dut"].verilab_core_env_cfgs["verilab_core_0"].proc_subsys_env_cfgs["proc_subsys_0"] = proc_subsys_env_cfg::type_id::create("proc_subsys_0");
    verilab_chip_env_cfgs["dut"].verilab_core_env_cfgs["verilab_core_0"].proc_subsys_env_cfgs["proc_subsys_0"].role = proc_subsys_pkg::BLIND;

    verilab_chip_env_cfgs["dut"].verilab_core_env_cfgs["verilab_core_0"].proc_subsys_env_cfgs["proc_subsys_0"].ahb_fabric_env_cfgs["ahb_fabric_0"] = ahb_fabric_env_cfg::type_id::create("ahb_fabric_0");
    verilab_chip_env_cfgs["dut"].verilab_core_env_cfgs["verilab_core_0"].proc_subsys_env_cfgs["proc_subsys_0"].ahb_fabric_env_cfgs["ahb_fabric_0"].role = ahb_fabric_pkg::ACTING_ON;
    void'($value$plusargs("CLK_FREQ=%s", verilab_chip_env_cfgs["dut"].verilab_core_env_cfgs["verilab_core_0"].proc_subsys_env_cfgs["proc_subsys_0"].ahb_fabric_env_cfgs["ahb_fabric_0"].clk_freq));

    verilab_chip_env_cfgs["dut"].verilab_core_env_cfgs["verilab_core_0"].proc_subsys_env_cfgs["proc_subsys_0"].ahb_fabric_env_cfgs["ahb_fabric_0"].arb_env_cfgs["arb[0].arb_0"] = arb_env_cfg::type_id::create("arb[0].arb_0");
    verilab_chip_env_cfgs["dut"].verilab_core_env_cfgs["verilab_core_0"].proc_subsys_env_cfgs["proc_subsys_0"].ahb_fabric_env_cfgs["ahb_fabric_0"].arb_env_cfgs["arb[0].arb_0"].role = arb_mod_pkg::JUST_LOOKING;

    verilab_chip_env_cfgs["dut"].verilab_core_env_cfgs["verilab_core_0"].proc_subsys_env_cfgs["proc_subsys_0"].ahb_fabric_env_cfgs["ahb_fabric_0"].arb_env_cfgs["arb[1].arb_0"] = arb_env_cfg::type_id::create("arb[1].arb_0");
    verilab_chip_env_cfgs["dut"].verilab_core_env_cfgs["verilab_core_0"].proc_subsys_env_cfgs["proc_subsys_0"].ahb_fabric_env_cfgs["ahb_fabric_0"].arb_env_cfgs["arb[1].arb_0"].role = arb_mod_pkg::JUST_LOOKING;
  endfunction

  virtual task run_phase(uvm_phase phase);
    string VSEQ;
    void'($value$plusargs("VSEQ=%s", VSEQ));
    set_type_override(ahb_fabric_test_base_vseq::type_name, VSEQ);
    vseq = ahb_fabric_test_base_vseq::type_id::create(VSEQ);

    phase.raise_objection(this);
    `uvm_info("run_phase", $sformatf("Starting VSEQ=%s",VSEQ),UVM_NONE)
    vseq.start(verilab_chip_envs["dut"].verilab_core_envs["verilab_core_0"].proc_subsys_envs["proc_subsys_0"].ahb_fabric_envs["ahb_fabric_0"].vseqr, null);
    `uvm_info("run_phase", $sformatf("Finished VSEQ=%s",VSEQ),UVM_NONE)
    phase.drop_objection(this);
  endtask
endclass

class ahb_fabric_test_base_vseq extends verilab_chip_base_vseq;
  `uvm_object_utils_begin(ahb_fabric_test_base_vseq)
  `uvm_object_utils_end
  `uvm_declare_p_sequencer(ahb_fabric_pkg::ahb_fabric_vseqr)

  function new(string name = "ahb_fabric_test_base_vseq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_error("body", "This is an empty base class method, you must specify a factory override vseq with a +VSEQ=... plusarg")
  endtask
endclass

`endif

