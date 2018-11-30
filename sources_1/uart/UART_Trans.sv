`timescale 1ns / 1ps

/* File: UART_Trans.sv
 * Init: 11/15/2018 09:46:48 AM
 * Author: Alex Goldstein
 * Description: Transmitter for UART system. Converts input data to bitstream, outputs the bitstream to Receiver.
 */

// packetSize: @ bits/bitstream
// cycleDiv: # clk cycles / sclk cycle
// propDelayOffset: The UART_Rec has a delay between the time it receives the "sending" signal and when it can first accept bits from the bitstream. This delay causes Trans to wait # sclk cycles.
module UART_Trans #(parameter packetSize=16, cycleDiv=100, propDelayOffset=1)(
    input [packetSize-1:0] data,
    input clk, sendBtn,
    output .bsOut(dOut[0]), // maps .dOut[0](bsOut) <-- except that the syntax is incorrect. Indices only allowed inside (), so the mapping is done here instead of in the ShiftReg module instantiation.
    output sendSig //brief high signal that alerts UART_Rec to begin accepting bitstream data
    );

//Interconnects   
logic t_sclk;
logic [1:0] t_regShift; //0=none, 1=right, 2=left
logic t_regLD; //1: LD-enable ShiftReg

//Modules
ClockDiv #(cycleDiv) uartClk(.clk(clk), .sclk(t_sclk));

logic [packetSize-1:0] dOut; //for mapping ShiftReg(.dOut(dOut))
ShiftReg #(packetSize) shift_reg(.clk(t_sclk), .dIn(data), .LD(t_regLD), .shift(t_regShift), .dOut );

TransFSM #(packetSize, propDelayOffset) transFSM(.clk(t_sclk), .ifSend(sendBtn), .regShift(t_regShift), .regLD(t_regLD), .sendSig(sendSig) );

endmodule
