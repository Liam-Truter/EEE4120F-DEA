set_property IOSTANDARD LVCMOS33 [get_ports {digit[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {digit[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {digit[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {digit[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports clk_100MHz]
set_property PACKAGE_PIN E3 [get_ports clk_100MHz]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk_100MHz]
set_property PACKAGE_PIN J17 [get_ports {digit[0]}]
set_property PACKAGE_PIN J18 [get_ports {digit[1]}]
set_property PACKAGE_PIN T9 [get_ports {digit[2]}]

set_property IOSTANDARD LVCMOS33 [get_ports {digit[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {digit[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {digit[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {digit[4]}]
set_property PACKAGE_PIN J14 [get_ports {digit[3]}]
set_property PACKAGE_PIN P14 [get_ports {digit[4]}]
set_property PACKAGE_PIN T14 [get_ports {digit[5]}]
set_property PACKAGE_PIN K2 [get_ports {digit[6]}]
set_property PACKAGE_PIN U13 [get_ports {digit[7]}]
set_property PACKAGE_PIN T10 [get_ports {seg[6]}]
set_property PACKAGE_PIN R10 [get_ports {seg[5]}]
set_property PACKAGE_PIN K16 [get_ports {seg[4]}]
set_property PACKAGE_PIN K13 [get_ports {seg[3]}]
set_property PACKAGE_PIN P15 [get_ports {seg[2]}]
set_property PACKAGE_PIN T11 [get_ports {seg[1]}]
set_property PACKAGE_PIN L18 [get_ports {seg[0]}]


set_property PACKAGE_PIN M13 [get_ports hold]
set_property IOSTANDARD LVCMOS33 [get_ports hold]


##Buttons
## btnL
set_property PACKAGE_PIN P17 [get_ports btn]
set_property IOSTANDARD LVCMOS33 [get_ports btn]

## btnR
set_property PACKAGE_PIN J15 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

##USB-RS232 Interface
set_property PACKAGE_PIN C4 [get_ports rx]
set_property IOSTANDARD LVCMOS33 [get_ports rx]
set_property PACKAGE_PIN D4 [get_ports tx]
set_property IOSTANDARD LVCMOS33 [get_ports tx]




set_property PACKAGE_PIN V11 [get_ports led]
set_property IOSTANDARD LVCMOS33 [get_ports led]
set_property PACKAGE_PIN L16 [get_ports xorBtn]
set_property IOSTANDARD LVCMOS33 [get_ports xorBtn]




set_property IOSTANDARD LVCMOS33 [get_ports resetOut]
set_property PACKAGE_PIN H17 [get_ports resetOut]
set_property PACKAGE_PIN K15 [get_ports xorBtnOut]
set_property IOSTANDARD LVCMOS33 [get_ports xorBtnOut]
