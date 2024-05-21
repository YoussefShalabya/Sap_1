library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SAP1 is
    Port ( clk : in  STD_LOGIC;
           clr : in  STD_LOGIC;
           dataout : out  STD_LOGIC_VECTOR (7 downto 0));
end SAP1;

architecture Structural of SAP1 is

component ALU is
    Port ( a : in  STD_LOGIC_VECTOR (7 downto 0);
           b : in  STD_LOGIC_VECTOR (7 downto 0);
			  ADD_SUB: in STD_LOGIC;
			  or_and:in std_logic;
			  out_enable : in STD_LOGIC;
           dataout : out  STD_LOGIC_VECTOR (7 downto 0));
end component;


component MEM is
    Port ( address : in  STD_LOGIC_VECTOR (3 downto 0);
           dataout : out  STD_LOGIC_VECTOR (7 downto 0);
           RAM_EN : in  STD_LOGIC);
end component;


component PC is
    Port ( inc : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           clr : in  STD_LOGIC;
           EN : in  STD_LOGIC;
           addr_out : out  STD_LOGIC_VECTOR (3 downto 0));
end component;


component MAR is
    Port ( MAR_in: in  STD_LOGIC;
           clk : in  STD_LOGIC;
			  addr_in : in STD_LOGIC_VECTOR (3 downto 0);
           addr_out : out  STD_LOGIC_VECTOR (3 downto 0));
end component;


component RegB is
    Port ( Lb : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           datain : in  STD_LOGIC_VECTOR (7 downto 0);
           dataout : out  STD_LOGIC_VECTOR (7 downto 0));
end component;

component AC is
    Port ( clk : in  STD_LOGIC;
           La : in  STD_LOGIC;
           Ea : in  STD_LOGIC;
           datain : in  STD_LOGIC_VECTOR (7 downto 0);
           dataout_bus : out  STD_LOGIC_VECTOR (7 downto 0);
           dataout_alu : out  STD_LOGIC_VECTOR (7 downto 0));
end component;

component IR is
    Port ( clk : in  STD_LOGIC;
           clr : in  STD_LOGIC;
           Li : in  STD_LOGIC;
           Ei : in  STD_LOGIC;
           inst_in : in  STD_LOGIC_VECTOR (7 downto 0);
           opcode_out : out  STD_LOGIC_VECTOR (3 downto 0);
           addr_out : out  STD_LOGIC_VECTOR (3 downto 0));
end component;


component OutReg is
    Port ( clk : in  STD_LOGIC;
           Lo : in  STD_LOGIC;
           datain : in  STD_LOGIC_VECTOR (7 downto 0);
           dataout : out  STD_LOGIC_VECTOR (7 downto 0));
end component;


component Controller is
    Port ( clk : in  STD_LOGIC;
			  clr : in  STD_LOGIC;
			  inst_in : in STD_LOGIC_VECTOR (3 downto 0);
			  inc : out STD_LOGIC;
			  EN : out STD_LOGIC;
			  MAR_in : out STD_LOGIC;
			  RAM_en : out STD_LOGIC;
			  Li : out STD_LOGIC;
			  Ei : out STD_LOGIC;
			  La : out STD_LOGIC;
			  Ea : out STD_LOGIC;
			  ADD_SUB : out STD_LOGIC;
			  or_and : out STD_LOGIC;
			  out_enable : out STD_LOGIC;
			  Lb : out STD_LOGIC;
			  Lo : out STD_LOGIC;
			  HLT : out STD_LOGIC := '1');
end component;

signal active_clk : STD_LOGIC :=  clk;
signal a, b, bus_signal : STD_LOGIC_VECTOR (7 downto 0);
signal inc,EN, MAR_in, RAM_en, Li, Ei, La, Ea, ADD_SUB,or_and, out_enable, Lb, Lo : STD_LOGIC := '0';
signal HLT : STD_LOGIC := '1';
signal MAR_out, IR_out : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');

begin

active_clk <= HLT and clk;

-- Note that all components give high impedance output in case they're not enabled. 
-- Hence, we don't have to make selection logic on the bus signal, as Controller will only enable one component at a time.

ALU_cmp : ALU port map (a, b, ADD_SUB,or_and, out_enable, bus_signal);
MEM_cmp : MEM port map (MAR_out, bus_signal, RAM_EN);
PC_cmp : PC port map (inc, active_clk, clr, EN, bus_signal(3 downto 0));
MAR_cmp : MAR port map (MAR_in, active_clk, bus_signal(3 downto 0), MAR_out);
RegB_cmp : RegB port map (Lb, active_clk, bus_signal, b);
AC_cmp : AC port map (active_clk, La, Ea, bus_signal, bus_signal, a);
IR_cmp : IR port map (active_clk, clr, Li, Ei, bus_signal, IR_out, bus_signal(3 downto 0));
OutReg_cmp : OutReg port map (active_clk, Lo, bus_signal, dataout);
Control: Controller port map (clk, clr, IR_out, inc, EN, MAR_in, RAM_en, Li, Ei, La, Ea, ADD_SUB,or_and, out_enable, Lb, Lo, HLT);

end Structural;
