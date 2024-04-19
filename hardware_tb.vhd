library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hardware_tb is
end entity hardware_tb;

architecture tb_arch of hardware_tb is
    -- Constants
    constant CLK_PERIOD : time := 10 ps; -- Clock period

    -- Signals
    signal clk, reset, start, ready : std_logic;
    signal input_1, input_2 : std_logic_vector(63 downto 0);
    signal operation: std_logic;
    signal result : std_logic_vector(128 downto 0);
    signal rep_check: std_logic_vector(7 downto 0);

begin
    -- Instantiate the optimized_multplier module
    dut : entity work.hardware_top
        port map(
            clk          => clk,
            reset        => reset,
            input_1      => input_1,
            input_2      => input_2,
            start        => start,
            operation    => operation,
            ready        => ready,
            rep_check    => rep_check,
            result     => result
        );

    -- Clock process
    clk_process: process
    begin
        while now < 2000 ns loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- Stimulus process
    stimulus_process: process
    begin
        -- Reset
        reset <= '1';
        start <= '0';
        operation <= '0';
        input_1 <= X"0000000000000000";
        input_2 <= X"0000000000000000";
        wait for CLK_PERIOD;
        reset <= '0';

        -- Load 
        input_1 <= X"000000000000EEEE";
        input_2 <= X"000000000000FFFF";
        operation <= '0';
        wait for CLK_PERIOD;
        -- Start operation
        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';
        -- Wait for operation to complete
        wait until ready = '1';

        -- engage hardware for 100 different input combinations
        for i in 56897 to 56995 loop
            -- Load 
            input_1 <= std_logic_vector(to_unsigned((i+8990)*137, 64));
            input_2 <= std_logic_vector(to_unsigned((i + 7179)*(i-568)*997651917, 64));
            operation <= std_logic(to_unsigned(i mod 2, 1)(0));
            wait for CLK_PERIOD;
            -- Start operation
            start <= '1';
            wait for CLK_PERIOD;
            start <= '0';
            -- Wait for operation to complete
            wait until ready = '1';
        end loop;
        
        wait;
    end process;

end architecture tb_arch;
