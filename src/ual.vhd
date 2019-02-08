library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ual is
generic (
    N : integer := 8                                     -- Number of bit
);
port (
------ Input data --------------------
    i_selec_op   : in  std_logic;                        -- Operation selection (0: NOR, 1: ADD)
    i_data_l     : in  std_logic_vector(N-1 downto 0);   -- Left input data bits
    i_data_r     : in  std_logic_vector(N-1 downto 0);   -- Right input data bits
------ Output data -------------------
    o_data       : out std_logic_vector(N-1 downto 0);   -- Output data bits
    o_carry      : out  std_logic                        -- Carry of the operation
);
end ual;

architecture rtl of ual is
------ Signals -------------------
    signal s_data_add : std_logic_vector(N-1 downto 0);
    signal s_carry_add : std_logic;

------ Components -------------------
    component addi_n_bits is
    generic (
      N : integer := 8                                     -- Number of bit
    );
    port (
    ------ Input data --------------------
      i_data_l : in std_logic_vector(N-1 downto 0);        -- Left input data bits
      i_data_r : in std_logic_vector(N-1 downto 0);        -- Right input data bits
    ------ Output data --------------------
      o_data : out std_logic_vector(N-1 downto 0);         -- Output data bits
      o_carry : out std_logic                              -- Output carry bit
    );
    end component addi_n_bits;
    
begin

    -- Instantiate a N-bits adder 
    addi_n_bits_i : component addi_n_bits
    generic map (
      N => N
    )
    port map (
      i_data_l => i_data_l, 
      i_data_r => i_data_r, 
      o_data => s_data_add, 
      o_carry => s_carry_add
    );

    o_data <= s_data_add when (i_selec_op = '1') else (i_data_l nor i_data_r);
    o_carry <= s_carry_add when (i_selec_op = '1') else '0';

end rtl;
