`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   02:04:22 05/09/2020
// Design Name:   clock_div_two
// Module Name:   /home/ise/Project3/task_one_testbench.v
// Project Name:  Project3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: clock_div_two
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module task_one_testbench;

	// Inputs
	reg clk_in;
	reg rst;

	// Outputs
	wire clk_div_2;
	wire clk_div_4;
	wire clk_div_8;
	wire clk_div_16;

	// Instantiate the Unit Under Test (UUT)
	clock_div_two uut (
		.clk_in(clk_in), 
		.rst(rst), 
		.clk_div_2(clk_div_2), 
		.clk_div_4(clk_div_4), 
		.clk_div_8(clk_div_8), 
		.clk_div_16(clk_div_16)
	);

	initial 
	begin
		// Initial reset to 0
		rst = 0;
	end
	
	always
	begin
		clk_in = 1'b1;
		#10;
		
		clk_in = 1'b0;
		#10;
	end
	
	always@(posedge clk_in, posedge rst)
	begin
		#10;
		$display("clk_div_2=%b, clk_div_4=%b, clk_div_8=%b; clk_div_16=%b", clk_div_2, clk_div_4, clk_div_8, clk_div_16);
   end
	  
endmodule