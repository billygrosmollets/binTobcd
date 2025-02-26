
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gene_1kHz is
port(	
		clk : in std_logic;			
		enable : in std_logic;		
		raz : in std_logic;			
		carry : out std_logic);  	
		
end gene_1kHz ;

Architecture behavioral of gene_1kHz is

constant modulo : integer :=10**5;  		
signal cpt : integer range 0 to modulo - 1;	

begin

process(clk)
begin
	if clk'event and clk='1' then
		if raz='1' then 
			cpt <= 0 ; 
			carry <= '0' ;
		elsif enable='1' then
			case cpt is
				when modulo - 2 =>
					cpt <= modulo - 1 ; 
					carry <= '1';
				when modulo - 1 => 
					cpt <= 0 ; 
					carry <= '0';
				when others => 
					cpt <= cpt + 1 ; 
					carry <= '0';
			end case;
	 	end if;
 	end if;
 end process;

end behavioral;
