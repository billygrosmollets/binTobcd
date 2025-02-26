library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_top_bin2bcd is
-- Aucun port n'est nécessaire pour un testbench
end tb_top_bin2bcd;

architecture Behavioral of tb_top_bin2bcd is
    -- Déclaration des signaux nécessaires pour interagir avec le DUT (Device Under Test)
    signal clk : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal bin_in : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal start : STD_LOGIC := '0';
    signal segments : STD_LOGIC_VECTOR(6 downto 0);
    signal anodes : STD_LOGIC_VECTOR(3 downto 0);

    -- Période de l'horloge pour la simulation
    constant CLK_PERIOD : time := 10 ns;

    -- Composant sous test
    COMPONENT top_bin2bcd
        Port (
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            bin_in : in STD_LOGIC_VECTOR(7 downto 0);
            start : in STD_LOGIC;
            segments : out STD_LOGIC_VECTOR(6 downto 0);
            anodes : out STD_LOGIC_VECTOR(3 downto 0)
        );
    END COMPONENT;

begin
    -- Instanciation du DUT
    DUT: top_bin2bcd PORT MAP (
        clk => clk,
        reset => reset,
        bin_in => bin_in,
        start => start,
        segments => segments,
        anodes => anodes
    );

    -- Génération de l'horloge
    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    -- Processus de simulation
    stim_process : process
    begin
        -- Étape 1 : Initialisation
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 20 ns;

        -- Étape 2 : Tester une conversion binaire-BCD
        bin_in <= "10100111";  -- 167 en binaire
        start <= '1';
        wait for 5 ms;
        start <= '0';

        wait;
    end process;
end Behavioral;
