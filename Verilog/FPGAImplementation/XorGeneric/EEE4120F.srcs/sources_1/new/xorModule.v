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
    
     
      always@(posedge rdy) begin //waits for positive edge from rx_done_tick to begin encryption
if(rdy) begin
dout = din^key;
//shift<=shift+1;

//done=rdy;
end

end    

endmodule