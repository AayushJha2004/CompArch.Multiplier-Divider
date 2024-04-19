library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity control_test_divider is
    port(
        clk, reset: in std_logic;
        start: in std_logic;
        diff_check: in std_logic;
        ready: out std_logic;
        ld: out std_logic;
        wr: out std_logic;
        l_shift: out std_logic;
        r_shift: out std_logic;
        op_flag: out std_logic;
        rep_check: out std_logic_vector (7 downto 0)
    );
end control_test_divider;

architecture arch of control_test_divider is
    type state_type is (idle, load, op);  
    signal state_reg, state_next: state_type;  
    signal rep_check_reg, rep_check_next: unsigned (7 downto 0);
begin
    process(clk, reset)
    begin
        if (reset = '1') then 
            state_reg <= idle;
            rep_check_reg <= (others => '0');
        elsif (clk'event and clk = '1') then
            state_reg <= state_next;
            rep_check_reg <= rep_check_next;
        end if;
    end process;

    process(start, state_reg, rep_check_reg, diff_check)
    begin
        state_next <= state_reg;
        rep_check_next <= rep_check_reg;
        ready <= '0';
        ld <= '0';
        wr <= '0';
        l_shift <= '0';
        r_shift <= '0';
        case state_reg is 
            when idle =>  
                if (start = '1') then  
                    state_next <= load; 
                end if;
                ready <= '1';  
            when load => 
                ld <= '1';
                rep_check_next <= (others => '0'); 
                state_next <= op;  
            when op =>  
                rep_check_next <= rep_check_reg + 1; 
                l_shift <= '1';
                if (diff_check = '0') then 
                    wr <= '1';
                end if;
                if (rep_check_reg = to_unsigned(64, 8)) then 
                    r_shift <= '1';
                    state_next <= idle;  
                end if;
        end case;
    end process;

    rep_check <= std_logic_vector(rep_check_reg);
end arch;