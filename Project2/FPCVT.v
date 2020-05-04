`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Arnav Garg
// 
// Create Date:    21:22:40 05/01/2020 
// Design Name: 
// Module Name:    FPCVT 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module FPCVT(
		D, S, E, F
    );

	 // wire [msb:lsb]
	 input [12:0] D;
	 output wire S; //Sign bit
	 output reg [2:0] E; //Exponent
	 output reg [4:0] F; //Significand/Mantissa
	 
	 // Register to manipulate bits for calculations
	 reg [12:0] data;
	 /* Register to track 6th bit following the last 
		 leading 0 to be used for rounding */
	 reg sixthbit;
	 
	 // D[12] is the most significant bit
	 assign S = D[12];
	 
	 always @(D)
	 begin
		
		// 1. If negative, we must invert the 2s complement format.
		if (D[12] == 1'b1)
			data = ~D[12:0] + 1'b1;
		else
			data = D[12:0];
		
		// 2. Match pattern to detect number of leading 0s in
		if (data[12:5] == 8'b0) // 8 or greater leading zeros
			begin 
				E = 3'b000;
				F = data[4:0];
				sixthbit = 1'b0; // No sixth bit, so set to 0
			end
		else if (data[12:6] == 7'b0) // 7 leading zeros
			begin 
				E = 3'b001;
				F = data[5:1];
				sixthbit = data[0];
			end
		else if (data[12:7] == 6'b0) // 6 leading zeros
			begin 
				E = 3'b010;
				F = data[6:2];
				sixthbit = data[1];
			end			
		else if (data[12:8] == 5'b0) // 5 leading zeros
			begin 
				E = 3'b011;
				F = data[7:3];
				sixthbit = data[2];
			end			
		else if (data[12:9] == 4'b0) // 4 leading zeros
			begin 
				E = 3'b100;
				F = data[8:4];
				sixthbit = data[3];
			end			
		else if (data[12:10] == 3'b0) // 3 leading zeros
			begin 
				E = 3'b101;
				F = data[9:5];
				sixthbit = data[4];
			end			
		else if (data[12:11] == 2'b0) // 2 leading zeros
			begin 
				E = 3'b110;
				F = data[10:6];
				sixthbit = data[5];
			end			
		else if (data[12] == 1'b0) // 1 leading zero
			begin 
				E = 3'b111;
				F = data[11:7];
				sixthbit = data[6];
			end
		else // No leading zeros: Only happens if input is -4096
			begin
				E = 3'b111;
				F = 5'b11111;
				sixthbit = 1'b1;
			end

	   // 3. Check for rounding based on value of sixthbit
		if (sixthbit == 1) //round up
			if (F == 5'b11111) //exceptional case for significand overflows
				begin
					F = 5'b10000; // divide significand by 2
					if (E == 3'b111) //detect exponent overflow
						F = 5'b11111; // create largest possible floating point representation
					else
						E = E + 1'b1; // add 1 to exponent to make up for the division by 2
				end
			else //for round up, just add 1 to significand
				F = F + 1'b1;
				
	 end

endmodule
