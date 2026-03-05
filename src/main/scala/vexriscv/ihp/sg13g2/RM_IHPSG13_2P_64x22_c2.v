// ------------------------------------------------------
//
//		Copyright 2025 IHP PDK Authors
//
//		Licensed under the Apache License, Version 2.0 (the "License");
//		you may not use this file except in compliance with the License.
//		You may obtain a copy of the License at
//
//		   https://www.apache.org/licenses/LICENSE-2.0
//
//		Unless required by applicable law or agreed to in writing, software
//		distributed under the License is distributed on an "AS IS" BASIS,
//		WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//		See the License for the specific language governing permissions and
//		limitations under the License.
//
//		Generated on Mon Jan 19 16:01:28 2026
//
// ------------------------------------------------------
`timescale 1ns/10ps
`celldefine
module RM_IHPSG13_2P_64x22_c2 (
    A_CLK,
    A_MEN,
    A_WEN,
    A_REN,
    A_ADDR,
    A_DIN,
    A_DLY,
    A_DOUT,
    B_CLK,
    B_MEN,
    B_WEN,
    B_REN,
    B_ADDR,
    B_DIN,
    B_DLY,
    B_DOUT
);

    input A_CLK;
    input A_MEN;
    input A_WEN;
    input A_REN;
    input [5:0] A_ADDR;
    input [21:0] A_DIN;
    input A_DLY;
    output [21:0] A_DOUT;
    input B_CLK;
    input B_MEN;
    input B_WEN;
    input B_REN;
    input [5:0] B_ADDR;
    input [21:0] B_DIN;
    input B_DLY;
    output [21:0] B_DOUT;

`define SYNTHESIS
`define FUNCTIONAL

// ---- Simulation-only check: A_DLY must be tied high ----------------------
`ifndef SYNTHESIS
    initial begin
      #0; // check at t=0 (after elaboration)
      if (A_DLY !== 1'b1) begin
        $display("%m ERROR: A_DLY must be tied to 1'b1 (saw %b) at time %0t.", A_DLY, $time);
        $stop; // use $finish if you prefer to exit completely
      end
    end

    always @(A_DLY) begin
      if (A_DLY !== 1'b1) begin
        $display("%m ERROR: A_DLY must remain 1'b1 (observed %b) at time %0t.", A_DLY, $time);
        $stop;
      end
    end
`endif

// ---- Simulation-only check: B_DLY must be tied high ----------------------
`ifndef SYNTHESIS
    initial begin
      #0; // check at t=0 (after elaboration)
      if (B_DLY !== 1'b1) begin
        $display("%m ERROR: B_DLY must be tied to 1'b1 (saw %b) at time %0t.", B_DLY, $time);
        $stop; // use $finish if you prefer to exit completely
      end
    end

    always @(B_DLY) begin
      if (B_DLY !== 1'b1) begin
        $display("%m ERROR: B_DLY must remain 1'b1 (observed %b) at time %0t.", B_DLY, $time);
        $stop;
      end
    end
`endif

