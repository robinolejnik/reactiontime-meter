library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity state_tb is
end state_tb;

architecture bench of state_tb is
    constant clock_period : time      := 10 ns;
    signal clk            : std_logic := '0';
    signal reset          : std_logic := '1';
    signal button         : std_logic := '0';
    signal overflow       : std_logic := '0';
    signal timeout        : std_logic := '0';
    signal ready          : std_logic;
    signal random_enable  : std_logic;
    signal timer_enable   : std_logic;
    signal display_on     : std_logic;
    
    component state is
        Port(
            clk_in      : in  std_logic;
            reset_in    : in  std_logic;
            button_in   : in  std_logic;
            timeout_in  : in  std_logic;
            overflow_in : in  std_logic;
            ready_out   : out std_logic;
            random_out  : out std_logic;
            timer_out   : out std_logic;
            display_out : out std_logic
        );
    end component state;

begin
    statemachine: state port map(
        clk_in      => clk,
        reset_in    => reset,
        button_in   => button,
        timeout_in  => timeout,
        overflow_in => overflow,
        ready_out   => ready,
        random_out  => random_enable,
        timer_out   => timer_enable,
        display_out => display_on
    );
    
    stimulus: process
    begin
        wait for 250 us;
        
        -- reset
        reset <= '0';
        wait for 1 ms;
        reset <= '1';
        
        wait for 5 ms;
        
        -- start random timer
        button <= '1';
        wait for 15 ms;
        button <= '0';
        
        -- wait for counter to start
        wait for 20 ms;
        timeout <= '1';
        wait for 1 ms;
        timeout <= '0';
        
        wait for 10 ms;
        
        -- stop counter
        button <= '1';
        wait for 15 ms;
        button <= '0';
        
        wait for 15 ms;
        
        -- ##############################
        -- start (overflow test)
        button <= '1';
        wait for 15 ms;
        button <= '0';
        
        -- wait for counter to start
        wait for 20 ms;
        timeout <= '1';
        wait for 1 ms;
        timeout <= '0';
        
        wait for 10 ms;
        overflow <= '1';
        
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
