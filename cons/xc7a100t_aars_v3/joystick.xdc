# Paul Honig 2020
#
# I/O Board
# Open AARS board V2
#
# Core board
# QMTech Artix-7XC7A100T Core Board
#
# Joystick layout [5:0]
# fire2[5],
# fire[4],
# up[3],
# down[2],
# left[1],
# right[0]

# Joystick SPI interface to the MCP23S17 I/O extender
set_property PACKAGE_PIN V21 [get_ports JS_MOSI]
set_property IOSTANDARD LVCMOS33 [get_ports JS_MOSI]
# Right
set_property PACKAGE_PIN U21 [get_ports JS_MISO]
set_property IOSTANDARD LVCMOS33 [get_ports JS_MISO]
# Left
set_property PACKAGE_PIN W23 [get_ports JS_CS]
set_property IOSTANDARD LVCMOS33 [get_ports JS_CS]
# Down
set_property PACKAGE_PIN V23 [get_ports JS_INTA]
set_property IOSTANDARD LVCMOS33 [get_ports JS_INTA]
# Fire
# set_property PACKAGE_PIN Y23 [get_ports {JS_INTB}]
# set_property IOSTANDARD LVCMOS33 [get_ports {JS_INTB}]
# UP
set_property PACKAGE_PIN Y22 [get_ports JS_SCK]
set_property IOSTANDARD LVCMOS33 [get_ports JS_SCK]

# Constrain timing on the Joystick port




























