library ieee;
use ieee.std_logic_1164.all;

entity tb_assembly is
end tb_assembly;

architecture behavior of tb_assembly is
  signal CLK, Reset : std_logic := '0';
  constant CLK_period : time := 10 ns;
begin
  uut: entity work.Assembly
    port map (
      CLK   => CLK,
      Reset => Reset
    );

  CLK_process: process
  begin
    CLK <= '0'; wait for CLK_period/2;
    CLK <= '1'; wait for CLK_period/2;
  end process;

  stim_proc: process
  begin
    Reset <= '1'; wait for 20 ns; -- Assert reset
    Reset <= '0'; wait for 1000 ns; -- Run for multiple cycles
    wait;
  end process;
end behavior;