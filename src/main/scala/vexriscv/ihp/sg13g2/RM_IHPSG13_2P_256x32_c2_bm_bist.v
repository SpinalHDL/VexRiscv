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
//		Generated on Wed Aug 27 13:14:43 2025
//
// ------------------------------------------------------
`celldefine
module RM_IHPSG13_2P_256x32_c2_bm_bist (
    A_CLK,
    A_MEN,
    A_WEN,
    A_REN,
    A_ADDR,
    A_DIN,
    A_DLY,
    A_DOUT,
    A_BM,
    A_BIST_CLK,
    A_BIST_EN,
    A_BIST_MEN,
    A_BIST_WEN,
    A_BIST_REN,
    A_BIST_ADDR,
    A_BIST_DIN,
    A_BIST_BM,
    B_CLK,
    B_MEN,
    B_WEN,
    B_REN,
    B_ADDR,
    B_DIN,
    B_DLY,
    B_DOUT,
    B_BM,
    B_BIST_CLK,
    B_BIST_EN,
    B_BIST_MEN,
    B_BIST_WEN,
    B_BIST_REN,
    B_BIST_ADDR,
    B_BIST_DIN,
    B_BIST_BM
);

    input A_CLK;
    input A_MEN;
    input A_WEN;
    input A_REN;
    input [7:0] A_ADDR;
    input [31:0] A_DIN;
    input A_DLY;
    output [31:0] A_DOUT;
    input [31:0] A_BM;
    input A_BIST_CLK;
    input A_BIST_EN;
    input A_BIST_MEN;
    input A_BIST_WEN;
    input A_BIST_REN;
    input [7:0] A_BIST_ADDR;
    input [31:0] A_BIST_DIN;
    input [31:0] A_BIST_BM;
    input B_CLK;
    input B_MEN;
    input B_WEN;
    input B_REN;
    input [7:0] B_ADDR;
    input [31:0] B_DIN;
    input B_DLY;
    output [31:0] B_DOUT;
    input [31:0] B_BM;
    input B_BIST_CLK;
    input B_BIST_EN;
    input B_BIST_MEN;
    input B_BIST_WEN;
    input B_BIST_REN;
    input [7:0] B_BIST_ADDR;
    input [31:0] B_BIST_DIN;
    input [31:0] B_BIST_BM;

`define SYNTHESIS
`define FUNCTIONAL

`ifdef FUNCTIONAL  //  functional //


    SRAM_2P_behavioral_bm_bist #(
	.P_DATA_WIDTH(32),
	.P_ADDR_WIDTH(8)
	) i_SRAM_2P_behavioral_bm_bist (
                    .A_CLK(A_CLK),
                    .A_MEN(A_MEN),
                    .A_WEN(A_WEN),
                    .A_REN(A_REN),
                    .A_ADDR(A_ADDR),
                    .A_DLY(A_DLY),
                    .A_DIN(A_DIN),
                    .A_DOUT(A_DOUT),
                    .A_BM(A_BM),
                    .A_BIST_CLK(A_BIST_CLK),
                    .A_BIST_EN(A_BIST_EN),
                    .A_BIST_MEN(A_BIST_MEN),
                    .A_BIST_WEN(A_BIST_WEN),
                    .A_BIST_REN(A_BIST_REN),
                    .A_BIST_ADDR(A_BIST_ADDR),
                    .A_BIST_DIN(A_BIST_DIN),
                    .A_BIST_BM(A_BIST_BM),
                    .B_CLK(B_CLK),
                    .B_MEN(B_MEN),
                    .B_WEN(B_WEN),
                    .B_REN(B_REN),
                    .B_ADDR(B_ADDR),
                    .B_DLY(B_DLY),
                    .B_DIN(B_DIN),
                    .B_DOUT(B_DOUT),
                    .B_BM(B_BM),
                    .B_BIST_CLK(B_BIST_CLK),
                    .B_BIST_EN(B_BIST_EN),
                    .B_BIST_MEN(B_BIST_MEN),
                    .B_BIST_WEN(B_BIST_WEN),
                    .B_BIST_REN(B_BIST_REN),
                    .B_BIST_ADDR(B_BIST_ADDR),
                    .B_BIST_DIN(B_BIST_DIN),
                    .B_BIST_BM(B_BIST_BM)
		);

