library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is
  port (
    clk        : in std_logic;
    write      : in std_logic;
    read       : in std_logic;
    address    : in std_logic_vector(4 downto 0); -- 5-bit address for 32 words
    write_data : in std_logic_vector(31 downto 0); -- data in
    read_data  : out std_logic_vector(31 downto 0) -- data out
  );
end memory;

architecture behavioral of memory is
  type mem_type is array (0 to 127) of std_logic_vector(7 downto 0); -- 128 bytes (32 words)   >> word = 4 bytes
  signal mem : mem_type := (
    -- Preloaded instructions (word-aligned, little-endian)
    -- lw $R0,47($R20)
    0 => "10001110",
    1 => "10000000",
    2 => "00000000",
    3 => "00101111",
    -- addi $R1,$R3,50
    4 => "00100000",
    5 => "01100001",
    6 => "00000000",
    7 => "00110010",
    -- addi $R2,$R3,48
    8 => "00100000",
    9 => "01100010",
    10 => "00000000",
    11 => "00110000",
    -- add $R2,$R2,$R0
    12 => "00000000",
    13 => "01000000",
    14 => "00010000",
    15 => "00100000",
    -- beq $R1,$R2,1
    16 => "00010000",
    17 => "00100010",
    18 => "00000000",
    19 => "00000001",
    -- j 3
    20 => "00001000",
    21 => "00000000",
    22 => "00000000",
    23 => "00000011",
    -- add $R0,$R1,$R2
    24 => "00000000",
    25 => "00100010",
    26 => "00000000",
    27 => "00100000",
    -- lw $R10,47($R20)
    28 => "10001110",
    29 => "10001010",
    30 => "00000000",
    31 => "00101111",
    -- Data at address 47 (word-aligned: 47*4 = 188, but adjusted to fit)
    124 => "00000001", -- Data at approximate word address 31
    others => "00000000"
  );
  signal read_data_reg : std_logic_vector(31 downto 0); -- Registered output
begin
  process(clk)
  begin
    if rising_edge(clk) then
      -- Synchronous write (word-aligned)
      if write = '1' then
        mem(to_integer(unsigned(address) & "00"))     <= write_data(31 downto 24);
        mem(to_integer(unsigned(address) & "00") + 1) <= write_data(23 downto 16);
        mem(to_integer(unsigned(address) & "00") + 2) <= write_data(15 downto 8);
        mem(to_integer(unsigned(address) & "00") + 3) <= write_data(7 downto 0);
      end if;
      -- Synchronous read (word-aligned)
      if read = '1' then
        read_data_reg <= mem(to_integer(unsigned(address) & "00")) &
                         mem(to_integer(unsigned(address) & "00") + 1) &
                         mem(to_integer(unsigned(address) & "00") + 2) &
                         mem(to_integer(unsigned(address) & "00") + 3);
      else
        read_data_reg <= (others => '0'); -- Default output
      end if;
    end if;
  end process;

  read_data <= read_data_reg;
end behavioral;