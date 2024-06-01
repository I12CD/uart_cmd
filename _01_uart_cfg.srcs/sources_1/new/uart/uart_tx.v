
module uart_tx#
(
parameter CLK_FREQ    = 4_000_000   ,   //equal 4MHz
parameter BUAD_RATE   = 115200      ,
parameter WIDTH_DATA  = 8            
)
(
  input			                      clk       ,
  input                           rst_n     ,
  input                           i_start   ,
  input         [WIDTH_DATA-1:0]  i_data    ,
  output                          o_txd     
  
);
localparam BUAD_CNT  = CLK_FREQ/BUAD_RATE;         
localparam WIDTH_CLK_CNT = 16;
localparam WIDTH_BIT_CNT = 4; 

reg   [WIDTH_CLK_CNT-1:0] clk_cnt     ;
reg   [WIDTH_BIT_CNT-1:0] bit_cnt     ;
reg                       tx_en       ;
reg                       txd         ;

wire  [WIDTH_CLK_CNT-1:0] nxt_clk_cnt ;
wire  [WIDTH_BIT_CNT-1:0] nxt_bit_cnt ;
wire                      nxt_tx_en   ;
wire                      nxt_txd     ;

always@(posedge clk or negedge rst_n)begin
  if(~rst_n)begin
    clk_cnt <= { WIDTH_CLK_CNT{1'b0}} ;
    bit_cnt <= { WIDTH_BIT_CNT{1'b0}} ;
    tx_en   <=  1'b0                  ;
    txd     <=  1'b1                  ;
  end
  else begin
    clk_cnt <= nxt_clk_cnt  ;
    bit_cnt <= nxt_bit_cnt  ;
    tx_en   <= nxt_tx_en    ;
    txd     <= nxt_txd      ;
  end
end 

assign nxt_tx_en = 
i_start ? 1'b1:
(clk_cnt==BUAD_CNT-1)&(bit_cnt==WIDTH_DATA+1)? 1'b0:
tx_en;

assign nxt_clk_cnt = 
~tx_en              ? { WIDTH_CLK_CNT{1'b0}}:
clk_cnt==BUAD_CNT-1 ? { WIDTH_CLK_CNT{1'b0}}:
                       clk_cnt+1'b1         ;

assign nxt_bit_cnt = 
~tx_en                ? { WIDTH_BIT_CNT{1'b0}}  :
clk_cnt == BUAD_CNT-1 ? bit_cnt+1'b1            :
bit_cnt;

assign nxt_txd = 
i_start ? 1'b0:
(bit_cnt<WIDTH_DATA)&(clk_cnt == BUAD_CNT-1)? i_data[bit_cnt]:
(bit_cnt==WIDTH_DATA)&(clk_cnt == BUAD_CNT-1)? 1'b1:
txd;

assign o_txd = txd;

endmodule	