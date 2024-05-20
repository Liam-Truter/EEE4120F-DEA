`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Reference Book: FPGA Prototyping By Verilog Examples Xilinx Spartan-3 Version
// Authored by: Dr. Pong P. Chu
// Published by: Wiley
//
// Adapted for the Basys 3 Artix-7 FPGA by David J. Marion
//Adapted for the Nexys 4 DDR FPGA by Moutloatsi Setlogelo
// UART System Verification Circuit
//
// Comments:
// - Many of the variable names have been changed for clarity
//////////////////////////////////////////////////////////////////////////////////

module uart_test
(
    input clk_100MHz,       // Neyxs FPGA clock signal
    input reset,            // reset switch J15
    input rx,               // USB-RS232 Rx line
    input btn,              // btnL (read and write FIFO operation)
    input xorBtn,           // Switch L16
    output tx,              // USB-RS232 Tx line
    output led,             //Output Led
    input hold,             //Output timer hold
    output [6:0] seg,       // Segmentation display segments
    output [7:0] digit,     // Digit counter for segmentaion display
    output resetOut,        // Reset led for reset switch
    output xorBtnOut        // XOR led for XOR Switch

    );
    
    // Connection Signals
    wire rx_full, rx_empty, btn_tick, recFin, xorFin;
    wire [7:0] rec_data1; wire [7:0] rec_data;
    wire btnPress;
    reg butt; wire timeHold;
    reg[31:0] timeout; reg MoreData; reg timerStart,waitTime;
    
    //LED Switch Assignments
    assign resetOut = reset;
    assign xorBtnOut = xorBtn;
    
    // Complete UART Core
    uart_top UART_UNIT
        (
            .clk_100MHz(clk_100MHz),
            .reset(reset),
            .read_uart(btn_tick),
            .write_uart(btn_tick),
            .rx(rx),
            .write_data(rec_data1),
            .rx_full(rx_full),
            .rx_empty(rx_empty),
            .read_data(rec_data),
            .tx(tx),
            .xorButton(xorBtn),
            .ledCplt(led),
            .xorRdy(recFin)
        );
            

    
    // Button Debouncer Trial Test
//    debounce_explicit BUTTON_DEBOUNCER
//        (
//            .clk_100MHz(clk_100MHz),
//            .reset(reset),
//            .btn(butt),         
//            .db_level(),  
//            .db_tick(btn_tick)
//        );
        
 //Segmentaion display timer control       
        top uartTop 
  (
  .clk_100MHz(clk_100MHz),
  .reset(reset),
  .hold(timeHold),
   .seg(seg),
    .digit(digit)
  );
        
        
        
    
//    // Signal Logic    
//  assign rec_data1 = rec_data + 1;    // add 1 to ascii value of received data (to transmit)
//  //assign timeHold = recFin & xorBtn;
//  //assign timeHold = recFin & xorBtn;
  
 
 
 //Always block to sense the rx line recFin and waits until no more pulses before stopping the timer 
  always@(posedge clk_100MHz or posedge reset or posedge recFin) begin
  
  if(reset) begin
    timeout<=0;
    MoreData<=0;
    timerStart<=0;
    waitTime<=0;
  end  
  else begin
  
  if(recFin && xorBtn)begin //check if the rx line and xorSwitch are both positive, resets the timeout counter
  
  timerStart<=1;
  timeout<=0;
  end  
  
  else if(!recFin && xorBtn && timerStart) begin //if rx is low, we start the timout counter.
  
  timeout <=timeout+1;
  
  if(timeout>=1000000)begin  //If timeout exceeds 1 micro second, we stop
    MoreData<=0;
    timerStart<=0;
    end
  end
    
  
  
  end
  end
  
  
  assign timeHold=timerStart;
 
  
endmodule