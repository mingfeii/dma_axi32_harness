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

`ifndef __dma_clk_rst_vseq__
`define __dma_clk_rst_vseq__

class dma_clk_rst_vseq extends dma_base_vseq;

  `uvm_object_utils_begin(dma_clk_rst_vseq)
  `uvm_object_utils_end
  `uvm_declare_p_sequencer(dma_verif_pkg::dma_vseqr)

  function new(string name = "dma_clk_rst_vseq");
    super.new(name);
  endfunction

  virtual task body();
    clk_rst_pkg::clk_rst_turnkey_seq clk_rst_turnkey_seqs[string];
    //apb_pkg::apb_master_rand_seq apb_master_rand_seqs[string];
    fork
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
	  wr_data_2_mem('h1048, 1'b1, 0, 0); // CH start
	  wr_data_2_mem('h10, 'h84032008, 0, 0); // Static 0
	  wr_data_2_mem('h14, 'hC4032008, 0, 0); // Static 1
	  wr_data_2_mem('h20, 'h10001, 0, 0); // Static 1
	  wr_data_2_mem('h08, 'hF, 0, 0); // CMD2
	  wr_data_2_mem('h0C, 'h2, 0, 0); // CMD3
	  wr_data_2_mem('h40, 'h1, 0, 0); // CH Enable 
	  wr_data_2_mem('h44, 'h1, 0, 0); // CH Start
	  #2000ns;
	  //apb_master_rand_seqs["mst_apb_if"] = apb_pkg::apb_master_rand_seq::type_id::create("mst_apb_if");
	  //apb_master_rand_seqs["mst_apb_if"].item_limit = 5;
	  //apb_master_rand_seqs["mst_apb_if"].start(p_sequencer.p_env.mst_apb_agents["mst_apb_if"].sequencer, this);
	  $display("item done");
      
    join
  endtask
  
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
    // task: rd_data_4m_mem
    // input parameters:
    //                      addr: Memory address to read
    //                      rand_addr: flag to enable random address selection
    // Description:         Read data from the specified address
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    task rd_data_4m_mem(input [`ADDR_WIDTH-1:0] addr, input bit rand_addr);
        // declare the sequence
        apb_rd_sequence  rd_seq;
        
        // create the sequence
        rd_seq = apb_rd_sequence::type_id::create("rd_seq");
        
        // configure sequence
        rd_seq.addr = addr;
        rd_seq.rand_addr = rand_addr;
        
        // start the sequence
        rd_seq.start(p_sequencer.p_env.apb_mstr_agnt.apb_mstr_seqr);
    endtask: rd_data_4m_mem
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    // task: wr_rand_data_2_mem
    // input parameters:
    //                      addr: Memory address to write
    //                      data: Data to write
    //                      rand_addr: flag to enable random address selection
    //                      rand_data: flag to enable random data write
    // Description:         Read data from the specified address
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    task wr_data_2_mem(input [`ADDR_WIDTH-1:0] addr, input [`DATA_WIDTH-1:0] data, input bit rand_addr, input bit rand_data);
        // declare the sequence
        apb_wr_sequence  wr_seq;
        
        // create the sequence
        wr_seq = apb_wr_sequence::type_id::create("wr_seq");
        
        // configure sequence
        wr_seq.addr = addr;
        wr_seq.data = data;
        wr_seq.rand_addr = rand_addr;
        wr_seq.rand_data = rand_data;
        
        // start the sequence
        wr_seq.start(p_sequencer.p_env.apb_mstr_agnt.apb_mstr_seqr);
    endtask: wr_data_2_mem

endclass

`endif

