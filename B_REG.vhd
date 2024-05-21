library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RegB is
    Port ( Lb : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           datain : in  STD_LOGIC_VECTOR (7 downto 0);
           dataout : out  STD_LOGIC_VECTOR (7 downto 0));
end RegB;

architecture Behavioral of RegB is

signal B_content : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');

begin
process (clk)
begin
	if rising_edge(clk) then
		if Lb = '1' then
			B_content <= datain;
		end if;
	end if;
end process;
dataout <= B_content;
end Behavioral;
