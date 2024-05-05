`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.05.2024 15:48:41
// Design Name: 
// Module Name: seg7_control
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


module seg7_control( 
    input clk_100MHz,
    input reset,
    input [3:0] hundredth,
    input [3:0] tenth,
    input [3:0] ones,
    input[3:0] tens,
    input [3:0] hundred,
    output reg [6:0] seg, //segments
    output reg [7:0] digit // to turn on the 8 anodes

    );
    
    parameter ZERO = 7'b000_0001; //1
    parameter ONE = 7'b100_1111; //2
    parameter TWO = 7'b001_0010; //3
    parameter THREE = 7'b000_0110; //4
    parameter FOUR = 7'b100_1100; //5
    parameter FIVE = 7'b010_0100; //6
    parameter SIX = 7'b010_0000; //7
    parameter SEVEN = 7'b000_1111; //8
    parameter EIGHT = 7'b000_0000; //0
    parameter NINE = 7'b000_0100; //9
    
    // To select each digit in turn
    reg[2:0] digit_select; //Need 5 digits, 3 bits
    reg[16:0] digit_timer; // counter for digit refresh
    
    //logic for controlling digit select and timer
    always @(posedge clk_100MHz or posedge reset) begin
    
        if(reset) begin
            digit_select<=0;
            digit_timer<=0;
        end
        
        else
            
            if(digit_timer==99_999) begin
                digit_timer<=0;
            //digit_select=digit_select +1;
            
                if(digit_select<5) begin                       
                    digit_select<=digit_select+1; //changing digit led
                end
                
                else begin
                    digit_select<=0;
                end
                
            end
            
            else
                digit_timer <= digit_timer +1;
            
    
    end
    
    always @(digit_select) begin
        case(digit_select)
            3'b000: digit = 8'b1111_1011; //Turn on hundreth digit anode
            3'b001: digit = 8'b1111_0111; //Turn on tenth digit
            3'b010: digit = 8'b1110_1111; //Turn on ones digit
            3'b011: digit = 8'b1101_1111; //Turn on tens digit
            3'b100: digit = 8'b1011_1111; //Turn on hundred digit
            
        endcase
    
    end
    
    always @*
        case(digit_select)
            3'b000 : begin //Hundredth digit
                        case(hundredth)
                            4'b0000: seg = ZERO;
                            4'b0001: seg = ONE;
                            4'b0010: seg = TWO;
                            4'b0011: seg = THREE;
                            4'b0100: seg = FOUR;
                            4'b0101: seg = FIVE;
                            4'b0110: seg = SIX;
                            4'b0111: seg = SEVEN;
                            4'b1000: seg = EIGHT;
                            4'b1001: seg = NINE;
                        endcase   
                     end   
                     
          3'b001 : begin //Tenth digit
                        case(tenth)
                            4'b0000: seg = ZERO;
                            4'b0001: seg = ONE;
                            4'b0010: seg = TWO;
                            4'b0011: seg = THREE;
                            4'b0100: seg = FOUR;
                            4'b0101: seg = FIVE;
                            4'b0110: seg = SIX;
                            4'b0111: seg = SEVEN;
                            4'b1000: seg = EIGHT;
                            4'b1001: seg = NINE;
                        endcase   
                     end           
                     
       3'b010 : begin //ones digit
                        case(ones)
                            4'b0000: seg = ZERO;
                            4'b0001: seg = ONE;
                            4'b0010: seg = TWO;
                            4'b0011: seg = THREE;
                            4'b0100: seg = FOUR;
                            4'b0101: seg = FIVE;
                            4'b0110: seg = SIX;
                            4'b0111: seg = SEVEN;
                            4'b1000: seg = EIGHT;
                            4'b1001: seg = NINE;
                        endcase   
                     end    
                     
                     
       3'b011 : begin //tens digit
                        case(tens)
                            4'b0000: seg = ZERO;
                            4'b0001: seg = ONE;
                            4'b0010: seg = TWO;
                            4'b0011: seg = THREE;
                            4'b0100: seg = FOUR;
                            4'b0101: seg = FIVE;
                            4'b0110: seg = SIX;
                            4'b0111: seg = SEVEN;
                            4'b1000: seg = EIGHT;
                            4'b1001: seg = NINE;
                        endcase   
                     end 
                     
                     
       3'b100 : begin //Hundred digit
                        case(hundred)
                            4'b0000: seg = ZERO;
                            4'b0001: seg = ONE;
                            4'b0010: seg = TWO;
                            4'b0011: seg = THREE;
                            4'b0100: seg = FOUR;
                            4'b0101: seg = FIVE;
                            4'b0110: seg = SIX;
                            4'b0111: seg = SEVEN;
                            4'b1000: seg = EIGHT;
                            4'b1001: seg = NINE;
                        endcase   
                     end                                     
   endcase     
endmodule
