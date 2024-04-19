library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity control_test is
    port(
        clk, reset: in std_logic;
        start: in std_logic;
        operation: in std_logic;
        lsb_register_129: in std_logic;
        diff_check: in std_logic;
        ready: out std_logic;
        ld: out std_logic;
        wr: out std_logic;
        l_shift: out std_logic;
        r_shift: out std_logic;
        op_flag: out std_logic;
        rep_check: out std_logic_vector (7 downto 0)
    );
end control_test;

architecture arch of control_test is
    -- signal declarations
    signal ready_mul, ready_div: std_logic;
    signal ld_mul, ld_div: std_logic;
    signal wr_mul, wr_div: std_logic;
    signal r_shift_mul, r_shift_div: std_logic;
    signal l_shift_div: std_logic;
    signal rep_check_mul, rep_check_div: std_logic_vector (7 downto 0);
begin
    control_test_multiplier_unit: entity work.control_test_multiplier
        port map(clk => clk, reset => reset, start => start, lsb_register_129 => lsb_register_129, ready => ready_mul, ld => ld_mul, wr => wr_mul, r_shift => r_shift_mul, rep_check => rep_check_mul);
       
    control_test_divider_unit: entity work.control_test_divider
        port map(clk => clk, reset => reset, start => start, diff_check => diff_check, ready => ready_div, ld => ld_div, wr => wr_div, l_shift => l_shift_div, r_shift => r_shift_div, rep_check => rep_check_div);

    process(operation, ready_mul, ready_div, ld_mul, ld_div, wr_mul, wr_div, r_shift_mul, r_shift_div, l_shift_div, rep_check_mul, rep_check_div)
    begin
        ready <= '0';
        ld <= '0';
        wr <= '0';
        l_shift <= '0';
        r_shift <= '0';
        rep_check <= (others => '0');
        case operation is
            when '0' => 
                ready <= ready_mul;
                ld <= ld_mul;
                wr <= wr_mul;
                l_shift <= '0';
                r_shift <= r_shift_mul;
                rep_check <= rep_check_mul;
            when others =>
                ready <= ready_div;
                ld <= ld_div;
                wr <= wr_div;
                l_shift <= l_shift_div;
                r_shift <= r_shift_div;
                rep_check <= rep_check_div;
        end case;
    end process;
    op_flag <= operation;
end arch;