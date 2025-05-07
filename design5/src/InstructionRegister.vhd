library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity InstructionRegister is
  port (
    clk          : in  std_logic;
    reset        : in  std_logic;  -- Active-high reset
    IRWrite      : in  std_logic;  -- Control signal to write to IR
    mem_data_in  : in  std_logic_vector(31 downto 0);  -- Instruction data from memory
    IR_out       : out std_logic_vector(31 downto 0)   -- Output instruction
  );
end InstructionRegister;

architecture Behavioral of InstructionRegister is
  signal IR : std_logic_vector(31 downto 0) := (others => '0');  -- Initialize to zeros
begin
  process(clk, reset)
  begin
    if reset = '1' then
      IR <= (others => '0');  -- Reset the instruction register to 0
    elsif rising_edge(clk) then
      if IRWrite = '1' then
        IR <= mem_data_in;  -- Load the instruction from memory
      end if;
    end if;
  end process;

  IR_out <= IR;  -- Assign the internal register value to the output
end Behavioral;