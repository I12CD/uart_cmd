`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/20 21:41:05
// Design Name: 
// Module Name: clk_div
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


module clk_div 
#(
    parameter   DivWidth = 4
)
(
    input     [DivWidth-1:0]          i_DivFac      ,
    input                             i_div_en      ,
    input                             i_clk         ,
    input                             rst_n         ,
    output                            o_clk          
    );
    
    reg   [DivWidth-1:0]    clk_cnt     ;
    wire  [DivWidth-1:0]    clk_cnt_nxt ;
    reg                     clk_div     ;
    wire                    o_clk_nxt   ;
    wire                    pos_div_en  ;
    reg   [DivWidth-1:0]    div_value   ;

get_edge#(
.DELAY  (3)
)
edge_div_en(
.clk        (i_clk       ),
.rst_n      (rst_n       ),
.i_sig      (i_div_en    ),
.o_pos_sig  (pos_div_en  ),
.o_neg_sig  (            ) 
);
    
    always@(posedge i_clk or negedge rst_n)begin
      if(~rst_n)begin
        clk_cnt   <=  {DivWidth{1'b0}}  ;
        clk_div   <=  1'b0              ;
      end
      else begin
        clk_cnt   <= #1 clk_cnt_nxt   ;
        clk_div   <= #1 o_clk_nxt     ;
      end
    end
    
    assign  clk_cnt_nxt = (clk_cnt==i_DivFac-1) ? {DivWidth{1'b0}} : clk_cnt+1'b1;
    assign  o_clk_nxt   = ~(clk_cnt <i_DivFac>>1) ;
    
   BUFH BUFH_inst (
       .O(o_clk), // 1-bit output: Clock output
       .I(clk_div)  // 1-bit input: Clock input
    );    
    
endmodule
