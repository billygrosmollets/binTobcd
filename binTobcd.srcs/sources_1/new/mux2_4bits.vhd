library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2_4bits is
	Port ( 
    		e0 : in  STD_LOGIC_VECTOR (3 downto 0);
			e1 : in  STD_LOGIC_VECTOR (3 downto 0);
			e2 : in  STD_LOGIC_VECTOR (3 downto 0);
			e3 : in  STD_LOGIC_VECTOR (3 downto 0);
			sel : in  STD_LOGIC_VECTOR (1 downto 0);
			s : out  STD_LOGIC_VECTOR (3 downto 0));
end mux2_4bits;

architecture Behavioral of mux2_4bits is
begin
	with sel select
		s <= 	e0 when "00",
				e1 when "01",
				e2 when "10",
				e3 when others;
end Behavioral;
