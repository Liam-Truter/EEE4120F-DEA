`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.05.2024 15:48:41
// Design Name: 
// Module Name: hundredHz_gen
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

//Converts 100MHZ clock to 100HZ clock
module hundredHz_gen( input clk_100MHz, input reset, output clk_100Hz); 

reg [18:00] ctr_reg =0; // 19 bits to cover 500 000 half periods
reg clk_out_reg =0; //register to hold high/low for half period

always @(posedge clk_100MHz or posedge reset) begin
    if(reset) begin //reset state
        ctr_reg <=0;
        clk_out_reg <=0;
    end
    
    else begin
        if(ctr_reg == 499_999) begin //if we reach 499 999 cycles invert 100Hz clock
            ctr_reg<=0;
            clk_out_reg<= ~clk_out_reg;
        end
        
        else begin
            ctr_reg<=ctr_reg +1; //else count register
        end
    end
end

assign clk_100Hz = clk_out_reg; //assign module clock to output
            
endmodule
