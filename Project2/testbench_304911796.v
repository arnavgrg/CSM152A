`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Arnav Garg
//
// Create Date:   00:17:07 05/02/2020
// Design Name:   FPCVT
// Module Name:   /home/ise/Project2/testbench_304911796.v
// Project Name:  Project2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FPCVT
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
	reg [12:0] D;

	// Outputs
	wire S;
	wire [2:0] E;
	wire [4:0] F;

	// Instantiate the Unit Under Test (UUT)
	FPCVT uut (
		.D(D), 
		.S(S), 
		.E(E), 
		.F(F)
	);
	
	initial begin
		  // -1
        D = 13'b1111111111111;
        #10;
		  $display("D=%01B%04B%04B%04B [-1], S=%B, E=%B, F=%B, V=%D", D[12], D[11:8], D[7:4], D[3:0], S, E, F, $signed(((-1**(S))*F*(2**(E)))));
        
		  // 0
        D = 0;
        #10;
		  $display("D=%01B%04B%04B%04B [0], S=%B, E=%B, F=%B, V=%D", D[12], D[11:8], D[7:4], D[3:0], S, E, F, $signed(((-1**(S))*F*(2**(E)))));
        
		  // > 8 leading zeros
        D = 13'b000000000100;
        #10;
		  $display("D=%01B%04B%04B%04B [4], S=%B, E=%B, F=%B, V=%D", D[12], D[11:8], D[7:4], D[3:0], S, E, F, $signed(((-1**(S))*F*(2**(E)))));
        
		  // 16 ; 8 leading zeros
        D = 13'b0000000010000;
        #10;
		  $display("D=%01B%04B%04B%04B [16], S=%B, E=%B, F=%B, V=%D", D[12], D[11:8], D[7:4], D[3:0], S, E, F, $signed(((-1**(S))*F*(2**(E)))));
        
		  // 55 (7 leading zeros)
        D = 13'b0000000110111;
        #10;
		  $display("D=%01B%04B%04B%04B [55], S=%B, E=%B, F=%B, V=%D", D[12], D[11:8], D[7:4], D[3:0], S, E, F, $signed(((-1**(S))*F*(2**(E)))));
		  
		  // 1008 (3 leading zeros. 6th bit = 1, F = 11111) Round up
        D = 13'b0001111110000;
        #10;
		  $display("D=%01B%04B%04B%04B [1008], S=%B, E=%B, F=%B, V=%D", D[12], D[11:8], D[7:4], D[3:0], S, E, F, $signed(((-1**(S))*F*(2**(E)))));
		  
		  // 992 (3 leading zeros. 6th bit = 0, F = 11111) Round down
        D = 13'b0001111100000;
        #10;
		  $display("D=%01B%04B%04B%04B [992], S=%B, E=%B, F=%B, V=%D", D[12], D[11:8], D[7:4], D[3:0], S, E, F, $signed(((-1**(S))*F*(2**(E)))));
		  
		  // -2730
        D = 13'b1010101010101;
        #10;
		  $display("D=%01B%04B%04B%04B [-2730], S=%B, E=%B, F=%B, V=%D", D[12], D[11:8], D[7:4], D[3:0], S, E, F, $signed(((-1**(S))*F*(2**(E)))));
		  
		  // 2730
        D = 13'b0101010101010;
        #10;
		  $display("D=%01B%04B%04B%04B [2730], S=%B, E=%B, F=%B, V=%D", D[12], D[11:8], D[7:4], D[3:0], S, E, F, $signed(((-1**(S))*F*(2**(E)))));
		  
		  // 3640
        D = 13'b0111000111000;
        #10;
		  $display("D=%01B%04B%04B%04B [3640], S=%B, E=%B, F=%B, V=%D", D[12], D[11:8], D[7:4], D[3:0], S, E, F, $signed(((-1**(S))*F*(2**(E)))));
		  
		  // 253
		  D = 13'b0000011111101;
		  #10;
		  $display("D=%01B%04B%04B%04B [253], S=%B, E=%B, F=%B, V=%D", D[12], D[11:8], D[7:4], D[3:0], S, E, F, $signed(((-1**(S))*F*(2**(E)))));
		  
		  // 422
        D = 13'b0000110100110;
        #10;
		  $display("D=%01B%04B%04B%04B [422], S=%B, E=%B, F=%B, V=%D", D[12], D[11:8], D[7:4], D[3:0], S, E, F, $signed(((-1**(S))*F*(2**(E)))));
		  
		  // -422
        D = 13'b1111001011010;
        #10;
		  $display("D=%01B%04B%04B%04B [-422], S=%B, E=%B, F=%B, V=%D", D[12], D[11:8], D[7:4], D[3:0], S, E, F, $signed(((-1**(S))*F*(2**(E)))));
		  
		  // 4095
        D = 13'b0111111111111;
        #10;
		  $display("D=%01B%04B%04B%04B [4095], S=%B, E=%B, F=%B, V=%D", D[12], D[11:8], D[7:4], D[3:0], S, E, F, $signed(((-1**(S))*F*(2**(E)))));
		  
		  // -4095
        D = 13'b1000000000001;
        #10;
		  $display("D=%01B%04B%04B%04B [-4095], S=%B, E=%B, F=%B, V=%D", D[12], D[11:8], D[7:4], D[3:0], S, E, F, $signed(((-1**(S))*F*(2**(E)))));
		  
		  // -4096
        D = 13'b1000000000000;
        #10;
		  $display("D=%01B%04B%04B%04B [-4096], S=%B, E=%B, F=%B, V=%D", D[12], D[11:8], D[7:4], D[3:0], S, E, F, $signed(((-1**(S))*F*(2**(E)))));
        
	end
      
endmodule