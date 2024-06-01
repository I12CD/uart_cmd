`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/17 18:35:22
// Design Name: 
// Module Name: uart_cfg
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


module uart_top(
    input           clk         ,
    input           rst_n       ,
    output  [7:0]   o_rx_data   ,
    output          o_rx_end    ,
    input   [7:0]   i_tx_data   ,
    input           i_tx_start  ,
    input           RX          ,
    output          TX          
    );
    
parameter  CLK_FREQ = 4_000_000           ;
parameter  UART_BPS = 115200              ;   


   uart_rx 
//    #(                          
//        .CLK_FREQ       (CLK_FREQ),
//        .UART_BPS       (UART_BPS)
//        )
    rx_inst(                 
        .clk            (clk    ), 
        .rst_n          (rst_n  ),    
        .i_rxd          (RX     ),
        .o_rx_end       (o_rx_end),
        .o_rx_data      (o_rx_data)
        ); 
    
    
    uart_tx
//    #(
//    .CLK_FREQ       (CLK_FREQ),
//    .UART_BPS       (UART_BPS)
//    )
    tx_inst(
    .clk             (clk  ),                  
    .rst_n           (rst_n),               
    .i_start         (i_tx_start),
    .i_data          (i_tx_data),
    .o_txd           (TX)
);
    
endmodule
