`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Youtube Reference: FPGA Discovery How to Control 7-Segment Displays on Basys3 FPGA using Verilog in Vivado
// Authored by: David J Marion
// Published by: David J Marion

// 
// Create Date: 04.05.2024 15:48:41
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// Adapted for the Nexys 4 DDR FPGA by Moutloatsi Setlogelo
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
input clk_100MHz,
input reset,
input hold,
output [6:0] seg,
output [7:0] digit

    );
    
wire w_10Hz;
wire [3:0] w_10ths , w_1s,w_10s , w_100s;


tenHz_gen hz10(.clk_100MHz(clk_100MHz), .reset(reset), .clk_10Hz(w_10Hz), .hold(hold));

digits digs(.clk_10Hz(w_10Hz), .reset(reset) , .tenth(w_10ths), .ones(w_1s), .tens(w_10s), .hundred(w_100s));

seg7_control seg7(.clk_100MHz(clk_100MHz), .reset(reset), .tenth(w_10ths), .ones(w_1s), .tens(w_10s), .hundred(w_100s), .seg(seg), .digit(digit)); 
endmodule
