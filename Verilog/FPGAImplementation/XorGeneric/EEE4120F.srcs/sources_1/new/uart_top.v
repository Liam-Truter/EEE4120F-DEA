`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Reference Book: FPGA Prototyping By Verilog Examples Xilinx Spartan-3 Version
// Authored by: Dr. Pong P. Chu
// Published by: Wiley
//
// Adapted for the Basys 3 Artix-7 FPGA by David J. Marion
//Adapted for the Nexys 4 DDR FPGA by Moutloatsi Setlogelo
// Top Module for the Complete UART System
//
// Setup for 9600 Baud Rate
//
// For 9600 baud with 100MHz FPGA clock: 
// 9600 * 16 = 153,600
// 100 * 10^6 / 153,600 = ~651      (counter limit M)
// log2(651) = 10                   (counter bits N) 
//
// For 19,200 baud rate with a 100MHz FPGA clock signal:
// 19,200 * 16 = 307,200
// 100 * 10^6 / 307,200 = ~326      (counter limit M)
// log2(326) = 9                    (counter bits N)
//
// For 115,200 baud with 100MHz FPGA clock:
// 115,200 * 16 = 1,843,200
// 100 * 10^6 / 1,843,200 = ~52 55     (counter limit M)
// log2(52) = 6                     (counter bits N) 
//
// For 1500 baud with 100MHz FPGA clock:
// 1500 * 16 = 24,000
// 100 * 10^6 / 24,000 = ~4,167     (counter limit M)
// log2(4167) = 13                  (counter bits N) 
//
// Comments:
// - Many of the variable names have been changed for clarity
//////////////////////////////////////////////////////////////////////////////////

module uart_top
    #(
        parameter   DBITS = 8,          // number of data bits in a word
                    SB_TICK = 16,       // number of stop bit / oversampling ticks
                    BR_LIMIT = 82,     // baud rate generator counter limit
                    BR_BITS = 7,       // number of baud rate generator counter bits
                    FIFO_EXP = 2        // exponent for number of FIFO addresses (2^2 = 4)
    )
    (
        input clk_100MHz,               // FPGA clock
        input reset,                    // reset
        input read_uart,                // button
        input write_uart,               // button
        input rx,                       // serial data in
        input [DBITS-1:0] write_data,   // data from Tx FIFO
        input xorButton,
        output rx_full,                 // do not write data to FIFO
        output rx_empty,                // no data to read from FIFO
        output tx,                      // serial data out
        output [DBITS-1:0] read_data,    // data to Rx FIFO
        output ledCplt,
        output xorRdy
    );
    
    // Connection Signals
    wire tick;                          // sample tick from baud rate generator
    wire rx_done_tick;                  // data word received
    wire tx_done_tick;                  // data transmission complete
    wire tx_empty;                      // Tx FIFO has no data to transmit
    wire tx_fifo_not_empty;             // Tx FIFO contains data to transmit
    wire [DBITS-1:0] tx_fifo_out;       // from Tx FIFO to UART transmitter
    wire [DBITS-1:0] rx_data_out;       // from UART receiver to Rx FIFO
    wire [DBITS-1:0] xorData;           //xor data bits
    wire xorDone;
    //wire xorRdy;
    wire [DBITS-1:0] transform;       // from UART receiver to Rx FIFO
    reg xorStart;
    reg [7:0] key;
    reg [DBITS-1:0] xorTransform;
    
    //Baudrate generator module for UART
    baud_rate_generator 
        #(
            .M(BR_LIMIT), 
            .N(BR_BITS)
         ) 
        BAUD_RATE_GEN   
        (
            .clk_100MHz(clk_100MHz), 
            .reset(reset),
            .tick(tick)
         );
   
   //UART Receiver module. Byte is collected on every completion pulse received by rx_done_tick 
    uart_receiver
        #(
            .DBITS(DBITS),
            .SB_TICK(SB_TICK)
         )
         UART_RX_UNIT
         (
            .clk_100MHz(clk_100MHz),
            .reset(reset),
            .rx(rx),
            .sample_tick(tick),
            .data_ready(rx_done_tick),
            .data_out(rx_data_out)
         );
     

//XOR encryption Module. UART byte is passed to the module on every rx_done_tick pulse
    xorModule xorTest
    (
    .clk(clk_100MHz),
    .din(transform),
    .start_reset(reset),
    .xor_enable(xorButton),
    .dout(xorData),
    //.led_complete(ledCplt),
    //.done(xorRdy),
    .rdy(xorDone),
    .key(key)
    );     

  //UART transmitter. Encrypyted byte is pass to the module on every xorDone pulse  
    uart_transmitter
        #(
            .DBITS(DBITS),
            .SB_TICK(SB_TICK)
         )
         UART_TX_UNIT
         (
            .clk_100MHz(clk_100MHz),
            .reset(reset),
            .tx_start(xorDone),
            .sample_tick(tick),
            .data_in(xorData),
            .tx_done(tx_done_tick),
            .tx(tx)
         );
    //Fifo buffers to hold and store UART characters for reception and transmission
    fifo
        #(
            .DATA_SIZE(DBITS),
            .ADDR_SPACE_EXP(FIFO_EXP)
         )
         FIFO_RX_UNIT
         (
            .clk(clk_100MHz),
            .reset(reset),
            .write_to_fifo(rx_done_tick),
	        .read_from_fifo(read_uart),
	        .write_data_in(rx_data_out),
	        .read_data_out(read_data),
	        .empty(rx_empty),
	        .full(rx_full)            
	      );
	   
    fifo
        #(
            .DATA_SIZE(DBITS),
            .ADDR_SPACE_EXP(FIFO_EXP)
         )
         FIFO_TX_UNIT
         (
            .clk(clk_100MHz),
            .reset(reset),
            .write_to_fifo(write_uart),
	        .read_from_fifo(tx_done_tick),
	        .write_data_in(write_data),
	        .read_data_out(tx_fifo_out),
	        .empty(tx_empty),
	        .full()                // intentionally disconnected
	      );
    
    // Signal Logic
    assign tx_fifo_not_empty = ~tx_empty;
 
//check if rx_done_tick/ UART receiver pulse has changed state    
always@(rx_done_tick) begin

if(rx_done_tick && xorButton) begin //If rx_done_tick is high and XOR switch is enabled, we begin encryption on every byte
xorStart=rx_done_tick;
xorTransform = rx_data_out;
end


else if(rx_done_tick) begin //If rx_done_tick is high but XOR switch is not enabled, we begin encryption key setting
xorStart <=0;
//counter <=1'b1;
//key<=rx_data_out;
key <= rx_data_out;

end


else if(!rx_done_tick && xorButton) begin //if rx_done_tick is not high and XOr switch is enabled, we set xorModule to ignore encyrption
xorStart =0;
end

end

//signal assignments
     assign transform = xorTransform; 
     assign xorDone = xorStart;
     assign xorRdy = xorStart;
  
endmodule