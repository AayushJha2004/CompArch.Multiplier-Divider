library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_129_bit is
    port(
        clk, reset: in std_logic;
        input_2: in std_logic_vector (63 downto 0);
        sum: in std_logic_vector (64 downto 0);
        ld: in std_logic;
        wr: in std_logic;
        l_shift: in std_logic;
        r_shift: in std_logic;
        op_flag: in std_logic;
        data_2: out std_logic_vector (128 downto 0)
    );
end register_129_bit;

architecture arch of register_129_bit is 
    signal data_2_reg, data_2_next: std_logic_vector (128 downto 0);
    signal intermediate: std_logic_vector (128 downto 0);
begin
    process(clk , reset)
    begin
        if (reset = '1') then 
            data_2_reg <= (others => '0');
        elsif (clk'event and clk = '1') then 
            data_2_reg <= data_2_next;
        end if;
    end process;

    process(ld, input_2, wr, sum, data_2_reg, l_shift, r_shift, intermediate)
    begin
        data_2_next <= (others => '0');
        intermediate <= (others => '0');
        if (ld = '1') then
            data_2_next <= "00000000000000000000000000000000000000000000000000000000000000000" & input_2;
        else
            if (op_flag = '0') then 
                if (wr = '1') then 
                    data_2_next <= '0' & sum & data_2_reg(63 downto 1);
                elsif (r_shift = '1') then 
                    data_2_next <= '0' & data_2_reg (128 downto 1);
                end if;
            else
                if (wr = '1') then 
                    intermediate <= sum(63 downto 0) & data_2_reg(63 downto 0) & '1';
                elsif (l_shift = '1') then 
                    intermediate <= data_2_reg (127 downto 0) & '0';
                end if;
                if (r_shift = '1') then 
                    data_2_next <= "0" & intermediate(128 downto 65) & intermediate (63 downto 0);
                else 
                    data_2_next <= intermediate;
                end if;
            end if;
        end if;
    end process;

    data_2 <= data_2_reg;
end arch;