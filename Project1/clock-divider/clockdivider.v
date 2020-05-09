`timescale 1ms / 1us
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Arnav Garg
// 
// Create Date:    06:26:56 04/23/2020 
// Design Name: 
// Module Name:    clockdivider 
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
module clockdivider(
		clk,
		rst,
		clk_div
    );
	
	input clk, rst;
	output reg clk_div;
	
	localparam constNum = 5000;
	
	reg[12:0] counter;
	
	 initial
    begin
		clk_div = 0;
    end
	
	always@(posedge clk, posedge rst)
	begin
		if (rst == 1'b1)
		begin
			counter <= 13'b0;
			clk_div <= 1'b0;
		end
		else if (counter == constNum-1)
		begin
			counter <= 13'b0;
			clk_div <= ~clk_div;
		end
		else
		begin
			counter <= counter + 1;
			clk_div <= clk_div;
		end
	end

endmodule
