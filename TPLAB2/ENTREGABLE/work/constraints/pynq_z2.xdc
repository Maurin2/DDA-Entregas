## Reloj de 125 MHz de la PYNQ-Z2
set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVCMOS33} [get_ports clk]
create_clock -period 8.000 -name sys_clk [get_ports clk]