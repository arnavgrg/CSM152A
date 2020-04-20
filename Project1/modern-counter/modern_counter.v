`timescale 1ns / 1ps

module modern_counter(
		clk, reset, a
    );

	input wire clk, reset;
	output reg [3:0] a;
	
	initial
	begin
		a[0] = 0;
		a[1] = 0;
		a[2] = 0;
		a[3] = 0;
		#1;
	end
	
	always@(posedge clk, posedge reset)
	begin
		if (reset)
			a <= 4'b0000;
		else
			a <= a + 1'b1;
	end

endmodule