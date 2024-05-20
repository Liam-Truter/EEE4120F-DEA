`timescale 1ms / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.05.2024 16:40:26
// Design Name: 
// Module Name: digits_tb
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


module digits_tb();

reg clk;
reg rst;
wire [3:0] hundredth;
wire [3:0] tenth;
wire [3:0] ones;
wire [3:0] tens;
wire [3:0] hundred;
    

digits dut(.clk_100Hz(clk), .reset(rst) , .hundredth(hundredth) ,.tenth(tenth), .ones(ones), .tens(tens), .hundred(hundred));

initial begin
   clk=1'b0;
   #30
   forever
   #5
    clk = ~clk;
    //#20//5ns delay
    end;   
    
initial begin
    rst = 1'b1;
    #10
    rst = !rst;
end    

initial begin
    #50000000; 
    $stop;
end

endmodule
