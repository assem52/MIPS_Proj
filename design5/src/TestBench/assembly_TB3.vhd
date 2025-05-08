---------------------------------------------------------------------------------------------------
--
-- Title       : Test Bench for assembly
-- Design      : design5
-- Author      : Assem_CS
-- Company     : n
--
---------------------------------------------------------------------------------------------------
--
-- File        : $DSN\src\TestBench\assembly_TB3.vhd
-- Generated   : 5/8/2025, 1:06 AM
-- From        : $DSN\src\Assembly.vhd
-- By          : Active-HDL Built-in Test Bench Generator ver. 1.2s
--
---------------------------------------------------------------------------------------------------
--
-- Description : Automatically generated Test Bench for assembly_tb3
--
---------------------------------------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity assembly_tb3 is
end assembly_tb3;

architecture TB_ARCHITECTURE of assembly_tb3 is
	-- Component declaration of the tested unit
	component assembly
	port(
		CLK : in std_logic;
		Reset : in std_logic );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal CLK : std_logic;
	signal Reset : std_logic;
	-- Observed signals - signals mapped to the output ports of tested entity

	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : assembly
		port map (
			CLK => CLK,
			Reset => Reset
		);

	-- Add your stimulus here ...

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_assembly of assembly_tb3 is
	for TB_ARCHITECTURE
		for UUT : assembly
			use entity work.assembly(behavioral);
		end for;
	end for;
end TESTBENCH_FOR_assembly;

