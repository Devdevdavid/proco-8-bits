-------------------------------
-- Project  : Proco-8bits
-- Date     : Jan. 2019
-- Author   : D.DEVANT
-- School   : ENSEIRB-MATMECA
-- Desc     : Top Layer of the project
-------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu is
generic (
    OP_CODE_LENGTH : integer := 2;                       -- Number of bit for operation code
    ADD_LENGTH : integer := 6                            -- Number of bit for address bus
);
port (
------ Globally routed signals -------
    reset         : in  std_logic;                       -- Reset input  
    clk           : in  std_logic;                       -- Input clock
    ce            : in  std_logic;                       -- Clock enable
------ Output data -------------------
    o_mem_address : out std_logic_vector(ADD_LENGTH - 1 downto 0);  -- Current Memory address
    o_mem_in_data : out std_logic_vector(OP_CODE_LENGTH + ADD_LENGTH - 1 downto 0); -- Input data bus from memory
    o_mem_out_data: out std_logic_vector(OP_CODE_LENGTH + ADD_LENGTH - 1 downto 0)  -- Output data bus to memory
);
end cpu;

architecture rtl of cpu is
------ Signals -------------------
    signal s_mem_address : std_logic_vector(ADD_LENGTH - 1 downto 0) := (others => '0');
    signal s_mem_out     : std_logic_vector(OP_CODE_LENGTH + ADD_LENGTH - 1 downto 0) := (others => '0');
    signal s_mem_in      : std_logic_vector(OP_CODE_LENGTH + ADD_LENGTH - 1 downto 0) := (others => '0');

    signal s_carry       : std_logic := '0';
    signal s_init_carry  : std_logic := '0';
    signal s_ld_carry    : std_logic := '0';
    signal s_ld_accu     : std_logic := '0';
    signal s_ld_mem      : std_logic := '0';
    signal s_ld_mem_data : std_logic := '0';
    signal s_rw_mem_mode : std_logic := '0';
    signal s_selec_op    : std_logic := '0';
    
------ Components -------------------
    component ut is
    generic (
        DATA_LENGTH : integer := 8                           -- Number of bit
    );
    port (
    ------ Globally routed signals -------
        reset        : in  std_logic;                        -- Reset input  
        clk          : in  std_logic;                        -- Input clock
        ce           : in  std_logic;                        -- Clock enable
    ------ Input data --------------------
        i_mem_data   : in  std_logic_vector(DATA_LENGTH-1 downto 0);   -- Incomming data from the memory
        i_selec_op   : in  std_logic;                        -- Operation selection (0: NOR, 1: ADD)
        i_ld_mem_data: in  std_logic;                        -- Load of the memory data register
        i_ld_accu    : in  std_logic;                        -- Load of the Accu register
        i_ld_carry   : in  std_logic;                        -- Load of the Carry flip flop
        i_init_carry : in  std_logic;                        -- Initialization of the flip flop carry
    ------ Output data -------------------
        o_mem_data   : out std_logic_vector(DATA_LENGTH-1 downto 0);   -- Output data going to memory
        o_carry      : out  std_logic                        -- Carry from the flip flop
    );
    end component ut;

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

    component sync_ram is
    generic (
        DATA_LENGTH : integer := 8;                           -- Number of bit for operation code
        ADD_LENGTH : integer := 6                             -- Number of bit for address bus
    );
    port (
    ------ Globally routed signals -------
        clk           : in  std_logic;                        -- Input clock
        ce            : in  std_logic;                        -- Clock enable
    ------ Input data --------------------
        i_load        : in  std_logic;                        -- Load Memory
        i_rw_mode     : in  std_logic;                        -- Read/Write Mode (0: Read, 1: Write)
        i_address     : in  std_logic_vector(ADD_LENGTH - 1 downto 0);   -- Address to Read or Write
        i_data        : in  std_logic_vector(DATA_LENGTH - 1 downto 0);  -- Data input
    ------ Output data -------------------
        o_data        : out std_logic_vector(DATA_LENGTH - 1 downto 0)   -- Data output
    );
    end component sync_ram;
begin

    uc_i : component uc
    generic map (
        OP_CODE_LENGTH => OP_CODE_LENGTH,
        ADD_LENGTH => ADD_LENGTH
    )
    port map (
        reset => reset, 
        clk => clk, 
        ce => ce, 
        i_carry => s_carry, 
        i_mem_data => s_mem_out, 
        o_mem_data => s_mem_address, 
        o_init_carry => s_init_carry, 
        o_ld_carry => s_ld_carry,
        o_ld_accu => s_ld_accu,
        o_ld_mem => s_ld_mem,
        o_ld_mem_data => s_ld_mem_data,
        o_rw_mem_mode => s_rw_mem_mode,
        o_selec_op => s_selec_op
    );

    ut_i : component ut
    generic map (
        DATA_LENGTH => ADD_LENGTH + OP_CODE_LENGTH
    )
    port map (
        reset => reset, 
        clk => clk, 
        ce => ce, 
        i_mem_data => s_mem_out, 
        i_selec_op => s_selec_op,
        i_ld_mem_data => s_ld_mem_data,
        i_ld_accu => s_ld_accu,
        i_ld_carry => s_ld_carry,
        i_init_carry => s_init_carry,
        o_mem_data => s_mem_in,
        o_carry => s_carry
    );

    sync_ram_i : component sync_ram
    generic map (
        DATA_LENGTH => OP_CODE_LENGTH + ADD_LENGTH,
        ADD_LENGTH => ADD_LENGTH
    )
    port map (
        clk => clk, 
        ce => ce, 
        i_load => s_ld_mem, 
        i_rw_mode => s_rw_mem_mode, 
        i_address => s_mem_address, 
        i_data => s_mem_in, 
        o_data => s_mem_out
    );

    -- Permanent
    o_mem_in_data <= s_mem_in;
    o_mem_out_data <= s_mem_out;
    o_mem_address <= s_mem_address;

end rtl;
