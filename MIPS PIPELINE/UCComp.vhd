----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/25/2022 05:25:37 PM
-- Design Name: 
-- Module Name: UCComp - Behavioral
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

entity UCComp is
    Port ( Instr : in STD_LOGIC_VECTOR (2 downto 0);
           RegDst : out STD_LOGIC;
           ExtOp : out STD_LOGIC;
           ALUSrc : out STD_LOGIC;
           Branch : out STD_LOGIC;
           Jump : out STD_LOGIC;
           ALUOp : out STD_LOGIC_VECTOR(2 downto 0);
           MemWrite : out STD_LOGIC; 
           MemtoReg : out STD_LOGIC;
           RegWrite : out STD_LOGIC;
           BranchGez : out STD_LOGIC;
           BranchNe: out STD_LOGIC);
end UCComp;

architecture Behavioral of UCComp is
begin
    
    process(Instr)
    begin 
        case Instr is 
            --R
            when "000" =>
                RegDst <= '1';
                ExtOp <= '0';
                ALUSrc <= '0';
                Branch <= '0';
                BranchGez <= '0';
                BranchNe <= '0';
                Jump <= '0';
                MemWrite <= '0';
                MemtoReg <= '0';
                RegWrite <= '1';
                ALUOp <= "000";
            --addi
            when "001" => 
                RegDst <= '0';
                ExtOp <= '1';
                ALUSrc <= '1';
                Branch <= '0';
                BranchGez <= '0';
                BranchNe <= '0';
                Jump <= '0';
                MemWrite <= '0';
                MemtoReg <= '0';
                RegWrite <= '1';
                ALUOp <= "001";
            --lw
            when "010" => 
                RegDst <= '0';
                ExtOp <= '1';
                ALUSrc <= '1';
                Branch <= '0';
                BranchGez <= '0';
                BranchNe <= '0';
                Jump <= '0';
                MemWrite <= '0';
                MemtoReg <= '1';
                RegWrite <= '1';
                ALUOp <= "010";
            --sw
            when "011" => 
                RegDst <= '0';
                ExtOp <= '1';
                ALUSrc <= '1';
                Branch <= '0';
                BranchGez <= '0';
                BranchNe <= '0';
                Jump <= '0';
                MemWrite <= '1';
                MemtoReg <= '0';
                RegWrite <= '0';
                ALUOp <= "011";
            --beq
            when "100" =>
                RegDst <= '0';
                ExtOp <= '1';
                ALUSrc <= '0';
                Branch <= '1';
                BranchGez <= '0';
                BranchNe <= '0';
                Jump <= '0';
                MemWrite <= '0';
                MemtoReg <= '0';
                RegWrite <= '0';
                ALUOp <= "100";
            --bgez
            when "101" =>
                RegDst <= '0';
                ExtOp <= '1';
                ALUSrc <= '0';
                Branch <= '0';
                BranchGez <= '1';
                BranchNe <= '0';
                Jump <= '0';
                MemWrite <= '0';
                MemtoReg <= '0';
                RegWrite <= '0';
                ALUOp <= "101";
            --bne  
            when "110" =>
                RegDst <= '0';
                ExtOp <= '1';
                ALUSrc <= '0';
                Branch <= '0';
                BranchGez <= '0';
                BranchNe <= '1';
                Jump <= '0';
                MemWrite <= '0';
                MemtoReg <= '0';
                RegWrite <= '0';
                ALUOp <= "110";
            --j
            when "111" =>
                RegDst <= '0';
                ExtOp <= '0';
                ALUSrc <= '0';
                Branch <= '0';
                BranchGez <= '0';
                BranchNe <= '0';
                Jump <= '1';
                MemWrite <= '0';
                MemtoReg <= '0';
                RegWrite <= '0';
                ALUOp <= "111";
        end case;
    end process;
    
end Behavioral;
