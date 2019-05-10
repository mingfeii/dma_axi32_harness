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

`ifndef __apb_names_pkg__
`define __apb_names_pkg__

package apb_names_pkg;

  typedef enum bit { PPROT2_DATA = 1'b0,
                     PPROT2_OPCODE = 1'b1
                   } pprot2_t;

  typedef enum bit { PPROT1_SECURE = 1'b0,
                     PPROT1_NONSECURE = 1'b1
                   } pprot1_t;

  typedef enum bit { PPROT0_USER = 1'b0,
                     PPROT0_PRIVILEGED = 1'b1
                   } pprot0_t;

  typedef enum bit [2:0] { PPROT_DATA_SECURE_USER = 3'b000,
                           PPROT_DATA_SECURE_PRIV = 3'b001,
                           PPROT_DATA_noSECURE_USER = 3'b010,
                           PPROT_DATA_noSECURE_PRIV = 3'b011,
                           PPROT_OP_SECURE_USER = 3'b100,
                           PPROT_OP_SECURE_PRIV = 3'b101,
                           PPROT_OP_noSECURE_USER = 3'b110,
                           PPROT_OP_noSECURE_PRIV = 3'b111
                         } pprot_t;

  typedef enum bit { PWRITE_READ = 1'b0,
                     PWRITE_WRITE = 1'b1
                   } pwrite_t;

  typedef enum bit { PSLVERR_OKAY = 1'b0,
                     PSLVERR_ERROR = 1'b1
                   } pslverr_t;
endpackage

`endif

