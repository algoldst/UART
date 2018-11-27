`timescale 1ns / 1ps

/* File: BitStreamReg_Sim.sv
 * Init: 11/17/2018 02:03:26 AM
 * Author: Alex Goldstein
 * Description: Simulates BitStreamReg on UART_Rec as it receives bitstream input.
 */

module BitStreamReg_Sim(
    );

// Instantiate Module
parameter packetSize=4; //simulate using 4 bits / bitstream packet
logic clk, LD, msbLD;
logic [1:0] shift;
logic [packetSize-1:0] dIn;
logic [packetSize-1:0] dOut = 0; //output
logic SIGNALGOT;

BitStreamReg bistreamreg_sim(.*);
  
// Simulate clk
always
    begin
    clk=1; #5; //clk period = 10ns
    clk=0; #5;
    end

// Simulate
initial
    begin
    LD<=0; msbLD<=1; shift<=0; dIn<=0; // start with rest state
    #10;
    
    LD<=1; shift<=1; //begin loading/shifting
    dIn<=1; //receive 1010010
    #1000;
    dIn<=0;
    #1000;
    dIn<=1;
    #1000;
    dIn<=0;
    #2000;
    dIn<=1;
    #1000;
    dIn<=0;
    
    
    end
endmodule
