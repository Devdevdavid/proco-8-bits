library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity addi_1_bit is
port (
------ Input data --------------------
  i_data_l : in std_logic;                             -- Left input data bit
  i_data_r : in std_logic;                             -- Right input data bit
  i_carry  : in std_logic;                             -- Carry input data bit
------ Output data --------------------
  o_data : out std_logic;                              -- Output data bits
  o_carry : out std_logic                              -- Output carry bit
);
end addi_1_bit;

architecture rtl of addi_1_bit is
begin

  o_data <= i_data_l XOR i_data_r XOR i_carry;
  o_carry <= (i_data_l AND i_data_r) OR (i_carry AND (i_data_l OR i_data_r));

end architecture rtl;

