
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Controller is
    Port ( clk : in  STD_LOGIC;
			  clr : in  STD_LOGIC;
			  inst_in : in STD_LOGIC_VECTOR (3 downto 0);
			  inc : out STD_LOGIC;
			  EN : out STD_LOGIC;
			  MAR_in: out STD_LOGIC;
			  RAM_EN: out STD_LOGIC;
			  Li : out STD_LOGIC;
			  Ei : out STD_LOGIC;
			  La : out STD_LOGIC;
			  Ea : out STD_LOGIC;
			  ADD_SUB : out STD_LOGIC;
 			  or_and : out STD_LOGIC;
			  out_enable : out STD_LOGIC;
			  Lb : out STD_LOGIC;
			  Lo : out STD_LOGIC;
			  HLT : out STD_LOGIC);
end Controller;

architecture Behavioral of Controller is

type state is (idle, t0, t1, t2, t3, t4, t5);
signal pr_state, nx_state : state := t0;
signal control_signal : STD_LOGIC_VECTOR (12 downto 0) := (others => '0');
signal HLT_sig : STD_LOGIC := '1';

begin

-- This process if for updating current state.
process(clk, clr)
begin
	if clr = '0' then
		pr_state <= idle;
	elsif rising_edge(clk) then
		pr_state <= nx_state;
	end if;
end process;


-- This process does the actual transition logic and operations.
process(pr_state)
begin
	case pr_state is
		when idle =>
			--Do nothing
			control_signal <= "0000000000000";
			HLT_sig <= '1';
			nx_state <= t0;

		when t0 =>
			--Enable PC (Ep = 1), Load into MAR (Lm = 1)
			control_signal <= "0110000000000";
			nx_state <= t1;
		
		when t1 =>
			--Increment PC (Cp = 1)
			control_signal <= "1000000000000";
			nx_state <= t2;
		
		when t2 =>
			--Enable memory (CE = 1), Load into IR (Li = 1)
			control_signal <= "0001100000000";
			nx_state <= t3;
			
		when t3 =>
			--OUT
			if inst_in = "1110" then
				--Enable AC, Load into OUT
				control_signal <= "0000000100001";
			--HALT
			elsif inst_in = "1111" then
				control_signal <= "0000000000000";
				HLT_sig <= '0';
			--Other instructions
			else
				control_signal <= "0010010000000";
			end if;
			nx_state <= t4;
		
		when t4 =>
			--LDA
			if inst_in = "0000" then
				--Enable memory, Load into AC
				control_signal <= "0001001000000";
			--ADD
			elsif inst_in = "0001" then
				--Enable memory, Load into B
				control_signal <= "0001000000010";
			--SUB
			elsif inst_in = "0010" then
				--Enable memory, Load into B
				control_signal <= "0001000000010";
			--or
			elsif inst_in = "0110" then
				--Enable memory, Load into B
				control_signal <= "0001000000010";
			--and
			elsif inst_in = "0011" then
				--Enable memory, Load into B
				control_signal <= "0001000000010";
			--Other instructions
			else
				control_signal <= "0000000000000";
			end if;
			nx_state <= t5;
			
		when t5 =>
			--ADD
			if inst_in = "0001" then
				--Enable ALU, Load into AC,add_sub=0 &or_and =0 for add
				control_signal <= "0000001000100";
			--SUB

			elsif inst_in = "0010" then
				--Enable ALU, Load into AC,add_sub=1 &or_and =0 for sub
				control_signal <= "0000001010100";
			--or
			elsif inst_in = "0110" then
				--Enable ALU, Load into AC,add_sub=0 &or_and =1 for or
				control_signal <= "0000001001100";
			--and
			elsif inst_in = "0011" then
				--Enable ALU, Load into AC,add_sub=1n &or_and =1 for and
				control_signal <= "0000001011100";
			--Other instructions
			else
				control_signal <= "0000000000000";
			end if;
			nx_state <= t0;
			
	end case;
end process;

--Move control signal to output

inc <= control_signal(12);--pc increment
EN <= control_signal(11);--pc out enable
MAR_in <= control_signal(10);--mar in enable
RAM_EN <= control_signal(9);--ram in emable
Li <= control_signal(8);--loab ir enable
Ei <= control_signal(7);--out ir enable 
La <= control_signal(6);--load ac enable  
Ea <= control_signal(5);--out ac enable
ADD_SUB<= control_signal(4);--add or sub signal
or_and<=control_signal(3);--or /and signal
out_enable <= control_signal(2);--alu ot enable
Lb <= control_signal(1);--load reg b enable
Lo <= control_signal(0);--load output reg enable
HLT <= HLT_sig;--stop system signal

end Behavioral;