`ifdef FUNCTIONAL  //  functional //


    SRAM_2P_behavioral #(
	.P_DATA_WIDTH(22),
	.P_ADDR_WIDTH(6)
	) i_SRAM_2P_behavioral (
                    .A_CLK(A_CLK),
                    .A_MEN(A_MEN),
                    .A_WEN(A_WEN),
                    .A_REN(A_REN),
                    .A_ADDR(A_ADDR),
                    .A_DLY(A_DLY),
                    .A_DIN(A_DIN),
                    .A_DOUT(A_DOUT),
                    .B_CLK(B_CLK),
                    .B_MEN(B_MEN),
                    .B_WEN(B_WEN),
                    .B_REN(B_REN),
                    .B_ADDR(B_ADDR),
                    .B_DLY(B_DLY),
                    .B_DIN(B_DIN),
                    .B_DOUT(B_DOUT)
		);

`else

    wire A_CLK_DELAY;
    wire A_MEN_DELAY;
    wire A_WEN_DELAY;
    wire A_REN_DELAY;
    wire [5:0] A_ADDR_DELAY;
    wire [21:0] A_DIN_DELAY;
    wire B_CLK_DELAY;
    wire B_MEN_DELAY;
    wire B_WEN_DELAY;
    wire B_REN_DELAY;
    wire [5:0] B_ADDR_DELAY;
    wire [21:0] B_DIN_DELAY;

    reg notifier;

    wire A_RW_ACCESS = (A_WEN || A_REN) && A_MEN;
    wire A_W_ACCESS  = A_WEN && A_MEN;

    wire B_RW_ACCESS = (B_WEN || B_REN) && B_MEN;
    wire B_W_ACCESS  = B_WEN && B_MEN;


    SRAM_2P_behavioral #(
	.P_DATA_WIDTH(22),
	.P_ADDR_WIDTH(6)
	) i_SRAM_2P_behavioral (
                    .A_CLK(A_CLK_DELAY),
                    .A_MEN(A_MEN_DELAY),
                    .A_WEN(A_WEN_DELAY),
                    .A_REN(A_REN_DELAY),
                    .A_ADDR(A_ADDR_DELAY),
                    .A_DLY(A_DLY),
                    .A_DIN(A_DIN_DELAY),
                    .A_DOUT(A_DOUT),
                    .B_CLK(B_CLK_DELAY),
                    .B_MEN(B_MEN_DELAY),
                    .B_WEN(B_WEN_DELAY),
                    .B_REN(B_REN_DELAY),
                    .B_ADDR(B_ADDR_DELAY),
                    .B_DLY(B_DLY),
                    .B_DIN(B_DIN_DELAY),
                    .B_DOUT(B_DOUT)
		);


    specify

      (posedge A_CLK *> (A_DOUT : A_DIN)) = (1.0, 1.0);
      $width(posedge A_CLK, 1.0,0,notifier);
      $setuphold(posedge A_CLK &&& A_MEN, posedge A_MEN, 1.0, 1.0,notifier,,,A_CLK_DELAY, A_MEN_DELAY);
      $setuphold(posedge A_CLK &&& A_MEN, posedge A_REN, 1.0, 1.0,notifier,,,A_CLK_DELAY, A_REN_DELAY);
      $setuphold(posedge A_CLK &&& A_MEN, posedge A_WEN, 1.0, 1.0,notifier,,,A_CLK_DELAY, A_WEN_DELAY);
      $setuphold(posedge A_CLK &&& A_MEN, negedge A_MEN, 1.0, 1.0,notifier,,,A_CLK_DELAY, A_MEN_DELAY);
      $setuphold(posedge A_CLK &&& A_MEN, negedge A_REN, 1.0, 1.0,notifier,,,A_CLK_DELAY, A_REN_DELAY);
      $setuphold(posedge A_CLK &&& A_MEN, negedge A_WEN, 1.0, 1.0,notifier,,,A_CLK_DELAY, A_WEN_DELAY);
      $setuphold(posedge A_CLK &&& A_RW_ACCESS, posedge A_ADDR, 1.0 ,1.0, notifier,,,A_CLK_DELAY, A_ADDR_DELAY);
      $setuphold(posedge A_CLK &&& A_RW_ACCESS, negedge A_ADDR, 1.0 ,1.0, notifier,,,A_CLK_DELAY, A_ADDR_DELAY);

      $setuphold(posedge A_CLK &&& A_W_ACCESS, posedge A_DIN, 1.0 ,1.0, notifier,,,A_CLK_DELAY, A_DIN_DELAY);
      $setuphold(posedge A_CLK &&& A_W_ACCESS, negedge A_DIN, 1.0 ,1.0, notifier,,,A_CLK_DELAY, A_DIN_DELAY);

      (posedge B_CLK *> (B_DOUT : B_DIN)) = (1.0, 1.0);
      $width(posedge B_CLK, 1.0,0,notifier);
      $setuphold(posedge B_CLK &&& B_MEN, posedge B_MEN, 1.0, 1.0,notifier,,,B_CLK_DELAY, B_MEN_DELAY);
      $setuphold(posedge B_CLK &&& B_MEN, posedge B_REN, 1.0, 1.0,notifier,,,B_CLK_DELAY, B_REN_DELAY);
      $setuphold(posedge B_CLK &&& B_MEN, posedge B_WEN, 1.0, 1.0,notifier,,,B_CLK_DELAY, B_WEN_DELAY);
      $setuphold(posedge B_CLK &&& B_MEN, negedge B_MEN, 1.0, 1.0,notifier,,,B_CLK_DELAY, B_MEN_DELAY);
      $setuphold(posedge B_CLK &&& B_MEN, negedge B_REN, 1.0, 1.0,notifier,,,B_CLK_DELAY, B_REN_DELAY);
      $setuphold(posedge B_CLK &&& B_MEN, negedge B_WEN, 1.0, 1.0,notifier,,,B_CLK_DELAY, B_WEN_DELAY);
      $setuphold(posedge B_CLK &&& B_RW_ACCESS, posedge B_ADDR, 1.0 ,1.0, notifier,,,B_CLK_DELAY, B_ADDR_DELAY);
      $setuphold(posedge B_CLK &&& B_RW_ACCESS, negedge B_ADDR, 1.0 ,1.0, notifier,,,B_CLK_DELAY, B_ADDR_DELAY);

      $setuphold(posedge B_CLK &&& B_W_ACCESS, posedge B_DIN, 1.0 ,1.0, notifier,,,B_CLK_DELAY, B_DIN_DELAY);
      $setuphold(posedge B_CLK &&& B_W_ACCESS, negedge B_DIN, 1.0 ,1.0, notifier,,,B_CLK_DELAY, B_DIN_DELAY);

    endspecify

`endif

endmodule
`endcelldefine
