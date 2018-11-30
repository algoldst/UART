`timescale 1ns / 1ps

/* File: UART_Rec.sv
 * Init: 11/16/2018 08:50:37 PM
 * Author: Alex Goldstein
 * Description: Receives bitstream from a UART_Trans, assembles bs into a single register.
 *     1. recSig indicates that Trans is about to send
 *     2. Three sclk cycles later, receives the first bit of bs
 *        NOTE: RecFSM requires 3 cycles to begin accepting bits. Therefore, Trans must delay its bs sending by 3 cycles.
 */

// packetSize: # bits in bitstream
// cycleDiv: sclk = (1/100)clk
module UART_Rec #(parameter packetSize=4, cycleDiv=100)(
    input clk, bsIn, recSig,
    output [packetSize-1:0] data
    );

// Interconnects
logic t_sclk;
logic t_regLD;
logic [1:0] t_regShift;

// Modules
ClockDiv #(cycleDiv) uartClk(.clk(clk), .sclk(t_sclk));
RecFSM #(packetSize) recFSM(.clk(t_sclk), .ifRecSig(recSig), .regShift(t_regShift), .regLD(t_regLD) );
BitStreamReg #(packetSize, cycleDiv) shiftReg(.clk(clk), .dIn( { {packetSize-1{1'b0} }, bsIn}), .LD(t_regLD), .msbLD(1), .shift(t_regShift), .dOut(data));

endmodule
