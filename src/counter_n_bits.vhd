library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_n_bits is
generic (
    N : integer := 6                                     -- Number of bit
);
port (
------ Globally routed signals -------
    reset        : in  std_logic;                        -- Reset input  
    clk          : in  std_logic;                        -- Input clock
------ Input data --------------------
    i_enable     : in  std_logic;                        -- Enable (0: nothing, 1: counting clk)
    i_init       : in  std_logic;                        -- Reset counter value to 0
    i_load       : in  std_logic;                        -- Load i_data if high
    i_data       : in  std_logic_vector(N-1 downto 0);   -- Input data bits
------ Output data -------------------
    o_data       : out std_logic_vector(N-1 downto 0)    -- Output data bits
);
end counter_n_bits;

architecture struct of counter_n_bits is
------ Signals -------------------
    signal s_data : unsigned(N-1 downto 0);
begin
    -- Copy input to output on clk if load is high
    process(reset, clk, i_enable, i_init, i_load, i_data) is
    begin
        if rising_edge(clk) then
            if reset = '1' or i_init = '1' then
                s_data <= (others => '0');
            elsif i_load = '1' then
                s_data <= unsigned(i_data);
            elsif i_enable = '1' then
                s_data <= s_data + 1;
            end if;
        end if;
    end process;

    o_data <= std_logic_vector(s_data);

end struct;
