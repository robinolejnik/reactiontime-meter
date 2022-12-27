library ieee;
use ieee.std_logic_1164.all;

entity timer_tb is
end timer_tb;

architecture bench of timer_tb is
    component random_timer is
        generic(min_value, max_value: integer);
        port(
            reset_in    : in  std_logic;
            clk_prng_in : in  std_logic;
            clk_time_in : in  std_logic;
            enable_in   : in  std_logic;
            timeout_out : out std_logic
        );
    end component random_timer;
    
    constant clock_period1  : time      := 10 ns;
    constant clock_period2  : time      := 5 ns;
    signal clk1             : std_logic := '0';
    signal clk2             : std_logic := '0';
    signal reset            : std_logic := '1';
    signal timeout          : std_logic := '0';
    signal timer_enable     : std_logic := '0';
begin
    timer: random_timer generic map(min_value => 4, max_value => 8)
    port map(
        reset_in    => reset,
        clk_prng_in => clk2,
        clk_time_in => clk1,
        enable_in   => timer_enable,
        timeout_out => timeout
    );

    stimulus: process
    begin
        wait for 1 ns;
        
        -- reset
        reset <= '0';
        wait for 1 ns;
        reset <= '1';
        
        wait for 35 ns;
        
        -- enable timer (countdown)
        timer_enable <= '1';
        wait for 50 ns;
        timer_enable <= '0';
        
        wait;
    end process stimulus;

    clock1: process
    begin
        while true loop
            clk1 <= '0', '1' after clock_period1 / 2;
            wait for clock_period1;
        end loop;
        wait;
    end process clock1;
    
    clock2: process
    begin
        while true loop
            clk2 <= '0', '1' after clock_period2 / 2;
            wait for clock_period2;
        end loop;
        wait;
    end process clock2;
end bench;