`else

    wire A_CLK_DELAY;
    wire A_MEN_DELAY;
    wire A_WEN_DELAY;
    wire A_REN_DELAY;
    wire [7:0] A_ADDR_DELAY;
    wire [31:0] A_DIN_DELAY;
    wire [31:0] A_BM_DELAY;
    wire A_BIST_CLK_DELAY;
    wire A_BIST_MEN_DELAY;
    wire A_BIST_WEN_DELAY;
    wire A_BIST_REN_DELAY;
    wire [7:0] A_BIST_ADDR_DELAY;
    wire [31:0] A_BIST_DIN_DELAY;
    wire [31:0] A_BIST_BM_DELAY;
    wire B_CLK_DELAY;
    wire B_MEN_DELAY;
    wire B_WEN_DELAY;
    wire B_REN_DELAY;
    wire [7:0] B_ADDR_DELAY;
    wire [31:0] B_DIN_DELAY;
    wire [31:0] B_BM_DELAY;
    wire B_BIST_CLK_DELAY;
    wire B_BIST_MEN_DELAY;
    wire B_BIST_WEN_DELAY;
    wire B_BIST_REN_DELAY;
    wire [7:0] B_BIST_ADDR_DELAY;
    wire [31:0] B_BIST_DIN_DELAY;
    wire [31:0] B_BIST_BM_DELAY;

    reg notifier;

    wire A_RW_ACCESS = (A_WEN || A_REN) && A_MEN;
    wire A_W_ACCESS  = A_WEN && A_MEN;
    wire A_BIST_RW_ACCESS = (A_BIST_WEN || A_BIST_REN) && A_BIST_MEN;
    wire A_BIST_W_ACCESS  = A_BIST_WEN && A_BIST_MEN;

    wire B_RW_ACCESS = (B_WEN || B_REN) && B_MEN;
    wire B_W_ACCESS  = B_WEN && B_MEN;
    wire B_BIST_RW_ACCESS = (B_BIST_WEN || B_BIST_REN) && B_BIST_MEN;
    wire B_BIST_W_ACCESS  = B_BIST_WEN && B_BIST_MEN;


    SRAM_2P_behavioral_bm_bist #(
	.P_DATA_WIDTH(32),
	.P_ADDR_WIDTH(8)
	) i_SRAM_2P_behavioral_bm_bist (
                    .A_CLK(A_CLK_DELAY),
                    .A_MEN(A_MEN_DELAY),
                    .A_WEN(A_WEN_DELAY),
                    .A_REN(A_REN_DELAY),
                    .A_ADDR(A_ADDR_DELAY),
                    .A_DLY(A_DLY),
                    .A_DIN(A_DIN_DELAY),
                    .A_DOUT(A_DOUT),
                    .A_BM(A_BM_DELAY),
                    .A_BIST_CLK(A_BIST_CLK_DELAY),
                    .A_BIST_EN(A_BIST_EN),
                    .A_BIST_MEN(A_BIST_MEN_DELAY),
                    .A_BIST_WEN(A_BIST_WEN_DELAY),
                    .A_BIST_REN(A_BIST_REN_DELAY),
                    .A_BIST_ADDR(A_BIST_ADDR_DELAY),
                    .A_BIST_DIN(A_BIST_DIN_DELAY),
                    .A_BIST_BM(A_BIST_BM_DELAY),
                    .B_CLK(B_CLK_DELAY),
                    .B_MEN(B_MEN_DELAY),
                    .B_WEN(B_WEN_DELAY),
                    .B_REN(B_REN_DELAY),
                    .B_ADDR(B_ADDR_DELAY),
                    .B_DLY(B_DLY),
                    .B_DIN(B_DIN_DELAY),
                    .B_DOUT(B_DOUT),
                    .B_BM(B_BM_DELAY),
                    .B_BIST_CLK(B_BIST_CLK_DELAY),
                    .B_BIST_EN(B_BIST_EN),
                    .B_BIST_MEN(B_BIST_MEN_DELAY),
                    .B_BIST_WEN(B_BIST_WEN_DELAY),
                    .B_BIST_REN(B_BIST_REN_DELAY),
                    .B_BIST_ADDR(B_BIST_ADDR_DELAY),
                    .B_BIST_DIN(B_BIST_DIN_DELAY),
                    .B_BIST_BM(B_BIST_BM_DELAY)
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
      $setuphold(posedge A_CLK &&& A_W_ACCESS, posedge A_BM, 1.0 ,1.0, notifier,,,A_CLK_DELAY, A_BM_DELAY);
      $setuphold(posedge A_CLK &&& A_W_ACCESS, negedge A_BM, 1.0 ,1.0, notifier,,,A_CLK_DELAY, A_BM_DELAY);
      (posedge A_BIST_CLK *> (A_DOUT : A_BIST_DIN)) = (1.0, 1.0);
      $width(posedge A_BIST_CLK, 1.0,0,notifier);
      $setuphold(posedge A_BIST_CLK &&& A_BIST_MEN, posedge A_BIST_MEN, 1.0, 1.0,notifier,,,A_BIST_CLK_DELAY, A_BIST_MEN_DELAY);
      $setuphold(posedge A_BIST_CLK &&& A_BIST_MEN, posedge A_BIST_REN, 1.0, 1.0,notifier,,,A_BIST_CLK_DELAY, A_BIST_REN_DELAY);
      $setuphold(posedge A_BIST_CLK &&& A_BIST_MEN, posedge A_BIST_WEN, 1.0, 1.0,notifier,,,A_BIST_CLK_DELAY, A_BIST_WEN_DELAY);
      $setuphold(posedge A_BIST_CLK &&& A_BIST_MEN, negedge A_BIST_MEN, 1.0, 1.0,notifier,,,A_BIST_CLK_DELAY, A_BIST_MEN_DELAY);
      $setuphold(posedge A_BIST_CLK &&& A_BIST_MEN, negedge A_BIST_REN, 1.0, 1.0,notifier,,,A_BIST_CLK_DELAY, A_BIST_REN_DELAY);
      $setuphold(posedge A_BIST_CLK &&& A_BIST_MEN, negedge A_BIST_WEN, 1.0, 1.0,notifier,,,A_BIST_CLK_DELAY, A_BIST_WEN_DELAY);
      $setuphold(posedge A_BIST_CLK &&& A_BIST_RW_ACCESS, posedge A_BIST_ADDR, 1.0 ,1.0, notifier,,,A_BIST_CLK_DELAY, A_BIST_ADDR_DELAY);
      $setuphold(posedge A_BIST_CLK &&& A_BIST_RW_ACCESS, negedge A_BIST_ADDR, 1.0 ,1.0, notifier,,,A_BIST_CLK_DELAY, A_BIST_ADDR_DELAY);

      $setuphold(posedge A_BIST_CLK &&& A_BIST_W_ACCESS, posedge A_BIST_DIN, 1.0 ,1.0, notifier,,,A_BIST_CLK_DELAY, A_BIST_DIN_DELAY);
      $setuphold(posedge A_BIST_CLK &&& A_BIST_W_ACCESS, negedge A_BIST_DIN, 1.0 ,1.0, notifier,,,A_BIST_CLK_DELAY, A_BIST_DIN_DELAY);
      $setuphold(posedge A_BIST_CLK &&& A_BIST_W_ACCESS, posedge A_BIST_BM, 1.0 ,1.0, notifier,,,A_BIST_CLK_DELAY, A_BIST_BM_DELAY);
      $setuphold(posedge A_BIST_CLK &&& A_BIST_W_ACCESS, negedge A_BIST_BM, 1.0 ,1.0, notifier,,,A_BIST_CLK_DELAY, A_BIST_BM_DELAY);

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
      $setuphold(posedge B_CLK &&& B_W_ACCESS, posedge B_BM, 1.0 ,1.0, notifier,,,B_CLK_DELAY, B_BM_DELAY);
      $setuphold(posedge B_CLK &&& B_W_ACCESS, negedge B_BM, 1.0 ,1.0, notifier,,,B_CLK_DELAY, B_BM_DELAY);
      (posedge B_BIST_CLK *> (B_DOUT : B_BIST_DIN)) = (1.0, 1.0);
      $width(posedge B_BIST_CLK, 1.0,0,notifier);
      $setuphold(posedge B_BIST_CLK &&& B_BIST_MEN, posedge B_BIST_MEN, 1.0, 1.0,notifier,,,B_BIST_CLK_DELAY, B_BIST_MEN_DELAY);
      $setuphold(posedge B_BIST_CLK &&& B_BIST_MEN, posedge B_BIST_REN, 1.0, 1.0,notifier,,,B_BIST_CLK_DELAY, B_BIST_REN_DELAY);
      $setuphold(posedge B_BIST_CLK &&& B_BIST_MEN, posedge B_BIST_WEN, 1.0, 1.0,notifier,,,B_BIST_CLK_DELAY, B_BIST_WEN_DELAY);
      $setuphold(posedge B_BIST_CLK &&& B_BIST_MEN, negedge B_BIST_MEN, 1.0, 1.0,notifier,,,B_BIST_CLK_DELAY, B_BIST_MEN_DELAY);
      $setuphold(posedge B_BIST_CLK &&& B_BIST_MEN, negedge B_BIST_REN, 1.0, 1.0,notifier,,,B_BIST_CLK_DELAY, B_BIST_REN_DELAY);
      $setuphold(posedge B_BIST_CLK &&& B_BIST_MEN, negedge B_BIST_WEN, 1.0, 1.0,notifier,,,B_BIST_CLK_DELAY, B_BIST_WEN_DELAY);
      $setuphold(posedge B_BIST_CLK &&& B_BIST_RW_ACCESS, posedge B_BIST_ADDR, 1.0 ,1.0, notifier,,,B_BIST_CLK_DELAY, B_BIST_ADDR_DELAY);
      $setuphold(posedge B_BIST_CLK &&& B_BIST_RW_ACCESS, negedge B_BIST_ADDR, 1.0 ,1.0, notifier,,,B_BIST_CLK_DELAY, B_BIST_ADDR_DELAY);

      $setuphold(posedge B_BIST_CLK &&& B_BIST_W_ACCESS, posedge B_BIST_DIN, 1.0 ,1.0, notifier,,,B_BIST_CLK_DELAY, B_BIST_DIN_DELAY);
      $setuphold(posedge B_BIST_CLK &&& B_BIST_W_ACCESS, negedge B_BIST_DIN, 1.0 ,1.0, notifier,,,B_BIST_CLK_DELAY, B_BIST_DIN_DELAY);
      $setuphold(posedge B_BIST_CLK &&& B_BIST_W_ACCESS, posedge B_BIST_BM, 1.0 ,1.0, notifier,,,B_BIST_CLK_DELAY, B_BIST_BM_DELAY);
      $setuphold(posedge B_BIST_CLK &&& B_BIST_W_ACCESS, negedge B_BIST_BM, 1.0 ,1.0, notifier,,,B_BIST_CLK_DELAY, B_BIST_BM_DELAY);

    endspecify

`endif

endmodule
`endcelldefine
