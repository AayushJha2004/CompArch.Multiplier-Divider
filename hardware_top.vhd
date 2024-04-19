library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hardware_top is
    port(
        clk, reset: in std_logic;
        input_1, input_2: in std_logic_vector (63 downto 0);
        start: in std_logic;
        operation: in std_logic; -- '0' -> Multiplication, '1' -> Division
        ready: out std_logic;
        rep_check: out std_logic_vector (7 downto 0);
        result: out std_logic_vector (128 downto 0)
    );
end hardware_top;

architecture arch of hardware_top is
    -- signal decalrations
    signal data_1: std_logic_vector (63 downto 0);
    signal sum: std_logic_vector (64 downto 0);
    signal ld, wr, l_shift, r_shift, diff_check: std_logic;
    signal rep_check_out: std_logic_vector (7 downto 0);
    signal data_2: std_logic_vector (128 downto 0);
    signal op_flag: std_logic;
begin
    -- component instantiations

    register_64_bit_unit: entity work.register_64_bit
        port map(clk => clk, reset => reset, input_1 => input_1, data_1 => data_1);

    ALU_64_bit_unit: entity work.ALU_64_bit
        port map(num_1 => data_1, num_2 => data_2(128 downto 64), sum => sum, diff_check => diff_check, op_flag => op_flag);
    
    control_test_unit: entity work.control_test
        port map(clk => clk, reset => reset, start => start, lsb_register_129 => data_2(0), operation => operation, diff_check => diff_check, ready => ready, ld => ld, wr => wr, l_shift => l_shift, r_shift => r_shift, rep_check => rep_check_out, op_flag => op_flag);

    register_129_bit_unit: entity work.register_129_bit
        port map(clk => clk, reset => reset, input_2 => input_2, sum => sum, ld => ld, wr => wr, l_shift => l_shift, r_shift => r_shift, op_flag => op_flag, data_2 => data_2);
        
    -- outputs
    rep_check <= rep_check_out;
    result <= data_2;
end arch;