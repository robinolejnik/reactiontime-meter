library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity timer_tb is
end timer_tb;

architecture bench of timer_tb is
    component random_timer is
        generic(min_value, max_value: integer);
        port(
            clk_prng_in     :   in  std_logic;
            clk_time_in     :   in  std_logic;
            enable_in       :   in  std_logic;
            timeout_out     :   out std_logic
        );
    end component random_timer;

    signal clk1 : std_logic := '0';
    signal clk2 : std_logic := '0';
    signal tio : std_logic := '0';
    signal en  : std_logic := '0';
    
    constant clock_period1: time := 10 ns;
    constant clock_period2: time := 5 ns;
    signal stop_the_clock: boolean;
begin
    timer: random_timer generic map(min_value => 4, max_value => 8)
    port map(
        clk_prng_in => clk2,
        clk_time_in => clk1,
        enable_in   => en,
        timeout_out => tio
    );

stimulus: process
begin


en <= '0';
wait for 100 ns;
en <= '1';
wait for 150 ns;
en <= '0';

stop_the_clock <= false;
wait;

end process stimulus;


clock1: process
begin
    while not stop_the_clock loop    
        clk1 <= '0', '1' after clock_period1 / 2;
        wait for clock_period1;
    end loop;
    wait;
end process clock1;

clock2: process
begin
    while not stop_the_clock loop
        clk2 <= '0', '1' after clock_period2 / 2;
        wait for clock_period2;
    end loop;
    wait;
end process clock2;
        
end bench;
