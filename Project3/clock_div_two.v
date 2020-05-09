`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Arnav Garg
// 
// Create Date:    01:39:12 05/09/2020 
// Design Name: 
// Module Name:    clock_div_two 
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
module clock_div_two(
		clk_in, 
		rst, 
		clk_div_2, 
		clk_div_4, 
		clk_div_8, 
		clk_div_16
	);
	
	input wire clk_in, rst;
	output reg clk_div_2, clk_div_4, clk_div_8, clk_div_16;
	
	reg [3:0] a = 4'b0000;
	
	always@(posedge clk_in, posedge rst)
	begin
		if (rst)
			a <= 4'b0000;
		else
			// clk_div_2
			if (a[0] == 1'b1)
				clk_div_2 <= 1'b1;
			else 
				clk_div_2 <= 1'b0;
				
			// clk_div_4
			if (a[1] == 1'b1)
				clk_div_4 <= 1'b1;
			else 
				clk_div_4 <= 1'b0;
				
			// clk_div_8
			if (a[2] == 1'b1)
				clk_div_8 <= 1'b1;
			else 
				clk_div_8 <= 1'b0;
				
			// clk_div_16
			if (a[3] == 1'b1)
				clk_div_16 <= 1'b1;
			else 
				clk_div_16 <= 1'b0;
			
			a <= a + 1'b1;
	end

endmodule
