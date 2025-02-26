library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity top_bin2bcd is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        bin_in : in STD_LOGIC_VECTOR(7 downto 0);
        start : in STD_LOGIC;
        segments : out STD_LOGIC_VECTOR(6 downto 0);
        anodes : out STD_LOGIC_VECTOR(3 downto 0)
    );
end top_bin2bcd;

architecture Behavioral of top_bin2bcd is

    signal s_1KHz : STD_LOGIC;  							
    signal choix_digit : STD_LOGIC_VECTOR(1 downto 0);      
    signal val_hexa_aff : STD_LOGIC_VECTOR(3 downto 0);      
           
    signal bcd_units : STD_LOGIC_VECTOR(3 downto 0); -- Sortie BCD unit�s
    signal bcd_tens : STD_LOGIC_VECTOR(3 downto 0); -- Sortie BCD dizaines
    signal bcd_hundreds : STD_LOGIC_VECTOR(3 downto 0); -- Sortie BCD centaines
    signal don : STD_LOGIC; -- Signal de fin de conversion      

    COMPONENT mux2_4bits
        PORT(
            e0 : IN std_logic_vector(3 downto 0);
            e1 : IN std_logic_vector(3 downto 0);
            e2 : IN std_logic_vector(3 downto 0);
            e3 : IN std_logic_vector(3 downto 0);
            sel : IN std_logic_vector(1 downto 0);          
            s : OUT std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    
    COMPONENT cpt_mod4
        PORT(
            clk : IN std_logic;
            enable : IN std_logic;
            reset : IN std_logic;          
            count : OUT std_logic_vector(1 downto 0)
        );
    END COMPONENT;
            
    COMPONENT gene_1kHz
        PORT(
            clk : IN std_logic;
            enable : IN std_logic;
            raz : IN std_logic;          
            carry : OUT std_logic
        );
    END COMPONENT;
                
    COMPONENT hex2seg_dp
        PORT(
            hex : IN std_logic_vector(3 downto 0);
            aff : IN std_logic_vector(1 downto 0);
            segments : OUT std_logic_vector(6 downto 0);
            anodes : OUT std_logic_vector(3 downto 0)
        );
    END COMPONENT;
                   
    COMPONENT fsm_bin2bcd
        port(
            clk, reset: in std_logic;
            binary_in: in std_logic_vector(7 downto 0);
            bcd0: out std_logic_vector(3 downto 0);
            bcd1: out std_logic_vector(3 downto 0);
            bcd2: out std_logic_vector(3 downto 0);
            don : out std_logic        
        );
    END COMPONENT;   

begin

    Inst_gene_1kHz: gene_1kHz port map(
        clk => clk,
        enable => start,
        raz => reset,
        carry => s_1KHz
    );

    Inst_cpt_mod4: cpt_mod4 PORT MAP(
        clk => clk,
        enable => s_1KHz,
        reset => reset,
        count => choix_digit
    );

    Inst_mux2_4bits: mux2_4bits PORT MAP(
        e0 => bcd_units,
        e1 => bcd_tens,
        e2 => bcd_hundreds,
        e3 => (others => '0'), -- Utilisation d'une valeur nulle pour le cas par d�faut
        sel => choix_digit,
        s => val_hexa_aff
    );

    Inst_hex2seg_dp: hex2seg_dp PORT MAP(
            hex => val_hexa_aff,
            aff => choix_digit,
            segments => segments,
            anodes => anodes
    );

    Inst_fsm_bin2bcd: fsm_bin2bcd port map (
        clk => clk,
        reset => reset,
        binary_in => bin_in,
        bcd0 => bcd_units,
        bcd1 => bcd_tens ,
        bcd2 => bcd_hundreds ,
        don => don
    );

end Behavioral;