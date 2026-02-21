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
//		Generated on Tue Sep  9 10:49:23 2025
//
// ------------------------------------------------------
module SRAM_2P_behavioral_bm_bist(//inputs port
                          A_CLK,
                          A_DLY,
                          A_MEN,
                          A_ADDR,
                          A_DIN,
                          A_BM,
                          A_WEN,
                          A_REN,

                          //output port a
                          A_DOUT,

                          A_BIST_EN,
                          A_BIST_ADDR,
                          A_BIST_DIN,
                          A_BIST_BM,
                          A_BIST_MEN,
                          A_BIST_WEN,
                          A_BIST_REN,
                          A_BIST_CLK,


                          //inputs port b
                          B_CLK,
                          B_DLY,
                          B_MEN,
                          B_ADDR,
                          B_DIN,
                          B_BM,
                          B_WEN,
                          B_REN,

                          //output port b
                          B_DOUT,

                          B_BIST_EN,
                          B_BIST_ADDR,
                          B_BIST_DIN,
                          B_BIST_BM,
                          B_BIST_MEN,
                          B_BIST_WEN,
                          B_BIST_REN,
                          B_BIST_CLK);



parameter P_DATA_WIDTH =  20;
parameter P_ADDR_WIDTH =  9;

parameter P_ADDR_COUNT = 2**P_ADDR_WIDTH; //2^P_ADDR_WIDTH

parameter      P_FORCE_ERROR    = 0;
parameter [P_ADDR_WIDTH:0]    P_ERROR_ADDR    = 50;
parameter [P_DATA_WIDTH-1:0]  P_ERROR_PATTERN     = 40'h0000000000;

//inputs port a
input                    A_CLK;
input                    A_DLY;
input                    A_MEN;
input [P_ADDR_WIDTH-1:0] A_ADDR;
input [P_DATA_WIDTH-1:0] A_DIN;
input [P_DATA_WIDTH-1:0] A_BM;
input                    A_WEN;
input                    A_REN;

//output port a
output [P_DATA_WIDTH-1:0] A_DOUT;

input                    A_BIST_EN;
input [P_ADDR_WIDTH-1:0] A_BIST_ADDR;
input [P_DATA_WIDTH-1:0] A_BIST_DIN;
input [P_DATA_WIDTH-1:0] A_BIST_BM;
input                    A_BIST_MEN;
input                    A_BIST_WEN;
input                    A_BIST_REN;
input                    A_BIST_CLK;


//inputs port b
input                    B_CLK;
input                    B_DLY;
input                    B_MEN;
input [P_ADDR_WIDTH-1:0] B_ADDR;
input [P_DATA_WIDTH-1:0] B_DIN;
input [P_DATA_WIDTH-1:0] B_BM;
input                    B_WEN;
input                    B_REN;

//output port b
output [P_DATA_WIDTH-1:0] B_DOUT;

input                    B_BIST_EN;
input [P_ADDR_WIDTH-1:0] B_BIST_ADDR;
input [P_DATA_WIDTH-1:0] B_BIST_DIN;
input [P_DATA_WIDTH-1:0] B_BIST_BM;
input                    B_BIST_MEN;
input                    B_BIST_WEN;
input                    B_BIST_REN;
input                    B_BIST_CLK;



//memory array
reg [P_DATA_WIDTH-1:0]    mem_arr [0:P_ADDR_COUNT-1];

//real time_a;
//real time_b;

reg [P_DATA_WIDTH-1:0] dr_a_r;
reg [P_DATA_WIDTH-1:0] dr_b_r;

wire  [P_ADDR_WIDTH-1:0]	A_ADDR_MUX;
wire  [P_DATA_WIDTH-1:0] 	A_DIN_MUX;
wire  [P_DATA_WIDTH-1:0]	A_BM_MUX;
wire                        A_MEN_MUX;
wire                        A_WEN_MUX;
wire                        A_REN_MUX;
wire                        A_CLK_MUX;

wire  [P_ADDR_WIDTH-1:0]	B_ADDR_MUX;
wire  [P_DATA_WIDTH-1:0] 	B_DIN_MUX;
wire  [P_DATA_WIDTH-1:0]	B_BM_MUX;
wire                        B_MEN_MUX;
wire                        B_WEN_MUX;
wire                        B_REN_MUX;
wire                        B_CLK_MUX;


//BIST-MUX
assign A_ADDR_MUX=(A_BIST_EN==1'b1)?A_BIST_ADDR:A_ADDR;
assign A_DIN_MUX=(A_BIST_EN==1'b1)?A_BIST_DIN:A_DIN;
assign A_BM_MUX=(A_BIST_EN==1'b1)?A_BIST_BM:A_BM;
assign A_MEN_MUX=(A_BIST_EN==1'b1)?A_BIST_MEN:A_MEN;
assign A_WEN_MUX=(A_BIST_EN==1'b1)?A_BIST_WEN:A_WEN;
assign A_REN_MUX=(A_BIST_EN==1'b1)?A_BIST_REN:A_REN;
assign A_CLK_MUX=(A_BIST_EN==1'b1)?A_BIST_CLK:A_CLK;

assign B_ADDR_MUX=(B_BIST_EN==1'b1)?B_BIST_ADDR:B_ADDR;
assign B_DIN_MUX=(B_BIST_EN==1'b1)?B_BIST_DIN:B_DIN;
assign B_BM_MUX=(B_BIST_EN==1'b1)?B_BIST_BM:B_BM;
assign B_MEN_MUX=(B_BIST_EN==1'b1)?B_BIST_MEN:B_MEN;
assign B_WEN_MUX=(B_BIST_EN==1'b1)?B_BIST_WEN:B_WEN;
assign B_REN_MUX=(B_BIST_EN==1'b1)?B_BIST_REN:B_REN;
assign B_CLK_MUX=(B_BIST_EN==1'b1)?B_BIST_CLK:B_CLK;


always @(posedge A_CLK_MUX) begin
    time_a=$realtime;
    if(A_MEN_MUX==1'b1 && A_WEN_MUX==1'b1) begin
        mem_arr[A_ADDR_MUX] <= (mem_arr[A_ADDR_MUX] & ~A_BM_MUX) | (A_DIN_MUX & A_BM_MUX);
        if (A_REN_MUX==1'b1) begin
            dr_a_r<= (mem_arr[A_ADDR_MUX] & ~A_BM_MUX) | (A_DIN_MUX & A_BM_MUX);
        end
    end
    else if(A_MEN_MUX==1'b1 && A_REN_MUX==1'b1) begin
        dr_a_r<=mem_arr[A_ADDR_MUX];
    end
end


always @(posedge B_CLK_MUX) begin
    time_b=$realtime;
    if(B_MEN_MUX==1'b1 && B_WEN_MUX==1'b1) begin
        mem_arr[B_ADDR_MUX] <= (mem_arr[B_ADDR_MUX] & ~B_BM_MUX) | (B_DIN_MUX & B_BM_MUX);
        if (B_REN_MUX==1'b1) begin
            dr_b_r<= (mem_arr[B_ADDR_MUX] & ~B_BM_MUX) | (B_DIN_MUX & B_BM_MUX);
        end
    end
    else if(B_MEN_MUX==1'b1 && B_REN_MUX==1'b1) begin
        dr_b_r<=mem_arr[B_ADDR_MUX];
    end
end

assign A_DOUT=  dr_a_r;
assign B_DOUT=  dr_b_r;


endmodule
