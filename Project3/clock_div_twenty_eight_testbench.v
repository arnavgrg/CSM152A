`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Arnav Garg
//
// Create Date:   02:25:19 05/09/2020
// Design Name:   clock_div_twenty_eight
// Module Name:   /home/ise/Project3/task_two_testbench.v
// Project Name:  Project3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: clock_div_twenty_eight
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module task_two_testbench;

	// Inputs
	reg clk_in;
	reg rst;

	// Outputs
	wire clk_div_28;

	// Instantiate the Unit Under Test (UUT)
	clock_div_twenty_eight uut (
		.clk_in(clk_in), 
		.rst(rst), 
		.clk_div_28(clk_div_28)
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
		$display("clk_div_28=%b", clk_div_28);
   end
      
endmodule

