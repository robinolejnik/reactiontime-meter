library ieee;
use ieee.std_logic_1164.all;

entity clock_divider_tb is
end clock_divider_tb;

architecture bench of clock_divider_tb is
    constant clock_period   : time      := 10 ns;
    signal clk              : std_logic := '0';
    signal reset            : std_logic := '1';
    signal clk_out          : std_logic := '0';
    
    component clock_divider
        generic(f_in, f_out: integer);
        port(
            reset_in : in  std_logic;
            clk_in   : in  std_logic;
            clk_out  : out std_logic
        );
    end component clock_divider;
begin
    clk_divider: clock_divider generic map(f_in => 100e6, f_out => 10e6) port map(
        reset_in => reset,
        clk_in   => clk,
        clk_out  => clk_out
    );

    
    reset_process: process
    begin
        wait for 1 ns;
        reset <= '0';
        wait for 1 ns;
        reset <= '1';
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
