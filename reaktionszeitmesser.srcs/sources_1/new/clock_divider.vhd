-- vgl. https://frank-buss.de/vhdl/simpleClock.html

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_divider is
    generic(f_in, f_out: integer);
    port(
        reset_in : in  std_logic;
        clk_in   : in  std_logic;
        clk_out  : out std_logic
    );
end entity clock_divider;

architecture Behavioral of clock_divider is
    function num_bits(n: natural) return natural is
        begin
        if n > 0 then
            return 1 + num_bits(n / 2);
        else
            return 1;
        end if;
    end num_bits;
    
    constant max_counter: natural := f_in / f_out / 2;
    constant counter_bits: natural := num_bits(max_counter);
    
    signal cnt    : unsigned(counter_bits - 1 downto 0) := (others => '0');
    signal toggle : std_logic;
    
begin
    cnt_update: process(reset_in, clk_in)
    begin
        if reset_in = '0' then
            cnt <= (others => '0');
        elsif rising_edge(clk_in) then
            if cnt = max_counter then
                cnt <= to_unsigned(0, counter_bits);
                toggle <= not toggle;
            else
                cnt <= cnt + 1;
            end if;
        end if;
    end process;

    clk_out <= toggle;
end architecture Behavioral;