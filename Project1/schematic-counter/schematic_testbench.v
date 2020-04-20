module schematic_testbench;

	// Inputs
	reg clk;
	reg reset;
	reg d0;
	reg d1;
	reg d2;
	reg d3;

	// Outputs
	wire [3:0] result;

	// Instantiate the Unit Under Test (UUT)
	schematic_counter uut (
		.clk(clk), 
		.reset(reset), 
		.d0(d0), 
		.d1(d1), 
		.d2(d2), 
		.d3(d3), 
		.result(result)
	);
	
	initial
	begin
		reset = 0;
		d0 = 0;
		d1 = 0;
		d2 = 0;
		d3 = 0;
	end
	
	always 
	begin
    clk = 1'b1; 
    #10; // high for 20 * timescale = 20 ns

    clk = 1'b0;
    #10; // low for 20 * timescale = 20 ns
	end
	
	always @(posedge clk)
	begin		
		#30;
		$display("Counter=%b%b%b%b", d3, d2, d1, d0);
		d0 = result[0];
		d1 = result[1];
		d2 = result[2];
		d3 = result[3];
	end
      
endmodule