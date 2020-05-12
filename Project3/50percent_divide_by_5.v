`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Arnav Garg
// 
// Create Date:    01:40:30 05/09/2020 
// Design Name: 
// Module Name:    clock_div_five 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
 module clock_div_five (
		clk_in, 
		rst, 
		clk_div_5
	);

	input clk_in, rst;
	output clk_div_5;
	
	reg [2:0] clk_pos = 3'b000;
	reg [2:0] clk_neg = 3'b000;
	
	always@(posedge clk_in, posedge rst)
	begin
		if (rst)
			clk_pos <= 3'b000;
		else if (clk_pos == 3'b100)
			clk_pos <= 3'b000;
		else
			clk_pos <= clk_pos + 1'b1;
	end
	
	always@(negedge clk_in, posedge rst)
	begin
		if (rst)
			clk_neg <= 3'b000;
		else if (clk_neg == 3'b100)
			clk_neg <= 3'b000;
		else
			clk_neg <= clk_neg + 1'b1;
	end
	
	assign clk_div_5 = ((clk_pos > 2'b10)|(clk_neg > 2'b10));

endmodule