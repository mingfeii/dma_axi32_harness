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

`ifndef __apb_fabric_verif_param_pkg__
`define __apb_fabric_verif_param_pkg__

package apb_fabric_verif_param_pkg;

  // Global parameters.
  parameter PADDR // Set to project-wide max apb addr width.
            = proj_param_pkg::PROJ_PADDR;
  parameter PDATA // Set to project-wide max apb data width.
            = proj_param_pkg::PROJ_PDATA;

  // Local parameters.
  // N/A
endpackage

`endif

