LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_ual IS
END ENTITY tb_ual;

ARCHITECTURE rtl OF tb_ual IS

  CONSTANT N : integer := 8;

  -- Declaration
  signal reset : std_logic := '0';
  signal clk : std_logic := '0';
  signal s_selec_op : std_logic := '0';
  signal s_data_l : std_logic_vector(N-1 downto 0) := (others => '0');
  signal s_data_r : std_logic_vector(N-1 downto 0) := (others => '0');
  signal s_data : std_logic_vector(N-1 downto 0) := (others => '0');
  signal s_carry : std_logic := '0';

  component ual is
  generic (
      N : integer := 8                                   -- Number of bit
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
  end component ual;
  
BEGIN  -- ARCHITECTURE rtl

  ual_i : component ual
  generic map (
    N => N
  )
  port map (
    i_selec_op => s_selec_op, 
    i_data_l => s_data_l, 
    i_data_r => s_data_r,
    o_data => s_data,
    o_carry => s_carry
  );

  P1 : PROCESS IS
    VARIABLE var_i : integer := 0;
    VARIABLE var_l : integer := 0;
    VARIABLE var_r : integer := 0;
    VARIABLE var_o : integer := 0;
  BEGIN  -- PROCESS

    -- Update signals
    s_data_l <= std_logic_vector(to_unsigned(var_l, n));
    s_data_r <= std_logic_vector(to_unsigned(var_r, n));
    
    wait until rising_edge(clk);

    var_o := to_integer(unsigned(s_data));

    -- Error message
    if (s_selec_op = '0') then
      ASSERT var_o = to_integer(unsigned(s_data_l nor s_data_r))
        REPORT "ERROR: "& integer'image(var_l) &" nor "& integer'image(var_r) &" != "& integer'image(var_o) 
        SEVERITY error;
    else
      ASSERT var_o = (var_l + var_r)
        REPORT "ERROR: "& integer'image(var_l) &"+"& integer'image(var_r) &" != "& integer'image(var_o) 
        SEVERITY error;
    end if;

    -- Change variables
    case (var_i) is
      when 0 => var_l := 0; var_r := 0; s_selec_op <= '1';
      when 1 => var_l := 0; var_r := 1; s_selec_op <= '1';
      when 2 => var_l := 255; var_r := 1; s_selec_op <= '1';
      when 3 => var_l := 1; var_r := 255; s_selec_op <= '1';
      when 4 => var_l := 255; var_r := 255; s_selec_op <= '1';
      when 5 => var_l := 0; var_r := 0; s_selec_op <= '0';
      when 6 => var_l := 0; var_r := 1; s_selec_op <= '0';
      when 7 => var_l := 1; var_r := 0; s_selec_op <= '0';
      when 8 => var_l := 1; var_r := 255; s_selec_op <= '0';
      when others => wait;
    end case;
    var_i := var_i + 1;

  END PROCESS P1;

  st_p : process is
  begin
    reset <= '1';
    wait for 20 ns;
    reset <= '0';
    wait;
  end process;
  
  clk_p : process is
  begin
    clk <= '0';
    loop
      wait for 5 ns;
      clk <= not clk;
    end loop;
  end process;
  

END ARCHITECTURE rtl;
