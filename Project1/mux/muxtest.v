`timescale 1ns / 1ps

module muxtest;

	// Inputs
	reg sw0;
	reg sw1;
	reg [2:0] select;

	// Outputs
	wire out;

	// Instantiate the Unit Under Test (UUT)
	mux uut (
		.sw0(sw0), 
		.sw1(sw1), 
		.select(select), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		sw0 = 0;
		sw1 = 0;
		select = 3'b000;
		#100;
		
		//Not
		$display("Test: Not; sw0=%b, sw1=%b, sel=%b, out=%b",sw0,sw1,select, out);
		sw0 = 1;
		#100;
		$display("Test: Not; sw0=%b, sw1=%b, sel=%b, out=%b",sw0,sw1,select, out);

		//Buff
		sw0 = 0;
		select = 3'b001;
		#100;
		$display("Test: Buf; sw0=%b, sw1=%b, sel=%b, out=%b",sw0,sw1,select, out);
		
		sw0 = 1;
		#100;
		$display("Test: Buf; sw0=%b, sw1=%b, sel=%b, out=%b",sw0,sw1,select, out);
        
		//Xnor
		sw0 = 0;
		sw1 = 0;
		select = 3'b010;
		#100;
		$display("Test: XNOR; sw0=%b, sw1=%b, sel=%b, out=%b",sw0,sw1,select, out);
		
		sw1 = 1;
		#100;
		$display("Test: XNOR; sw0=%b, sw1=%b, sel=%b, out=%b",sw0,sw1,select, out);
		
		sw0 = 1;
		#100;
		$display("Test: XNOR; sw0=%b, sw1=%b, sel=%b, out=%b",sw0,sw1,select, out);
		
		sw1 = 0;
		#100;
		$display("Test: XNOR; sw0=%b, sw1=%b, sel=%b, out=%b",sw0,sw1,select, out);

		
	end
      
endmodule

