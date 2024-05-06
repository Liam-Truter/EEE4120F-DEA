`timescale 1ns / 1ps

module xor_encrypter_tb;
    // Inputs
    reg clk = 0;
    reg[2:0] shift = 0;
    reg[7:0] key = 0;
    reg[7:0] din = 0;
    
    // Outputs
    wire[7:0] dout;

    // Instantiate xor_encrypter module
    xor_encrypter U0 (
        .clk(clk),
        .shift(shift),
        .key(key),
        .din(din),
        .dout(dout)
    );

    always begin
        #5 clk = ~clk;
    end

    initial begin
        shift = 0;
        key = 0;
        din = 0;
    

        $display("\t\ttime,\tclk,\tkey,\t\tshift,\tdin,\t\tdout");
        $monitor("%d,\t%b\t,%b,\t%d,\t%b,\t%b", $time, clk, key, shift, din, dout);
        
        #10 din = 8'hFF;
        #10 key = 8'b10101000;
        #10 shift = 1;
        #10 shift = 2;
        #10 shift = 3;
        #10 shift = 4;
        #10 shift = 5;
        #10 shift = 6;
        #10 shift = 7;

        // End the simulation
        #10 $finish;
    end

endmodule