LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_mux_2_in IS
END ENTITY tb_mux_2_in;

ARCHITECTURE rtl OF tb_mux_2_in IS

  CONSTANT N : integer := 6;

  -- Declaration
  signal clk : std_logic := '0';
  signal s_selec_mux : std_logic := '0';
  signal s_mux_in_0 : std_logic_vector(N-1 downto 0) := (others => '0');
  signal s_mux_in_1 : std_logic_vector(N-1 downto 0) := (others => '0');
  signal s_data     : std_logic_vector(N-1 downto 0) := (others => '0');

  component mux_2_in is
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
    end component mux_2_in;
  
BEGIN  -- ARCHITECTURE rtl

  -- Instantiate the multiplexer
  mux_2_in_i : component mux_2_in
  generic map (
      N => N
  )
  port map (
      i_select => s_selec_mux, 
      i_data_0 => s_mux_in_0,
      i_data_1 => s_mux_in_1, 
      o_data => s_data
  );

  P1 : PROCESS IS
    VARIABLE var_i : integer := 0;
    VARIABLE var_0 : integer := 0;
    VARIABLE var_1 : integer := 0;
    VARIABLE var_o : integer := 0;
  BEGIN  -- PROCESS

    -- Update signals
    s_mux_in_0 <= std_logic_vector(to_unsigned(var_0, n));
    s_mux_in_1 <= std_logic_vector(to_unsigned(var_1, n));
    
    wait until rising_edge(clk);

    var_o := to_integer(unsigned(s_data));

    -- Error message
    if (s_selec_mux = '0') then
      ASSERT s_mux_in_0 = s_data
        REPORT "ERROR: "& integer'image(var_0) &" != "& integer'image(var_o) 
        SEVERITY error;
    else
      ASSERT s_mux_in_1 = s_data
        REPORT "ERROR: "& integer'image(var_1) &" != "& integer'image(var_o)
        SEVERITY error;
    end if;

    -- Change variables
    case (var_i) is
      when 0 => var_0 := 0; var_1 := 0; s_selec_mux <= '1';
      when 1 => var_0 := 0; var_1 := 1; s_selec_mux <= '1';
      when 2 => var_0 := 63; var_1 := 1; s_selec_mux <= '1';
      when 3 => var_0 := 1; var_1 := 63; s_selec_mux <= '1';
      when 4 => var_0 := 63; var_1 := 63; s_selec_mux <= '1';
      when 5 => var_0 := 0; var_1 := 0; s_selec_mux <= '0';
      when 6 => var_0 := 0; var_1 := 1; s_selec_mux <= '0';
      when 7 => var_0 := 1; var_1 := 0; s_selec_mux <= '0';
      when 8 => var_0 := 1; var_1 := 63; s_selec_mux <= '0';
      when others => wait;
    end case;
    var_i := var_i + 1;

  END PROCESS P1;

  clk_p : process is
  begin
    clk <= '0';
    loop
      wait for 5 ns;
      clk <= not clk;
    end loop;
  end process;
  

END ARCHITECTURE rtl;
