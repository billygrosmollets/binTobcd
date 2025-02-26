library ieee;
use ieee.std_logic_1164.all;

entity hex2seg_dp is
   port (   
   		    hex : in std_logic_vector(3 downto 0);
			aff : in std_logic_vector(1 downto 0);
			segments :out std_logic_vector(6 downto 0);
			anodes : out std_logic_vector(3 downto 0)
	    ); 
end entity hex2seg_dp; 
  
architecture behavioral of hex2seg_dp is
begin
    with hex select
        segments <= "1000000" when "0000", -- 0
                    "1111001" when "0001", -- 1
                    "0100100" when "0010", -- 2
                    "0110000" when "0011", -- 3
                    "0011001" when "0100", -- 4
                    "0010010" when "0101", -- 5
                    "0000010" when "0110", -- 6
                    "1111000" when "0111", -- 7
                    "0000000" when "1000", -- 8
                    "0010000" when "1001", -- 9
                    "0001000" when "1010", -- A
                    "0000011" when "1011", -- b
                    "1000110" when "1100", -- C
                    "0100001" when "1101", -- d
                    "0000110" when "1110", -- E
                    "0001110" when others; -- F

    with aff select
        anodes <= "1110" when "00", -- Activer digit 0 (unités)
                  "1101" when "01", -- Activer digit 1 (dizaines)
                  "1011" when "10", -- Activer digit 2 (centaines)
                  "0111" when others; -- Activer digit 3

                  
end architecture behavioral;
