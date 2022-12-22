library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity random_timer is
    generic(min_value, max_value: integer);
    port(
        reset_in    : in  std_logic;
        clk_prng_in : in  std_logic;
        clk_time_in : in  std_logic;
        enable_in   : in  std_logic;
        timeout_out : out std_logic
    );
end entity random_timer;

architecture Behavioral of random_timer is
    function num_bits(n: natural) return natural is
        begin
        if n > 0 then
            return 1 + num_bits(n / 2);
        else
            return 1;
        end if;
    end num_bits;
    
    constant counter_bits: natural := num_bits(max_value);
    signal counter : unsigned(counter_bits - 1 downto 0) := (others => '0');
    signal clk     : std_logic;
begin

    count: process(reset_in, clk, enable_in)
    begin
        if reset_in = '0' then
            timeout_out <= '0';
            counter <= (others => '0');
        elsif rising_edge(clk) then

            -- Timer enabled: count down to 0, then enable timeout
            if(enable_in = '1') then
                if(counter > 0) then
                    counter <= counter - 1;
                end if;
                if(counter <= 1) then
                    timeout_out <= '1';
                end if;

            -- Timer disabled: count up with overflow to min_value at max_value
            else
                timeout_out <= '0';
                if(counter >= max_value OR counter = 0) then -- (overflow condition) OR (initialization condition)
                    counter <= to_unsigned(min_value, counter_bits);
                else
                    counter <= counter + 1;
                end if;

            end if;
        end if;
    end process count;

    -- 1kHz clock when timer is enabled, higher frequency for random numger generation
    clk <= (enable_in AND clk_time_in) OR (NOT enable_in AND clk_prng_in);
end Behavioral;
