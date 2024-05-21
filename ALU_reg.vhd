library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU is
    Port (
        a : in  STD_LOGIC_VECTOR (7 downto 0);
        b : in  STD_LOGIC_VECTOR (7 downto 0);
        ADD_SUB : in STD_LOGIC; 
	or_and: in std_logic;
        out_enable : in STD_LOGIC; 
        dataout : out  STD_LOGIC_VECTOR (7 downto 0)
    );
end ALU;

architecture Behavioral of ALU is
begin
    process(a, b, ADD_SUB, out_enable)
    begin
        if out_enable = '1' then
            if( ADD_SUB = '0'  and or_and ='0')then -- ADD
                dataout <= a + b;
            elsif ( ADD_SUB = '1'  and or_and ='0') then -- SUB
                dataout <= a - b;
            elsif( ADD_SUB = '0'  and or_and ='1') then -- OR
                dataout <= a or b;
            elsif ( ADD_SUB = '1'  and or_and ='1') then -- AND
                dataout <= a and b;
            else
                dataout <= (others => 'Z'); -- Others (Invalid operation)
            end if;
        else
            dataout <= (others => 'Z'); -- Output disabled
        end if;
    end process;
end Behavioral;
