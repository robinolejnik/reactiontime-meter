library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity state is
    port(
        clk_in:      in  std_logic;
        reset_in:    in  std_logic;
        button_in:   in  std_logic;
        timeout_in:  in  std_logic;
        overflow_in: in  std_logic;
        ready_out:   out std_logic;
        random_out:  out std_logic;
        timer_out:   out std_logic;
        display_out: out std_logic
    );
end state;

architecture Behavioral of state is
    type states is (
        ready,
        prng_wait_btn_release,
        randomtime,
        counting,
        wait_btn_press,
        wait_btn_release
    );
    signal state: states := ready;
    signal button_debounced: std_logic;
    
    component debounce is
        port(
            clk_in     : in std_logic;
            reset_in   : in std_logic;
            button_in  : in std_logic;
            button_out : out std_logic
    );
    end component debounce;

begin
    debounce_button: debounce port map(
        clk_in     => clk_in,
        reset_in   => reset_in,
        button_in  => button_in,
        button_out => button_debounced
    );

    statechange: process(clk_in, reset_in)
    begin
        if reset_in = '0' then
            state       <= ready;
            ready_out   <= '0';
            random_out  <= '0';
            timer_out   <= '0';
            display_out <= '0';
        else
            if rising_edge(clk_in) then
                case state is
                when ready =>
                    ready_out   <= '1';
                    random_out  <= '0';
                    timer_out   <= '0';
                    display_out <= '1';
                    if button_debounced = '1' then
                        state <= prng_wait_btn_release;
                    end if;
                
                when prng_wait_btn_release =>
                    ready_out   <= '0';
                    random_out  <= '0';
                    timer_out   <= '0';
                    display_out <= '0';
                    if button_debounced = '0' then
                        state <= randomtime;
                    end if;
                    
                when randomtime =>
                    ready_out   <= '0';
                    random_out  <= '1';
                    timer_out   <= '0';
                    display_out <= '0';
                    if timeout_in = '1' then
                        state <= counting;
                    end if;
                    
                when counting =>
                    ready_out   <= '0';
                    random_out  <= '0';
                    timer_out   <= '1';
                    display_out <= '1';
                    if overflow_in = '1' then
                        state <= ready;
                    end if;
                    if button_in = '1' then -- Don't debounce button at this point to get immediate response. Debouncing will happen in next state. 
                        state <= wait_btn_press;
                    end if;
                    
                when wait_btn_press =>
                    ready_out   <= '0';
                    random_out  <= '0';
                    timer_out   <= '0';
                    display_out <= '1';
                    if button_debounced = '1' then
                        state <= wait_btn_release;
                    end if;
                    
                when wait_btn_release =>
                    ready_out   <= '0';
                    random_out  <= '0';
                    timer_out   <= '0';
                    display_out <= '1';
                    if button_debounced = '0' then
                        state <= ready;
                    end if;
        
                when others =>
                    state <= ready;
                end case;
            end if;
        end if;
    end process statechange;

end Behavioral;
