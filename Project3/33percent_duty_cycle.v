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
	output reg clk_div_5 = 1'b0;
	
	reg [1:0] a = 2'b00;
	
	always@(posedge clk_in, posedge rst)
	begin
		if (rst)
			a <= 2'b00;
		else if (a == 2'b10)
		begin
			a <= 2'b00;
			clk_div_5 <= ~clk_div_5; //functions like a t flip-flop
		end
		else
			a <= a + 1'b1;
	end

endmodule