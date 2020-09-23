`timescale 100000ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Arnav Garg
//
// Create Date:   
// Design Name:   parking_meter
// Module Name:   /home/ise/Project5/testbench_304911796.v
// Project Name:  Project5
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: parking_meter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testbench_304911796;

	// Inputs
	reg add1;
	reg add2;
	reg add3;
	reg add4;
	reg rst1;
	reg rst2;
	reg clk;
	reg rst;

	// Outputs
	wire [6:0] led_seg;
	wire [3:0] val1;
	wire [3:0] val2;
	wire [3:0] val3;
	wire [3:0] val4;
	wire a1;
	wire a2;
	wire a3;
	wire a4;

	// Instantiate the Unit Under Test (UUT)
	parking_meter uut (
		.add1(add1), 
		.add2(add2), 
		.add3(add3), 
		.add4(add4), 
		.rst1(rst1), 
		.rst2(rst2), 
		.clk(clk), 
		.rst(rst), 
		.led_seg(led_seg), 
		.val1(val1), 
		.val2(val2), 
		.val3(val3), 
		.val4(val4), 
		.a1(a1), 
		.a2(a2), 
		.a3(a3), 
		.a4(a4)
	);
			
		initial begin 
			forever #50 clk = ~clk;
		end

		initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		add1 = 0;
		add2 = 0;
		add3 = 0;
		add4 = 0;
		rst1 = 0;
		rst2 = 0;

		// Wait for entire clock cycle for all outputs to initialize
		#100;
      rst = 0;

		$monitor("remaining time=%d %d %d %d", val1, val2, val3, val4);
		 
	   add1 = 1;
		#100;
		add1 = 0;
		#100000;
		add2 = 1;
		#100;
		add2 = 0;
		#100000;
		add3 = 1;
		#100;
		add3 = 0;
      #100000;
		rst1 = 1;
      #100;
      rst1 = 0;
		#50000;
		add4 = 1;
		#100;
		add4 = 0;
		#100000;
		rst2 = 1;
		#100;
		rst2 = 0;
		#100000;
	end
      
endmodule