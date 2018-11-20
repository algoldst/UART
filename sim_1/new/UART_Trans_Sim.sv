`timescale 1ns / 1ps

/* File: UART_Trans_Sim.sv
 * Init: 11/16/2018 07:02:22 PM
 * Author: Alex Goldstein
 * Description: Simulates sending a bitstream via UART_Trans
 */

module UART_Trans_Sim(
    );
parameter [5:0] packetSize=4; //# bits / bitstream packet
UART_Trans #(packetSize,100,2) uart_trans(.*);
            // ([packetSize],[cycleDiv],[propDelayOffset])

logic clk; //inputs
logic sendBtn;
logic [packetSize-1:0] data;
logic bsOut, sendSig; //outputs

logic firstClk=1;
always
    begin
    if(firstClk) //setup initial clk hold so that sclk events align with integer time-steps
        begin
        clk=0;
        #10; //wait 1 period
        firstClk=0;
        end
    clk = 1; #5; //.5 period
    clk = 0; #5; //.5 period
    end
    
initial
    begin
    data=13; sendBtn=0; //start in rest state
    #1000;
    sendBtn=1; // simulate send button press for 100 clk cycles
    #1000;
    sendBtn=0; // due to propogation delay, don't be surprised if the output bitstream doesn't look like the input data
    end
endmodule
