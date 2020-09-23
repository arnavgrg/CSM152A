`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Arnav Garg
// 
// Create Date:    22:23:04 05/18/2020 
// Design Name: 
// Module Name:    vending_machine 
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
module vending_machine(
		input CLK,
		input RESET,
		input RELOAD,
		input CARD_IN,
		input [3:0] ITEM_CODE,
		input KEY_PRESS,
		input VALID_TRAN,
		input DOOR_OPEN,
		output reg VEND,
		output reg INVALID_SEL,
		output reg [2:0] COST,
		output reg FAILED_TRAN
    );
	 
	 parameter IDLE = 3'b001;
	 parameter TRANSACT = 3'b010;
	 parameter GET_CODE = 3'b011;
	 parameter TRANSACT_INTERMEDIATE = 3'b100;
	 parameter VENDING = 3'b101;
	 
	 reg [2:0] current_state;
	 reg [2:0] next_state;
	 
	 reg [2:0] costs [19:0];
	 reg [3:0] counts [19:0];
	 reg digits = 2'b00;
	 reg max_cycles = 3'b000;
	 reg selected_item = 5'b00000;
	 reg was_open = 1'b0;
	 
	 integer i;
	 
	 // initialize costs and counts
	 initial
	 begin
		// Initialize counts array
		for (i=0; i < 20; i = i+1)
		begin
			counts[i] = 4'b1010;
		end
		// Initialize costs array
		costs[0] = 3'b001;  costs[1] = 3'b001;  costs[2] = 3'b001;  costs[3] = 3'b001;
		costs[4] = 3'b010;  costs[5] = 3'b010;  costs[6] = 3'b010;  costs[7] = 3'b010;
		costs[8] = 3'b011;  costs[9] = 3'b011;  costs[10] = 3'b011; costs[11] = 3'b011;
		costs[12] = 3'b100; costs[13] = 3'b100; costs[14] = 3'b100; costs[15] = 3'b100;
		costs[16] = 3'b101; costs[17] = 3'b101; costs[18] = 3'b110; costs[19] = 3'b110;
		// Set initial state to IDLE
		current_state = IDLE;
		// Set default output values
		VEND = 1'b0;
		INVALID_SEL = 1'b0;
		COST = 3'b000;
		FAILED_TRAN = 1'b0;
		// Set next state to IDLE
		next_state = IDLE;
	 end
	 
	 // Always block to determine current_state
	 always@(posedge CLK)
	 begin
		if (RESET)
			begin
				for (i = 0; i < 20; i = i + 1)
				begin
					counts[i] <= 4'b0000;
				end
				current_state <= IDLE;
			end
		else
			current_state <= next_state;
		$display("current_state=%d, next_state=%d, digits=%d, max_cycles=%d, selected_item=%d, was_open=%d",
					current_state, next_state, digits, max_cycles, selected_item, was_open);
	 end
	 
	 // Always block to decide next_state
	 always@(*)
	 case(current_state)
		// Idle state
		IDLE :
			begin
			$display("Idle State");
			if (CARD_IN && RELOAD == 0 && RESET == 0)
				begin
					next_state <= TRANSACT;
				end
			else if (RELOAD)
				begin
					for (i=0; i < 20; i = i+1)
					begin
						counts[i] <= 4'b1010;
					end
				end
			end
		// Transact state
		TRANSACT :
			begin
				$display("Transact State");
				if (CARD_IN)
					next_state <= GET_CODE;
				if (selected_item >= 5'b00000 && 
				    selected_item <= 5'b10111 &&
					 counts[selected_item] > 4'b0000 && 
					 counts[selected_item] <= 4'b1010)
					next_state <= TRANSACT_INTERMEDIATE;
				else if (selected_item > 5'b10011 || counts[selected_item] == 0)
					next_state <= IDLE;
			end
		// Get Code
		GET_CODE :
			begin
				$display("Get_code State");
				if (KEY_PRESS)
					begin
						digits <= digits + 1'b0;
						if (digits == 2'b01)
							begin
								if (ITEM_CODE == 4'b0000)
									selected_item <= 5'b00000;
								else if (ITEM_CODE == 4'b0001)
									selected_item <= 5'b01010;
								else 
									next_state <= IDLE;
							end
						else if (digits == 2'b10)
							begin
								selected_item <= selected_item + ITEM_CODE;
								digits = 2'b00;
							end
					end
				else if (KEY_PRESS == 0 && CLK == 1 && max_cycles != 3'b101)
					max_cycles <= max_cycles + 1'b1;
				else if (digits != 2'b10 && max_cycles == 3'b101)
					begin
						max_cycles <= 3'b000;
						next_state <= IDLE;
					end
				else if (digits == 2'b10)
					begin
						max_cycles <= 3'b000;
						next_state <= TRANSACT;
					end
			end
		// Transact Stage II
		TRANSACT_INTERMEDIATE :
			begin
				$display("Transact_intermediate state");
				if (VALID_TRAN)
					begin
						max_cycles <= 3'b000;
						next_state <= VENDING;
						counts[selected_item] <= counts[selected_item] - 1'b1;
					end
				else if (VALID_TRAN == 0 && CLK && max_cycles != 3'b101)
					max_cycles <= max_cycles + 1'b1;
				else if (VALID_TRAN == 0 && max_cycles == 3'b101)
					begin
						max_cycles <= 3'b000;
						next_state <= IDLE;
					end
			end
		// VENDING
		VENDING :
			begin
				$display("vending state");
				if (DOOR_OPEN)
					was_open <= 1'b1;
				else if (DOOR_OPEN == 0 && was_open)
					begin
						max_cycles <= 3'b000;
						next_state <= IDLE;
					end
				else if (DOOR_OPEN == 0 && max_cycles != 3'b101)
					max_cycles <= max_cycles + 1'b1;
				else if (DOOR_OPEN == 0 && max_cycles == 3'b101)
					begin
						max_cycles <= 3'b000;
						next_state <= IDLE;
					end
			end
	 endcase
	 
	 // Always block to decide outputs
	 always@(*)
	 case(current_state)
		IDLE :
			if (CARD_IN == 0 && RELOAD == 0)
				begin
					VEND <= 1'b0;
					INVALID_SEL <= 1'b0;
					COST <= 3'b000;
					FAILED_TRAN <= 1'b0;
				end
		TRANSACT_INTERMEDIATE :
			begin
				COST <= costs[selected_item];
				if (digits == 2'b01)
					begin
						if (ITEM_CODE != 4'b0000 && ITEM_CODE != 4'b0001)
							INVALID_SEL <= 1'b1;
					end
			end
		VENDING :
			begin
				VEND <= 1'b1;
				if (VALID_TRAN == 0 && max_cycles == 3'b101)
					FAILED_TRAN <= 1'b1;
			end
	 endcase

endmodule