#
# Paul Honig 2020
#
# I/O Board
# Open AARS board V2
#
# Core board
# QMTech Artix-7XC7A100T Core Board

# Core board LED
set_property PACKAGE_PIN J19 [get_ports CORE_LED]
set_property IOSTANDARD LVCMOS33 [get_ports CORE_LED]

# LEDS
set_property PACKAGE_PIN T24 [get_ports {BOARD_LEDS[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BOARD_LEDS[0]}]
set_property PACKAGE_PIN Y25 [get_ports {BOARD_LEDS[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BOARD_LEDS[1]}]
set_property PACKAGE_PIN W21 [get_ports {BOARD_LEDS[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BOARD_LEDS[2]}]
set_property PACKAGE_PIN AB24 [get_ports {BOARD_LEDS[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BOARD_LEDS[3]}]























