library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux7seg is
    Port (
        clk_in      : in  std_logic;
        reset_in    : in  std_logic;
        bcd_in      : in  std_logic_vector(31 downto 0);
        dp_in       : in  std_logic_vector(7 downto 0);
        segment_out : out std_logic_vector(6 downto 0);
        digit_out   : out std_logic_vector(7 downto 0) := "11111111";
        dp_out      : out std_logic                    := '1'
    );
end mux7seg;

architecture Behavioral of mux7seg is
    signal selected_bcd   : std_logic_vector(3 downto 0) := (others => '0');
    signal selected_digit : std_logic_vector(2 downto 0) := (others => '0');

    component segment_decoder
        port(
            reset_in    : in  std_logic;
            hex_in      : in  std_logic_vector (3 downto 0);
            segment_out : out std_logic_vector (6 downto 0)
        );
    end component segment_decoder;
begin
    process(reset_in, clk_in, bcd_in, dp_in)
    begin
        if reset_in = '0' then
            dp_out <= '1';
            digit_out <= "11111111";
        elsif rising_edge(clk_in) then
            case selected_digit is
                when "000"  =>
                    selected_bcd <= bcd_in(31 downto 28);
                    dp_out       <= dp_in(7);
                    digit_out    <= "01111111";
                when "001"  =>
                    selected_bcd <= bcd_in(27 downto 24);
                    dp_out       <= dp_in(6);
                    digit_out    <= "10111111";
                when "010"  =>
                    selected_bcd <= bcd_in(23 downto 20);
                    dp_out       <= dp_in(5);
                    digit_out    <= "11011111";
                when "011"  =>
                    selected_bcd <= bcd_in(19 downto 16);
                    dp_out       <= dp_in(4);
                    digit_out    <= "11101111";
                when "100"  =>
                    selected_bcd <= bcd_in(15 downto 12);
                    dp_out       <= dp_in(3);
                    digit_out    <= "11110111";
                when "101"  =>
                    selected_bcd <= bcd_in(11 downto 8);
                    dp_out       <= dp_in(2);
                    digit_out    <= "11111011";
                when "110"  =>
                    selected_bcd <= bcd_in(7 downto 4);
                    dp_out       <= dp_in(1);
                    digit_out    <= "11111101";
                when others =>
                    selected_bcd <= bcd_in(3 downto 0);
                    dp_out       <= dp_in(0);
                    digit_out    <= "11111110";
            end case;
        end if;
    end process;

    cnt_update: process(reset_in, clk_in)
    begin
        if reset_in = '0' then
            selected_digit <= (others => '0');
        else
            if rising_edge(clk_in) then
                selected_digit <= std_logic_vector(unsigned(selected_digit) + 1);
            end if;
        end if;
    end process cnt_update;

    segment_decoder1: segment_decoder port map(
        reset_in    => reset_in,
        hex_in      => selected_bcd,
        segment_out => segment_out
    );
end Behavioral;
