library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux7seg_tb is
end mux7seg_tb;

architecture bench of mux7seg_tb is
    constant clock_period   : time      := 1 ms;
    signal clk              : std_logic := '0';
    signal reset            : std_logic := '1';
    signal bcd              : std_logic_vector(31 downto 0) := x"12345678";
    signal dp               : std_logic_vector(7 downto 0)  := "10101100";
    signal digit            : std_logic_vector(7 downto 0);
    signal segments         : std_logic_vector(6 downto 0);
    signal dp_out           : std_logic;
    
    component mux7seg
        port(
            clk_in      : in  std_logic;
            reset_in    : in  std_logic;
            bcd_in      : in  std_logic_vector(31 downto 0);
            dp_in       : in  std_logic_vector(7 downto 0);
            segment_out : out std_logic_vector(6 downto 0);
            digit_out   : out std_logic_vector(7 downto 0);
            dp_out      : out std_logic
        );
    end component mux7seg;
begin
    segment_display: mux7seg port map(
        clk_in      => clk,
        reset_in    => reset,
        bcd_in      => bcd,
        segment_out => segments,
        digit_out   => digit,
        dp_in       => dp,
        dp_out      => dp_out
    );

    reset_process: process
    begin
        wait for 250 us;
        reset <= '0';
        wait for 500 us;
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
