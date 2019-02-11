LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_cpu IS
END ENTITY tb_cpu;

ARCHITECTURE rtl OF tb_cpu IS
  CONSTANT OP_CODE_LENGTH : integer := 2;
  CONSTANT ADD_LENGTH : integer := 6;

  -- Declaration
  signal reset : std_logic := '0';
  signal clk : std_logic := '0';
  signal ce : std_logic := '0';
  signal s_mem_out     : std_logic_vector(OP_CODE_LENGTH + ADD_LENGTH - 1 downto 0) := (others => '0');
  signal s_mem_in      : std_logic_vector(OP_CODE_LENGTH + ADD_LENGTH - 1 downto 0) := (others => '0');


  component cpu is
  generic (
    OP_CODE_LENGTH : integer := 2;                       -- Number of bit for operation code
    ADD_LENGTH : integer := 6                            -- Number of bit for address bus
  );
  port (
  ------ Globally routed signals -------
    reset         : in  std_logic;                        -- Reset input  
    clk           : in  std_logic;                        -- Input clock
    ce            : in  std_logic;                        -- Clock enable
  ------ Output data -------------------
    o_mem_in_data : out std_logic_vector(OP_CODE_LENGTH + ADD_LENGTH - 1 downto 0); -- Input data bus from memory
    o_mem_out_data: out std_logic_vector(OP_CODE_LENGTH + ADD_LENGTH - 1 downto 0)  -- Output data bus to memory
  );
  end component cpu;
  
BEGIN  -- ARCHITECTURE rtl

  cpu_i : component cpu
  generic map (
    OP_CODE_LENGTH => OP_CODE_LENGTH,
    ADD_LENGTH => ADD_LENGTH
  )
  port map (
    reset => reset, 
    clk => clk,
    ce => ce,
    o_mem_in_data => s_mem_in,
    o_mem_out_data => s_mem_out
  );

  P1 : PROCESS IS
    VARIABLE var : integer := 0;
  BEGIN  -- PROCESS
    reset <= '1';
    ce <= '1';
    wait until rising_edge(clk);
    wait until rising_edge(clk);

    reset <= '0';
    wait until rising_edge(clk);

    loop

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
