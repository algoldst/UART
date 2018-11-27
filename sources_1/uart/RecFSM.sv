`timescale 1ns / 1ps

/* File: RecFSM.sv
 * Init: 11/16/2018 09:06:46 PM
 * Author: Alex Goldstein
 * Description: Triggers BitStreamReg shiftReg to begin/end accepting bits from bitstream.
 *     1. Receives ifRecSig, indicates Trans is going to send 3 sclk cycles later
 *     2. Tells shiftReg to accept bits for [packetSize] sclk cycles
 *     3. Rest state causes shiftReg to stop, hold value.
 */

// packetSize: # bits per bitstream
module RecFSM #(parameter packetSize=4)(
    input clk, // clk receives from sclk
    input ifRecSig,
    output logic [1:0] regShift, //controls for shiftReg
    output logic regLD
    );

// Set states
localparam [3:0] rest=0, receiving=1;
logic [3:0] PS = rest, NS = rest;

// FSM Logic
logic [15:0] bitsReceived = 0;
always_ff @(posedge clk)
    begin
    PS = NS; //advance to next state at each clock edge
    //except we need to return to rest when all bits in a packet have been received
    if(bitsReceived == packetSize)
        begin
        PS=rest;
        bitsReceived=0;
        end
    
    case(PS)
        rest: // do nothing. Reg holds value.
            begin
            regShift=0;
            regLD=0;
            if(ifRecSig) NS=receiving; //when we receive the signal from Trans
            else NS=rest;
            end
        receiving: //This state occurs when ifRecSig==1, even when ifRecSig goes back to zero.
            begin
            regShift=1; //start shifting, loading the register (reg shifts, then loads, so we can turn both off simultaneously, and it will not shift the last bit
            regLD=1;
            bitsReceived += 1;
            NS=receiving; // Stay in this state until bitsReceived==packetSize.
            end
        endcase
    
    end

endmodule
