module mux8 (sw0, sw1, select, out);
    
    // Define inputs and outputs
    input wire sw0, sw1;
    input wire [2:0] select;
    output reg out;
    
    /* Initialize additional wires needed to 
    store intermediate values */
    wire w0, w1, w2, w3, w4, w5, w6, w7;

    // Define gates and operations
    not 
        (w0, sw0);
    buf
        (w1, sw0);
    xnor
        (w2, sw0, sw1);
    xor
        (w3, sw0, sw1);
    or
        (w4, sw0, sw1);
    nor
        (w5, sw0, sw1);
    and
        (w6, sw0, sw1);
    nand
        (w7, sw0, sw1);
    
    // Switch case for mux selector
    always @(select) 
    case (select)
        3'b000 : out = w0;
        3'b001 : out = w1;
        3'b010 : out = w2;
        3'b011 : out = w3;
        3'b100 : out = w4;
        3'b101 : out = w5;
        3'b110 : out = w6;
        3'b111 : out = w7;
        default : out = out;
    endcase

endmodule