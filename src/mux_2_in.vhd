library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_2_in is
generic (
    N : integer := 6                                     -- Number of bit of data
);
port (
------ Input data --------------------
    i_select     : in  std_logic;                        -- Load input (0: i_data_0, 1: i_data_1)
    i_data_0     : in  std_logic_vector(N-1 downto 0);   -- Input data bits 0
    i_data_1     : in  std_logic_vector(N-1 downto 0);   -- Input data bits 1
------ Output data -------------------
    o_data       : out std_logic_vector(N-1 downto 0)    -- Output data bits
);
end mux_2_in;

architecture rtl of mux_2_in is
begin

    -- Permanent
    o_data <= (i_data_1) when (i_select = '1') else (i_data_0);

end rtl;
