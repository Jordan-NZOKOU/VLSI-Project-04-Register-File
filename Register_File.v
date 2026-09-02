/**
 * Copyright 2026 Jordan Nzokou
 * Project: Nexvantis
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

`timescale 1ns/1ps
`default_nettype none

// RV32I register file: two asynchronous read ports and one synchronous write
// port. Writes to x0 are discarded and reads from x0 always return zero.
module Register_File(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        WE3,
    input  wire [4:0]  A1,
    input  wire [4:0]  A2,
    input  wire [4:0]  A3,
    input  wire [31:0] WD3,
    output wire [31:0] RD1,
    output wire [31:0] RD2
);

    reg [31:0] registers [0:31];
    integer i;

    // Full reset is retained for deterministic simulation. A production FPGA
    // or ASIC implementation may use a different initialization strategy.
    always @(posedge clk) begin
        if (!rst_n) begin
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'b0;
        end
        else if (WE3 && (A3 != 5'd0)) begin
            registers[A3] <= WD3;
        end
    end

    assign RD1 = (A1 == 5'd0) ? 32'b0 : registers[A1];
    assign RD2 = (A2 == 5'd0) ? 32'b0 : registers[A2];

endmodule

`default_nettype wire
