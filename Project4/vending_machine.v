module vending_machine(CARD_IN, VALID_TRAN, ITEM_CODE, KEY_PRESS, DOOR_OPEN, RELOAD, CLK, RESET, VEND, INVALID_SEL, FAILED_TRAN, COST);
input CARD_IN, VALID_TRAN, KEY_PRESS, DOOR_OPEN, RELOAD, CLK, RESET;
input wire [3:0] ITEM_CODE;
output reg VEND, INVALID_SEL, FAILED_TRAN;
output reg [2:0] COST;

		// Parameters defining different states
		parameter IDLE = 'd0;
		parameter STATE_RELOAD = 'd1;
		parameter SELECTION = 'd2;
		parameter VEND_STATE = 'd9;
		parameter GET_CODE = 'd11;

		// Parameters for 6 groups of snacks based on costs
		parameter SNACK_COST_1 = 'd3;
		parameter SNACK_COST_2 = 'd4;
		parameter SNACK_COST_3 = 'd5;
		parameter SNACK_COST_4 = 'd6;
		parameter SNACK_COST_5 = 'd7;
		parameter SNACK_COST_6 = 'd8;

		// Keep track of states
		reg [3:0] current_state;
		reg [3:0] next_state;

		// Number of input digits and item code
		reg [3:0] digits = 4'b0000;
		reg [4:0] item_code;

		reg [3:0] counter = 4'b0000;
		reg [2:0] cycles = 3'b000;

		// Flags
		reg item_code_flag = 1'b0;
		reg get_cycle_flag = 1'b0;
		reg sel_cycle_flag = 1'b0;
		reg vend_cycle_flag = 1'b0;

		// Counters
		reg [3:0] counter_0 = 4'b1010;  reg [3:0] counter_1 = 4'b1010;  reg [3:0] counter_2 = 4'b1010;
		reg [3:0] counter_3 = 4'b1010;  reg [3:0] counter_4 = 4'b1010;  reg [3:0] counter_5 = 4'b1010;
		reg [3:0] counter_6 = 4'b1010;  reg [3:0] counter_7 = 4'b1010;  reg [3:0] counter_8 = 4'b1010;
		reg [3:0] counter_9 = 4'b1010;  reg [3:0] counter_10 = 4'b1010; reg [3:0] counter_11 = 4'b1010;
		reg [3:0] counter_12 = 4'b1010; reg [3:0] counter_13 = 4'b1010; reg [3:0] counter_14 = 4'b1010;
		reg [3:0] counter_15 = 4'b1010; reg [3:0] counter_16 = 4'b1010; reg [3:0] counter_17 = 4'b1010;
		reg [3:0] counter_18 = 4'b1010; reg [3:0] counter_19 = 4'b1010;

		// Update Current State
		always@(posedge CLK)
		begin
			if (RESET)
				current_state <= IDLE;
			else
				current_state <= next_state;
		end

		// Update Next State
		always @(*)
		case(current_state)
			// Idle state
			IDLE:
				begin
					if (RELOAD)
						next_state = STATE_RELOAD;
					else if (CARD_IN && RELOAD == 1'b0)
						next_state = GET_CODE;
					else 
						next_state = IDLE;
				end
			// Intermediate Reload State
			STATE_RELOAD:
				begin
					if (RELOAD == 1'b0)
						next_state = IDLE;
				end
			// State representing Get Code action
			GET_CODE:
				begin
					if (digits == 4'b0010)
						next_state = SELECTION;
					else if (KEY_PRESS == 1'b0 & cycles < 3'b101)
						next_state = GET_CODE;
					else if (digits != 4'b0010 & cycles == 3'b101)
						next_state = IDLE;
				end
			// Selection state from Get code state
			SELECTION:
				begin
					if (item_code >= 5'b0 && item_code <= 5'b00011)
						begin
							// No more snacks to vend, so return to IDLE
							if (counter_0 == 0 || 
								counter_1 == 0 || 
								counter_2 == 0 || 
								counter_3 == 0)
								next_state = IDLE;
							// Otherwise transition to that snack
							else
								next_state = SNACK_COST_1;
						end
					else if(item_code >= 5'b00100 && item_code <= 5'b00111)
						begin
							// No more snacks to vend, so return to IDLE
							if (counter_4 == 1'b0 || 
							    counter_5 == 1'b0 || 
								counter_6 == 1'b0 || 
								counter_7 == 1'b0 )
								next_state = IDLE;
							else
								next_state = SNACK_COST_2; 
						end
					else if(item_code >= 5'b01000 && item_code <= 5'b01011)
						begin
							// No more snacks to vend, so return to IDLE
							if (counter_8 == 1'b0 || 
							    counter_9 == 1'b0 || 
								counter_10 == 1'b0 || 
								counter_11 == 1'b0 )
								next_state = IDLE;
							else
								next_state = SNACK_COST_3; 
						end
					else if(item_code >= 5'b01100 && item_code <= 5'b01111)
						begin
							// No more snacks to vend, so return to IDLE
							if (counter_12 == 1'b0 || 
							    counter_13 == 1'b0 || 
								counter_14 == 1'b0 || 
								counter_15 == 1'b0)
								next_state = IDLE;
							else
								next_state = SNACK_COST_4;
						end
					else if(item_code == 5'b10000 || item_code == 5'b10001)
						begin
							// No more snacks to vend, so return to IDLE
							if (counter_16 == 1'b0 || counter_17 == 1'b0)
								next_state = IDLE;
							else
								next_state = SNACK_COST_5;
						end
					else if(item_code == 5'b10010 || item_code == 5'b10011)
						begin
							// No more snacks to vend, so return to IDLE
							if (counter_18 == 1'b0 || counter_19 == 1'b0)
								next_state = IDLE;
							else
								next_state = SNACK_COST_6;
						end
					else
						next_state = IDLE;
				end
			VEND_STATE:
				begin
					// Check if door_open signal is set to high
					if (DOOR_OPEN)
						next_state = VEND_STATE;
					else if(cycles >= 3'b101 & DOOR_OPEN == 0)
						next_state = IDLE;
				end
			SNACK_COST_1:
				begin
					// Vend if Valid_tran is high
					if (VALID_TRAN)
						next_state = VEND_STATE;
					// If cycles is 5, move back to idle
					else if (cycles == 3'b101)
						next_state = IDLE;
				end
			SNACK_COST_2:
				begin
					if(VALID_TRAN)
						next_state = VEND_STATE;
					else if(cycles == 3'b101)
						next_state = IDLE;
				end
			SNACK_COST_3:
				begin
					if(VALID_TRAN)
						next_state = VEND_STATE;
					else if(cycles == 3'b101)
						next_state = IDLE;
				end
			SNACK_COST_4:
				begin
					if(VALID_TRAN)
						next_state = VEND_STATE;
					else if(cycles == 3'b101)
						next_state = IDLE;
				end
			SNACK_COST_5:
				begin
					if(VALID_TRAN)
						next_state = VEND_STATE;
					else if(cycles == 3'b101)
						next_state = IDLE;
				end
			SNACK_COST_6:
				begin
					if(VALID_TRAN)
						next_state = VEND_STATE;
					else if(cycles == 3'b101)
						next_state = IDLE;
				end
		endcase

		// Always block to track counter
		always@(posedge CLK)
			begin
				// Increment cycles
				cycles <= cycles + 1'b1;

				// If Greater than 5, reset to 0
				if (cycles > 3'b101)
					cycles <= 3'b000;
				
				// Reset to 0 if self_cycle_flag turned on for snacks
				// or IDLE state active or get_cycle_flag turned on during GET_CODE
				if (current_state == IDLE ||
					(current_state == GET_CODE & get_cycle_flag) ||
					(current_state == SNACK_COST_1 & sel_cycle_flag) ||
					(current_state == SNACK_COST_2 & sel_cycle_flag) ||
					(current_state == SNACK_COST_3 & sel_cycle_flag) ||
					(current_state == SNACK_COST_4 & sel_cycle_flag) ||
					(current_state == SNACK_COST_5 & sel_cycle_flag) ||
					(current_state == SNACK_COST_6 & sel_cycle_flag) ||
					(current_state == VEND & vend_cycle_flag))
					cycles <= 3'b000;
			end

		// Always block for outputs
		always @(*)
		case(current_state)
			IDLE: 
				begin
					//Set outputs to 0
					VEND = 1'b0;
					INVALID_SEL = 1'b0;
					FAILED_TRAN = 1'b0;
					COST[2:0] <= 3'b0;
					digits <= 4'b0;
					get_cycle_flag = 1'b0;
					sel_cycle_flag = 1'b0;
					vend_cycle_flag = 1'b0;
					item_code <= 5'b10101;
				end
			STATE_RELOAD:
				begin
					// Reset counters to 10
					counter_0 <= 4'b1010; counter_1 <= 4'b1010; counter_2 <= 4'b1010;
					counter_3 <= 4'b1010; counter_4 <= 4'b1010; counter_5 <= 4'b1010;
					counter_6 <= 4'b1010; counter_7 <= 4'b1010; counter_8 <= 4'b1010;
					counter_9 <= 4'b1010; counter_10 <= 4'b1010; counter_11 <= 4'b1010;
					counter_12 <= 4'b1010; counter_13 <= 4'b1010; counter_14 <= 4'b1010;
					counter_15 <= 4'b1010; counter_16 <= 4'b1010; counter_17 <= 4'b1010;
					counter_18 <= 4'b1010; counter_19 <= 4'b1010;
				end
			GET_CODE:
				begin
					// if Key_press set to high
					if (KEY_PRESS)
						begin
							// Make sure item code numbers fall with 0-9 inclusive
							if (ITEM_CODE >= 4'b0 && ITEM_CODE < 4'b1010)
								begin
									// If first digit is 0
									if (digits == 1'b0 & ~item_code_flag)
										begin
											item_code <= ITEM_CODE * 10;
											// increment number of digits by 1
											digits <= 1;
											// set get code cycle to 1
											get_cycle_flag = 1;
											// and item code flag to 1
											item_code_flag = 1;
										end
									// If first digit is 1
									else if (digits == 1 & ~item_code_flag)
										begin
											// Simply add the second digit passed in
											item_code <= item_code + ITEM_CODE;
											// We now know both digits have been entered
											digits <= 2;
										end
								end
						end
					else
						begin
							// If key press is off, then we know the flags are 0 so counter
							// can start counting
							item_code_flag = 0;
							get_cycle_flag = 0;
						end
					// Set invalid_sel to 1 for idle state
					if (next_state == IDLE)
						INVALID_SEL = 1;
				end
			SELECTION:
				begin
					if (next_state == IDLE)
						INVALID_SEL = 1;
					else 
						// we know selection can happen now 
						sel_cycle_flag = 1;
				end
			SNACK_COST_1:
				begin
					// All snacks in SNACK_COST_1 cost 1
					COST <= 1;
					// Selection has been made, so turn off the flag
					sel_cycle_flag = 0;
					if (next_state == IDLE)
						FAILED_TRAN = 1;
					if (next_state == VEND_STATE)
						vend_cycle_flag = 1;
				end
			SNACK_COST_2:
				begin
					COST <= 2;
					sel_cycle_flag = 0;
					if(next_state == IDLE)
						FAILED_TRAN = 1;
					if(next_state == VEND_STATE)
						vend_cycle_flag = 1;
				end
			SNACK_COST_3:
				begin
					COST <= 3;
					sel_cycle_flag = 0;
					if(next_state == IDLE)
						FAILED_TRAN = 1;
					if(next_state == VEND_STATE)
						vend_cycle_flag = 1;
				end
			SNACK_COST_4:
				begin
					COST <= 4;
					sel_cycle_flag = 0;
					if (next_state == IDLE)
						FAILED_TRAN = 1;
					if (next_state == VEND_STATE)
						vend_cycle_flag = 1;
				end
			SNACK_COST_5:
				begin
					COST <= 5;
					sel_cycle_flag = 0;
					if(next_state == IDLE)
						FAILED_TRAN = 1;
					if(next_state == VEND_STATE)
						vend_cycle_flag = 1;
				end
			SNACK_COST_6:
				begin
					COST <= 6;
					sel_cycle_flag = 0;
					if(next_state == IDLE)
						FAILED_TRAN = 1;
					if(next_state == VEND_STATE)
						vend_cycle_flag = 1;
				end
			VEND_STATE:
				begin
				vend_cycle_flag = 0;
				if (item_code == 0)
					counter_0 <= counter_0 - 1'b1;
				else if (item_code == 5'b00001)
					counter_1 <= counter_1 - 1'b1;		
				else if (item_code == 5'b00010)
					counter_2 <= counter_2 - 1'b1;
				else if (item_code == 5'b00011)
					counter_3 <= counter_3 - 1'b1;
				else if (item_code == 5'b00100)
					counter_4 <= counter_4 - 1'b1;
				else if (item_code == 5'b00101)
					counter_5 <= counter_5 - 1'b1;
				else if (item_code == 5'b00110)
					counter_6 <= counter_6 - 1'b1;
				else if (item_code == 5'b00111)
					counter_7 <= counter_7 - 1'b1;
				else if (item_code == 5'b01000)
					counter_8 <= counter_8 - 1'b1;
				else if (item_code == 5'b01001)
					counter_9 <= counter_9 - 1'b1;
				else if (item_code == 5'b01010)
					counter_10 <= counter_10 - 1'b1;
				else if (item_code == 5'b01011)
					counter_11 <= counter_11 - 1'b1;
				else if (item_code == 5'b01100)
					counter_12 <= counter_12 - 1'b1;
				else if (item_code == 5'b01101)
					counter_13 <= counter_13 - 1'b1;
				else if (item_code == 5'b01110)
					counter_14 <= counter_14 - 1'b1;
				else if (item_code == 5'b01111)
					counter_15 <= counter_15 - 1'b1;
				else if (item_code == 5'b10000)
					counter_16 <= counter_16 - 1'b1;
				else if (item_code == 5'b10001)
					counter_17 <= counter_17 - 1'b1;
				else if (item_code == 5'b10010)
					counter_18 <= counter_18 - 1'b1;
				else if (item_code == 5'b10011)
					counter_19 <= counter_19 - 1'b1;
				
				// Set vend to 1 again
				VEND = 1'b1;
				item_code <= 5'b10101;

				end
		endcase
	endmodule
