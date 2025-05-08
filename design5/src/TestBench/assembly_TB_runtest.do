SetActiveLib -work
comp -include "$DSN\src\controlunit.vhd" 
comp -include "$DSN\src\mux_3in_32bit.vhd" 
comp -include "$DSN\src\mux_2in_32bit.vhd" 
comp -include "$DSN\src\temp_register_dmr.vhd" 
comp -include "$DSN\src\temp_register_aluout.vhd" 
comp -include "$DSN\src\alu_control_unit.vhd" 
comp -include "$DSN\src\alu.vhd" 
comp -include "$DSN\src\mux_4in_32bit.vhd" 
comp -include "$DSN\src\shiftleft2.vhd" 
comp -include "$DSN\src\shiftleft.vhd" 
comp -include "$DSN\src\sign_extend.vhd" 
comp -include "$DSN\src\mux_2in_5bit.vhd" 
comp -include "$DSN\src\register_file.vhd" 
comp -include "$DSN\src\InstructionRegister.vhd" 
comp -include "$DSN\src\memory.vhd" 
comp -include "$DSN\src\pc.vhd" 
comp -include "$DSN\src\Assembly.vhd" 
comp -include "$DSN\src\TestBench\assembly_TB.vhd" 
asim TESTBENCH_FOR_assembly 
wave 
wave -noreg CLK
wave -noreg Reset
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$DSN\src\TestBench\assembly_TB_tim_cfg.vhd" 
# asim TIMING_FOR_assembly 
