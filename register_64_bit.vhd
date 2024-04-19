library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity register_64_bit is
    port(
        clk, reset: in std_logic;
        input_1: in std_logic_vector (63 downto 0);
        data_1: out std_logic_vector (63 downto 0)
    );
end register_64_bit;

architecture arch of register_64_bit is
    signal input_1_reg, input_1_next: std_logic_vector (63 downto 0);
begin
    process(clk, reset)
    begin
        if (reset = '1') then 
            input_1_reg <= (others => '0');
        elsif (clk'event and clk = '1') then 
            input_1_reg <= input_1_next;
        end if;
    end process;

    -- next state logic
    input_1_next <= input_1;

    -- output logic
    data_1 <= input_1_reg;

end arch;
