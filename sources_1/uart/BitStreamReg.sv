`timescale 1ns / 1ps

/* File: BitStreamReg.sv
 * Init: 11/16/2018 06:23:30 PM
 * Author: Alex Goldstein
 * Desc: Receiver module for UART, receives a bitstream and assembles it as a register value.
 *       Works in conjunction with UART_Trans module.
 */

// packetSize: # bits / bitstream
// cyclesDiv: clock divider. sclk = (1/100)clk. While this doesn't use a clock divider, it needs to know what division Trans uses, so it can calculate the midpoint of each state.
module BitStreamReg #(parameter packetSize=4, cycleDiv=100)(
    input clk, 
    input LD, msbLD, //LD=load enable. msbLD = load incoming LSB into MSB slot (because Trans sends LSB first, and this right-shifts on each sclk)
    input [1:0] shift, //0=none, 1=right shift, 2=left shift
    input [packetSize-1:0] dIn,
    output logic [packetSize-1:0] dOut = 0,
    output logic HERE //dummy output, spikes show when reg is taking samples from the input
    );

logic [29:0] cycleCounter = 0; //tracks board clk, resets to 0 @ cycleDiv
always_ff @(posedge clk)
    begin
    cycleCounter++;
    HERE=0;
    if(cycleCounter == 20) //at the halfway point
        begin
        HERE = 1;
        
        //Bit shift
        if(shift==1) dOut = {1'b0, dOut[packetSize-1:1]};
        else if(shift==2) dOut = {dOut[packetSize-2:0], 1'b0};
        else dOut = dOut;
        
        //Load newest bit from bitstream
        if(LD && msbLD) dOut[packetSize-1] = dIn[0];
        else if(LD && ~msbLD) dOut[0] = dIn[0];
        end
    if(cycleCounter == cycleDiv) cycleCounter=0;
    end
endmodule
