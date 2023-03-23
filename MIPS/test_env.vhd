----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/18/2022 04:32:53 PM
-- Design Name: 
-- Module Name: saqwdf - Behavioral
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

entity saqwdf is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end saqwdf;

architecture Behavioral of saqwdf is

component MPG is
    Port ( en : out STD_LOGIC;
           input : in STD_LOGIC;
           clk : in STD_LOGIC);
end component;

component SSD is
    Port ( nr : in STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           clk : in STD_LOGIC);
end component;

component IFComp is
    Port ( JAdr : in STD_LOGIC_VECTOR (15 downto 0);
           BAdr : in STD_LOGIC_VECTOR (15 downto 0);
           PCSrc : in STD_LOGIC;
           Jump : in STD_LOGIC;
           RST : in STD_LOGIC;
           EN : in STD_LOGIC;
           CLK : in STD_LOGIC;
           Instr : out STD_LOGIC_VECTOR (15 downto 0);
           NextInstr : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component IDComp is
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
end component;

component UCComp is
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
end component;

component ALUComp is
    Port ( RD1 : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           ALUSrc : in STD_LOGIC;
           Ext_Imm : in STD_LOGIC_VECTOR (15 downto 0);
           sa : in STD_LOGIC;
           func : in STD_LOGIC_VECTOR (2 downto 0);
           ALUOp : in STD_LOGIC_VECTOR (2 downto 0);
           Zero : out STD_LOGIC;
           ALURes: inout STD_LOGIC_VECTOR(15 downto 0));
end component;

component MEMComp is
    Port ( MemWrite : in STD_LOGIC;
           ALURes : inout STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           MemData : out STD_LOGIC_VECTOR (15 downto 0);
           CLK : in STD_LOGIC);
end component;

signal Instr : STD_LOGIC_VECTOR (15 downto 0);
signal RegDst, ExtOp, ALUSrc, Branch, Jump, MemWrite, MemtoReg, RegWrite, BranchGez, BranchNe, PCSrc : STD_LOGIC;
signal ALUOp : STD_LOGIC_VECTOR(2 downto 0);

signal Zero, GraterEqual: STD_LOGIC;
signal WD: STD_LOGIC_VECTOR(15 downto 0);
signal RD1, RD2, Ext_Imm, MemData, ALURes: STD_LOGIC_VECTOR(15 downto 0);
signal RST, EN: STD_LOGIC;
signal NextInstr: STD_LOGIC_VECTOR(15 downto 0);
signal JAdr, BAdr: STD_LOGIC_VECTOR(15 downto 0);
signal func: STD_LOGIC_VECTOR (2 downto 0);
signal sa: STD_LOGIC;

signal verif: STD_LOGIC_VECTOR (15 downto 0);

begin

led(12 downto 0) <= RegDst & ExtOp & ALUSrc & Branch & BranchGez & BranchNe & Jump & MemWrite & MemtoReg & RegWrite & ALUOp;
PCSrc <= (Zero and Branch) or ((not Zero) and BranchNe) or (GraterEqual and BranchGez);
WD <= MemData when MemtoReg = '1' else ALURes;

JAdr <= NextInstr(15 downto 13) & Instr(12 downto 0);
BAdr <= NextInstr + Ext_Imm;

MPG1: MPG port map (EN, btn(0), clk);
MPG2: MPG port map (RST, btn(1), clk);

IFCOMP1: IFComp port map (JAdr, BAdr, PCSrc, Jump, RST, EN, clk, Instr, NextInstr);
IDCOMP1: IDComp port map (Instr (12 downto 0), RegWrite, RegDst, ExtOp, WD, clk, EN, RD1, RD2, Ext_Imm, func, sa);
UCCOMP1: UCComp port map (Instr (15 downto 13), RegDst, ExtOp, ALUSrc, Branch, Jump, ALUOp, MemWrite, MemtoReg, RegWrite, BranchGez, BranchNe);
ALUCOMP1: ALUComp port map (RD1, RD2, ALUSrc, Ext_Imm, sa, func, ALUOp, Zero, ALURes);
MEMCOMP1: MEMComp port map (MemWrite, ALURes, RD2, MemData, clk);

SSD1 : SSD port map(verif, an, cat, clk);

with sw(2 downto 0) Select
verif <= Instr when "000",
         NextInstr when "001",
         RD1 when "010",
         RD2 when "011",
         Ext_Imm when "100",
         ALURes when "101",
         MemData when "110",
         WD when "111";

end Behavioral;
