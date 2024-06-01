module get_edge#(
parameter  DELAY = 3
)
(
input      clk        ,
input      rst_n      ,
input      i_sig      ,
output     o_pos_sig  ,
output     o_neg_sig   
);

reg [DELAY-1:0]sig_dly;
always@(posedge clk or negedge rst_n)begin
  if(~rst_n)
    sig_dly <= { DELAY{1'b0} };
  else
    sig_dly <= { sig_dly[DELAY-2:0] , i_sig };
end

assign o_pos_sig =  sig_dly[DELAY-2] & ~sig_dly[DELAY-1];
assign o_neg_sig = ~sig_dly[DELAY-2] &  sig_dly[DELAY-1];

endmodule