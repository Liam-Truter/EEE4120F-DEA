module xor_encrypter (
    // Inputs
    input wire clk,         // Operating Clock
    input wire[2:0] shift,  // Number of bits to shift key by
    input wire[7:0] key,    // Key for encryption
    input wire[7:0] din,    // Data byte to encrypt

    // Outputs
    output reg[7:0] dout    // Encrypted data byte
    );

    // Local variables
    reg [7:0] shifted_key;  // Key shifted by number of bits

    always @(posedge clk) begin
        // Shift key to the left with wrap
        shifted_key <= (key << shift) | (key >> (8 - shift));
        dout <= din ^ shifted_key;
    end

endmodule