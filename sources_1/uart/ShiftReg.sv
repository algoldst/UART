`timescale 1ns / 1ps

/* File: ShiftReg.sv
 * Init: 11/16/2018 06:23:30 PM
 * Author: Alex Goldstein
 * Description: Register for UART_Trans. Takes in register dIn, shifts right on each clk.
 */

//packetSize: # bits/bitstream
module ShiftReg #(parameter packetSize=4)(
    input clk, 
    input LD, //load-enable
    input [1:0] shift, //0=hold, 1=right shift, 2=left shift
    input [packetSize-1:0] dIn,
    output logic [packetSize-1:0] dOut = 0
    );
    
always_ff @(posedge clk)
    begin
    //Load data (reg)
    if(LD) dOut = dIn;
    
    //Bit shift
    if(shift==1) dOut = {1'b0, dOut[packetSize-1:1]};
    else if(shift==2) dOut = {dOut[packetSize-2:0], 1'b0};
    else dOut = dOut;
    
    end
endmodule
