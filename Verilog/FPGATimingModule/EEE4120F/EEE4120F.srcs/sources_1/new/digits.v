`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
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
    input clk_100Hz,
    input reset,
    output reg [3:0] hundredth,
    output reg [3:0] tenth,
    output reg [3:0] ones,
    output reg [3:0] tens,
    output reg [3:0] hundred
    );
    
    
    //hundredth increment control
    always@(posedge clk_100Hz or posedge reset)   begin
        if(reset)
            hundredth <=0;
            
        else
            if(hundredth==9)
                hundredth <=0;
            else
                hundredth <= hundredth+1;    
    
    end
    
    //tenth increment control
    always@(posedge clk_100Hz or posedge reset)   begin
        if(reset)
            tenth <=0;
            
        else
            if(hundredth==9)
                if(tenth == 9 )
                    tenth <=0;
                else
                    tenth <= tenth+1;    
    
    end
    
    //ones increment control
    always@(posedge clk_100Hz or posedge reset)   begin
        if(reset)
            ones <=0;
            
        else
            if(tenth==9 && hundredth==9)
                if(ones == 9 )
                    ones <=0;
                else
                    ones <= ones+1;    
    
    end
    
    //tens increment control
    always@(posedge clk_100Hz or posedge reset)   begin
        if(reset)
            tens <=0;
            
        else
            if(tenth==9 && hundredth==9 && ones==9)
                if(tens==9)
                    tens <=0;
                else
                    tens <= tens+1;    
    
    end
    
    //hundred increment control
    always@(posedge clk_100Hz or posedge reset)   begin
        if(reset)
            hundred <=0;
            
        else
            if(tenth==9 && hundredth==9 && ones==9 && tens==9)
                if(hundred==9)
                    hundred <=0;
                else
                    hundred <= hundred+1;    
        
    end
    
endmodule
