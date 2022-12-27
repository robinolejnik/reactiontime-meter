library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debounce is
    port(
        clk_in     :  in std_logic;
        reset_in   :  in std_logic;
        button_in  :  in std_logic;
        button_out : out std_logic
    );
end debounce;

architecture Behavioral of debounce is
    type states is (btn_up, btn_up_debounce, btn_down, btn_down_debounce);
    signal state: states := btn_up;
    signal counter:  unsigned(27 downto 0) := (others => '0');
begin
    debounce_process: process(reset_in, clk_in)
    begin
        if reset_in = '0' then
            counter    <= (others => '0');
            state      <= btn_up;
            button_out <= '0';
        elsif rising_edge(clk_in) then
            case state is
                when btn_up =>
                    button_out <= '0';
                    if button_in = '1' then
                        counter <= (others => '0');
                        state <= btn_down_debounce;
                    end if;

                when btn_down_debounce =>
                    button_out <= '0';
                    if counter = 1000000 then
                        counter <= (others => '0');
                        if button_in = '1' then
                            state <= btn_down;
                        else
                            state <= btn_up_debounce;
                        end if;
                    else
                        counter <= counter + 1;
                    end if;

                when btn_down =>
                    button_out <= '1';
                    if button_in = '0' then
                        counter <= (others => '0');
                        state <= btn_up_debounce;
                    end if;

                when btn_up_debounce =>
                    button_out <= '1';
                    if counter = 1000000 then -- 10 ms debounce time @ 100 MHz clock
                        counter <= (others => '0');
                        if button_in = '0' then
                            state <= btn_up;
                        else
                            state <= btn_down_debounce;
                        end if;
                    else
                        counter <= counter + 1;
                    end if;
                when others =>
                    state <= btn_up;
            end case;
        end if;
    end process debounce_process;
end Behavioral;
