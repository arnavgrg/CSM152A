`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   04:59:24 05/25/2020
// Design Name:   vending_machine
// Module Name:   /home/ise/Project4V2/testbench_304911796.v
// Project Name:  Project4V2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: vending_machine
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
	reg CLK;
	reg RESET;
	reg RELOAD;
	reg CARD_IN;
	reg [3:0] ITEM_CODE;
	reg KEY_PRESS;
	reg VALID_TRAN;
	reg DOOR_OPEN;

	// Outputs
	wire VEND;
	wire INVALID_SEL;
	wire [2:0] COST;
	wire FAILED_TRAN;

	// Instantiate the Unit Under Test (UUT)
	vending_machine uut (
		.CLK(CLK), 
		.RESET(RESET), 
		.RELOAD(RELOAD), 
		.CARD_IN(CARD_IN), 
		.ITEM_CODE(ITEM_CODE), 
		.KEY_PRESS(KEY_PRESS), 
		.VALID_TRAN(VALID_TRAN), 
		.DOOR_OPEN(DOOR_OPEN), 
		.VEND(VEND), 
		.INVALID_SEL(INVALID_SEL), 
		.COST(COST), 
		.FAILED_TRAN(FAILED_TRAN)
	);
    
initial begin
		// Initialize Inputs
		CARD_IN = 0;
		VALID_TRAN = 0;
		ITEM_CODE = 0;
		KEY_PRESS = 0;
		DOOR_OPEN = 0;
		RELOAD = 0;
		CLK = 0;

		RESET = 1;
		#10;
		RESET = 0;
		
		// Normal Transaction
		CARD_IN = @(negedge CLK) 1;
		CARD_IN = @(negedge CLK) 0;
		KEY_PRESS = @(negedge CLK)1;
		ITEM_CODE = 1;
		KEY_PRESS = @(negedge CLK)0;
		#2;
		$display("Vend=%d, Cost=%d, Invalid_sel=%d, Failed_tran=%d", VEND, COST, INVALID_SEL, FAILED_TRAN);
		KEY_PRESS = @(negedge CLK)1;
		ITEM_CODE = 3;
		KEY_PRESS = @(negedge CLK)0;
		VALID_TRAN = @(negedge CLK)1;
		DOOR_OPEN = @(negedge CLK)1;
		DOOR_OPEN = @(negedge CLK)0;
      $display("Vend=%d, Cost=%d, Invalid_sel=%d, Failed_tran=%d", VEND, COST, INVALID_SEL, FAILED_TRAN);
		
		// Incorrect item code / non-valid item code
		#10;
		CARD_IN = @(negedge CLK) 1;
		CARD_IN = @(negedge CLK) 0;
		KEY_PRESS = @(negedge CLK)1;
		ITEM_CODE = 4;
		KEY_PRESS = @(negedge CLK)0;
		#2;
		KEY_PRESS = @(negedge CLK)1;
		ITEM_CODE = 2;
		KEY_PRESS = @(negedge CLK)0;
		VALID_TRAN = @(negedge CLK)1;
		DOOR_OPEN = @(negedge CLK)1;
		DOOR_OPEN = @(negedge CLK)0;
		
	end
	always 
		#1 CLK = ~CLK;

endmodule