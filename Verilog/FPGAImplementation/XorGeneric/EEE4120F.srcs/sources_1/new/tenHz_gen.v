`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Youtube Reference: FPGA Discovery How to Control 7-Segment Displays on Basys3 FPGA using Verilog in Vivado
// Authored by: David J Marion
// Published by: David J Marion
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

//Converts 100MHZ clock to 10HZ clock
module tenHz_gen( input clk_100MHz, input reset, output clk_10Hz, input hold); 

reg [22:00] ctr_reg =0; // 22 bits to cover 5 000 000 half periods
reg clk_out_reg =0; //register to hold high/low for half period

always @(posedge clk_100MHz or posedge reset) begin
    if(reset) begin //reset state
        ctr_reg <=0;
        clk_out_reg <=0;
    end
    
    else begin 
    if(hold) begin
        if(ctr_reg == 4_999_999) begin //if we reach 4_999 999 cycles invert to create 10Hz clock
            ctr_reg<=0;
            clk_out_reg<= ~clk_out_reg;
        end
        
        else begin
            ctr_reg<=ctr_reg +1; //else count register
        end
        end
    end
end

assign clk_10Hz = clk_out_reg; //assign module clock to output
            
endmodule
