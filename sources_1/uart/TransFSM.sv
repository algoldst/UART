`timescale 1ns / 1ps

/* File: TransFSM.sv
 * Init: 11/16/2018 04:42:38 PM
 * Author: Alex Goldstein
 * Description: FSM for UART_Trans. Holds register value unless button input (ifSend) is received, then begins bitshift and sends transmission signal to Receiver.
 */

module TransFSM #(parameter packetSize=4, propDelayOffset=0)(
    input clk,
    input ifSend, //if send button is pressed
    output logic regLD=0,  //start state doesn't let register load
    output logic sendSig=0,
    output logic [1:0] regShift=1 //shift right (initially, this makes sure we are clearing the register if there isn't anything in it)
    );
  
// States
localparam [3:0] rest=0, sendFirst=1, sendRemaining=2;

logic [3:0] PS = rest;
logic [3:0] NS = rest;

// FSM Logic
logic [15:0] bitsSent = 0;
logic [5:0] propDelayCounter = 0; //Due to propogation delays, we need to delay sending the bitstream by a clock cycle or two. Use this to adjust.
always_ff @ (posedge clk) 
    begin
    PS = NS; //advance to next state on clock edge
    if(bitsSent == packetSize) PS=rest; //unless we've sent all the bits in a packet; in this case, return to rest

    case(PS)
        rest:
            begin
            regShift = 1; regLD = 0; //don't load the register, continually shift (to clear) the register
            sendSig = 0;
            bitsSent = 0; //reset bitsSent from last run
            propDelayCounter = 0; //reset propDelayCounter from last run
            if(ifSend) NS = sendFirst; //go to sendFirst when btn is pressed
            else NS = rest;
            end
        sendFirst: //send first bit by loading it data into register
            begin
            regLD = 1; regShift = 0;
            sendSig = 1; //notify receiver to receive bitstream
            NS=sendRemaining;
            bitsSent = 1; //we've sent the first bit
            end
        sendRemaining:
            begin
            if(propDelayCounter < propDelayOffset) propDelayCounter++; //don't send the second bit until propDelayOffset sclk cycles have passed. This only applies to hold the first bit; the remaining bits don't get delayed.
            else
                begin
                regLD = 0; regShift = 1; //Don't let the reg load anymore, just shift on each sclk edge
                sendSig = 0; //sendSig is brief, it only needs to be HIGH to notify for the beginning.
                bitsSent = bitsSent+1; //if all packets are sent, the if(bitsSent==packetSize) will kick us back to the rest state.
                NS = sendRemaining; //otherwise keep looping; we have more bits to send
                end
            end
        endcase
    end
endmodule
