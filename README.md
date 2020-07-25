# Introduction
This project is going to hold the Minimig project running on the QMTech Artix-7A100T Core board, with the Open AARS 

TODO: Add more information

# Rebuild the project

```bash
rm -rf project_1
# vivado -source rebuild.tcl
```

# Generate the project script

When Vivado is open, enter the following into the 'TCL console'.

```tcl
write_project_tcl <project_path>/rebuild.tcl
```

# Information about the project setup

[Original repo](https://github.com/jhallen/vivado\_setup)


