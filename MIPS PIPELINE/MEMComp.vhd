----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/07/2022 01:16:06 PM
-- Design Name: 
-- Module Name: MEMComp - Behavioral
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

entity MEMComp is
    Port ( MemWrite : in STD_LOGIC;
           ALURes : inout STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           MemData : out STD_LOGIC_VECTOR (15 downto 0);
           CLK : in STD_LOGIC);
end MEMComp;

architecture Behavioral of MEMComp is
type RAM_type is array(0 to 255) of STD_LOGIC_VECTOR (15 downto 0);

signal RAM: RAM_type := (others => x"0000");

begin

process(clk)
begin 
    if rising_edge(clk) then 
        if MemWrite = '1' then 
            RAM(conv_integer(ALURes)) <= RD2;
        else
            MemData <= RAM (conv_integer(ALURes));
        end if;
     end if;
end process;


end Behavioral;
