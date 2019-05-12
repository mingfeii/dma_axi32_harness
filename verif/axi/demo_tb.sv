
`ifndef DEMO_TB_SV
`define DEMO_TB_SV

class Demo_tb extends uvm_env;

  `uvm_component_utils_begin(Demo_tb)
  `uvm_component_utils_end

   AXI_env          m_axi_env;
   Demo_scoreboard  m_demo_scoreboard;
   Demo_conf        m_demo_conf;
   clk_rst_agent clk_rst_agents[string];
   axi_pharness_base harness;
   axi_vseqr vseqr;

  function new (string name="Demo_tb", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : Demo_tb

// set up conf to sub leaf masters/slaves
function void Demo_tb::build_phase(uvm_phase phase);
  super.build_phase(phase);
    
  m_demo_scoreboard = Demo_scoreboard::type_id::create("m_demo_scoreboard", this);
  m_axi_env         = AXI_env::type_id::create("m_axi_env", this);
 
 
  vseqr = axi_vseqr::type_id::create("vseqr", this);
  
 /* if (! uvm_config_db#(axi_pharness_base)::get(this, "", "harness", harness)) begin
    `uvm_fatal("build_phase", "No axi_pharness_base 'harness' in uvm_config_db")
  end*/
  
  clk_rst_agents["clk_rst_if"] = clk_rst_agent::type_id::create("clk_rst_if", this);
  if (! uvm_config_db#(virtual clk_rst_interface)::get(this, "", "clk_rst_if", clk_rst_agents["clk_rst_if"].vif)) begin
	`uvm_fatal("build_phase", "No virtual clk_rst_interface 'clk_rst_if' in uvm_config_db")
  end
  clk_rst_agents["clk_rst_if"].cfg = clk_rst_vip_cfg::type_id::create("clk_rst_if_cfg");
  if (m_demo_conf.role == ACTING_ON) begin
	clk_rst_agents["clk_rst_if"].is_active = UVM_ACTIVE; 
	m_demo_conf.add_master(.name            ("m_masters[0]"),
							 .is_active        (UVM_ACTIVE));
  end
  else if (m_demo_conf.role == JUST_LOOKING) begin
	clk_rst_agents["clk_rst_if"].is_active = UVM_PASSIVE; 
	m_demo_conf.add_master(.name            ("m_masters[0]"),
						 .is_active        (UVM_PASSIVE));
  end
  
  
  m_axi_env.assign_conf(m_demo_conf);  
  //clk_rst_agents["clk_rst_if"].cfg.freq = cfg.clk_freq;
endfunction : build_phase

// TLM analysis port from master/slave monitor to scoreboard
function void Demo_tb::connect_phase(uvm_phase phase);
  m_axi_env.m_masters[0].m_monitor.item_collected_port.connect(m_demo_scoreboard.item_collected_imp);
  //m_axi_env.m_slaves[0].m_monitor.item_collected_port.connect(m_demo_scoreboard.item_collected_imp);
endfunction : connect_phase

`endif // DEMO_TB_SV
