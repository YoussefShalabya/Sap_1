library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PC is
    Port ( inc : in  STD_LOGIC;--pc incrment 
           clk : in  STD_LOGIC;--fallaing edge triggered
           clr : in  STD_LOGIC;--active low
           EN : in  STD_LOGIC;--pc out enable 
           addr_out : out  STD_LOGIC_VECTOR (3 downto 0));--the out put of pc as 4 bit address
end PC;

architecture Behavioral of PC is

signal PC_content : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');

begin
process (clk, clr)
begin
	if clr = '0' then
		PC_content <= (others => '0');
	elsif falling_edge(clk) then
		if inc= '1' then
			PC_content <= PC_content + 1;
		end if;
	end if;
end process;
addr_out <= PC_content when EN = '1' else (others => 'Z');
end Behavioral;
