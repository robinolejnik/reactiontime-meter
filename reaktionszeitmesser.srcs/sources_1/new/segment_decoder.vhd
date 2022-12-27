library ieee;
use ieee.std_logic_1164.all;

entity segment_decoder is
    port(
        reset_in    : in  std_logic;       
        hex_in      : in  std_logic_vector (3 downto 0);
        segment_out : out std_logic_vector (6 downto 0)
    );
end segment_decoder;

architecture Behavioral of segment_decoder is

begin

segment_decoder : process(reset_in, hex_in)
begin
    if reset_in = '0' then
        segment_out <= "1111111";
    else
        case hex_in is
            when "0000" => segment_out <= "0000001"; -- 0
            when "0001" => segment_out <= "1001111"; -- 1
            when "0010" => segment_out <= "0010010"; -- 2
            when "0011" => segment_out <= "0000110"; -- 3
            when "0100" => segment_out <= "1001100"; -- 4
            when "0101" => segment_out <= "0100100"; -- 5
            when "0110" => segment_out <= "0100000"; -- 6
            when "0111" => segment_out <= "0001111"; -- 7
            when "1000" => segment_out <= "0000000"; -- 8
            when "1001" => segment_out <= "0000100"; -- 9
            when "1010" => segment_out <= "0001000"; -- A
            
            --when "1011" => segment_out <= "1100000"; -- b
            --when "1100" => segment_out <= "0110001"; -- C
            --when "1101" => segment_out <= "1000010"; -- d
            --when "1110" => segment_out <= "0110000"; -- E
            --when "1111" => segment_out <= "0111000"; -- F
    
            -- alternative assignment to display word "over" ("ouEr") by outputting x"BCED"
            -- x"F" to turn digit off
    
            when "1011" => segment_out <= "1100010"; -- o
            when "1100" => segment_out <= "1100011"; -- u
            when "1101" => segment_out <= "1111010"; -- r
            when "1110" => segment_out <= "0110000"; -- E
            when "1111" => segment_out <= "1111111"; -- all segments off
    
            when others => segment_out <= "1111111"; -- turn off all segments
        end case;
    end if;
end process;

end Behavioral;
