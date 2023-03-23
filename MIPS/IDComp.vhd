----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/25/2022 04:35:59 PM
-- Design Name: 
-- Module Name: IDComp - Behavioral
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

entity IDComp is
    Port ( Instr : in STD_LOGIC_VECTOR (12 downto 0);
           RegWrite : in STD_LOGIC;
           RegDst : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           WD : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           en : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           RD2 : out STD_LOGIC_VECTOR (15 downto 0);
           Ext_Imm: out STD_LOGIC_VECTOR (15 downto 0);
           func: out STD_LOGIC_VECTOR (2 downto 0);
           sa: out STD_LOGIC);
end IDComp;

architecture Behavioral of IDComp is
type reg_array is array (0 to 7) of STD_LOGIC_VECTOR (15 downto 0);
signal reg_file: reg_array := (
                                x"0000", 
                                x"000A", 
                                x"0002", 
                                x"0000",
                                x"0000",
                                x"0004",
                                x"0006",
                                others => x"0000");

signal wa: STD_LOGIC_VECTOR (2 downto 0); 
                        
begin
with RegDst select 
    wa <= Instr(6 downto 4) when '1',
          Instr(9 downto 7) when '0', 
          (others => 'X') when others;
          
process (clk)
begin
    if (rising_edge(clk)) then 
        if (en = '1' and RegWrite = '1') then 
            reg_file(conv_integer(wa)) <= WD;
        end if;
    end if;
end process;

RD1 <= reg_file(conv_integer(Instr(12 downto 10)));
RD2 <= reg_file(conv_integer(Instr(9 downto 7)));

process(ExtOp, Instr)
begin 
    if (ExtOp = '0') then 
        Ext_Imm <= "000000000" & Instr(6 downto 0);
    end if;
    
    if (ExtOp = '1' and Instr(6) = '1') then 
        Ext_Imm <= "111111111" & Instr(6 downto 0);
    elsif (ExtOp = '1' and Instr(6) = '0') then 
        Ext_Imm <= "000000000" & Instr(6 downto 0);
    end if;

end process;

sa <= Instr(3);
func <= Instr(2 downto 0);

end Behavioral;
