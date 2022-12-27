library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity segment_decoder_tb is
end segment_decoder_tb;

architecture bench of segment_decoder_tb is
    signal reset    : std_logic := '1';
    signal bcd      : std_logic_vector(3 downto 0) := (others => '0');
    signal segments : std_logic_vector(6 downto 0);
    
    component segment_decoder
        port(
            reset_in    : in  std_logic;
            hex_in      : in  std_logic_vector (3 downto 0);
            segment_out : out std_logic_vector (6 downto 0)
        );
    end component segment_decoder;
begin
    segment_decoder1: segment_decoder port map(
        reset_in    => reset,
        hex_in      => bcd,
        segment_out => segments
    );

    stimulus: process
    begin
        wait for 5 ns;
        
        -- reset
        reset <= '0';
        wait for 5 ns;
        reset <= '1';
        
        wait for 5 ns;
        
        -- switch through BCD codes
        while bcd /= "1111" loop
            wait for 10 ns;
            bcd <= std_logic_vector(unsigned(bcd) + 1);
        end loop;
        
        wait;
    end process stimulus;
end bench;
