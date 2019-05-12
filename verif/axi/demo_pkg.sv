
`ifndef DEMO_PKG_SV
`define DEMO_PKG_SV

package demo_pkg;

`include "axi_pkg.sv"
`include "axi_seq_lib_pkg.sv"

import uvm_pkg::*;
`include "uvm_macros.svh"

import clk_rst_pkg::*;
import axi_pkg::*;
import axi_seq_lib_pkg::*;

typedef enum int {BLIND, ACTING_ON, JUST_LOOKING} env_role;

typedef class Demo_tb;
`include "axi_pharness_base.sv"
`include "demo_conf.sv"
`include "demo_scoreboard.sv"
`include "axi_vseqr.sv"
`include "demo_axi_master_seq_lib.sv"
`include "demo_axi_slave_seq_lib.sv"
`include "axi_vseq.sv"
`include "demo_tb.sv"
`include "demo_lib.sv"


endpackage : demo_pkg

`endif // DEMO_PKG_SV

