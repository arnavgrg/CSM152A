`timescale 1ns / 1ps

module d_ff(
    clk, reset, d, q
);

    input wire clk, reset;
    input wire d;
    output reg q;

    always @(posedge clk, posedge reset) 
    begin
        if (reset ==  1) 
            q <= 0;
        else
            q <= d;
    end

endmodule