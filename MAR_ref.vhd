library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MAR is
    Port ( MAR_in : in  STD_LOGIC;
           clk : in  STD_LOGIC;
			  addr_in : in STD_LOGIC_VECTOR (3 downto 0);
           addr_out : out  STD_LOGIC_VECTOR (3 downto 0));
end MAR;

architecture Behavioral of MAR is

signal MAR_content : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');

begin
process (clk)
begin
	if rising_edge(clk) then
		if MAR_in = '1' then
			MAR_content <= addr_in;
		end if;
	end if;
end process;
addr_out <= MAR_content;
end Behavioral;
