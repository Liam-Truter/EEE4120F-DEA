`timescale 1ns / 1ps

module xor_encrypter_tb;
    // Inputs
    reg clk = 0;
    reg[2:0] shift = 0;
    reg[7:0] key = 0;
    reg[7:0] din = 0;
    reg start_reset = 0;
    reg xor_enable = 0;
    reg improved_encrypt_enable = 0;
	reg last_data = 0;
    
    // Outputs
    wire[7:0] dout;
    wire led_complete;

    // Instantiate xor_encrypter module
    xor_encrypter U0 (
        .clk(clk),
        .shift(shift),
        .key(key),
        .din(din),
        .start_reset(start_reset),
        .xor_enable(xor_enable),
        .improved_encrypt_enable(improved_encrypt_enable),
		.last_data(last_data),
        .dout(dout),
        .led_complete(led_complete)
    );

    always begin
        #5 clk = ~clk;
    end

    initial begin
        shift = 0;
        key = 0;
        din = 0;
        start_reset = 0;
        xor_enable = 0;
        improved_encrypt_enable = 0;
    

        $display("\t\ttime,\tclk,\tkey,\t\tshift,\tdin,\t\tstart_reset,\txor_enable,\timproved_enable,\tdout,\t\tled_complete");
        $monitor("%d,\t%b\t,%b,\t%d,\t%b,\t\t%b,\t\t%b,\t\t%b,\t\t%b,\t\t%b", $time, clk, key, shift, din, start_reset, xor_enable, improved_encrypt_enable, dout, led_complete);
        
        #10 din = 8'hFF;
        #10 key = 8'b10101000;
        $display("TESTING RESET");
		#10 start_reset = 1;
		#10 start_reset = 0;
		$display("TESTING SIMPLER CIPHER");
		#10 xor_enable = 1;
		#10 shift = 1;
        #10 shift = 2;
        #10 shift = 3;
        #10 shift = 4;
        #10 shift = 5;
        #10 shift = 6;
        #10 shift = 7;
		#10 last_data = 1;
		#10 xor_enable = 0;

        // End the simulation
        #10 $finish;
    end

endmodule
