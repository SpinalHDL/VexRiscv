// ------------------------------------------------------
//
//		Copyright 2023 IHP PDK Authors
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
//		Generated on Thu Jun 12 11:08:49 2025
//
// ------------------------------------------------------
module SRAM_2P_behavioral(//inputs port
                          A_CLK,
                          A_DLY,
                          A_MEN,
                          A_ADDR,
                          A_DIN,
                          A_WEN,
                          A_REN,

                          //output port a
                          A_DOUT,

                          //inputs port b
                          B_CLK,
                          B_DLY,
                          B_MEN,
                          B_ADDR,
                          B_DIN,
                          B_WEN,
                          B_REN,

                          //output port b
                          B_DOUT);



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
input                    A_WEN;
input                    A_REN;

//output port a
output [P_DATA_WIDTH-1:0] A_DOUT;


//inputs port b
input                    B_CLK;
input                    B_DLY;
input                    B_MEN;
input [P_ADDR_WIDTH-1:0] B_ADDR;
input [P_DATA_WIDTH-1:0] B_DIN;
input                    B_WEN;
input                    B_REN;

//output port b
output [P_DATA_WIDTH-1:0] B_DOUT;



//memory array
reg [P_DATA_WIDTH-1:0]    mem_arr [0:P_ADDR_COUNT-1];

reg [P_DATA_WIDTH-1:0] dr_a_r;
reg [P_DATA_WIDTH-1:0] dr_b_r;

wire  [P_ADDR_WIDTH-1:0]	A_ADDR_MUX;
wire  [P_DATA_WIDTH-1:0] 	A_DIN_MUX;
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
assign A_ADDR_MUX=A_ADDR;
assign A_DIN_MUX=A_DIN;
assign A_MEN_MUX=A_MEN;
assign A_WEN_MUX=A_WEN;
assign A_REN_MUX=A_REN;
assign A_CLK_MUX=A_CLK;

assign B_ADDR_MUX=B_ADDR;
assign B_DIN_MUX=B_DIN;
assign B_MEN_MUX=B_MEN;
assign B_WEN_MUX=B_WEN;
assign B_REN_MUX=B_REN;
assign B_CLK_MUX=B_CLK;


always @(posedge A_CLK_MUX) begin
    if(A_MEN_MUX==1'b1 && A_WEN_MUX==1'b1) begin
        mem_arr[A_ADDR_MUX] <= A_DIN_MUX;
        if (A_REN_MUX==1'b1) begin
            dr_a_r<= A_DIN_MUX;
        end
    end
    else if(A_MEN_MUX==1'b1 && A_REN_MUX==1'b1) begin
        dr_a_r<=mem_arr[A_ADDR_MUX];
    end
end


always @(posedge B_CLK_MUX) begin
    if(B_MEN_MUX==1'b1 && B_WEN_MUX==1'b1) begin
        mem_arr[B_ADDR_MUX] <= B_DIN_MUX;
        if (B_REN_MUX==1'b1) begin
            dr_b_r<= B_DIN_MUX;
        end
    end
    else if(B_MEN_MUX==1'b1 && B_REN_MUX==1'b1) begin
        dr_b_r<=mem_arr[B_ADDR_MUX];
    end
end

assign A_DOUT=  dr_a_r;
assign B_DOUT=  dr_b_r;


endmodule
