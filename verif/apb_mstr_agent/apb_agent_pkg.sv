
package apb_agent_pkg;
    // include and import uvm_pkg
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    `include "apb_param_pkg.sv"
    
    // typedefines
    typedef enum {READ=0, WRITE=1} op_type_e;
    
    // include agent files
	`include "apb_seq_item.sv"
    `include "apb_mstr_agent_config.sv"
    `include "apb_mstr_driver.sv"
    `include "apb_monitor.sv"
    `include "apb_mstr_sequencer.sv"
    `include "apb_coverage_monitor.sv"
    `include "apb_mstr_agent.sv"
	`include "apb_seq_list.sv"
endpackage: apb_agent_pkg