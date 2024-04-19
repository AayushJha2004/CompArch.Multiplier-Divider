library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU_64_bit is
    port(
        num_1: in std_logic_vector (63 downto 0);
        num_2: in std_logic_vector (64 downto 0);
        op_flag: in std_logic;
        diff_check: out std_logic;
        sum: out std_logic_vector (64 downto 0)
    );
end ALU_64_bit;

architecture arch of ALU_64_bit is 
    signal num_1_unsg: unsigned (64 downto 0);
    signal num_2_unsg: unsigned (64 downto 0);
    signal diff_unsg: unsigned (64 downto 0);
    signal sum_unsg: unsigned (64 downto 0);
begin
    num_1_unsg <= '0' & unsigned(num_1);
    num_2_unsg <= unsigned(num_2);
    diff_unsg <= num_2_unsg - num_1_unsg;
    sum_unsg <= num_2_unsg + num_1_unsg; 
    diff_check <= '1' when (num_2_unsg < num_1_unsg) else '0';
    sum <= std_logic_vector(sum_unsg) when op_flag = '0' else std_logic_vector(diff_unsg);
end arch;