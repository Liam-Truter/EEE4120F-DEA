Fully functional XOR encryption on Nexys 4 DDR FPGA

How to use:

1) Set reset J15 high then low, display should display four
zeroes
2) Set encryption switch L16 low, and enter an 8 bit key either a ASCII/UTF-8 character or Input binary file containing key using CoolTerm Application
3) Set encryption switch L16 high, and input textfile using
CoolTerm
4) Segment display timer should start and terminate after
the last read character, with the final elapsed time
remaining
5) Encrypted characters should print to CoolTerm simulta-
neously as data is read.
6) Save the encrypted text as a textfile using CoolTerm
