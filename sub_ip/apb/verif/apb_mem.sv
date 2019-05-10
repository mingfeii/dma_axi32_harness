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

`ifndef __apb_mem__
`define __apb_mem__

class apb_mem extends uvm_object;

  byte mem[ADDR_t];

  `uvm_object_utils_begin(apb_mem)
  `uvm_object_utils_end

  function new(string name = "apb_mem");
    super.new(name);
  endfunction

  virtual function void access(apb_seq_item item);
    DATA_t data_offset = 0;

    if (item.pwrite == PWRITE_WRITE) begin
      ADDR_t mem_addr = item.paddr & ~((ADDR_t'(item.cfg.actual_data_bus_bits) >> 3) - 1);
      data_offset = item.pxdata;
      for (int b = 0; b < (item.cfg.actual_data_bus_bits >> 3); ++b) begin
        if (item.pstrb[b]) begin
          mem[mem_addr] = data_offset[7:0];
        end
        ++mem_addr;
        data_offset >>= 8;
      end
    end
    else begin
      ADDR_t mem_addr = item.paddr + (item.cfg.actual_data_bus_bits >> 3);
      for (int b = 0; b < (item.cfg.actual_data_bus_bits >> 3); ++b) begin
        data_offset <<= 8;
        --mem_addr;
        if (! mem.exists(mem_addr)) begin
          mem[mem_addr] = $urandom;
        end
        data_offset[7:0] = mem[mem_addr];
      end
      item.pxdata = data_offset;
    end
  endfunction
endclass

`endif

