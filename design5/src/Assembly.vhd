library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Assembly is
  port (
    CLK   : in std_logic;
    Reset : in std_logic
  );
end Assembly;

architecture Structural of Assembly is
  -- Signals
  signal PC_out, PC_in, Mem_addr, Mem_data, IR_out, Reg_A, Reg_B, ALU_A, ALU_B, ALU_result, ALU_out, Mem_data_reg, Write_data : std_logic_vector(31 downto 0);
  signal Write_reg_addr : std_logic_vector(4 downto 0);
  signal Sign_ext_out, Shift_left_out, Jump_addr_full : std_logic_vector(31 downto 0);
  signal Jump_addr : std_logic_vector(27 downto 0);
  signal ALU_control : std_logic_vector(3 downto 0);
  signal PCWriteCond, PCWrite, IorD, MemRead, MemWrite, MemToReg, IRWrite, ALUSrcA, RegWrite, RegDst, Zero : std_logic;
  signal PCSource, ALUOp, ALUSrcB : std_logic_vector(1 downto 0);
  signal PC_load, IR_en, A_B_en, ALUout_en, DMR_en : std_logic;
  signal Instruction : std_logic_vector(31 downto 0); -- Alias for IR_out

  -- Constants
  constant FOUR : std_logic_vector(31 downto 0) := x"00000004"; -- For PC + 4

begin
  -- Control Signals
  PC_load <= PCWrite or (PCWriteCond and Zero); -- PC update condition
  IR_en   <= IRWrite; -- Instruction Register enable
  A_B_en  <= '1'; -- Always enable A and B registers (simplification)
  ALUout_en <= '1'; -- Always enable ALUout register (simplification)
  DMR_en  <= '1'; -- Always enable Data Memory Register (simplification)

  -- Compute Jump Address
  Jump_addr_full <= PC_out(31 downto 28) & Jump_addr; -- Concatenate Jump_addr with upper 4 bits of PC

  -- Program Counter
  PC_inst : entity work.PC
    port map (
      clk     => CLK,
      load    => PC_load,
      reset   => Reset,
      PCcount => '1', -- Increment PC by 4 each cycle (simplification)
      DATAin  => PC_in,
      DATAout => PC_out
    );

  -- Memory Address Mux
  Mem_addr_mux : entity work.mux_2_32
    port map (
      in0    => PC_out,
      in1    => ALU_out,
      sel    => IorD,
      output => Mem_addr
    );

  -- Memory
  Mem_inst : entity work.memory
    port map (
      clk        => CLK,
      write      => MemWrite,
      read       => MemRead,
      address    => Mem_addr(4 downto 0), -- Use lower 5 bits
      write_data => Reg_B,
      read_data  => Mem_data
    );

  -- Instruction Register
  IR_inst : entity work.InstructionRegister
    port map (
      clk          => CLK,
      reset        => Reset,
      IRWrite      => IR_en,
      mem_data_in  => Mem_data,
      IR_out       => IR_out
    );

  -- Alias for instruction fields
  Instruction <= IR_out;

  -- Register File
  Reg_file_inst : entity work.register_file
    port map (
      clk       => CLK,
      writeEN   => RegWrite,
      write     => Write_reg_addr,
      read1     => Instruction(25 downto 21), -- rs
      read2     => Instruction(20 downto 16), -- rt
      datawrite => Write_data,
      dataread1 => Reg_A,
      dataread2 => Reg_B
    );

  -- Register Write Address Mux
  Reg_dst_mux : entity work.mux_2_5
    port map (
      in0    => Instruction(20 downto 16), -- rt
      in1    => Instruction(15 downto 11), -- rd
      sel    => RegDst,
      output => Write_reg_addr
    );

  -- Sign Extend
  Sign_ext_inst : entity work.sign_extend
    port map (
      input         => Instruction(15 downto 0),
      sign_extended => Sign_ext_out
    );

  -- Shift Left for Branch
  Shift_left_inst : entity work.shiftLeft
    port map (
      input   => Sign_ext_out,
      shifted => Shift_left_out
    );

  -- Shift Left for Jump
  Shift_left2_inst : entity work.shiftLeft2
    port map (
      input   => Instruction(25 downto 0),
      shifted => Jump_addr
    );

  -- ALU Source A Mux
  ALU_A_mux : entity work.mux_2_32
    port map (
      in0    => PC_out,
      in1    => Reg_A,
      sel    => ALUSrcA,
      output => ALU_A
    );

  -- ALU Source B Mux
  ALU_B_mux : entity work.mux4
    port map (
      in0    => Reg_B,
      in1    => FOUR,
      in2    => Sign_ext_out,
      in3    => Shift_left_out,
      sel    => ALUSrcB,
      output => ALU_B
    );

  -- ALU
  ALU_inst : entity work.ALU
    port map (
      operand1   => ALU_A,
      operand2   => ALU_B,
      ALUcontrol => ALU_control,
      result     => ALU_result,
      zero       => Zero
    );

  -- ALU Control Unit
  ALU_ctrl_inst : entity work.ALU_Control_Unit
    port map (
      opcode      => Instruction(31 downto 26),
      funct_field => Instruction(5 downto 0),
      ALUcontrol  => ALU_control
    );

  -- ALU Output Register
  ALU_out_inst : entity work.temp_register_ALUout
    port map (
      clk     => CLK,
      en      => ALUout_en,
      datain  => ALU_result,
      dataout => ALU_out
    );

  -- Data Memory Register
  DMR_inst : entity work.temp_register_DMR
    port map (
      clk     => CLK,
      en      => DMR_en,
      datain  => Mem_data,
      dataout => Mem_data_reg
    );

  -- Write Back Mux
  Write_back_mux : entity work.mux_2_32
    port map (
      in0    => ALU_out,
      in1    => Mem_data_reg,
      sel    => MemToReg,
      output => Write_data
    );

  -- PC Source Mux
  PC_source_mux : entity work.mux3
    port map (
      in0    => ALU_result, -- PC + 4 or ALU result
      in1    => ALU_out,    -- Branch target
      in2    => Jump_addr_full, -- Jump address
      sel    => PCSource,
      output => PC_in
    );

  -- Control Unit
  Ctrl_unit_inst : entity work.ControlUnit
    port map (
      CLK         => CLK,
      Reset       => Reset,
      Op          => Instruction(31 downto 26),
      PCWriteCond => PCWriteCond,
      PCWrite     => PCWrite,
      IorD        => IorD,
      MemRead     => MemRead,
      MemWrite    => MemWrite,
      MemToReg    => MemToReg,
      IRWrite     => IRWrite,
      PCSource    => PCSource,
      ALUOp       => ALUOp,
      ALUSrcB     => ALUSrcB,
      ALUSrcA     => ALUSrcA,
      RegWrite    => RegWrite,
      RegDst      => RegDst
    );

end Structural;