`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.05.2024 15:48:41
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
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
output [6:0] seg,
output [7:0] digit

    );
    
wire w_100Hz;
wire [4:0] w_100ths, w_10ths , w_1s,w_10s , w_100s;


hundredHz_gen hz100(.clk_100MHz(clk_100MHz), .reset(reset), .clk_100Hz(w_100Hz));

digits digs(.clk_100Hz(w_100Hz), .reset(reset) , .hundredth(w_100ths), .tenth(w_10ths), .ones(w_1s), .tens(w_10s), .hundred(w_100s));

seg7_control seg7(.clk_100MHz(clk_100MHz), .reset(reset), .hundredth(w_100ths), .tenth(w_10ths), .ones(w_1s), .tens(w_10s), .hundred(w_100s), .seg(seg), .digit(digit)); 
endmodule
