
`ifndef __dma_clk_rst_test__
`define __dma_clk_rst_test__

class dma_clk_rst_test extends dma_base_test;
  dma_base_vseq vseq; // Only vseqs that extend this base can be run with this test.

  `uvm_component_utils_begin(dma_clk_rst_test)
  `uvm_component_utils_end
   

  function new(string name = "dma_clk_rst_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    dma_env_cfgs["dut"].role = dma_verif_pkg::ACTING_ON;
    void'($value$plusargs("CLK_FREQ=%s", dma_env_cfgs["dut"].clk_freq));
	
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

