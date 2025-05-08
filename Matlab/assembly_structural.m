function comp = assembly_structural

comp.settings.language = 'VHDL';
comp.settings.lib = 'design5';
comp.settings.entity = 'assembly';
comp.settings.arch = 'structural';
comp.settings.ahdl_path = 'd:\your data\programs\';
comp.settings.dsn_path = 'C:\My_Designs\design5\design5';
comp.settings.dsn_file = 'design5.adf';
comp.settings.wsp_path = 'C:\My_Designs\design5';
comp.settings.wsp_file = 'design5.aws';
comp.settings.wave = 0;
comp.settings.active = 1;
comp.settings.inputs = 2;
comp.settings.outputs = 0;


comp.port(1).type = 0;
comp.port(1).name = 'CLK';
comp.port(1).size = 1;
comp.port(1).fract = 0;
comp.port(1).signed = 0;
comp.port(1).quant = 0;
comp.port(1).ovf = 0;
comp.port(1).hdl = 'std_logic';
comp.port(2).type = 0;
comp.port(2).name = 'Reset';
comp.port(2).size = 1;
comp.port(2).fract = 0;
comp.port(2).signed = 0;
comp.port(2).quant = 0;
comp.port(2).ovf = 0;
comp.port(2).hdl = 'std_logic';

comp.include(1).value = 'library ieee;';
comp.include(2).value = 'use ieee.numeric_std.all;';
comp.include(3).value = 'use ieee.std_logic_1164.all;';

comp.src(1).file = 'C:\My_Designs\design5\design5/src/Assembly.vhd';
comp.src(2).file = 'C:\My_Designs\design5\design5/src/InstructionRegister.vhd';
comp.src(3).file = 'C:\My_Designs\design5\design5/src/alu.vhd';
comp.src(4).file = 'C:\My_Designs\design5\design5/src/alu_control_unit.vhd';
comp.src(5).file = 'C:\My_Designs\design5\design5/src/controlunit.vhd';
comp.src(6).file = 'C:\My_Designs\design5\design5/src/memory.vhd';
comp.src(7).file = 'C:\My_Designs\design5\design5/src/mux_2in_32bit.vhd';
comp.src(8).file = 'C:\My_Designs\design5\design5/src/mux_2in_5bit.vhd';
comp.src(9).file = 'C:\My_Designs\design5\design5/src/mux_3in_32bit.vhd';
comp.src(10).file = 'C:\My_Designs\design5\design5/src/mux_4in_32bit.vhd';
comp.src(11).file = 'C:\My_Designs\design5\design5/src/pc.vhd';
comp.src(12).file = 'C:\My_Designs\design5\design5/src/register_file.vhd';
comp.src(13).file = 'C:\My_Designs\design5\design5/src/shiftleft.vhd';
comp.src(14).file = 'C:\My_Designs\design5\design5/src/shiftleft2.vhd';
comp.src(15).file = 'C:\My_Designs\design5\design5/src/sign_extend.vhd';
comp.src(16).file = 'C:\My_Designs\design5\design5/src/temp_register_aluout.vhd';
comp.src(17).file = 'C:\My_Designs\design5\design5/src/temp_register_dmr.vhd';


