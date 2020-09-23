`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Arnav Garg
// 
// Create Date:     
// Design Name: 
// Module Name:    parking_meter 
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

module parking_meter(
        input wire add1,
        input wire add2,
        input wire add3,
        input wire add4,
        input wire rst1,
        input wire rst2,
        input wire clk,
        input wire rst,
        output reg [6:0] led_seg,
        output reg [3:0] val1,
        output reg [3:0] val2,
        output reg [3:0] val3,
        output reg [3:0] val4,
        output reg a1,
        output reg a2,
        output reg a3,
        output reg a4
    );

    // Constant states
    parameter IDLE        = 3'b001;
    parameter ABOVE_3_MIN = 3'b010;
    parameter BELOW_3_MIN = 3'b100;

    // Internal variables
    reg [2:0] current_state, next_state;

    // Used for binary to BCD conversion
    reg [3:0] digit1  = 4'b0000;
    reg [3:0] digit2  = 4'b0000;
    reg [3:0] digit3  = 4'b0000;
    reg [3:0] digit4  = 4'b0000;
    integer k;

    // time remaining
    reg [6:0] clk_counter     = 7'b0;
    reg [13:0] time_remaining = 14'b0;

    // used for clock divider
    reg internal_clk;

    // Update current state, clock counter and internal clock (to act as
    // a clock divider for the 100Hz input signal)
    always @ (posedge clk)
        begin : SEQUENTIAL_LOG

            // Logic for updating current state
            // If global reset turned on, go back to idle
            if (rst == 1'b1) 
                begin
                    clk_counter <= #1 7'b0;
                    current_state <=  IDLE;
                end
            // If rst 1 or rst2 is turned on, set current_state to BELOW_3_MIN
            // since we know both rst 1 and rst 2 set time remaining to < 180s
            else if (rst1 == 1'b1 || rst2 == 1'b1) 
                current_state <= #1 BELOW_3_MIN;
            // If neither of the cases above (which are special), current state
            // will just go to next state based on the combination logic
            else 
                current_state <= #1 next_state;
						  
            // Logic for clock divider
            // on 100 counts of global clock (clk_counter == 99), set internal clock 
            // to 1 and reset counter for clock cycles back to 0
            if (clk_counter == 7'b1100011) 
                begin
                    clk_counter <= #1 7'b0;
                    internal_clk <= 1'b1;
                end
            // Otherwise, just increment counter by 1 after waiting for
            // 1 time interval
            else 
                begin
                    internal_clk <= 1'b0;
                    clk_counter <= #1 clk_counter + 1'b1;
                end
          
        end

    // Update next state based on current state
    always @ (current_state, add1, add2, add3, add4, rst1, rst2, rst, internal_clk)
        begin : COMBINATIONAL_LOG
            next_state = 3'b000;
            // decrement remaining time by 1 everytime internal clk is set to 1
            if (internal_clk == 1'b1) 
                begin
                    if (time_remaining != 14'b0)
                        time_remaining = time_remaining - 1'b1;
                end
            // if rst 1 is turned on, then time is 16
            else if (rst1 == 1'b1) 
                time_remaining = 14'b00000000010000;
            // if rst 2 is turned on, then time is 150
            else if (rst2 == 1'b1)
                time_remaining = 14'b00000010010110; 
            // if main rst is set to 1, then set time to 0
            else if (rst == 1'b1) 
                time_remaining = 14'b00000000000000;
            // update next state based on the current state
            case(current_state)
                // Idle state which is also the initial state
                IDLE :
                    begin 
                        // If add1 is turned on, increment time by 60s
                        if (add1 == 1'b1) 
                            begin
                                time_remaining = time_remaining + 14'b00000000111100;
                                next_state = BELOW_3_MIN;
                            end
                        // If add2 is turned on, increment time by 120s
                        else if (add2 == 1'b1) 
                            begin
                                time_remaining = time_remaining + 14'b00000001111000;
                                next_state = BELOW_3_MIN;
                            end 
                        // If add3 is turned on, increment time by 180s
                        else if (add3 == 1'b1) 
                            begin 
                                time_remaining = time_remaining + 14'b00000010110100;
                                next_state = ABOVE_3_MIN;
                            end
                        // If add4 is turned on, increment time by 300s
                        else if (add4 == 1'b1) 
                            begin
                                time_remaining = time_remaining + 14'b00000100101100;
                                next_state = ABOVE_3_MIN;
                            end
                        // If time remaining is > 180, then we move to the 
                        // state corresponding to time > 180s
                        else if (time_remaining >= 14'b00000010110100) 
                            next_state = ABOVE_3_MIN;
                        // If time is within [0,180), then transition to state with <180s
                        else if (time_remaining < 14'b00000010110100 && time_remaining > 14'b0) 
                            next_state = BELOW_3_MIN;
                        // fall back incase nothing else is passed, that is, continue 
                        // to stay in the idle state
                        else 
                            next_state = IDLE;
                    end 
                // When time_remaining >= 180
                ABOVE_3_MIN :
                    begin
                        // If add1 is turned on, increment time remaining by 60
                        if (add1 == 1'b1) 
                            begin
                                time_remaining = time_remaining + 14'b00000000111100;
                                next_state = ABOVE_3_MIN;
                            end
                        // If add2 is turned on, increment time by 120s
                        else if (add2 == 1'b1) 
                            begin
                                time_remaining = time_remaining + 14'b00000000111100;
                                next_state = ABOVE_3_MIN;
                            end
                        // If add 3 is turned on, increment time by 180s
                        else if (add3 == 1'b1) 
                            begin 
                                time_remaining = time_remaining + 14'b00000010110100;
                                next_state = ABOVE_3_MIN;
                            end
                        // If add 4 is turned on, increment time by 300s
                        else if (add4 == 1'b1) 
                            begin
                                time_remaining = time_remaining + 14'b00000100101100;
                                next_state = ABOVE_3_MIN;
                            end
                        // If the time remaining is strictly < 180, then
                        // move back to state corresponding to < 180s
                        else if (time_remaining < 14'b00000010110100) 
                            next_state = BELOW_3_MIN;
                        // Otherwise, continue to remain in this state since 
                        // time >= 180s
                        else
                            next_state = ABOVE_3_MIN;
                    end
                // When time remaining < 180
                BELOW_3_MIN :
                    begin
                        // If add1 is turned on, add 60s and see if the time remaining
                        // now is greater than 180. If yes, transition to ABOVE_3_MIN
                        if (add1 == 1'b1) 
                            begin
                                time_remaining = time_remaining + 14'b00000000111100;
                                if (time_remaining < 14'b00000010110100) 
                                    next_state = BELOW_3_MIN;
                                else
                                    next_state = ABOVE_3_MIN;
                            end
                        // If add2 is turned on, add 120s and see if the time remaining
                        // now is greater than 180. If yes, transition to ABOVE_3_MIN
                        else if (add2 == 1'b1) 
                            begin
                                time_remaining = time_remaining + 14'b00000000111100;
                                if (time_remaining < 14'b00000010110100) 
                                    next_state = BELOW_3_MIN;
                                else 
                                    next_state = ABOVE_3_MIN;
                            end
                        // If add3 is turned on, increment time and move to ABOVE_3_MIN
                        else if (add3 == 1'b1)
                            begin 
                                time_remaining = time_remaining + 14'b00000010110100;
                                next_state = ABOVE_3_MIN;
                            end
                        // If add4 is turned on, increment time by 300 and move to ABOVE_3_MIN
                        else if (add4 == 1'b1) 
                            begin
                                time_remaining = time_remaining + 14'b00000100101100;
                                next_state = ABOVE_3_MIN;
                            end
                        // If time remaining reaches 0, then transition back to IDLE
                        else if (time_remaining == 14'b00000000000000) 
                            next_state = IDLE;
                        // Otherwise just continue to stay in the same state
                        else
                            next_state = BELOW_3_MIN;
                    end
                // by default, next state is set to IDLE
                default : next_state = IDLE;
            endcase
            // Check if time_remaining is > 9999, and if yes, reset back to 9999
            if (time_remaining > 14'b10011100001111)
                time_remaining = 14'b10011100001111;
        end

        // Set outputs
        always @ (posedge clk)
            begin : SET_OUTPUTS
                // If global reset is turned on, then reset all outputs 
                // to 0, anodes to 0 and same with 7 segment display
                if (rst == 1'b1) 
                    begin
                        a1 = 1'b1; a2 = 1'b0; a3 = 1'b0; a4 = 1'b0;
                        val1 <= #1 4'b0000;  val2 <= #1 4'b0000;
                        val3 <= #1 4'b0000; val4 <= #1 4'b0000;
                        led_seg = 7'b0000001;
                    end
                // Otherwise we need to handle each state separately
                else 
                    begin
                        case(current_state)
                            // If current state is IDLE
                            IDLE : 
                                begin
                                    // Initially, all 4 BCD outputs are 0
                                    val1 <= #1 4'b0000; val2 <= #1 4'b0000;
                                    val3 <= #1 4'b0000; val4 <= #1 4'b0000;
                                    // led_seg is also set to default
                                    led_seg = 7'b0000001;
                                    // If anode 1 is turned on, set back to 0
                                    // and change anode 2 to be turned on
                                    if (a1 == 1'b1) 
                                        begin 
                                            a1 = 1'b0; a2 = 1'b1;
                                        end
                                    // If anode 2 is turned on, set back to 0
                                    // and change anode 3 to be turned on
                                    else if (a2 == 1'b1)
                                        begin 
                                            a2 = 1'b0; a3 = 1'b1;
                                        end
                                    // If anode 3 is turned on, set back to 0
                                    // and change anode 4 to be turned on
                                    else if (a3 == 1'b1) 
                                        begin 
                                            a3 = 1'b0; a4 = 1'b1;
                                        end
                                    // If anode 4 is turned on, set back to 0
                                    // and change anode 1 to be turned on 
                                    else if (a4 == 1'b1) 
                                        begin 
                                            a4 = 1'b0; a1 = 1'b1;
                                        end
                                    // default to anode 1 being turnd on so cyclic
                                    // nature of anodes being turned on in turns 
                                    // can occur with each positive clock edge
                                    else 
                                        begin
                                            a1 = 1'b1; a2 = 1'b0;
                                            a3 = 1'b0; a4 = 1'b0;
                                        end
                                end
                            // If current state is BELOW_3_MIN
                            BELOW_3_MIN : 
                                begin
                                    // Initially, all 4 digits are 0
                                    digit1 = 4'b0; digit2 = 4'b0;
                                    digit3 = 4'b0; digit4 = 4'b0;
                                    // Basic binary to BCD conversion:
                                    // 1. If any column >= 5, increment by 3
                                    // 2. Shift all digits to the left by 1 position
                                    // 3. If the 14 shifts hav been performed, it's done.
                                    for(k = 13; k >= 0; k = k-1)
                                        begin
                                            // Increment by 3 once the digit column is 
                                            // 5 or greater (same as > 4)
                                            if (digit4 > 4'b0100)
                                                digit4 = digit4 + 4'b0011;
                                            if (digit3 > 4'b0100)
                                                digit3 = digit3 + 4'b0011;
                                            if (digit2 > 4'b0100)
                                                digit2 = digit2 + 4'b0011;
                                            if (digit1 > 4'b0100)
                                                digit1 = digit1 + 4'b0011;
                                            // Shift all digits to the left by 1 position
                                            digit4 = digit4 << 1;
                                            digit4[0] = digit3[3];
                                            digit3 = digit3 << 1;
                                            digit3[0] = digit2[3];
                                            digit2 = digit2 << 1;
                                            digit2[0] = digit1[3];
                                            digit1 = digit1 << 1;
                                            // Make use of the 14 bits of time remaining to
                                            // actually reflect the valeus for each of the digits
                                            digit1[0] = time_remaining[k];
                                        end
                                    // setout output values to digit values
                                    val1 <= #1 digit4;
												val2 <= #1 digit3;
                                    val3 <= #1 digit2;
                                    val4 <= #1 digit1;
                                    // Check which anode is turned on and light up the 
                                    // led segment corresponding to that digit based on 
                                    // the val
                                    if (a1 == 1'b1) 
                                        begin
                                            // turn it off and turn the next one so we can turn on
                                            // the next LED digit (in sequence)
                                            a1 = 1'b0;
                                            a2 = 1'b1;
                                            // Based on value, set 7 segment display output
                                            case(val2)
                                                0: led_seg = 7'b1111110;
                                                1: led_seg = 7'b1001111;
                                                2: led_seg = 7'b0010010;
                                                3: led_seg = 7'b0000110;
                                                4: led_seg = 7'b1001100;
                                                5: led_seg = 7'b0100100;
                                                6: led_seg = 7'b0100000;
                                                7: led_seg = 7'b0001111;
                                                8: led_seg = 7'b0000000;
                                                9: led_seg = 7'b0001100;
                                                // Default is that it's turned off
                                                default: led_seg = 7'b1111110;	
                                            endcase;
                                        end
                                    // repeat for this anode
                                    else if (a2 == 1'b1) 
                                        begin 
                                            a2 = 1'b0;
                                            a3 = 1'b1;
                                            case(val3)
                                                0: led_seg = 7'b1111110;
                                                1: led_seg = 7'b1001111;
                                                2: led_seg = 7'b0010010;
                                                3: led_seg = 7'b0000110;
                                                4: led_seg = 7'b1001100;
                                                5: led_seg = 7'b0100100;
                                                6: led_seg = 7'b0100000;
                                                7: led_seg = 7'b0001111;
                                                8: led_seg = 7'b0000000;
                                                9: led_seg = 7'b0001100;
                                                default: led_seg = 7'b1111110;	
                                            endcase;
                                        end 
                                    else if (a3 == 1'b1) 
                                        begin 
                                            a3 = 1'b0;
                                            a4 = 1'b1;
                                            case(val4)
                                                0: led_seg = 7'b1111110;
                                                1: led_seg = 7'b1001111;
                                                2: led_seg = 7'b0010010;
                                                3: led_seg = 7'b0000110;
                                                4: led_seg = 7'b1001100;
                                                5: led_seg = 7'b0100100;
                                                6: led_seg = 7'b0100000;
                                                7: led_seg = 7'b0001111;
                                                8: led_seg = 7'b0000000;
                                                9: led_seg = 7'b0001100;
                                                default: led_seg = 7'b1111110;	
                                            endcase;
                                        end 
                                    else if (a4 == 1'b1) 
                                        begin 
                                            a4 = 1'b0;
                                            a1 = 1'b1;
                                            case(val1)
                                                0: led_seg = 7'b1111110;
                                                1: led_seg = 7'b1001111;
                                                2: led_seg = 7'b0010010;
                                                3: led_seg = 7'b0000110;
                                                4: led_seg = 7'b1001100;
                                                5: led_seg = 7'b0100100;
                                                6: led_seg = 7'b0100000;
                                                7: led_seg = 7'b0001111;
                                                8: led_seg = 7'b0000000;
                                                9: led_seg = 7'b0001100;
                                                default: led_seg = 7'b1111110;	
                                            endcase;
                                        end 
                                    else 
                                        begin
                                            a1 = 1'b1; a2 = 1'b0;
                                            a3 = 1'b0; a4 = 1'b0;
                                            case(val1)
                                                0: led_seg = 7'b1111110;
                                                1: led_seg = 7'b1001111;
                                                2: led_seg = 7'b0010010;
                                                3: led_seg = 7'b0000110;
                                                4: led_seg = 7'b1001100;
                                                5: led_seg = 7'b0100100;
                                                6: led_seg = 7'b0100000;
                                                7: led_seg = 7'b0001111;
                                                8: led_seg = 7'b0000000;
                                                9: led_seg = 7'b0001100;
                                                default: led_seg = 7'b1111110;	
                                            endcase;
                                        end
                                    // If time_remaining is odd, then reset anode so that 
                                    // we skip odd time remaining and only light up when time 
                                    // remaining is even
                                    if (time_remaining % 2 != 0) 
                                        begin
                                            a1 = 1'b0; a2 = 1'b0;
                                            a3 = 1'b0; a4 = 1'b0;
                                        end
                                    // If they're all set to 0, then simply set a1 to 1 so that the 
                                    // LED light up cycle can start again
                                    else if (a1 == 1'b0 && a2 == 1'b0 && a3 == 1'b0 && a4 == 1'b0) 
                                        a1 = 1'b1;
                                end
                            // Case where time remaining > 180s
                            ABOVE_3_MIN : 
                                begin
                                    // At the beginning, initialize all 4 digits to 0
                                    digit1 = 4'b0; digit2 = 4'b0;
                                    digit3 = 4'b0; digit4 = 4'b0;
                                    // Just like above, convert time remaining in binary to
                                    // BCD format
                                    for(k = 13; k >= 0; k = k-1)
                                        begin
                                            //add 3 if > 4;
                                            if (digit4 > 4'b0100)
                                                digit4 = digit4 + 4'b0011;
                                            if (digit3 > 4'b0100)
                                                digit3 = digit3 + 4'b0011;
                                            if (digit2 > 4'b0100)
                                                digit2 = digit2 + 4'b0011;
                                            if (digit1 > 4'b0100)
                                                digit1 = digit1 + 4'b0011;
                                            //shift left one
                                            digit4 = digit4 << 1;
                                            digit4[0] = digit3[3];
                                            digit3 = digit3 << 1;
                                            digit3[0] = digit2[3];
                                            digit2 = digit2 << 1;
                                            digit2[0] = digit1[3];
                                            digit1 = digit1 << 1;
                                            digit1[0] = time_remaining[k];
                                        end
                                    // Assign outputs to each BCD digit
                                    val1 <= #1 digit4;
                                    val2 <= #1 digit3;
                                    val3 <= #1 digit2;
                                    val4 <= #1 digit1;
                                    // If anode 1 is turned on, then turn it off 
                                    // and set anode 2 off so the next cycle can light up 
                                    // the next LED in the 7 seg display.
                                    if (a1 == 1'b1) 
                                        begin 
                                            a1 = 1'b0;
                                            a2 = 1'b1;
                                            // Based on BCD digit, set the output LED segment
                                            case(val2)
                                                0: led_seg = 7'b1111110;
                                                1: led_seg = 7'b1001111;
                                                2: led_seg = 7'b0010010;
                                                3: led_seg = 7'b0000110;
                                                4: led_seg = 7'b1001100;
                                                5: led_seg = 7'b0100100;
                                                6: led_seg = 7'b0100000;
                                                7: led_seg = 7'b0001111;
                                                8: led_seg = 7'b0000000;
                                                9: led_seg = 7'b0001100;
                                                default: led_seg = 7'b1111110;	
                                            endcase;
                                        end 
                                    else if (a2 == 1'b1) 
                                        begin 
                                            a2 = 1'b0;
                                            a3 = 1'b1;
                                            case(val3)
                                                0: led_seg = 7'b1111110;
                                                1: led_seg = 7'b1001111;
                                                2: led_seg = 7'b0010010;
                                                3: led_seg = 7'b0000110;
                                                4: led_seg = 7'b1001100;
                                                5: led_seg = 7'b0100100;
                                                6: led_seg = 7'b0100000;
                                                7: led_seg = 7'b0001111;
                                                8: led_seg = 7'b0000000;
                                                9: led_seg = 7'b0001100;
                                                default: led_seg = 7'b1111110;	
                                            endcase;
                                        end 
                                    else if (a3 == 1'b1) 
                                        begin 
                                            a3 = 1'b0;
                                            a4 = 1'b1;
                                            case(val4)
                                                0: led_seg = 7'b1111110;
                                                1: led_seg = 7'b1001111;
                                                2: led_seg = 7'b0010010;
                                                3: led_seg = 7'b0000110;
                                                4: led_seg = 7'b1001100;
                                                5: led_seg = 7'b0100100;
                                                6: led_seg = 7'b0100000;
                                                7: led_seg = 7'b0001111;
                                                8: led_seg = 7'b0000000;
                                                9: led_seg = 7'b0001100;
                                                default: led_seg = 7'b1111110;	
                                            endcase;
                                        end 
                                    else if (a4 == 1'b1) 
                                        begin 
                                            a4 = 1'b0;
                                            a1 = 1'b1;
                                            case(val1)
                                                0: led_seg = 7'b1111110;
                                                1: led_seg = 7'b1001111;
                                                2: led_seg = 7'b0010010;
                                                3: led_seg = 7'b0000110;
                                                4: led_seg = 7'b1001100;
                                                5: led_seg = 7'b0100100;
                                                6: led_seg = 7'b0100000;
                                                7: led_seg = 7'b0001111;
                                                8: led_seg = 7'b0000000;
                                                9: led_seg = 7'b0001100;
                                                default: led_seg = 7'b1111110;	
                                            endcase;
                                        end
                                    // If no anode is turned on, set anode 1 to on
                                    else 
                                        begin
                                            a1 = 1'b1; a2 = 1'b0;
                                            a3 = 1'b0; a4 = 1'b0;
                                            // use BCD to light the LED for val1
                                            case(val2)
                                                0: led_seg = 7'b1111110;
                                                1: led_seg = 7'b1001111;
                                                2: led_seg = 7'b0010010;
                                                3: led_seg = 7'b0000110;
                                                4: led_seg = 7'b1001100;
                                                5: led_seg = 7'b0100100;
                                                6: led_seg = 7'b0100000;
                                                7: led_seg = 7'b0001111;
                                                8: led_seg = 7'b0000000;
                                                9: led_seg = 7'b0001100;
                                                default: led_seg = 7'b1111110;	
                                            endcase;
                                        end
                                    // If clock counter is less than 50, then we want to reset the
                                    // anodes back to 0
                                    if (clk_counter <= 7'b0110010) 
                                        begin
                                            a1 = 1'b0; a2 = 1'b0;
                                            a3 = 1'b0; a4 = 1'b0;
                                        end
                                    // At this point, set a1 back to 1 so we can restart the LED cycle
                                    else if (a1 == 1'b0 && a2 == 1'b0 && a3 == 1'b0 && a4 == 1'b0)
                                        a1 = 1'b1;
                                end
                            // in the default cause where we're not in any known state,
                            // perform the same output process as that for IDLE. The only difference
                            // is that val is not set.
                            default : 
                                begin
                                    led_seg = 7'b0000001;
                                    if (a1 == 1'b1) 
                                        begin 
                                            a1 = 1'b0; a2 = 1'b1;
                                        end 
                                    else if (a2 == 1'b1) 
                                        begin 
                                            a2 = 1'b0; a3 = 1'b1;
                                        end
                                    else if (a3 == 1'b1) 
                                        begin 
                                            a3 = 1'b0; a4 = 1'b1;
                                        end
                                    else if (a4 == 1'b1) 
                                        begin 
                                            a4 = 1'b0; a1 = 1'b1;
                                        end
                                    // If all are set to 0 (initial), then set a1 to 1 so 
                                    // LED loop cycle can start
                                    else 
                                        begin
                                            a1 = 1'b1; a2 = 1'b0;
                                            a3 = 1'b0; a4 = 1'b0;
                                        end
                                end
                        endcase
                    end
                
            end

endmodule