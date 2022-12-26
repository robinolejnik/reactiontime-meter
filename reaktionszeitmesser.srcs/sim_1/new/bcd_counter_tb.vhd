library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bcd_counter_tb is
end bcd_counter_tb;

architecture bench of bcd_counter_tb is
    constant clock_period : time      := 1 ms;
    signal clk            : std_logic := '0';
    signal reset          : std_logic := '1';
    signal counter_enable : std_logic := '0';
    signal carry          : std_logic;
    signal bcd            : std_logic_vector(3 downto 0);
    
    component bcd_counter
        port(
            enable_in : in  std_logic;
            clk_in    : in  std_logic;
            reset_in  : in  std_logic;
            carry_out : out std_logic;
            bcd_out   : out std_logic_vector(3 downto 0)
        );
    end component bcd_counter;
begin
    cnt1000: bcd_counter port map(
        enable_in => counter_enable,
        clk_in    => clk,
        reset_in  => reset,
        carry_out => carry,
        bcd_out   => bcd
    );

    reset_process: process
    begin
        wait for 250 us;
        
        -- reset
        reset <= '0';
        wait for 1 ms;
        reset <= '1';
        
        wait for 1 ms;
        
        counter_enable <= '1';
        wait for 15 ms;
        counter_enable <= '0';
        
        wait;
    end process reset_process;

    clock: process
    begin
        while true loop
            clk <= '0', '1' after clock_period / 2;
            wait for clock_period;
        end loop;
        wait;
    end process clock;
end bench;