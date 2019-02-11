LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_flipflop IS
END ENTITY tb_flipflop;

ARCHITECTURE rtl OF tb_flipflop IS

  CONSTANT N : integer := 6;

  -- Declaration
  signal clk : std_logic := '0';
  signal reset : std_logic := '0';
  signal ce : std_logic := '0';
  signal s_load : std_logic := '0';
  signal s_init : std_logic := '0';
  signal s_i_data : std_logic := '0';
  signal s_o_data : std_logic := '0';

  component flipflop is
    port (
    ------ Globally routed signals -------
        reset        : in  std_logic;                        -- Reset input  
        clk          : in  std_logic;                        -- Input clock
        ce           : in  std_logic;                        -- Clock enable
    ------ Input data --------------------
        i_load       : in  std_logic;                        -- Load input (0: Nothing, 1: Copy input to output)
        i_init       : in  std_logic;                        -- Init input (0: Nothing, 1: Set output to 0)
        i_data       : in  std_logic;                        -- Input data bits
    ------ Output data -------------------
        o_data       : out std_logic                         -- Output data bits
    );
    end component flipflop;
  
BEGIN  -- ARCHITECTURE rtl

  -- Instantiate the flipflop for Carry 
  carry_flipflop : component flipflop
  port map (
      reset => reset,
      clk => clk,
      ce => '1',
      i_load => s_load, 
      i_init => s_init,
      i_data => s_i_data, 
      o_data => s_o_data 
  );

  P1 : PROCESS IS
    VARIABLE var_i : integer := 0;
  BEGIN  -- PROCESS

    wait until rising_edge(clk);

    -- Change variables
    case (var_i) is
      when 0 => s_load <= '0'; s_init <= '0'; s_i_data <= '0';
      when 1 => s_load <= '1'; s_init <= '0'; s_i_data <= '0';
      when 2 => s_load <= '0'; s_init <= '0'; s_i_data <= '0';
      when 3 => s_load <= '0'; s_init <= '0'; s_i_data <= '1';
      when 4 => s_load <= '0'; s_init <= '0'; s_i_data <= '0';
      when 5 => s_load <= '1'; s_init <= '0'; s_i_data <= '1';
      when 6 => s_load <= '0'; s_init <= '0'; s_i_data <= '1';
      when 7 => s_load <= '0'; s_init <= '1'; s_i_data <= '1';
      when others => wait;
    end case;
    var_i := var_i + 1;

  END PROCESS P1;

  clk_p : process is
  begin
    clk <= '0';
    reset <= '1';
    wait for 5 ns;
    clk <= not clk;
    wait for 5 ns;
    clk <= not clk;
    loop
      wait for 5 ns;
      clk <= not clk;
      reset <= '0';
    end loop;
  end process;
  

END ARCHITECTURE rtl;


