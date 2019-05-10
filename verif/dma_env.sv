
`ifndef __dma_env__
`define __dma_env__

class dma_env extends uvm_env;


  clk_rst_agent clk_rst_agents[string];
  //apb_agent mst_apb_agents[string];

  // instance of agent
  apb_mstr_agent  apb_mstr_agnt;
  apb_mstr_agent_config apb_mstr_agnt_cfg;
	
  dma_env_cfg cfg;
  dma_pharness_base harness;
  dma_vseqr vseqr;

  `uvm_component_utils_begin(dma_env)
  `uvm_component_utils_end

  function new(string name = "dma_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    $display(cfg.role);
    if (cfg.role != BLIND) begin
	  $display(cfg.role);
      if (! uvm_config_db#(dma_pharness_base)::get(this, "", "harness", harness)) begin
        `uvm_fatal("build_phase", "No dma_pharness_base 'harness' in uvm_config_db")
      end
      vseqr = dma_vseqr::type_id::create("vseqr", this);

      clk_rst_agents["clk_rst_if"] = clk_rst_agent::type_id::create("clk_rst_if", this);
      if (! uvm_config_db#(virtual clk_rst_interface)::get(this, "", "clk_rst_if", clk_rst_agents["clk_rst_if"].vif)) begin
        `uvm_fatal("build_phase", "No virtual clk_rst_interface 'clk_rst_if' in uvm_config_db")
      end
      clk_rst_agents["clk_rst_if"].cfg = clk_rst_vip_cfg::type_id::create("clk_rst_if_cfg");
      apb_mstr_agnt = apb_mstr_agent::type_id::create("apb_mstr_agnt", this);
	  /*mst_apb_agents["mst_apb_if"] = apb_agent::type_id::create("mst_apb_if", this);
	  if (! uvm_config_db#(virtual apb_interface)::get(this, "", "mst_apb_if", mst_apb_agents["mst_apb_if"].vif)) begin
	    `uvm_fatal("build_phase", $sformatf("No virtual apb_interface 'mst_apb_if' in uvm_config_db"))
	  end
	  mst_apb_agents["mst_apb_if"].cfg = apb_vip_cfg::type_id::create($sformatf("mst_apb_if_cfg"));
	  mst_apb_agents["mst_apb_if"].cfg.actual_addr_bus_bits = 12; mst_apb_agents["mst_apb_if"].cfg.actual_data_bus_bits = 32;
      */
      apb_mstr_agnt_cfg = apb_mstr_agent_config::type_id::create("apb_mstr_agnt_cfg");
  	  // get the interface from uvm_config_db
      if(!uvm_config_db#(virtual apb_interface)::get(this,"","APB_INTF", apb_mstr_agnt_cfg.apb_intf)) begin
		`uvm_fatal("INTERFACE NOT FOUND ERROR", $sformatf("Could not retrieve apb_interface from uvm_config_db"))
	  end
	
	  // configure env_cfg
	  apb_mstr_agnt_cfg.has_functional_coverage = 0;
	  apb_mstr_agnt_cfg.is_active = UVM_ACTIVE;
	  uvm_config_db#(apb_mstr_agent_config)::set(null, "*", "APB_MSTR_AGNT_CFG", apb_mstr_agnt_cfg);  
	  
      if (cfg.role == ACTING_AS) begin
        //gpioz_agents["gpioz_if"].is_active = UVM_ACTIVE; gpioz_agents["gpioz_if"].cfg.role = gpioz_pkg::REQUESTER;
        //i2cz_agents["i2cz_if"].is_active = UVM_ACTIVE;
      end
      else if (cfg.role == ACTING_ON) begin
        clk_rst_agents["clk_rst_if"].is_active = UVM_ACTIVE; clk_rst_agents["clk_rst_if"].cfg.freq = cfg.clk_freq;
		//mst_apb_agents["mst_apb_if"].is_active = UVM_ACTIVE; mst_apb_agents["mst_apb_if"].cfg.role = apb_pkg::REQUESTER;
        //gpioz_agents["gpioz_if"].is_active = UVM_ACTIVE; gpioz_agents["gpioz_if"].cfg.role = gpioz_pkg::RESPONDER;
        //i2cz_agents["i2cz_if"].is_active = UVM_ACTIVE;
      end
    end


  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  virtual task run_phase(uvm_phase phase);
  endtask
endclass

`endif

