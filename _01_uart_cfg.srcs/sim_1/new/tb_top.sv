`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/20 22:13:50
// Design Name: 
// Module Name: tb_top
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


module tb_top();

reg   clk_100M  ;
reg   rst_n     ;
wire  tdo		;
reg	  [7:0]	data  	;
reg			snd_en	;

top top_inst(
    .clk     (clk_100M  ),            
    .rst_n   (rst_n     ),          
    .RX      (tdo		),           
    .TX      ()
    );

uart_model	uart_inst(
    .tdo         (tdo		),
    .snd_ok      (			),
    .data        (data  	),
    .snd_en      (snd_en	)
    );	
	
initial begin
  clk_100M = 1'b0;
  forever
  #10 clk_100M = ~clk_100M;
end

initial begin
  rst_n   = 1'b0;
  snd_en  = 1'b0;
  #150_000
  rst_n   = 1'b1;
  
  #200_000	data 	= 8'h55	;
  #100		snd_en 	= 1'b1	;
  #100		snd_en	= 1'b0	;
  
end


endmodule
