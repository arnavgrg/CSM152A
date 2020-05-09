`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Arnav Garg
// 
// Create Date:    01:39:34 05/09/2020 
// Design Name: 
// Module Name:    clock_div_twenty_eight 
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
module clock_div_twenty_eight(
		clk_in, 
		rst, 
		clk_div_28
	);
	
	input clk_in, rst;
	output reg clk_div_28;
	
	reg [3:0] a = 4'b0000;
	
	initial
	begin
		clk_div_28 = 1'b0;
	end
	
	always@(posedge clk_in, posedge rst)
	begin
		if(rst)
			a <= 4'b0000;
		else
			a <= a + 1'b1;
			if(a[0] == 1'b0 && a[1] == 1'b1 &&
				a[2] == 1'b1 && a[3] == 1'b1)
				begin
					clk_div_28 <= ~clk_div_28;
					a <= 4'b0000;
				end
	end

endmodule
