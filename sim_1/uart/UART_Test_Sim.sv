`timescale 1ns / 1ps

/* File: UART_Test_Sim.sv
 * Init: 11/17/2018 03:41:27 AM
 * Author: Alex Goldstein
 * Desc: Simulates UART_Test send/receiving
 *       NOTE: For this sim, you must set UART_Test to use t_ interconnects instead of JA inputs/outputs. The effect is the same.
 */

module UART_Test_Sim(
    );
 
// Instantiate module
logic clk;
logic [3:0] dataIn; //dataIn = original value sent by Trans
logic [3:0] dataOut; //dataOut = what Rec receives as its value
logic sendBtn;

UART_Test uart_test(.*);

// Simulate clk
always
    begin
    clk=1; #5; //clk period = 10ns
    clk=0; #5;
    end

// Simulate
initial
    begin
    sendBtn=0;
    dataIn=13;
    #1000;
    
    sendBtn=1;
    #20000; //simulate holding the button for an obscene amount of time
    sendBtn=0;
    end
endmodule
