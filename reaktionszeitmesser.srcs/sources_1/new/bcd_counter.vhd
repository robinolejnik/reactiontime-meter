library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bcd_counter is
    port(
        enable_in : in  std_logic;
        clk_in    : in  std_logic;
        reset_in  : in  std_logic;
        carry_out : out std_logic;
        bcd_out   : out std_logic_vector(3 downto 0)
    );
end entity bcd_counter;

architecture Behavioral of bcd_counter is
    signal counter : std_logic_vector(3 downto 0);
begin

    count: process(clk_in, reset_in)
    begin
        if reset_in = '0' then
            counter <= (others => '0');
        else
            if(rising_edge(clk_in)) then
                if(enable_in = '1') then
                    if(counter = "1001") then
                        counter <= (others => '0');
                        carry_out <= '1';
                    else
                        counter <= std_logic_vector(unsigned(counter) + 1);
                        carry_out <= '0';
                    end if;
                end if;                 
            end if;
        end if;
    end process count;

    bcd_out <= counter;
end Behavioral;
