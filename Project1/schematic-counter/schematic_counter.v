`timescale 1ns / 1ps

module schematic_counter(
    clk, reset, d0, d1, d2, d3, result
);

    // Set inputs and outputs
    input wire clk, reset;
    input d0, d1, d2, d3;
    output reg [3:0] result;
	 
    initial
    begin
        result[0] = 0;
        result[1] = 0;
        result[2] = 0;
        result[3] = 0;
    end
    
    // Define additional wires
    wire q0, q1, q2, q3;

    // Create and initialize 4 d-flop-flops
    d_ff f0(.clk(clk), .reset(reset), .d(d0), .q(q0));
    d_ff f1(.clk(clk), .reset(reset), .d(d1), .q(q1));
    d_ff f2(.clk(clk), .reset(reset), .d(d2), .q(q2));
    d_ff f3(.clk(clk), .reset(reset), .d(d3), .q(q3));

    always @(reset, q0, q1, q2, q3) 
    begin
        if (reset ==  1)
            result <= 4'b0;
        else      
            //D0 = Q0′
            result[0] <= ~q0;
            //D1 = Q1'Q0 + Q1Q0′  = Q1 ⊕ Q0
            result[1] <= q1^q0;
            //D2 = Q2Q0′ + Q2Q1′ + Q2'Q1Q0
            result[2] <= (q2&(~q0))|(q2&(~q1))|((~q2)&q1&q0);
            //D3 = Q3Q2′ + Q3Q0′ + Q3Q1′ + Q3'Q2Q1Q0
            result[3] <= (q3&(~q2))|(q3&(~q0))|(q3&(~q1))|((~q3)&q2&q1&q0);
    end

endmodule 