library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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
    
    constant max_counter  : natural := f_in / f_out / 2;
    constant counter_bits : natural := num_bits(max_counter);
    
    signal cnt    : unsigned(counter_bits - 1 downto 0) := (others => '0');
    signal toggle : std_logic := '0';
    
begin
    cnt_update: process(reset_in, clk_in)
    begin
        if reset_in = '0' then
            cnt <= (others => '0');
            toggle <= '0';
        elsif rising_edge(clk_in) then
            if cnt = max_counter - 1 then
                cnt <= to_unsigned(0, counter_bits);
                toggle <= not toggle;
            else
                cnt <= cnt + 1;
            end if;
        end if;
    end process;

    clk_out <= toggle;
end architecture Behavioral;