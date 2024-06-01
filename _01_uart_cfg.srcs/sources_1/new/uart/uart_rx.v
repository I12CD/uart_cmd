`timescale 1ns / 1ps

module uart_rx#
(
parameter CLK_FREQ    = 4_000_000   ,   //equal 4MHz
parameter BUAD_RATE   = 115200      ,
parameter WIDTH_DATA  = 8            
)
(
  input			                      clk       ,
  input                           rst_n     ,
  input                           i_rxd     ,
  output                          o_rx_end	,
  output        [WIDTH_DATA-1:0]  o_rx_data  
);

localparam BUAD_CNT  = CLK_FREQ/BUAD_RATE;         
localparam WIDTH_CLK_CNT = 16;
localparam WIDTH_BIT_CNT = 4;

//----------------------------------------------//
reg   [WIDTH_CLK_CNT-1:0] clk_cnt ;
reg   [WIDTH_BIT_CNT-1:0] bit_cnt ;
reg   [3:0]               rxd_dly ;
reg                       rx_en   ;
reg                       rx_end  ;
reg   [WIDTH_DATA+1:0]    rx_buf  ;

wire  [WIDTH_CLK_CNT-1:0] nxt_clk_cnt ;
wire  [WIDTH_BIT_CNT-1:0] nxt_bit_cnt ;
wire  [3:0]               nxt_rxd_dly ;
wire                      nxt_rx_en   ;
wire  [WIDTH_DATA+1:0]    nxt_rx_buf  ;
wire                      nxt_rx_end  ;

wire                      neg_rxd     ;

always@(posedge clk or negedge rst_n)begin
  if(~rst_n)begin
    clk_cnt <= { WIDTH_CLK_CNT{1'b0}} ;
    bit_cnt <= { WIDTH_BIT_CNT{1'b0}} ;
    rxd_dly <= { 4{1'b0}}             ;
    rx_en   <=  1'b0                  ;
    rx_end  <=  1'b0                  ;
    rx_buf  <= {(WIDTH_DATA+2){1'b0}} ;
  end
  else begin
    clk_cnt <= nxt_clk_cnt  ;
    bit_cnt <= nxt_bit_cnt  ;
    rxd_dly <= nxt_rxd_dly  ;
    rx_en   <= nxt_rx_en    ;
    rx_end  <= nxt_rx_end   ;
    rx_buf  <= nxt_rx_buf   ;
  end
end 

assign neg_rxd     = ~rxd_dly[2] &  rxd_dly[3];

//assign nxt_rxd_dly = ~rx_en ? {rxd_dly[2:0],i_rxd}:
//                              {4{1'b0}};
assign nxt_rxd_dly = {rxd_dly[2:0],i_rxd};
assign nxt_clk_cnt = 
~rx_en                ? { WIDTH_CLK_CNT{1'b0}}  :
clk_cnt == BUAD_CNT-1 ? { WIDTH_CLK_CNT{1'b0}}  :
                          clk_cnt+1'b1          ;

assign nxt_bit_cnt = 
~rx_en                ? { WIDTH_BIT_CNT{1'b0}}  :
clk_cnt == BUAD_CNT-1 ? bit_cnt+1'b1            :
bit_cnt;

assign nxt_rx_en = 
neg_rxd ? 1'b1:
(bit_cnt == WIDTH_DATA+1)&(clk_cnt == BUAD_CNT-1)? 1'b0:
rx_en;

assign nxt_rx_buf = 
clk_cnt == BUAD_CNT>>1 ? {rxd_dly[3],rx_buf[WIDTH_DATA+1:1]}:
rx_buf;

assign nxt_rx_end = 
(bit_cnt == WIDTH_DATA+1)
&(clk_cnt == BUAD_CNT-1)
&(~rx_buf[0])
&(rx_buf[WIDTH_DATA+1])?  1'b1:
                          1'b0;

assign o_rx_end = rx_end;
assign o_rx_data = rx_buf[WIDTH_DATA:1];

endmodule
