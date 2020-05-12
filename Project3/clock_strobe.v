`timescale 1ns / 1ps
module clock_strobe (
		clk_in, 
		rst, 
		glitchy_counter
	);
	
	input wire clk_in, rst;
	output reg [7:0] glitchy_counter = 8'b0;

	wire clk_div_2;
	wire clk_div_4;
	wire clk_div_8;
	wire clk_div_16;

	clock_div_two clk2 (
		.clk_in(clk_in), 
		.rst(rst), 
		.clk_div_2(clk_div_2), 
		.clk_div_4(clk_div_4), 
		.clk_div_8(clk_div_8), 
		.clk_div_16(clk_div_16)
	);
	
	reg clk_prev = 1'b0;
	
	always@(posedge clk_in)
	begin
		if (rst)
			glitchy_counter <= 0;
		else if (clk_div_4 != clk_prev && clk_div_4)
			glitchy_counter <= glitchy_counter - 3'b101;
		else
			glitchy_counter <= glitchy_counter + 2'b10;
		clk_prev = clk_div_4;
	end

endmodule
