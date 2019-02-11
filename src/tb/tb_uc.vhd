LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_uc IS
END ENTITY tb_uc;

ARCHITECTURE rtl OF tb_uc IS

  CONSTANT OP_CODE_LENGTH : integer := 2;
  CONSTANT ADD_LENGTH : integer := 6;

  -- Declaration
  signal reset : std_logic := '0';
  signal clk : std_logic := '0';
  signal s_carry : std_logic := '0';
  signal s_i_mem_data : std_logic_vector(OP_CODE_LENGTH + ADD_LENGTH - 1 downto 0) := (others => '0');
  signal s_o_mem_data : std_logic_vector(ADD_LENGTH - 1 downto 0) := (others => '0');
  signal s_init_carry : std_logic := '0';
  signal s_ld_carry : std_logic := '0';
  signal s_ld_accu : std_logic := '0';
  signal s_ld_mem : std_logic := '0';
  signal s_ld_mem_data : std_logic := '0';
  signal s_rw_mem_mode : std_logic := '0';
  signal s_selec_op : std_logic := '0';

  component uc is
  generic (
    OP_CODE_LENGTH : integer := 2;                       -- Number of bit for operation code
    ADD_LENGTH : integer := 6                            -- Number of bit for address bus
  );
  port (
  ------ Globally routed signals -------
    reset         : in  std_logic;                        -- Reset input  
    clk           : in  std_logic;                        -- Input clock
    ce            : in  std_logic;                        -- Clock enable
  ------ Input data --------------------
    i_carry       : in  std_logic;                        -- Carry from UT
    i_mem_data    : in  std_logic_vector(OP_CODE_LENGTH + ADD_LENGTH - 1 downto 0);   -- Incomming data from the memory
  ------ Output data -------------------
    o_mem_data    : out  std_logic_vector(ADD_LENGTH - 1 downto 0);   -- Output data for address
    
    o_init_carry  : out    std_logic;                      -- Init the carry flipflop
    o_ld_carry    : out    std_logic;                      -- Load for Carry flipflop
    o_ld_accu     : out    std_logic;                      -- Load accumulation resgister
    o_ld_mem      : out    std_logic;                      -- Load for memory
    o_ld_mem_data : out    std_logic;                      -- UT Memory data register
    o_rw_mem_mode : out    std_logic;                      -- Read (0) / Write (1) Mode of the memory
    o_selec_op    : out    std_logic                       -- Operation selection for UAL (0: NOR, 1: ADD)
  );
  end component uc;
  
BEGIN  -- ARCHITECTURE rtl

  uc_i : component uc
  generic map (
    OP_CODE_LENGTH => OP_CODE_LENGTH,
    ADD_LENGTH => ADD_LENGTH
  )
  port map (
    reset => reset, 
    clk => clk, 
    ce => '1', 
    i_carry => s_carry, 
    i_mem_data => s_i_mem_data, 
    o_mem_data => s_o_mem_data, 
    o_init_carry => s_init_carry, 
    o_ld_carry => s_ld_carry,
    o_ld_accu => s_ld_accu,
    o_ld_mem => s_ld_mem,
    o_ld_mem_data => s_ld_mem_data,
    o_rw_mem_mode => s_rw_mem_mode,
    o_selec_op => s_selec_op
  );

  P1 : PROCESS IS
    VARIABLE var_i_mem_data : integer := 32;
    VARIABLE var_o_mem_data : integer := 0;
    VARIABLE var_o_mem_data_old : integer := 0;
  BEGIN  -- PROCESS
    reset <= '1';
    wait until rising_edge(clk);
    wait until rising_edge(clk);

    reset <= '0';
    wait until rising_edge(clk);

    loop

      -- Write new OP Code
      s_i_mem_data <= "00000000";

      wait until rising_edge(clk);

      -- Fetch instruction

      wait until rising_edge(clk);

      -- Decode

      wait until rising_edge(clk);

      -- Fetch operand

      wait until rising_edge(clk);

      -- Exec UAL/STA/JCC

    end loop;
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
