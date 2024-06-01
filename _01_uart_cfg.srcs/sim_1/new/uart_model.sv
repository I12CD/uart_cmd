`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/20 22:25:39
// Design Name: 
// Module Name: uart_model
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


module uart_model(
    output    reg         tdo         ,
    output    reg         snd_ok      , 
    input           [7:0] data        ,
    input                 snd_en    
    );
    
    parameter   BAUDRATE = 115200;
    integer		bit_num;
	
	initial	begin
		tdo		=	1'b1;
		snd_ok	=	1'b0;
		
		while(1)begin
			@(posedge snd_en);
			tdo	=	1'b0;
			for(bit_num=0;bit_num<8;bit_num=bit_num+1)begin
				#(1_000_000_000/BAUDRATE);
				tdo	=	data[bit_num];
			end
			#(1_000_000_000/BAUDRATE)	tdo	=	1'b1;
			snd_ok	=	1'b1;
			#5_000	snd_ok	=	1'b0;
		end
	end
	
    
endmodule
