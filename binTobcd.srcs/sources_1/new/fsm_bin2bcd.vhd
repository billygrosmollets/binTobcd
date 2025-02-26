library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity fsm_bin2bcd is
    port(
        clk, reset: in std_logic;
        binary_in: in std_logic_vector(7 downto 0);
        bcd0: out std_logic_vector(3 downto 0);
        bcd1: out std_logic_vector(3 downto 0);
        bcd2: out std_logic_vector(3 downto 0);
        don: out std_logic
    );
end fsm_bin2bcd;

architecture behaviour of fsm_bin2bcd is
    type states is (start, shift, done);-- machine d'�tat finie a trois �tats
    signal state, state_next: states; -- d�ffinition de deux variable de type states
    signal binary, binary_next: std_logic_vector(7 downto 0); -- signal pour le nombre binaire actuel et pour le suivant 
    signal bcds, bcds_reg, bcds_next: std_logic_vector(11 downto 0);
    signal bcds_out_reg, bcds_out_reg_next: std_logic_vector(11 downto 0);
    signal shift_counter, shift_counter_next: natural range 0 to 8;
    signal donn: std_logic := '0';
begin

    -- Process synchrone
process(clk)
begin
    if clk'event and clk = '1' then
        if reset = '1' then
            binary <= (others => '0');
            bcds <= (others => '0');
            state <= start;
            bcds_out_reg <= (others => '0');
            shift_counter <= 0;
        else
            binary <= binary_next;
            bcds <= bcds_next;
            state <= state_next;
            bcds_out_reg <= bcds_out_reg_next;
            shift_counter <= shift_counter_next;
        end if;
    end if;
end process;


    -- Process combinatoire
    process(state, binary, binary_in, bcds, bcds_reg, shift_counter)
    begin
        state_next <= state;
        bcds_next <= bcds;
        binary_next <= binary;
        shift_counter_next <= shift_counter;
        donn <= '0';

        case state is
            when start =>
                state_next <= shift;
                binary_next <= binary_in;
                bcds_next <= (others => '0');
                shift_counter_next <= 0;
            when shift =>
                if shift_counter = 8 then
                    state_next <= done;
                else
                    binary_next <= binary(6 downto 0) & '0';
                    bcds_next <= bcds_reg(10 downto 0) & binary(7);
                    shift_counter_next <= shift_counter + 1;
                end if;
            when done =>
                state_next <= start;
                donn <= '1';
        end case;
    end process;

    -- Correction des BCD
    bcds_reg(11 downto 8) <= bcds(11 downto 8) + 3 when bcds(11 downto 8) > 4 else bcds(11 downto 8);
    bcds_reg(7 downto 4) <= bcds(7 downto 4) + 3 when bcds(7 downto 4) > 4 else bcds(7 downto 4);
    bcds_reg(3 downto 0) <= bcds(3 downto 0) + 3 when bcds(3 downto 0) > 4 else bcds(3 downto 0);
    
    -- Mise � jour des sorties
    bcds_out_reg_next <= bcds when state = done else bcds_out_reg;
    bcd2 <= bcds_out_reg(11 downto 8);
    bcd1 <= bcds_out_reg(7 downto 4);
    bcd0 <= bcds_out_reg(3 downto 0);
    
    --bcd0 <= bcds_out_reg(11 downto 8);
    --bcd1 <= bcds_out_reg(7 downto 4);
    --bcd2 <= bcds_out_reg(3 downto 0);
    

    don <= donn;

end behaviour;
