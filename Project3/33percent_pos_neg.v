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
	output reg [1:0] clk_div_5 = {1'b0, 1'b0};
	
	reg [1:0] a = 2'b00;
	reg [1:0] b = 2'b00;
	
	always@(posedge clk_in, posedge rst)
	begin
		if (rst)
			a <= 2'b00;
		else if (a == 2'b10)
		begin
			a <= 2'b00;
			clk_div_5[0] <= ~clk_div_5[0];
		end
		else
		begin
			a <= a + 1'b1;
			clk_div_5[0] <= 1'b0;
		end
	end
	
	always@(negedge clk_in, posedge rst)
	begin
		if (rst)
			b <= 2'b00;
		else if (b == 2'b10)
		begin
			b <= 2'b00;
			clk_div_5[1] <= ~clk_div_5[1];
		end
		else
		begin
			b <= b + 1'b1;
			clk_div_5[1] <= 1'b0;
		end
	end

endmodule