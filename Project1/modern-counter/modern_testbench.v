`timescale 1ns / 1ps

module modern_testbench;

	// Inputs
	reg clk;
	reg reset;

	// Outputs
	wire [3:0] a;

	// Instantiate the Unit Under Test (UUT)
	modern_counter uut (
		.clk(clk), 
		.reset(reset), 
		.a(a)
	);
	
	initial 
	begin
		// Initialize Inputs
		reset = 0;
	end

	always
	begin
		clk = 1'b1; 
    	#10; // high for 20 * timescale = 20 ns

    	clk = 1'b0;
    	#10; // low for 20 * timescale = 20 ns
	end
	
	always @(posedge clk, posedge reset)
	begin
		#10;
		$display("Counter=%b", a);
	end
      
endmodule