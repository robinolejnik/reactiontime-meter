library ieee;
use ieee.std_logic_1164.all;

entity debounce_tb is
end debounce_tb;

architecture bench of debounce_tb is
    constant clock_period   : time      := 10 ns;
    signal clk              : std_logic := '0';
    signal reset            : std_logic := '1';
    signal button           : std_logic := '0';
    signal button_debounced : std_logic := '0';
    
    component debounce is
        port(
            clk_in     : in std_logic;
            reset_in   : in std_logic;
            button_in  : in std_logic;
            button_out : out std_logic
    );
    end component debounce;
begin

    debounce_button: debounce port map(
        clk_in     => clk,
        reset_in   => reset,
        button_in  => button,
        button_out => button_debounced
    );
    
    stimulus: process
    begin
        wait for 1 ms;
        
        -- reset
        reset <= '0';
        wait for 1 ms;
        reset <= '1';
        
        wait for 1 ms;
        
        -- button press/down
        button <= '1';
        wait for 1 ms;
        button <= '0';
        wait for 1 ms;
        button <= '1';
        wait for 1 ms;
        button <= '0';
        wait for 1 ms;
        button <= '1';
        wait for 1 ms;
        button <= '0';
        wait for 1 ms;
        button <= '1';
        
        wait for 15 ms;
        
        -- button release/up
        button <= '0';
        wait for 1 ms;
        button <= '1';
        wait for 1 ms;
        button <= '0';
        wait for 1 ms;
        button <= '1';
        wait for 1 ms;
        button <= '0';
        wait for 1 ms;
        button <= '1';
        wait for 1 ms;
        button <= '0';
        
        wait;
    end process stimulus;


    clock: process
    begin
        while true loop
            clk <= '0', '1' after clock_period / 2;
            wait for clock_period;
        end loop;
        wait;
    end process clock;

end bench;
