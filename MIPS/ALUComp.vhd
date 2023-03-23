----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/01/2022 05:24:16 PM
-- Design Name: 
-- Module Name: ALUComp - Behavioral
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
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALUComp is
    Port ( RD1 : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           ALUSrc : in STD_LOGIC;
           Ext_Imm : in STD_LOGIC_VECTOR (15 downto 0);
           sa : in STD_LOGIC;
           func : in STD_LOGIC_VECTOR (2 downto 0);
           ALUOp : in STD_LOGIC_VECTOR (2 downto 0);
           Zero : out STD_LOGIC;
           GreaterEqual: out STD_LOGIC;
           ALURes: inout STD_LOGIC_VECTOR(15 downto 0));
end ALUComp;

architecture Behavioral of ALUComp is

signal ALUCtrl : STD_LOGIC_VECTOR(2 downto 0);
signal muxOut: STD_LOGIC_VECTOR(15 downto 0);
signal auxALURes: STD_LOGIC_VECTOR(15 downto 0);

begin

process (ALUOp, func, sa)
begin 
    case ALUOp is
        when "000" => 
            if (func = "000") then
                     ALUCtrl <= "000";  --add
            end if;
            if (func = "001") then
                    ALUCtrl <= "001";   --sub 
            end if;
            if (func = "010") then 
                    ALUCtrl <= "010";   --sll
            end if;
            if (func = "011") then 
                    ALUCtrl <= "011";   --srl
            end if;
            if (func = "100") then 
                    ALUCtrl <= "100";   --and
            end if;
            if (func = "101") then 
                    ALUCtrl <= "101";   --or
            end if;
            if (func = "110") then 
                    ALUCtrl <= "110";   --xor
            end if;
            if (func = "111") then 
                    ALUCtrl <= "111";   --slt
            end if;
         when "001" => ALUCtrl <= "000";    --addi
         when "010" => ALUCtrl <= "000";    --lw
         when "011" => ALUCtrl <= "000";    --sw
         when "100" => ALUCtrl <= "001";    --beq
         when "101" => ALUCtrl <= "001";    --bgez
         when "110" => ALUCtrl <= "001";    --bne
         when others => ALUCtrl <= "000";
    end case;

end process;

muxOut <= RD2 when ALUSrc = '0' else Ext_Imm;

process (ALUCtrl, muxOut, RD1, auxALURes)
begin 
    case ALUCtrl is 
        when "000" => auxALURes <= RD1 + muxOut;
        when "001" => auxALURes <= RD1 - muxOut;
        when "010" => auxALURes <= RD1(14 downto 0) & "0";
        when "011" => auxALURes <= "0" & RD1(15 downto 1);
        when "100" => auxALURes <= RD1 and muxOut;
        when "101" => auxALURes <= RD1 or muxOut;
        when "110" => auxALURes <= RD1 xor muxOut;
        when "111" => if (RD1 < muxOut) then 
                            auxALURes <= x"0001";
                      else 
                            auxALURes <= x"0000";
                      end if;
     end case;
     
     ALURes <= auxALURes;
end process;

Zero <= '1' when auxALURes = x"0000" else '0';
GreaterEqual <= '1' when auxALURes >= x"0000" else '0';

end Behavioral;
