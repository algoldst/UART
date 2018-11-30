`timescale 1ns / 1ps

/* File: ClockDiv.sv
 * Init: 11/16/2018 04:54:54 PM
 * Author: Alex Goldstein
 * Description: Simple clock divider.
 */

// CYCLES: # of clk cycles to equal one sclk cycle
module ClockDiv #(parameter CYCLES=1)(
    input clk,
    output logic sclk = 1 //doesn't seem to matter if this is 1 or 0 initially, but necessary for sim
    );
    
    logic [29:0] count = 0;
        
    always_ff @ (posedge clk)
    begin
        count = count + 1;
        if (count == (CYCLES)/2) //Flip state at 1/2 period == 1/2 CYCLES
        begin
            count = 0;
            sclk = ~sclk;
        end
             
    end

endmodule
