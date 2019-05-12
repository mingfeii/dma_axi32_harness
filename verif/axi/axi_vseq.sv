// Copyright 2017 Verilab Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in wraxiiting, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

`ifndef __axi_vseq__
`define __axi_vseq__

class axi_vseq extends uvm_sequence;

  `uvm_object_utils_begin(axi_vseq)
  `uvm_object_utils_end
  `uvm_declare_p_sequencer(demo_pkg::axi_vseqr)

  function new(string name = "axi_vseq");
    super.new(name);
  endfunction

  virtual task body();
    clk_rst_pkg::clk_rst_turnkey_seq clk_rst_turnkey_seqs[string];
	DEMO_AXI_master_write_data_after_write_addr axi_wr_seq;
    //apb_pkg::apb_master_rand_seq apb_master_rand_seqs[string];
    //fork
      // Clock(s) start automatically, but we need reset(s). Send one, then let the clock(s) run forever.
      foreach (p_sequencer.p_env.clk_rst_agents[a]) begin
        fork
          automatic string b = a;
          begin
            clk_rst_turnkey_seqs[b] = clk_rst_pkg::clk_rst_turnkey_seq::type_id::create(b);
            clk_rst_turnkey_seqs[b].start(p_sequencer.p_env.clk_rst_agents[b].sequencer, this);
          end
        join_none
      end
	  #100ns;
	  $display("starting axi seq");
	  axi_wr_seq = DEMO_AXI_master_write_data_after_write_addr::type_id::create("axi_wr_seq");
	  axi_wr_seq.start(p_sequencer.p_env.m_axi_env.m_masters[0].m_sequencer, this);
	  #2000ns;

	  $display("item done");
      
   // join
  endtask
 

endclass

`endif

