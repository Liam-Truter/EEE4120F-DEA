`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Reference Book: FPGA Prototyping By Verilog Examples Xilinx Spartan-3 Version
// Authored by: Dr. Pong P. Chu
// Published by: Wiley
//
// Adapted for the Basys 3 Artix-7 FPGA by David J. Marion
//
// UART System Verification Circuit
//
// Comments:
// - Many of the variable names have been changed for clarity
//////////////////////////////////////////////////////////////////////////////////

module uart_test
(
    input clk_100MHz,       // basys 3 FPGA clock signal
    input reset,            // btnR    
    input rx,               // USB-RS232 Rx
    input btn,              // btnL (read and write FIFO operation)
    input xorBtn,
    output tx,              // USB-RS232 Tx
    output led,
    input hold,
    output [6:0] seg,
    output [7:0] digit,
    output resetOut,
    output xorBtnOut

    );
    
    // Connection Signals
    wire rx_full, rx_empty, btn_tick, recFin, xorFin;
    wire [7:0] rec_data1; wire [7:0] rec_data;
    wire btnPress;
    reg butt; wire timeHold;
    reg[31:0] timeout; reg MoreData; reg timerStart,waitTime;
    
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
            

    
    // Button Debouncer
    debounce_explicit BUTTON_DEBOUNCER
        (
            .clk_100MHz(clk_100MHz),
            .reset(reset),
            .btn(butt),         
            .db_level(),  
            .db_tick(btn_tick)
        );
        
        top uartTop 
  (
  .clk_100MHz(clk_100MHz),
  .reset(reset),
  .hold(timeHold),
   .seg(seg),
    .digit(digit)
  );
        
        
        
    
    // Signal Logic    
  assign rec_data1 = rec_data + 1;    // add 1 to ascii value of received data (to transmit)
  //assign timeHold = recFin & xorBtn;
  //assign timeHold = recFin & xorBtn;
  
  always@(posedge clk_100MHz or posedge reset or posedge recFin) begin
  
  if(reset) begin
    timeout<=0;
    MoreData<=0;
    timerStart<=0;
    waitTime<=0;
  end  
  else begin
  
  if(recFin && xorBtn)begin
  
  timerStart<=1;
  timeout<=0;
  end  
  
  else if(!recFin && xorBtn && timerStart) begin
  
  timeout <=timeout+1;
  
  if(timeout>=1000000)begin
    MoreData<=0;
    timerStart<=0;
    end
  end
    
  
  
  end
  end
  
//  always@(posedge recFin) begin
  
//  if(recFin && xorBtn)begin
  
//  timerStart<=1;
//  end
  
//  end
  
  assign timeHold=timerStart;
 
  
endmodule