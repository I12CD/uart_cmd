
module top(
input           clk     ,
input           rst_n   ,
input           RX      ,
output          TX       
);


wire [7:0]data_rcv   ;
wire      rcv_ok     ;
wire [7:0]data_out   ;
wire      snd_start  ;
wire      clk_4M     ;
clk_gen  clk_gen_inst(
.clk      (clk),
.rst_n    (rst_n),
.o_clk_4M (clk_4M) 
);

 

 
uart_top uart_top_inst(
.clk         (clk_4M       ),
.rst_n       (rst_n        ),
.o_rx_data   (data_rcv     ),
.o_rx_end    (rcv_ok       ),
.i_tx_data   (data_out     ),
.i_tx_start  (snd_start    ),
.RX          (RX           ),
.TX          (TX           )
);

cmd_PU cmd_PU_inst(
.i_data_rcv   (data_rcv    ),
.i_rcv_ok     (rcv_ok      ),
.o_data_out   (data_out    ),
.o_snd_start  (snd_start   ),
.clk          (clk_4M      ),
.rst_n        (rst_n       )
    );


endmodule