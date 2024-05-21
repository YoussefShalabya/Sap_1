library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity AC is
    Port ( clk : in  STD_LOGIC;
           La : in  STD_LOGIC;
           Ea : in  STD_LOGIC;
           datain : in  STD_LOGIC_VECTOR (7 downto 0);
           dataout_bus : out  STD_LOGIC_VECTOR (7 downto 0);
           dataout_alu : out  STD_LOGIC_VECTOR (7 downto 0));
end AC;

architecture Behavioral of AC is

signal AC_content : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');

begin
process (clk)
begin
	if rising_edge(clk) then
		if La = '1' then
			AC_content <= datain;
		end if;
	end if;
end process;
dataout_alu <= AC_content;--store the data of AC in the ALU automatic As the first operand
dataout_bus <= AC_content when Ea = '1' else (others => 'Z');
end Behavioral;
