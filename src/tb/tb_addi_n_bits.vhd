LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_addi_n_bits IS
END ENTITY tb_addi_n_bits;

ARCHITECTURE rtl OF tb_addi_n_bits IS

  CONSTANT N : integer := 6;

  -- Declaration
  SIGNAL sig_A : std_logic_vector(N-1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL sig_B : std_logic_vector(N-1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL sig_S : std_logic_vector(N DOWNTO 0) := (OTHERS => '0');

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
  
BEGIN  -- ARCHITECTURE rtl

  addi_n_bits_i : component addi_n_bits
  generic map (
    N => N
  )
  port map (
    i_data_l => sig_A, 
    i_data_r => sig_B, 
    o_data => sig_S(N-1 downto 0), 
    o_carry => sig_S(N)
  );


  P1 : PROCESS IS
    VARIABLE var_A : integer := 0;
    VARIABLE var_B : integer := 0;
    VARIABLE var_S : integer := 0;
  BEGIN  -- PROCESS
    WAIT FOR 10 ns;
    -- Get previous result
    var_S := to_integer(unsigned(sig_S));

    -- Error message
    ASSERT var_S = (var_A + var_B)
      REPORT "ERROR: "& integer'image(var_A) &"+"& integer'image(var_B) &" != "& integer'image(var_S) 
      SEVERITY error;

    -- Change variables
    IF (var_A < 62) THEN
      var_A := var_A + 1;
    ELSE
      var_A := 0;
      IF (var_B < 10) THEN
	      var_B := var_B + 1;
      ELSE
	      var_B := 0;
      END IF;
    END IF;

    -- Update signals
    sig_A <= std_logic_vector(to_unsigned(var_A, n));
    sig_B <= std_logic_vector(to_unsigned(var_B, n));
    
  END PROCESS P1;
  

END ARCHITECTURE rtl;
