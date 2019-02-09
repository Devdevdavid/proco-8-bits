library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_n_bits is
generic (
    N : integer := 8                                     -- Number of bit
);
port (
------ Globally routed signals -------
    reset        : in  std_logic;                        -- Reset input  
    clk          : in  std_logic;                        -- Input clock
------ Input data --------------------
    i_load       : in  std_logic;                        -- Load input (0: Nothing, 1: Copy input to output)
    i_data       : in  std_logic_vector(N-1 downto 0);   -- Input data bits
------ Output data -------------------
    o_data       : out std_logic_vector(N-1 downto 0)    -- Output data bits
);
end register_n_bits;

architecture rtl of register_n_bits is
begin
    -- Copy input to output on clk if i_load is high
    process(reset, clk, i_load, i_data) is
    begin
        if rising_edge(clk) then
            if reset = '1' then
                o_data <= (others => '0');
            elsif i_load = '1' then
                o_data <= i_data;
            else
                null;
            end if;
        end if;
    end process;
end rtl;
