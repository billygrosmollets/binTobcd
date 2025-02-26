
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cpt_mod4 is
	port(	
			clk : in std_logic;			
			enable : in std_logic;		
			reset : in std_logic;		
			count : out std_logic_vector(1 downto 0)	
		);	
end cpt_mod4;

architecture behavioral of cpt_mod4 is

	constant modulo : integer :=4 ;			
	signal cpt : integer range 0 to modulo - 1;	
	
begin

	process(clk)
	begin
		if clk'event and clk='1' then
			if reset='1' then 
				cpt <= 0 ; 
			elsif enable='1' then
				case cpt is                          
					when modulo - 2 => 
						cpt <= modulo - 1 ; 
					when modulo - 1 => 
						cpt <= 0 ;
					when others => 
						cpt <= cpt + 1 ; 
				end case;
			end if;
		end if;
	end process;

	count <= std_logic_vector(to_unsigned(cpt, 2)); 

end behavioral;
