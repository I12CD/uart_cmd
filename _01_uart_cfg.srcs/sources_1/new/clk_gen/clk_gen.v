
module clk_gen(
input  clk      ,
input  rst_n    ,
output o_clk_4M  
);

wire  locked  ;
wire  clk_sys ;

clk_wiz_0 pll_inst
 (
  .clk_sys  (clk_sys  ),  //80M
  .locked   (locked   ),
  .clk_in1  (clk      )
 );

 clk_div#(
    .DivWidth (5)
) clk_4M_gen
  (
      .i_DivFac(5'd20    ),
      .i_div_en(1'b1     ),
      .i_clk   (clk_sys  ),
      .rst_n   (rst_n    ),
      .o_clk   (o_clk_4M )
 );

endmodule