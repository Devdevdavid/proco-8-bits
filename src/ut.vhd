-------------------------------
-- Project  : Proco-8bits
-- Date     : Jan. 2019
-- Author   : D.DEVANT
-- School   : ENSEIRB-MATMECA
-- Desc     : Operation Unit
-------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ut is
generic (
    DATA_LENGTH  : integer := 8                          -- Number of bit
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
end ut;

architecture rtl of ut is
------ Signals -------------------
    signal s_mem_data_to_ual : std_logic_vector(DATA_LENGTH-1 downto 0);
    signal s_ual_result : std_logic_vector(DATA_LENGTH-1 downto 0);
    signal s_accu_data : std_logic_vector(DATA_LENGTH-1 downto 0);
    signal s_carry : std_logic;

------ Components -------------------
    component register_n_bits is
    generic (
        N : integer := 8                                     -- Number of bit
    );
    port (
    ------ Globally routed signals -------
        reset        : in  std_logic;                        -- Reset input  
        clk          : in  std_logic;                        -- Input clock
        ce           : in  std_logic;                        -- Clock enable
    ------ Input data --------------------
        i_load       : in  std_logic;                        -- Load input (0: Nothing, 1: Copy input to output)
        i_data       : in  std_logic_vector(N-1 downto 0);   -- Input data bits
    ------ Output data -------------------
        o_data       : out std_logic_vector(N-1 downto 0)    -- Output data bits
    );
    end component register_n_bits;
    
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

    component ual is
    generic (
        N : integer := 8                                     -- Number of bit
    );
    port (
    ------ Input data --------------------
        i_selec_op   : in  std_logic;                        -- Operation selection (0: NOR, 1: ADD)
        i_data_l     : in  std_logic_vector(N-1 downto 0);   -- Left input data bits
        i_data_r     : in  std_logic_vector(N-1 downto 0);   -- Right input data bits
    ------ Output data -------------------
        o_data       : out std_logic_vector(N-1 downto 0);   -- Output data bits
        o_carry      : out std_logic                        -- Carry of the operation
    );
    end component ual;
    
begin

    -- Instantiate the N-bits register for memory data
    reg_mem_data : component register_n_bits
    generic map (
        N => DATA_LENGTH
    )
    port map (
        reset => reset,
        clk => clk,
        ce => ce,
        i_load => i_ld_mem_data, 
        i_data => i_mem_data, 
        o_data => s_mem_data_to_ual 
    );

    -- Instantiate the N-bits register for accumulation 
    reg_accu : component register_n_bits
    generic map (
        N => DATA_LENGTH
    )
    port map (
        reset => reset,
        clk => clk,
        ce => ce,
        i_load => i_ld_accu, 
        i_data => s_ual_result, 
        o_data => s_accu_data 
    );

    -- Instantiate the flipflop for Carry 
    carry_flipflop : component flipflop
    port map (
        reset => reset,
        clk => clk,
        ce => ce,
        i_load => i_ld_carry, 
        i_init => i_init_carry,
        i_data => s_carry, 
        o_data => o_carry 
    );

    -- Instantiate UAL unit
    ual_i : component ual
    generic map (
        N => DATA_LENGTH
    )
    port map (
        i_selec_op => i_selec_op,
        i_data_l => s_mem_data_to_ual,
        i_data_r => s_accu_data, 
        o_data => s_ual_result, 
        o_carry => s_carry 
    );

    -- Permanant link
    o_mem_data <= s_accu_data;

end rtl;
