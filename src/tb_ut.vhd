LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_ut IS
END ENTITY tb_ut;

ARCHITECTURE rtl OF tb_ut IS

  CONSTANT N : integer := 8;

  -- Declaration
  signal reset : std_logic := '0';
  signal clk : std_logic := '0';
  signal s_i_mem_data : std_logic_vector(N-1 downto 0) := (others => '0');
  signal s_selec_op : std_logic := '0';
  signal s_ld_mem_data : std_logic := '0';
  signal s_ld_accu : std_logic := '0';
  signal s_ld_carry : std_logic := '0';
  signal s_init_carry : std_logic := '0';
  signal s_o_mem_data : std_logic_vector(N-1 downto 0) := (others => '0');
  signal s_carry : std_logic := '0';

  component ut is
  generic (
    N : integer := 8                                     -- Number of bit
  );
  port (
  ------ Globally routed signals -------
    reset        : in  std_logic;                        -- Reset input  
    clk          : in  std_logic;                        -- Input clock
  ------ Input data --------------------
    i_mem_data   : in  std_logic_vector(N-1 downto 0);   -- Incomming data from the memory
    i_selec_op   : in  std_logic;                        -- Operation selection (0: NOR, 1: ADD)
    i_ld_mem_data: in  std_logic;                        -- Load of the memory data register
    i_ld_accu    : in  std_logic;                        -- Load of the Accu register
    i_ld_carry   : in  std_logic;                        -- Load of the Carry flip flop
    i_init_carry : in  std_logic;                        -- Initialization of the flip flop carry
  ------ Output data -------------------
    o_mem_data   : out std_logic_vector(N-1 downto 0);   -- Output data going to memory
    o_carry      : out  std_logic                        -- Carry from the flip flop
  );
  end component ut;
  
BEGIN  -- ARCHITECTURE rtl

  ut_i : component ut
  generic map (
    N => N
  )
  port map (
    reset => reset, 
    clk => clk, 
    i_mem_data => s_i_mem_data, 
    i_selec_op => s_selec_op,
    i_ld_mem_data => s_ld_mem_data,
    i_ld_accu => s_ld_accu,
    i_ld_carry => s_ld_carry,
    i_init_carry => s_init_carry,
    o_mem_data => s_o_mem_data,
    o_carry => s_carry
  );

  P1 : PROCESS IS
    VARIABLE var_i_mem_data : integer := 1;
    VARIABLE var_o_mem_data : integer := 0;
    VARIABLE var_o_mem_data_old : integer := 0;
  BEGIN  -- PROCESS

    wait until rising_edge(clk);

    -- Fetch operands
    s_i_mem_data <= std_logic_vector(to_unsigned(var_i_mem_data, N));
    s_ld_mem_data <= '1';
    var_o_mem_data_old := to_integer(unsigned(s_o_mem_data)); -- Save current value of ACC

    wait until rising_edge(clk);

    -- Exec UAL 
    s_ld_mem_data <= '0';
    s_selec_op <= '1'; -- ADD Operation
    s_ld_accu <= '1'; -- Save result
    s_ld_carry <= '1';  -- Save Carry

    wait until rising_edge(clk);

    s_ld_accu <= '0';
    s_ld_carry <= '0';

    var_o_mem_data := to_integer(unsigned(s_o_mem_data));

    -- Error message
    ASSERT var_o_mem_data = var_o_mem_data_old + var_i_mem_data;
      REPORT "ERROR: "& integer'image(var_o_mem_data_old) &" + "& integer'image(var_i_mem_data) &" != "& integer'image(var_o_mem_data) 
      SEVERITY error;
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
