`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:02:56 05/24/2020
// Design Name:   vending_machine
// Module Name:   /home/ise/xlinkproj/vendingmachine/testbench_004933460.v
// Project Name:  vendingmachine
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

module testbench_004933460;

	// Inputs
	reg CARD_IN;
	reg VALID_TRAN;
	reg [3:0] ITEM_CODE;
	reg KEY_PRESS;
	reg DOOR_OPEN;
	reg RELOAD;
	reg CLK;
	reg RESET;

	// Outputs
	wire VEND;
	wire INVALID_SELL;
	wire FAILED_TRAN;
	wire [2:0] COST;

	// Instantiate the Unit Under Test (UUT)
	vending_machine uut (
		.CARD_IN(CARD_IN), 
		.VALID_TRAN(VALID_TRAN), 
		.ITEM_CODE(ITEM_CODE), 
		.KEY_PRESS(KEY_PRESS), 
		.DOOR_OPEN(DOOR_OPEN), 
		.RELOAD(RELOAD), 
		.CLK(CLK), 
		.RESET(RESET), 
		.VEND(VEND), 
		.INVALID_SELL(INVALID_SELL), 
		.FAILED_TRAN(FAILED_TRAN), 
		.COST(COST)
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

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		RESET = 0;
		
		//successful trial 
		CARD_IN = @(negedge CLK) 1;
		CARD_IN = @(negedge CLK) 0;
		KEY_PRESS = @(negedge CLK)1;
		ITEM_CODE = 0;
		KEY_PRESS = @(negedge CLK)0;
		#2;
		KEY_PRESS = @(negedge CLK)1;
		ITEM_CODE = 1;
		KEY_PRESS = @(negedge CLK)0;
		VALID_TRAN = @(negedge CLK)1;
		DOOR_OPEN = @(negedge CLK)1;
		DOOR_OPEN = @(negedge CLK)0;
		
		// reload and DOOR OPEN for 10ns, VEND becomes 0 only after
		#10;
		RELOAD = @(negedge CLK)1;
		RELOAD = @(negedge CLK)0;
		CARD_IN = @(negedge CLK) 1;
		CARD_IN = @(negedge CLK) 0;
		KEY_PRESS = @(negedge CLK)1;
		ITEM_CODE = 1;
		KEY_PRESS = @(negedge CLK)0;
		#2;
		KEY_PRESS = @(negedge CLK)1;
		ITEM_CODE = 1;
		KEY_PRESS = @(negedge CLK)0;
		VALID_TRAN = @(negedge CLK)1;
		DOOR_OPEN = @(negedge CLK)1;
		
		// VALID_TRAN = 0
		#10;
		DOOR_OPEN = @(negedge CLK)0;
		CARD_IN = @(negedge CLK) 1;
		CARD_IN = @(negedge CLK) 0;
		KEY_PRESS = @(negedge CLK)1;
		ITEM_CODE = 1;
		KEY_PRESS = @(negedge CLK)0;
		#2;
		KEY_PRESS = @(negedge CLK)1;
		ITEM_CODE = 9;
		KEY_PRESS = @(negedge CLK)0;
		VALID_TRAN = @(negedge CLK)0;
		DOOR_OPEN = @(negedge CLK)1;
		DOOR_OPEN = @(negedge CLK)0;
		
		// VALID_TRAN delayed 
		#10;
		CARD_IN = @(negedge CLK) 1;
		CARD_IN = @(negedge CLK) 0;
		KEY_PRESS = @(negedge CLK)1;
		ITEM_CODE = 1;
		KEY_PRESS = @(negedge CLK)0;
		#2;
		KEY_PRESS = @(negedge CLK)1;
		ITEM_CODE = 9;
		KEY_PRESS = @(negedge CLK)0;
		#4
		VALID_TRAN = @(negedge CLK)1;
		DOOR_OPEN = @(negedge CLK)1;
		DOOR_OPEN = @(negedge CLK)0;
		
		// wrong item_code
		#10;
		CARD_IN = @(negedge CLK) 1;
		CARD_IN = @(negedge CLK) 0;
		KEY_PRESS = @(negedge CLK)1;
		ITEM_CODE = 2;
		KEY_PRESS = @(negedge CLK)0;
		#2;
		KEY_PRESS = @(negedge CLK)1;
		ITEM_CODE = 1;
		KEY_PRESS = @(negedge CLK)0;
		VALID_TRAN = @(negedge CLK)1;
		DOOR_OPEN = @(negedge CLK)1;
		DOOR_OPEN = @(negedge CLK)0;
		
		// 
		#10;
		CARD_IN = @(negedge CLK) 1;
		CARD_IN = @(negedge CLK) 0;
		KEY_PRESS = @(negedge CLK)1;
		ITEM_CODE = 1;
		KEY_PRESS = @(negedge CLK)0;
		#14;
		KEY_PRESS = @(negedge CLK)1;
		ITEM_CODE = 1;
		KEY_PRESS = @(negedge CLK)0;
		VALID_TRAN = @(negedge CLK)1;
		DOOR_OPEN = @(negedge CLK)1;
		DOOR_OPEN = @(negedge CLK)0;
		
	end
	always 
		#1 CLK = ~CLK;
      
endmodule

