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

`ifndef __apb_fabric_pharness_base__
`define __apb_fabric_pharness_base__

class apb_fabric_pharness_base;
  string name;
  int MST;
  int SLV;
  int MST_ADDR;
  int SLV_ADDR;
  int DATA;

  function new(string name = "apb_fabric_pharness_base");
    this.name = name;
  endfunction

  virtual function string get_name();
    return name;
  endfunction
endclass

`endif
