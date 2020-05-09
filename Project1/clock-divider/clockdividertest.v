`timescale 100000ns / 100ns

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Arnav Garg
//
// Create Date:   06:59:52 04/23/2020
// Design Name:   clockdivider
// Module Name:   /home/ise/project1clockdidiver/clockdividertest.v
// Project Name:  project1clockdidiver
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: clockdivider
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module clockdividertest;

	// Inputs
	reg clk;
	reg rst;

	// Outputs
	wire clk_div;

	// Instantiate the Unit Under Test (UUT)
	clockdivider uut (
		.clk(clk), 
		.rst(rst), 
		.clk_div(clk_div)
	);
	
	initial
	begin
		rst = 1;
		#1
		rst = 0;
	end
	
	always 
	begin
    	clk = 1'b1; 
    	#0.5;

    	clk = 1'b0;
    	#0.5;
	end
	
	always @(posedge clk, posedge rst)
	begin
		$display("Counter=%b", clk_div);
	end
      
endmodule

