library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_2_in is
generic (
    N : integer := 6                                     -- Number of bit of data
);
port (
------ Globally routed signals -------
    reset        : in  std_logic;                        -- Reset input  
    clk          : in  std_logic;                        -- Input clock
------ Input data --------------------
    i_select     : in  std_logic;                        -- Load input (0: i_data_0, 1: i_data_1)
    i_data_0     : in  std_logic_vector(N-1 downto 0);     -- Input data bits 0
    i_data_1     : in  std_logic_vector(N-1 downto 0);     -- Input data bits 1
------ Output data -------------------
    o_data       : out std_logic_vector(N-1 downto 0)      -- Output data bits
);
end mux_2_in;

architecture rtl of mux_2_in is
------ Signals -------------------
    signal s_data : std_logic_vector(N-1 downto 0);
begin
    -- Copy the selected input to output on clk if load is high
    process(reset, clk, i_select, i_data_0, i_data_1) is
    begin
        if rising_edge(clk) then
            if reset = '1' then
                s_data <= (others => '0');
            elsif i_select = '0' then
                s_data <= i_data_0;
            elsif i_select = '1' then
                s_data <= i_data_1;
            end if;
        end if;
    end process;

    o_data <= s_data;

end rtl;
