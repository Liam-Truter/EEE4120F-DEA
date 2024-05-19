`timescale 1ns/10ps

//`include "UART_TX.v"

module UART_TB1 ();

  // Testbench uses a 25 MHz clock
  // Want to interface to 115200 baud UART
  // 25000000 / 115200 = 217 Clocks Per Bit.
  parameter c_CLOCK_PERIOD_NS = 40;
  parameter c_CLKS_PER_BIT    = 217;
  parameter c_BIT_PERIOD      = 8600;
  
  reg r_Clock = 0;
  reg r_TX_DV = 0;
  wire w_TX_Active, w_UART_Line;
  wire w_TX_Serial;
  reg[2:0] shift = 0;
    reg[7:0] key = 0;
    reg[7:0] din = 0;
    reg start_reset = 0;
    reg xor_enable = 0;
    reg improved_encrypt_enable = 0;
	reg last_data = 0;
  reg [7:0] r_TX_Byte = 8'h00;
  reg [31:0] start_time, end_time; // Variables to store start and end times
  wire [7:0] w_RX_Byte;
  wire[7:0] dout;
    wire led_complete;
	
	// Instantiate xor_encrypter module
    xor_encrypter U0 (
        .clk(r_Clock),
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
  
  UART_RX #(.CLKS_PER_BIT(c_CLKS_PER_BIT)) UART_RX_Inst
    (.i_Clock(r_Clock),
     .i_RX_Serial(w_UART_Line),
     .o_RX_DV(w_RX_DV),
     .o_RX_Byte(w_RX_Byte)
     );
  
  UART_TX #(.CLKS_PER_BIT(c_CLKS_PER_BIT)) UART_TX_Inst
    (.i_Clock(r_Clock),
     .i_TX_DV(r_TX_DV),
     .i_TX_Byte(r_TX_Byte),
     .o_TX_Active(w_TX_Active),
     .o_TX_Serial(w_TX_Serial),
     .o_TX_Done()
     );

  // Keeps the UART Receive input high (default) when
  // UART transmitter is not active
  assign w_UART_Line = w_TX_Active ? w_TX_Serial : 1'b1;
    
  always
    #(c_CLOCK_PERIOD_NS/2) r_Clock <= !r_Clock;
  
  // Main Testing:
  initial
    begin
	
	shift = 0;
        key = 0;
        din = 0;
        start_reset = 0;
        xor_enable = 0;
        improved_encrypt_enable = 0;
    
        #100 din = 8'h61; // was 8'h3F
        #100 key = 8'b10000000; // was 10101000
        
		$display("TESTING SIMPLER CIPHER");
		#100 xor_enable = 1;
        #100 shift = 0; // was 7
		#100 last_data = 1;
		#100 xor_enable = 0;
	
      // Tell UART to send a command (exercise TX)
      @(posedge r_Clock);
      @(posedge r_Clock);
	  start_time = $time; // Capture start time
      r_TX_DV   <= 1'b1;
      r_TX_Byte <= dout;
      @(posedge r_Clock);
      r_TX_DV <= 1'b0;
	  #100;
      // Check that the correct command was received
      @(posedge w_RX_DV);
	  end_time = $time; // Capture end time
      if (w_RX_Byte == 8'hE1) // was 6B
        $display("Test Passed - Correct Byte Received");
      else
        $display("Test Failed - Incorrect Byte Received");
		$display("Cipher input = %b", din);
		$display("Received Byte = %b", w_RX_Byte);
		// Calculate and display the total transfer and receive time
		$display("Total transfer and receive time: %0d ns", end_time - start_time);
      $finish();
    end
  
  initial 
  begin
    // Required to dump signals to EPWave
    // $dumpfile("dump.vcd");
    // $dumpvars(0);
  end

endmodule