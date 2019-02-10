library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc is
generic (
    OP_CODE_LENGTH : integer := 2;                       -- Number of bit for operation code
    ADD_LENGTH : integer := 6                            -- Number of bit for address bus
);
port (
------ Globally routed signals -------
    reset         : in  std_logic;                        -- Reset input  
    clk           : in  std_logic;                        -- Input clock
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
end uc;

architecture rtl of uc is
------ Signals -------------------
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

    signal s_cur_inst    : std_logic_vector(OP_CODE_LENGTH + ADD_LENGTH - 1 downto 0) := (others => '0');
    signal s_mux_in_0    : std_logic_vector(ADD_LENGTH - 1 downto 0) := (others => '0');
------ Components -------------------
    component uc_fsm is
    generic (
        OP_CODE_LENGTH : integer := 2                          -- Number of bit
    );
    port (
    ------ Globally routed signals -------
        reset         : in    std_logic;
        clk           : in    std_logic;
    ------ Input data --------------------
        i_carry       : in    std_logic;                       -- Carry bit from UT
        i_op_code     : in    std_logic_vector(OP_CODE_LENGTH - 1 downto 0);    -- Operation code
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

    component counter_n_bits is
    generic (
        N : integer := 6                                     -- Number of bit
    );
    port (
    ------ Globally routed signals -------
        reset        : in  std_logic;                        -- Reset input  
        clk          : in  std_logic;                        -- Input clock
    ------ Input data --------------------
        i_enable     : in  std_logic;                        -- Enable (0: nothing, 1: counting clk)
        i_init       : in  std_logic;                        -- Reset counter value to 0
        i_load       : in  std_logic;                        -- Load i_data if high
        i_data       : in  std_logic_vector(N-1 downto 0);   -- Input data bits
    ------ Output data -------------------
        o_data       : out std_logic_vector(N-1 downto 0)    -- Output data bits
    );
    end component counter_n_bits;

    component register_n_bits is
    generic (
        N : integer := 8                                     -- Number of bit
    );
    port (
    ------ Globally routed signals -------
        reset        : in  std_logic;                        -- Reset input  
        clk          : in  std_logic;                        -- Input clock
    ------ Input data --------------------
        i_load       : in  std_logic;                        -- Load input (0: Nothing, 1: Copy input to output)
        i_data       : in  std_logic_vector(N-1 downto 0);   -- Input data bits
    ------ Output data -------------------
        o_data       : out std_logic_vector(N-1 downto 0)    -- Output data bits
    );
    end component register_n_bits;

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
begin

    -- Instantiate the FSM
    uc_fsm_i : component uc_fsm
    generic map (
        OP_CODE_LENGTH => OP_CODE_LENGTH
    )
    port map (
        reset          => reset, 
        clk            => clk, 
        i_carry        => i_carry, 
        i_op_code      => s_cur_inst(OP_CODE_LENGTH + ADD_LENGTH - 1 downto ADD_LENGTH), 
        o_init_carry   => o_init_carry,
        o_init_cpt_add => s_init_cpt_add,
        o_ld_carry     => o_ld_carry,
        o_ld_cpt_add   => s_ld_cpt_add,
        o_ld_inst      => s_ld_inst,
        o_ld_accu      => o_ld_accu,
        o_ld_mem       => o_ld_mem,
        o_ld_mem_data  => o_ld_mem_data,
        o_rw_mem_mode  => o_rw_mem_mode,
        o_en_cpt_add   => s_en_cpt_add,
        o_selec_mux    => s_selec_mux,
        o_selec_op     => o_selec_op  
    );

    -- Instantiate the N-bits register for memory data
    add_counter : component counter_n_bits
    generic map (
        N => ADD_LENGTH
    )
    port map (
        reset => reset,
        clk => clk,
        i_enable => s_en_cpt_add, 
        i_init => s_init_cpt_add, 
        i_load => s_ld_cpt_add, 
        i_data => s_cur_inst(ADD_LENGTH - 1 downto 0), 
        o_data => s_mux_in_0 
    );

    -- Instantiate the multiplexer
    mux_2_in_i : component mux_2_in
    generic map (
        N => ADD_LENGTH
    )
    port map (
        i_select => s_selec_mux, 
        i_data_0 => s_mux_in_0,
        i_data_1 => s_cur_inst(ADD_LENGTH - 1 downto 0), 
        o_data => o_mem_data 
    );

    -- Instantiate the N-bits register for accumulation 
    reg_inst : component register_n_bits
    generic map (
        N => OP_CODE_LENGTH + ADD_LENGTH
    )
    port map (
        reset => reset,
        clk => clk,
        i_load => s_ld_inst, 
        i_data => i_mem_data, 
        o_data => s_cur_inst 
    );

end rtl;
