----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/25/2022 02:10:28 PM
-- Design Name: 
-- Module Name: IFComp - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IFComp is
    Port ( JAdr : in STD_LOGIC_VECTOR (15 downto 0);
           BAdr : in STD_LOGIC_VECTOR (15 downto 0);
           PCSrc : in STD_LOGIC;
           Jump : in STD_LOGIC;
           RST : in STD_LOGIC;
           EN : in STD_LOGIC;
           CLK : in STD_LOGIC;
           Instr : out STD_LOGIC_VECTOR (15 downto 0);
           NextInstr : out STD_LOGIC_VECTOR (15 downto 0));
end IFComp;

architecture Behavioral of IFComp is
type ROM_type is array (0 to 255) of STD_LOGIC_VECTOR (15 downto 0);

--signal ROM: ROM_TYPE := (
--0=> b"000_001_010_011_0_000",
--1=> b"000_011_010_100_0_001",
--2=> b"000_101_000_110_1_010",
--3=> b"000_110_000_111_1_011",
--4=> b"000_001_010_011_0_100",
--5=> b"000_010_011_100_0_101",
--6=> b"000_110_101_100_0_110", 
--7=> b"000_001_010_011_1_111",
--8=> b"001_001_010_0000011", 
--9=> b"010_011_100_0000000",
--10=> b"011_110_101_0000000",
--11=> b"100_010_011_0000100",
--12=> b"101_100_000_0000101",
--13=> b"110_001_010_0000010",
--14=> b"111_0000000011001", 
--others => x"0000");

signal ROM: ROM_TYPE := (
0=> b"000_001_010_011_0_000",       --add $3, $1, $2
1=> b"000_000_000_000_0_110",       --xor $0, $0, $0
2=> b"000_000_000_000_0_110",       --xor $0, $0, $0
3=> b"000_011_000_100_1_010",       --sll $4, $3, 1
4=> b"000_101_110_111_0_000",       --add $7, $5, $6
5=> b"000_000_000_000_0_110",       --xor $0, $0, $0
6=> b"000_000_000_000_0_110",       --xor $0, $0, $0
7=> b"000_111_000_010_1_011",       --srl $2, $7, 1
8=> b"000_000_000_000_0_110",       --xor $0, $0, $0
9=> b"000_000_000_000_0_110",       --xor $0, $0, $0
10=> b"000_100_010_101_0_001",      --sub $5, $4, $2
11=> b"000_000_000_000_0_110",      --xor $0, $0, $0
12=> b"000_000_000_000_0_110",      --xor $0, $0, $0
13=> b"100_101_000_0000110",        --beq $5, $0, 0000110
14=> b"000_000_000_000_0_110",      --xor $0, $0, $0
15=> b"000_000_000_000_0_110",      --xor $0, $0, $0
16=> b"000_000_000_000_0_110",      --xor $0, $0, $0
17=> b"001_101_001_0000010",        --addi $1, $5, 0000010
18=> b"111_0000000010111",          --j 000000010111
19=> b"000_000_000_000_0_110",      --xor $0, $0, $0
20=> b"001_101_001_0000101",        --addi $1, $5, 0000101
21=> b"000_000_000_000_0_110",      --xor $0, $0, $0
22=> b"000_000_000_000_0_110",      --xor $0, $0, $0
23=> b"011_000_001_0000000",        --sw $1, 0($0)
24=> b"010_000_110_0000000",        --lw $6, 0($0)
others => x"0000");


signal PCIn: STD_LOGIC_VECTOR (15 downto 0);
signal PCOut: STD_LOGIC_VECTOR (15 downto 0);
signal muxBranch: STD_LOGIC_VECTOR (15 downto 0);

begin
process(EN, RST, CLK)
begin 
    if (RST = '1') then 
        PCOut <= x"0000";
    else if (EN = '1' and rising_edge(CLK)) then 
        PCOut <= PCIn;
        end if;
    end if;
end process;

Instr <= ROM(conv_integer(PCOut));
NextInstr <= PCOut + 1;

muxBranch <= (PCOut + 1) when PCSrc = '0' else BAdr;
PCIn <= muxBranch when Jump = '0' else JAdr;

end Behavioral;
