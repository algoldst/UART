`timescale 1ns / 1ps


/* File: UART_Test.sv
 * Init: 11/17/2018 03:34:53 AM
 * Author: Alex Goldstein
 * Desc: Test for UART_Trans & UART_Rec on a single board.
 *       Can be configured to send via wired JA ports, or using interconnects.
 */

module UART_Test(
    input clk, 
    input [15:0] dataIn, //value to send
    input sendBtn, // Push this button when ready to send. 
                   // Sending repeats until btn is released, so make sure to release it!
    output [15:0] dataOut //value received
    
    //input JAbsI, JAsigI, // JA pin inputs (bitstream, receiving signal)
    //output JAbsO, JAsigO // JA pin outputs (bitstream, sending signal)
    );
    
logic t_bs, t_sig; //used for internal wiring, in place of JA pins (eg. for simulation, JA pins cannot be used)

/* The parameters for the modules are a predetermined agreement.
   #([packetSize, cycleDiv, propDelayOffset]), where
        packetSize = # bits sent/received per bitstream (these must agree)
        cycleDiv = clock division for sclk. Period of sclk = (1/100)clk (these must agree)
        propDelayOffset = Rec has delay from the time it receives the "sending" signal, to the time it can begin accepting bits from bitstream.
                          Only an option for Trans.
*/ 
UART_Trans #(16,100,2) trans(.clk, .data(dataIn), .sendBtn, .bsOut(t_bs), .sendSig(t_sig));
UART_Rec #(16,100) rec(.clk, .bsIn(t_bs), .recSig(t_sig), .data(dataOut));


endmodule
