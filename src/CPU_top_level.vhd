----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:40:00 02/15/2011 
-- Design Name: 
-- Module Name:    CPU_8bits - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CPU_8bits is
    Port ( reset 		 : in  STD_LOGIC;
           clk100M 	     : in  STD_LOGIC;
	 	   AN            : out STD_LOGIC_VECTOR(7 downto 0);
           Sevenseg 	 : out STD_LOGIC_VECTOR (7 downto 0);
           LED 		     : out STD_LOGIC_VECTOR (7 downto 0)
			 );
end CPU_8bits;

architecture Behavioral of CPU_8bits is

component clk_wiz_0
port
 (
   clk_in1           : in     std_logic;
   clk_out1          : out    std_logic
  );
end component;

component cpu
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
end component;

component acces_carte 
    port (clk 		    : in std_logic;
	 	  reset  		: in std_logic;
          AdrLSB 		: in std_logic_vector(3 downto 0);
          AdrMSB 		: in std_logic_vector(1 downto 0);
          DataLSB		: in std_logic_vector(3 downto 0);
          DataMSB		: in std_logic_vector(3 downto 0);
          DataInMem		: in std_logic_vector(7 downto 0);
	 	  ce1s  		: out std_logic;
	      ce25M  		: out std_logic;
	 	  AN            : out std_logic_vector(7 downto 0);
	 	  Sseg 			: out std_logic_vector(7 downto 0);
	 	  LED  			: out std_logic_vector(7 downto 0);
		  LEDg 			: out std_logic);
end component;

signal Data_Mem_Unit    : STD_LOGIC_VECTOR (7 downto 0);
signal Data_Unit_Mem    : STD_LOGIC_VECTOR (7 downto 0);
signal Adr           	: STD_LOGIC_VECTOR (5 downto 0);
signal clk25M			: STD_LOGIC;
signal ce1s 			: STD_LOGIC;
signal ce25M			: STD_LOGIC;
signal LEDg 			: STD_LOGIC;
signal sig_locked   	: STD_LOGIC;

--attribute mark_debug : string;
--attribute keep : string;
--attribute mark_debug of ce25M      : signal is "true";
--attribute mark_debug of sig_locked : signal is "true";
--attribute mark_debug of reset : signal is "true";

constant zero           : STD_LOGIC := '0';

begin

Clock_IP : clk_wiz_0
  port map
   (
    clk_in1  => clk100M,
    clk_out1 => clk25M
    );

-- Attention pour la simulation mettre  ce de UT et UC à ce25M sinon ce1s
														  
proc  				 : cpu port map ( reset,
                                      clk25M,
                                      ce25M,
									  Adr,
									  Data_Unit_Mem,
									  Data_Mem_Unit);


Peripheriques 	 : acces_carte  port map (clk25M,
										  Reset, 
										  Adr(3 downto 0), 
										  Adr(5 downto 4),
										  Data_Unit_Mem(3 downto 0), 
										  Data_Unit_Mem(7 downto 4),
										  Data_Mem_Unit,
										  ce1s,  
										  ce25M, 
										  AN,
										  Sevenseg, 
										  LED, 
										  LEDg);		
end Behavioral;

