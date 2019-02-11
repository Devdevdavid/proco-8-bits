-------------------------------
-- Project  : Proco-8bits
-- Date     : Jan. 2019
-- Author   : D.DEVANT & A.TROMPAT
-- School   : ENSEIRB-MATMECA
-- Desc     : Top Level to test the CPU on Nexus 4 DDR
-------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CPU_top_level is
port (
------ Globally routed signals -------
    clk100M 	 : in  STD_LOGIC;
    reset 		 : in  STD_LOGIC;
    AN           : out STD_LOGIC_VECTOR(7 downto 0);
    segment 	 : out STD_LOGIC_VECTOR(7 downto 0);
    LED 		 : out STD_LOGIC_VECTOR(7 downto 0)
);
end CPU_top_level;

architecture rtl of CPU_top_level is
------ Signals -------------------
    signal Data_Mem_Unit    : STD_LOGIC_VECTOR (7 downto 0);
    signal Data_Unit_Mem    : STD_LOGIC_VECTOR (7 downto 0);
    signal Adr           	: STD_LOGIC_VECTOR (5 downto 0);
    signal clk25M			: STD_LOGIC;
    signal ce1s 			: STD_LOGIC;
    signal ce25M			: STD_LOGIC;
    signal LEDg 			: STD_LOGIC;
    signal sig_locked   	: STD_LOGIC;

------ Components -------------------
    component clk_wiz_0
    port (
        clk_in1           : in     std_logic;
        clk_out1          : out    std_logic
    );
    end component;

    component cpu
    generic (
        OP_CODE_LENGTH: integer := 2;                        -- Number of bit for operation code
        ADD_LENGTH    : integer := 6                         -- Number of bit for address bus
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
    end component;

    component acces_carte 
    port (
    ------ Globally routed signals -------
        clk 		: in std_logic;
        reset  		: in std_logic;
    ------ Input data --------------------
        AdrLSB 		: in std_logic_vector(3 downto 0);
        AdrMSB 		: in std_logic_vector(1 downto 0);
        DataLSB		: in std_logic_vector(3 downto 0);
        DataMSB		: in std_logic_vector(3 downto 0);
        DataInMem	: in std_logic_vector(7 downto 0);
    ------ Output data -------------------
        ce1s  		: out std_logic;
        ce25M  		: out std_logic;
        AN          : out std_logic_vector(7 downto 0);
        Sseg 		: out std_logic_vector(7 downto 0);
        LED  		: out std_logic_vector(7 downto 0);
        LEDg 		: out std_logic
    );
    end component;
begin

    -- Instantiate the clock to divide 100MHz into 25MHz
    clk_wiz_i : clk_wiz_0
    port map (
        clk_in1  => clk100M,
        clk_out1 => clk25M
    );

    -- Instantiate a CPU
    cpu_i : cpu 
    generic map (
        OP_CODE_LENGTH => 2,
        ADD_LENGTH => 6
    )
    port map ( 
        reset => reset,
        clk => clk25M,
        ce => ce25M,
        o_mem_address => Adr,
        o_mem_in_data => Data_Unit_Mem,
        o_mem_out_data => Data_Mem_Unit
    );

    -- Instantiate the access_carte to oversee the CPU
    acces_carte_i : acces_carte  
    port map (
        clk => clk25M,
        reset => Reset, 
        AdrLSB => Adr(3 downto 0), 
        AdrMSB => Adr(5 downto 4),
        DataLSB => Data_Unit_Mem(3 downto 0), 
        DataMSB => Data_Unit_Mem(7 downto 4),
        DataInMem => Data_Mem_Unit,
        ce1s => ce1s,  
        ce25M => ce25M, 
        AN => AN,
        Sseg => segment, 
        LED => LED, 
        LEDg => LEDg
    );		
end rtl;

