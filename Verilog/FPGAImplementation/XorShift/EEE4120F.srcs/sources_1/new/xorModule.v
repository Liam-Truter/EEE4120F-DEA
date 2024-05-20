module xorModule (
    // Inputs
    input wire clk,                 // Operating Clock
    input wire rdy,
    input wire[7:0] din,            // Data byte to encrypt
    input wire start_reset,         // Start/Reset switch
    input wire xor_enable,          // XOR Encryption switch
    input wire [7:0] key,
    // Outputs
    output reg [7:0] dout           // Encrypted data byte
    //output reg led_complete,         // LED for completed state
    //output reg done
    );
    
    reg[2:0] shift;
    //reg[7:0] key=8'b0000_1001;
    //reg[7:0] xorTransform
    //reg counter;
    
    wire [7:0] shiftWire;
   
    assign shiftWire=(key << shift) | (key >> (8 - shift));
    
    always @(posedge clk or posedge start_reset or posedge rdy) begin

        if (start_reset) begin
            shift<=3'b000;
            //shiftWire<=0;
            end 
        
         else begin
         
         if(rdy) begin
            
            dout = shiftWire ^ din;
            shift <= shift+1;

         end

         
         end   
            
     end   
     
//     //assign shiftWire=shift;
     
//      always@(posedge rdy) begin
//if(rdy) begin
//dout = din^key;
////shift<=shift+1;

////done=rdy;
//end

//end    

endmodule