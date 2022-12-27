library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reaktionszeitmesser is
    Port(
        clk_100mhz: in  std_logic;
        reset:      in  std_logic;
        btnc:       in  std_logic;
        dp:         out std_logic;
        a_to_g:     out std_logic_vector(6 downto 0);
        an:         out std_logic_vector(7 downto 0);
        led_g:      out std_logic;
        aud_pwm:    out std_logic
    );
end reaktionszeitmesser;

architecture Behavioral of reaktionszeitmesser is
    signal clk_100khz    : std_logic;
    signal clk_1khz      : std_logic;

    signal bcd_carry0    : std_logic;
    signal bcd_carry1    : std_logic;
    signal bcd_carry2    : std_logic;
    signal bcd           : std_logic_vector(31 downto 0);
    signal display_bcd   : std_logic_vector(15 downto 0);
    signal dp_set        : std_logic_vector(7 downto 0);
    
    signal ready         : std_logic;
    signal random_enable : std_logic;
    signal overflow      : std_logic;
    signal timeout       : std_logic;
    signal timer_enable  : std_logic;
    signal display_on    : std_logic;

    component clock_divider
        generic(f_in, f_out: integer);
        port(
            reset_in : in  std_logic;
            clk_in   : in  std_logic;
            clk_out  : out std_logic
        );
    end component clock_divider;

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
    
    component bcd_counter
        port(
            enable_in : in  std_logic;
            clk_in    : in  std_logic;
            reset_in  : in  std_logic;
            carry_out : out std_logic;
            bcd_out   : out std_logic_vector(3 downto 0)
        );
    end component bcd_counter;

    component random_timer is
        generic(min_value, max_value: integer);
        port(
            reset_in    : in  std_logic;
            clk_prng_in : in  std_logic;
            clk_time_in : in  std_logic;
            enable_in   : in  std_logic;
            timeout_out : out std_logic
        );
    end component random_timer;
    
    component state is
        Port(
            clk_in      : in  std_logic;
            reset_in    : in  std_logic;
            button_in   : in  std_logic;
            timeout_in  : in  std_logic;
            overflow_in : in  std_logic;
            ready_out   : out std_logic;
            random_out  : out std_logic;
            timer_out   : out std_logic;
            display_out : out std_logic
        );
    end component state;

begin
    -- ########## clock divider
    clk_divider_100khz: clock_divider generic map(f_in => 100e6, f_out => 100e3) port map(
        reset_in => reset,
        clk_in   => clk_100mhz,
        clk_out  => clk_100khz
    );
    
    clk_divider_1khz: clock_divider generic map(f_in => 100e6, f_out => 1e3) port map(
        reset_in => reset,
        clk_in   => clk_100mhz,
        clk_out  => clk_1khz
    );

    -- ########## 7-segment display
    segment_display: mux7seg port map(
        clk_in      => clk_1khz,
        reset_in    => reset,
        bcd_in      => bcd,
        segment_out => a_to_g,
        digit_out   => an,
        dp_in       => dp_set,
        dp_out      => dp
    );
    
    -- ########## bcd counter
    cnt1000: bcd_counter port map(
        enable_in => timer_enable,
        clk_in    => bcd_carry2,
        reset_in  => (reset and not random_enable),
        bcd_out   => display_bcd(15 downto 12)
    );
    cnt100: bcd_counter port map(
        enable_in => timer_enable,
        clk_in    => bcd_carry1,
        reset_in  => reset and not random_enable,
        carry_out => bcd_carry2,
        bcd_out   => display_bcd(11 downto 8)
    );
    cnt10: bcd_counter port map(
        enable_in => timer_enable,
        clk_in    => bcd_carry0,
        reset_in  => reset and not random_enable,
        carry_out => bcd_carry1,
        bcd_out   => display_bcd(7 downto 4)
    );
    cnt1: bcd_counter port map(
        enable_in => timer_enable,
        clk_in    => clk_1khz,
        reset_in  => reset and not random_enable,
        carry_out => bcd_carry0,
        bcd_out   => display_bcd(3 downto 0)
    );

    -- ########## random timer
    timer: random_timer generic map(min_value => 2000, max_value => 3000)
    port map(
        reset_in    => reset,
        clk_prng_in => clk_100khz,
        clk_time_in => clk_1khz,
        enable_in   => random_enable,
        timeout_out => timeout
    );
    
    -- ########## state machine
    statemachine: state port map(
        clk_in      => clk_100mhz,
        reset_in    => reset,
        button_in   => btnc,
        timeout_in  => timeout,
        overflow_in => overflow,
        ready_out   => ready,
        random_out  => random_enable,
        timer_out   => timer_enable,
        display_out => display_on
    );
    
    -- ####################
    
    overflow <= '1' when display_bcd = x"9999" else '0';
    
    -- Show "ovEr" on counter overflow
    bcd(31 downto 16) <= x"BCED" when overflow = '1' and display_on = '1' else x"FFFF";
    
    -- Display counter value (time)
    bcd(15 downto 0)  <= display_bcd when display_on = '1' else (others => '1');
    
    -- Fixed decimal point
    dp_set            <= "11110111"  when display_on = '1' else (others => '1');
    
    -- Ready LED
    led_g             <= ready and clk_1khz;
    
    -- According to board datasheet, audio PWM needs to be driven either low or high-z. 
    aud_pwm           <= '0' when timer_enable = '1' and clk_1khz = '1' else 'Z';

end Behavioral;
