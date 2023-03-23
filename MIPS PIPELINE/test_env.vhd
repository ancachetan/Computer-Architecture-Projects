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
           sa: out STD_LOGIC;
           wadr: in STD_LOGIC_VECTOR (2 downto 0));
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
           GreaterEqual: out STD_LOGIC;
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
signal en_pipeline: STD_LOGIC;
signal muxOut: STD_LOGIC_VECTOR(2 downto 0);

signal IF_ID_out, IF_ID_in: STD_LOGIC_VECTOR(31 downto 0);
signal ID_EX_in, ID_EX_out: STD_LOGIC_VECTOR (83 downto 0);
signal EX_MEM_in, EX_MEM_out: STD_LOGIC_VECTOR (58 downto 0);
signal MEM_WB_in, MEM_WB_out: STD_LOGIC_VECTOR (36 downto 0);

begin

led(12 downto 0) <= RegDst & ExtOp & ALUSrc & Branch & BranchGez & BranchNe & Jump & MemWrite & MemtoReg & RegWrite & ALUOp;
PCSrc <= (EX_MEM_out(36) and EX_MEM_out(55)) or ((not EX_MEM_out(36)) and EX_MEM_out(53)) or (EX_MEM_out(35) and EX_MEM_out(54));
WD <= MEM_WB_out (34 downto 19) when MEM_WB_out(36) = '1' else MEM_WB_out (18 downto 3);

JAdr <= IF_ID_out (31 downto 29) & IF_ID_out (12 downto 0);
BAdr <= ID_EX_out(72 downto 57) + ID_EX_out(24 downto 9);

--MPG1: MPG port map (EN, btn(0), clk);
MPG2: MPG port map (RST, btn(1), clk);
MPG3: MPG port map (en_pipeline, btn(2), clk);

IFCOMP1: IFComp port map (JAdr, BAdr, PCSrc, Jump, RST, en_pipeline, clk, Instr, NextInstr);
IDCOMP1: IDComp port map (IF_ID_out (12 downto 0), MEM_WB_out(35), RegDst, ExtOp, WD, clk, en_pipeline, RD1, RD2, Ext_Imm, func, sa, MEM_WB_out(2 downto 0));
UCCOMP1: UCComp port map (IF_ID_out (15 downto 13), RegDst, ExtOp, ALUSrc, Branch, Jump, ALUOp, MemWrite, MemtoReg, RegWrite, BranchGez, BranchNe);
ALUCOMP1: ALUComp port map (ID_EX_out(56 downto 41), ID_EX_out(40 downto 25), ID_EX_out(74), ID_EX_out(24 downto 9), sa, ID_EX_out(8 downto 6), ID_EX_out(77 downto 75), Zero, GraterEqual, ALURes);
MEMCOMP1: MEMComp port map (EX_MEM_out(56), EX_MEM_out (34 downto 19), EX_MEM_out (18 downto 3), MemData, clk);

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
         
---------------------------------------------------------MIPS pipeline---------------------------------------------------------------------------------------------
IF_ID_in (15 downto 0) <= Instr;
IF_ID_in (31 downto 16) <= NextInstr;

process(clk)
begin 
    if (en_pipeline = '1') then 
        if (rising_edge(clk)) then 
            IF_ID_out <= IF_ID_in;
        end if;
    end if;
end process;

ID_EX_in (83 downto 0) <= MemtoReg & RegWrite & MemWrite & Branch & BranchGez & BranchNe & ALUOp & ALUSrc & RegDst & IF_ID_out (31 downto 16) & RD1 & RD2 & Ext_Imm & func & IF_ID_out (9 downto 7) & IF_ID_out(6 downto 4);
                        --83          82         81         80        79          78     77...75    74       73               72...57       56...41 40...25  24...9  8...6      5...3                       2...0
process(clk)
begin 
    if (en_pipeline = '1') then 
        if (rising_edge(clk)) then 
            ID_EX_out <= ID_EX_in;
        end if;
    end if;
end process;

muxOut <= ID_EX_out (5 downto 3) when ID_EX_out(73) = '0' else ID_EX_out (2 downto 0);

EX_MEM_in (58 downto 0) <= ID_EX_out(83 downto 78) & BAdr & Zero & GraterEqual & ALURes & ID_EX_out (40 downto 25) & muxOut;
                           --58...53                 52...37   36     35         34...19    18...3                    2...0

process(clk)
begin 
    if (en_pipeline = '1') then 
        if (rising_edge(clk)) then 
            EX_MEM_out <= EX_MEM_in;
        end if;
    end if;
end process;

MEM_WB_in (36 downto 0) <= EX_MEM_out (58 downto 57) & MemData & EX_MEM_out (34 downto 19) & EX_MEM_out (2 downto 0);
                        -- 36...35                    34...19          18...3                     2...0        

process(clk)
begin 
    if (en_pipeline = '1') then 
        if (rising_edge(clk)) then 
            MEM_WB_out <= MEM_WB_in;
        end if;
    end if;
end process;

end Behavioral;
