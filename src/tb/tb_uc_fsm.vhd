LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_uc_fsm IS
END ENTITY tb_uc_fsm;

ARCHITECTURE rtl OF tb_uc_fsm IS
  -- Declaration
  signal reset : std_logic := '0';
  signal clk : std_logic := '0';

  signal s_carry : std_logic := '0';
  signal s_op_code : std_logic_vector(1 downto 0) := "00";

  signal s_init_carry  : std_logic := '0';
  signal s_init_cpt_add: std_logic := '0';
  signal s_ld_carry    : std_logic := '0';
  signal s_ld_cpt_add  : std_logic := '0';
  signal s_ld_inst     : std_logic := '0';
  signal s_ld_accu     : std_logic := '0';
  signal s_ld_mem      : std_logic := '0';
  signal s_ld_mem_data : std_logic := '0';
  signal s_rw_mem_mode : std_logic := '0';
  signal s_en_cpt_add  : std_logic := '0';
  signal s_selec_mux   : std_logic := '0';
  signal s_selec_op    : std_logic := '0';

  component uc_fsm is
  generic (
      OP_CODE_LENGTH : integer := 2                          -- Number of bit
  );
  port (
  ------ Globally routed signals -------
      reset         : in    std_logic;
      clk           : in    std_logic;
      ce            : in    std_logic;
  ------ Input data --------------------
      i_carry       : in    std_logic;                      -- Carry bit from UT
      i_op_code     : in    std_logic_vector(1 downto 0);   -- Operation code
  ------ Output data -------------------
      o_init_carry  : out    std_logic;                      -- Init the carry flipflop
      o_init_cpt_add: out    std_logic;                      -- Init the address counter
      o_ld_carry    : out    std_logic;                      -- Load for Carry flipflop
      o_ld_cpt_add  : out    std_logic;                      -- Load for address counter
      o_ld_inst     : out    std_logic;                      -- Load for instruction register
      o_ld_accu     : out    std_logic;                      -- Load accumulation resgister
      o_ld_mem      : out    std_logic;                      -- Load for memory
      o_ld_mem_data : out    std_logic;                      -- UT Memory data register
      o_rw_mem_mode : out    std_logic;                      -- Read (0) / Write (1) Mode of the memory
      o_en_cpt_add  : out    std_logic;                      -- Enable for address counter
      o_selec_mux   : out    std_logic;                      -- Mux selection (0: Cpt Add, 1: Inst Reg)
      o_selec_op    : out    std_logic                       -- Operation selection for UAL (0: NOR, 1: ADD)
  );
  end component uc_fsm;
  
BEGIN  -- ARCHITECTURE rtl

  uc_fsm_i : component uc_fsm
  generic map (
    OP_CODE_LENGTH => 2
  )
  port map (
    reset => reset, 
    clk => clk, 
    ce => '1', 
    i_carry => s_carry, 
    i_op_code => s_op_code, 
    o_init_carry   => s_init_carry,
    o_init_cpt_add => s_init_cpt_add,
    o_ld_carry     => s_ld_carry,
    o_ld_cpt_add   => s_ld_cpt_add,
    o_ld_inst      => s_ld_inst,
    o_ld_accu      => s_ld_accu,
    o_ld_mem       => s_ld_mem,
    o_ld_mem_data  => s_ld_mem_data,
    o_rw_mem_mode  => s_rw_mem_mode,
    o_en_cpt_add   => s_en_cpt_add,
    o_selec_mux    => s_selec_mux,
    o_selec_op     => s_selec_op  
  );

  P1 : PROCESS IS
    VARIABLE var_op_code : integer := 0;
  BEGIN  -- PROCESS

    reset <= '1';
    wait until rising_edge(clk);
    wait until rising_edge(clk);

    reset <= '0';
    wait until rising_edge(clk);

    loop

      -- Write new OP Code
      s_op_code <= std_logic_vector(to_unsigned(var_op_code, s_op_code'length));

      wait until rising_edge(clk);

      -- Fetch instruction

      wait until rising_edge(clk);

      -- Decode

      wait until rising_edge(clk);

      -- Fetch operand

      wait until rising_edge(clk);

      -- Exec UAL/STA/JCC

      -- Change OP Code
      if (var_op_code = 3) then
        var_op_code := 0; 
      else 
        var_op_code := var_op_code + 1;
      end if;
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
