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

`ifndef __clk_rst_pkg__
`define __clk_rst_pkg__

package clk_rst_pkg;

  import uvm_pkg::*;

  function real freq2period(string freq, real conversion); // The conversion factor is the time units of the result, e.g. if conversion = 1ps, result is in ps.
    real value;
    string units;
    real scale;
    if ($sscanf(freq, "%f%s", value, units) != 2) begin
      `uvm_fatal("freq2period", $sformatf("Unable to parse '%s' as a <value><units> string", freq))
    end
    case (units.tolower())
      "hz" : begin
        scale = 1s;
      end
      "khz" : begin
        scale = 1ms;
      end
      "mhz" : begin
        scale = 1us;
      end
      "ghz" : begin
        scale = 1ns;
      end
      default : begin
        `uvm_fatal("freq2period", $sformatf("Unrecognized units of freq value '%s' to convert. Only Hz, kHz, MHz, GHz units supported (case insensitive)", freq))
      end
    endcase
    return (1.0 / value) * (scale / conversion);
  endfunction

  typedef class clk_rst_seq_item;

  //`include "clk_rst_policy_lib.sv"
  `include "clk_rst_vip_cfg.sv"
  `include "clk_rst_sequencer.sv"
  `include "clk_rst_driver.sv"
  //`include "clk_rst_monitor.sv"
  `include "clk_rst_agent.sv"
  `include "clk_rst_seq_item.sv"

  `include "clk_rst_base_seq.sv"
  `include "clk_rst_turnkey_seq.sv"
endpackage

`endif

