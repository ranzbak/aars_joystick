# Introduction
This project is going to hold the Minimig project running on the QMTech Artix-7A100T Core board, with the Open AARS V3.0 board.

The GPIO ports are being read via SPI, and the output of the ports is being mapped mapped on the board LEDs.
Because there are 4 LEDS and 6 input lines from the Joystick, some leds light up fore 2 IO lines.

A debug core is included to show the SPI interaction.

# Making changes to this project

Please make sure to read the [Vivado\_setup](https://github.com/jhallen/vivado\_setup) document before making changes to the project.

Most important to take away from the document above is to **NOT** have source/ip/constraint files inside the Vivado project.

# (Re)build the Vivado project from TCL

```bash
rm -rf project_1
# vivado -source rebuild.tcl
```

After this the project XPR file can be found in the project_1 directory.

# Generate the project script

When Vivado is open, enter the following into the 'TCL console'.

```tcl
write_project_tcl <project_path>/rebuild.tcl
```

This step should be done before checking changes to the project into Git, to make sure the project can be recreated correctly.

# Information about the project setup

[Original repo](https://github.com/jhallen/vivado\_setup)


