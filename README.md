# Guidelines
This repository contains code for 5 stage pipelined 32-bit processor using RISC-V Instruction Set Architecture (ISA).

#### RTL can be compiled and simulated by just running ```compile.bat``` file which i've created in the same folder
Compilation and Simulation process is explained below:

## Compilation

RTL can be compiled with the command: 

``` 
vlog names_of_all_system_verilog_files
```

or simply:

``` 
vlog *.sv 
```

Compilation creates a ``` work ``` folder in your current working directory in which all the files generated after compilation are stored.
 
## Simulation

The compiled RTL can be simulated with command:

``` 
vsim -c name_of_toplevel_module -do "run -all"
```

Simulation creates a ``` .vcd ``` file. This files contains all the simulation behaviour of design.

## Viewing the VCD Waveform File

To view the waveform of the design run the command:

```
gtkwave dumpfile_name.vcd
```
Here dumpfile_name will be ```processor.vcd```

This opens a waveform window. Pull the required signals in the waveform and verify the behaviour of the design.

## License
[CC0 1.0 Universal](LICENSE)


