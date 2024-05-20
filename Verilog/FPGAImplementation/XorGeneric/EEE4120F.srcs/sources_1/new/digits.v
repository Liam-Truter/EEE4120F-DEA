`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Youtube Reference: FPGA Discovery How to Control 7-Segment Displays on Basys3 FPGA using Verilog in Vivado
// Authored by: David J Marion
// Published by: David J Marion
// Create Date: 04.05.2024 15:48:41
// Design Name: 
// Module Name: digits
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

//Decimals bits incrementer with reset control
module digits( 
    input clk_10Hz,
    input reset,
    output reg [3:0] tenth, //to hold value for display 1 0-9
    output reg [3:0] ones, //to hold value for display 2 0-9
    output reg [3:0] tens, //to hold value for display 3 0-9
    output reg [3:0] hundred //To hold value for display 4 0-9
    );
    
    

    //tenth increment control
    always@(posedge clk_10Hz or posedge reset)   begin
        if(reset)
            tenth <=0;
            
        else
            
                if(tenth == 9 )
                    tenth <=0;
                else
                    tenth <= tenth+1;    
    
    end
    
    //ones increment control
    always@(posedge clk_10Hz or posedge reset)   begin
        if(reset)
            ones <=0;
            
        else
            if(tenth==9)
                if(ones == 9 )
                    ones <=0;
                else
                    ones <= ones+1;    
    
    end
    
    //tens increment control
    always@(posedge clk_10Hz or posedge reset)   begin
        if(reset)
            tens <=0;
            
        else
            if(tenth==9 && ones==9)
                if(tens==9)
                    tens <=0;
                else
                    tens <= tens+1;    
    
    end
    
    //hundred increment control
    always@(posedge clk_10Hz or posedge reset)   begin
        if(reset)
            hundred <=0;
            
        else
            if(tenth==9 /*&& hundredth==9 */&& ones==9 && tens==9)
                if(hundred==9)
                    hundred <=0;
                else
                    hundred <= hundred+1;    
        
    end
endmodule
