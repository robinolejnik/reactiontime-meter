library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity debounce is
    port(
        clk_in     :  in std_logic;
        reset_in   :  in std_logic;
        button_in  :  in std_logic;
        button_out : out std_logic
    );
end debounce;

architecture Behavioral of debounce is
    type states is (state_button_up, state_button_up_debounce, state_button_down, state_button_down_debounce);
    signal state: states := state_button_up;
    signal counter:  unsigned(27 downto 0) := (others => '0');
begin
    debounce_process: process(reset_in, clk_in)
    begin
        if reset_in = '0' then
            counter    <= (others => '0');
            state      <= state_button_up;
            button_out <= '0';
        elsif rising_edge(clk_in) then
            case state is
                when state_button_up_debounce =>
                    button_out <= '1';
                    if counter = 1000000 then -- 10 ms debounce time @ 100 MHz clock
                        counter <= (others => '0');
                        if button_in = '0' then
                            state <= state_button_up;
                        else
                            state <= state_button_down_debounce;
                        end if;
                    else
                        counter <= counter + 1;
                    end if;
                
                when state_button_up =>
                    button_out <= '0';
                    if button_in = '1' then
                        counter <= (others => '0');
                        state <= state_button_down_debounce;
                    end if;
                    
                when state_button_down_debounce =>
                    button_out <= '0';
                    if counter = 1000000 then
                        counter <= (others => '0');
                        if button_in = '1' then
                            state <= state_button_down;
                        else
                            state <= state_button_up_debounce;
                        end if;
                    else
                        counter <= counter + 1;
                    end if;
                    
                when state_button_down =>
                    button_out <= '1';
                    if button_in = '0' then
                        counter <= (others => '0');
                        state <= state_button_up_debounce;
                    end if;
        
                when others =>
                    state <= state_button_up;
            end case;
        end if;
    end process debounce_process;
end Behavioral;
