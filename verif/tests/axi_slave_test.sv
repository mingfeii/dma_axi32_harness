
`ifndef __axi_slave_test__
`define __axi_slave_test__

class axi_slave_test extends dma_base_test;
  dma_base_vseq vseq; // Only vseqs that extend this base can be run with this test.

  `uvm_component_utils_begin(axi_slave_test)
  `uvm_component_utils_end
   

  function new(string name = "axi_slave_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    dma_env_cfgs["dut"].role = dma_verif_pkg::JUST_LOOKING;
	dma_env_cfgs["dut"].m_demo_conf = Demo_conf::type_id::create("m_demo_conf", this);
	dma_env_cfgs["dut"].m_demo_conf.role = demo_pkg::ACTING_ON;
  endfunction

  virtual task run_phase(uvm_phase phase);
    string VSEQ;
	clk_rst_pkg::clk_rst_turnkey_seq clk_rst_turnkey_seqs[string];
    void'($value$plusargs("VSEQ=%s", VSEQ));
    set_type_override(dma_base_vseq::type_name, VSEQ);
    vseq = dma_base_vseq::type_id::create(VSEQ);

	  
    phase.raise_objection(this);
    `uvm_info("run_phase", $sformatf("Starting VSEQ=%s",VSEQ),UVM_NONE)
     // clk_rst_turnkey_seqs["dut"] = clk_rst_pkg::clk_rst_turnkey_seq::type_id::create("dut");
     // clk_rst_turnkey_seqs["dut"].start(dma_envs["dut"].clk_rst_agents["clk_rst_if"].sequencer, null);
	 vseq.start(dma_envs["dut"].vseqr, null);
    `uvm_info("run_phase", $sformatf("Finished VSEQ=%s",VSEQ),UVM_NONE)
    phase.drop_objection(this);
  endtask
endclass


`endif

