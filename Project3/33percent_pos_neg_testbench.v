`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Arnav Garg
//
// Create Date:   03:55:35 05/09/2020
// Design Name:   clock_div_five
// Module Name:   /home/ise/Project3/task_three_testbench.v
// Project Name:  Project3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: clock_div_five
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module task_three_testbench;

	// Inputs
	reg clk_in;
	reg rst;

	// Outputs
	wire [1:0] clk_div_5;

	// Instantiate the Unit Under Test (UUT)
	clock_div_five uut (
		.clk_in(clk_in), 
		.rst(rst), 
		.clk_div_5(clk_div_5)
	);

	initial 
	begin
		// Initial reset to 0
		//#10 rst = 1'b1;
		rst = 1'b1;
		rst = 1'b0;
	end
	
	always
	begin
		clk_in = 1'b1;
		#15;
		
		clk_in = 1'b0;
		#15;
	end
	
	always@(posedge clk_in, posedge rst)
	begin
		#15;
		$display("clk_div_5_pos=%b", clk_div_5[0]);
   end
	
	always@(negedge clk_in, posedge rst)
	begin
		#15;
		$display("clk_div_5_neg=%b", clk_div_5[1]);
   end
      
endmodule