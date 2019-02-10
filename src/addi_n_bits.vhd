-------------------------------
-- Project  : Proco-8bits
-- Date     : Jan. 2019
-- Author   : D.DEVANT
-- School   : ENSEIRB-MATMECA
-- Desc     : Full adder n bits
-------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity addi_n_bits is
generic (
    N : integer := 8                                     -- Number of bit
);
port (
------ Input data --------------------
    i_data_l : in std_logic_vector(N-1 downto 0);        -- Left input data bits
    i_data_r : in std_logic_vector(N-1 downto 0);        -- Right input data bits
------ Output data --------------------
    o_data   : out std_logic_vector(N-1 downto 0);       -- Output data bits
    o_carry  : out std_logic                             -- Output carry bit
);
end addi_n_bits;

architecture rtl of addi_n_bits is
------ Signals -------------------
    signal s_carry : std_logic_vector(N downto 0);
------ Components ----------------
    component addi_1_bit is
    port ( 
    ------ Input data --------------------
        i_data_l : in std_logic;                             -- Left input data bit
        i_data_r : in std_logic;                             -- Right input data bit
        i_carry  : in std_logic;                             -- Carry input data bit
    ------ Output data --------------------
        o_data   : out std_logic;                            -- Output data bits
        o_carry  : out std_logic                             -- Output carry bit
    );
    end component addi_1_bit;
begin

  -- Instantiate N addi_1_bit
  addi_n : for i in 0 to (N-1) generate
    addi_1 : entity work.addi_1_bit(rtl)
    port map (
        i_data_l => i_data_l(i),
        i_data_r => i_data_r(i), 
        i_carry => s_carry(i), 
        o_data => o_data(i), 
        o_carry => s_carry(i + 1)
    );
  end generate addi_n;

  -- Permanent
  s_carry(0) <= '0';
  o_carry <= s_carry(N);

end architecture rtl;
