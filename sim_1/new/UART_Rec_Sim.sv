`timescale 1ns / 1ps

/* File: UART_Rec_Sim.sv
 * Init: 11/17/2018 11:26:35 AM
 * Author: Alex Goldstein
 * Description: Simulates UART_Rec module receiving a bitstream from a UART_Trans.
 */

module UART_Rec_Sim(
    );

// Instantiate module
parameter packetSize=4; // # of bits being received at a time
parameter cycleDiv = 100; // sclk = (1/cycleDiv)clk = (1/100)clk
UART_Rec #(packetSize) uart_rec(.*);

logic clk, bsIn, recSig; //inputs
logic [packetSize-1:0] data; //output

// Simulate clk
logic firstClk=1;
always
    begin
    if(firstClk) //This is because I want sclk to happen on integer time divisions. Otherwise, my states change at eg. 1.95 us.
        begin
        clk=0;
        #10; //wait 1 period
        firstClk=0;
        end
    clk = 1; #5; // period = 10 ns
    clk = 0; #5;
    end

// Simulate
initial
    begin
    // Start with no input signal.
    bsIn=1; recSig=0; //Start with bsIn high for sim purposes; if it began collecting data before we expect, we will be able to see it.
    #1000;
    
    //Button pressed --> Trans sends button-press signal for 100 clk cycles (1 sclk cycles)
    recSig=1;
    #1000;
    recSig=0;
    //Receiving bitstream 1 sclk cycle after sendBtn received.
    // Note: 1 sclk cycles is the minimum time for Trans_Rec to receive bits. RecFSM can't respond faster than this, so Trans must delay its bitstream send.
    bsIn=0; // receives 01100100, then infinite 1s.
    #1000;
    bsIn=1;
    #2000;
    bsIn=0;
    #2000;
    bsIn=1;
    #1000;
    bsIn=0;
    #2000;
    bsIn=1;
    end
endmodule
