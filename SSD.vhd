
--Pentru basys
--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;

--entity ssd1 is
--    Port ( clk : in STD_LOGIC;
--           digits : in STD_LOGIC_VECTOR(31 downto 0);
--           sw : in STD_LOGIC_VECTOR(1 downto 0); -- Switch to select most or least significant bits
--           an : out STD_LOGIC_VECTOR(3 downto 0);
--           cat : out STD_LOGIC_VECTOR(6 downto 0));
--end ssd1;

--architecture Behavioral of ssd1 is

--    signal digit : STD_LOGIC_VECTOR(3 downto 0);
--    signal cnt : STD_LOGIC_VECTOR(16 downto 0) := (others => '0');
--    signal sel : STD_LOGIC_VECTOR(1 downto 0);

--begin

--    counter : process(clk) 
--    begin
--        if rising_edge(clk) then
--            cnt <= cnt + 1;
--        end if;
--    end process;

--    sel <= cnt(16 downto 15);

--    muxCat : process(sel, digits, sw)
--    begin
--        if sw(0) = '0' then
--            case sel is
--                when "00" => digit <= digits(31 downto 28); -- Most significant 4 bits
--                when "01" => digit <= digits(27 downto 24);
--                when "10" => digit <= digits(23 downto 20);
--                when "11" => digit <= digits(19 downto 16);
--                when others => digit <= (others => 'X');
--            end case;
--        else
--            case sel is
--                when "00" => digit <= digits(15 downto 12); -- Least significant 4 bits
--                when "01" => digit <= digits(11 downto 8);
--                when "10" => digit <= digits(7 downto 4);
--                when "11" => digit <= digits(3 downto 0);
--                when others => digit <= (others => 'X');
--            end case;
--        end if;
--    end process;

--    muxAn : process(sel)
--    begin
--        case sel is
--            when "00" => an <= "0111"; -- Enable first SSD
--            when "01" => an <= "1011"; -- Enable second SSD
--            when "10" => an <= "1101"; -- Enable third SSD
--            when "11" => an <= "1110"; -- Enable fourth SSD
--            when others => an <= (others => 'X');
--        end case;
--    end process;

--    with digit select
--        cat <= "1000000" when "0000000",   -- 0
--               "1111001" when "0000001",   -- 1
--               "0100100" when "0000010",   -- 2
--               "0110000" when "0000011",   -- 3
--               "0011001" when "0000100",   -- 4
--               "0010010" when "0000101",   -- 5
--               "0000010" when "0000110",   -- 6
--               "1111000" when "0000111",   -- 7
--               "0000000" when "0001000",   -- 8
--               "0010000" when "0001001",   -- 9
--               "0001000" when "0001010",   -- A
--               "0000011" when "0001011",   -- b
--               "1000110" when "0001100",   -- C
--               "0100001" when "0001101",   -- d
--               "0000110" when "0001110",   -- E
--               "0001110" when "0001111",   -- F
--               (others => 'X') when others;

--end Behavioral;


--Pentru Nexys
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SSD is
    Port ( clk : in STD_LOGIC;
           digits : in STD_LOGIC_VECTOR(31 downto 0);
           an : out STD_LOGIC_VECTOR(7 downto 0);
           cat : out STD_LOGIC_VECTOR(6 downto 0));
end SSD;

architecture Behavioral of SSD is

signal digit : STD_LOGIC_VECTOR(3 downto 0);
signal cnt : STD_LOGIC_VECTOR(16 downto 0) := (others => '0');
signal sel : STD_LOGIC_VECTOR(2 downto 0);

begin

    counter : process(clk) 
    begin
        if rising_edge(clk) then
            cnt <= cnt + 1;
        end if;
    end process;

    sel <= cnt(16 downto 14);

    muxCat : process(sel, digits)
    begin
        case sel is
            when "000" => digit <= digits(3 downto 0);
            when "001" => digit <= digits(7 downto 4);
            when "010" => digit <= digits(11 downto 8);
            when "011" => digit <= digits(15 downto 12);
            when "100" => digit <= digits(19 downto 16);
            when "101" => digit <= digits(23 downto 20);
            when "110" => digit <= digits(27 downto 24);
            when "111" => digit <= digits(31 downto 28);
            when others => digit <= (others => 'X');
        end case;
    end process;

    muxAn : process(sel)
    begin
        case sel is
            when "000" => an <= "11111110";
            when "001" => an <= "11111101";
            when "010" => an <= "11111011";
            when "011" => an <= "11110111";
            when "100" => an <= "11101111";
            when "101" => an <= "11011111";
            when "110" => an <= "10111111";
            when "111" => an <= "01111111";
            when others => an <= (others => 'X');
        end case;
    end process;

    with digit SELect
        cat <= "1000000" when "0000",   -- 0
               "1111001" when "0001",   -- 1
               "0100100" when "0010",   -- 2
               "0110000" when "0011",   -- 3
               "0011001" when "0100",   -- 4
               "0010010" when "0101",   -- 5
               "0000010" when "0110",   -- 6
               "1111000" when "0111",   -- 7
               "0000000" when "1000",   -- 8
               "0010000" when "1001",   -- 9
               "0001000" when "1010",   -- A
               "0000011" when "1011",   -- b
               "1000110" when "1100",   -- C
               "0100001" when "1101",   -- d
               "0000110" when "1110",   -- E
               "0001110" when "1111",   -- F
               (others => 'X') when others;

end Behavioral;