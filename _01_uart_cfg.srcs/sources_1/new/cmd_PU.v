`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/26 23:36:38
// Design Name: 
// Module Name: cmd_PU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cmd_PU(
input    wire [7:0]  i_data_rcv   ,
input    wire        i_rcv_ok     ,
output   reg  [7:0]  o_data_out   ,
output   reg         o_snd_start  ,
input    wire        clk          ,
input    wire        rst_n        
    );
wire  [7:0] nxt_data_out  ;
wire        nxt_snd_start ;
always@(posedge clk or negedge rst_n)begin
  if(~rst_n)begin
    o_data_out   <= 8'h0;
    o_snd_start  <= 1'b0;
  end
  else begin
    o_data_out   <= nxt_data_out;
    o_snd_start  <= nxt_snd_start;
  end
end

assign nxt_snd_start = i_rcv_ok;
assign nxt_data_out  = i_rcv_ok ? i_data_rcv : o_data_out;


endmodule
