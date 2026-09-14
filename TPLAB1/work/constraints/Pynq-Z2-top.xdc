
## Clock 125 MHz 
set_property -dict { PACKAGE_PIN H16   IOSTANDARD LVCMOS33 } [get_ports { clock }];
create_clock -add -name sys_clk_pin -period 8.000 -waveform {0 4} [get_ports { clock }];

## Entradas de control
set_property -dict { PACKAGE_PIN M20   IOSTANDARD LVCMOS33 } [get_ports { i_sw[0] }]; #SW0  - enable
set_property -dict { PACKAGE_PIN M19   IOSTANDARD LVCMOS33 } [get_ports { i_sw[1] }]; #SW1  - sel limite (LSB)
set_property -dict { PACKAGE_PIN D19   IOSTANDARD LVCMOS33 } [get_ports { i_sw[2] }]; #BTN0 - sel limite (MSB)
set_property -dict { PACKAGE_PIN D20   IOSTANDARD LVCMOS33 } [get_ports { i_sw[3] }]; #BTN1 - color

## Reset (BTN3 - activo ALTO)
set_property -dict { PACKAGE_PIN L19   IOSTANDARD LVCMOS33 } [get_ports { i_reset }]; #BTN3

## Leds simples LD0-LD3
set_property -dict { PACKAGE_PIN R14   IOSTANDARD LVCMOS33 } [get_ports { o_led[0] }]; #LD0
set_property -dict { PACKAGE_PIN P14   IOSTANDARD LVCMOS33 } [get_ports { o_led[1] }]; #LD1
set_property -dict { PACKAGE_PIN N16   IOSTANDARD LVCMOS33 } [get_ports { o_led[2] }]; #LD2
set_property -dict { PACKAGE_PIN M14   IOSTANDARD LVCMOS33 } [get_ports { o_led[3] }]; #LD3

## Leds RGB
set_property -dict { PACKAGE_PIN L15   IOSTANDARD LVCMOS33 } [get_ports { o_led_b[0] }]; #LD4_B
set_property -dict { PACKAGE_PIN G14   IOSTANDARD LVCMOS33 } [get_ports { o_led_b[1] }]; #LD5_B
set_property -dict { PACKAGE_PIN Y18   IOSTANDARD LVCMOS33 } [get_ports { o_led_b[2] }]; #JA1 - sin led
set_property -dict { PACKAGE_PIN Y19   IOSTANDARD LVCMOS33 } [get_ports { o_led_b[3] }]; #JA2 - sin led

set_property -dict { PACKAGE_PIN G17   IOSTANDARD LVCMOS33 } [get_ports { o_led_g[0] }]; #LD4_G
set_property -dict { PACKAGE_PIN L14   IOSTANDARD LVCMOS33 } [get_ports { o_led_g[1] }]; #LD5_G
set_property -dict { PACKAGE_PIN Y16   IOSTANDARD LVCMOS33 } [get_ports { o_led_g[2] }]; #JA3 - sin led
set_property -dict { PACKAGE_PIN Y17   IOSTANDARD LVCMOS33 } [get_ports { o_led_g[3] }]; #JA4 - sin led

## Configuracion del banco
set_property CFGBVS VCCO [current_design];
set_property CONFIG_VOLTAGE 3.3 [current_design];
