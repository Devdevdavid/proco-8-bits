-------------------------------
-- Project  : Proco-8bits
-- Date     : Jan. 2019
-- Author   : D.DEVANT
-- School   : ENSEIRB-MATMECA
-- Desc     : A addressable memory
-------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity sync_ram is
generic (
    DATA_LENGTH : integer := 8;                           -- Number of bit for operation code
    ADD_LENGTH : integer := 6                             -- Number of bit for address bus
);
port (
------ Globally routed signals -------
    clk           : in  std_logic;                        -- Input clock
    ce            : in std_logic;                         -- Clock enable
------ Input data --------------------
    i_load        : in  std_logic;                        -- Load Memory
    i_rw_mode     : in  std_logic;                        -- Read/Write Mode (0: Read, 1: Write)
    i_address     : in  std_logic_vector(ADD_LENGTH - 1 downto 0);   -- Address to Read or Write
    i_data        : in  std_logic_vector(DATA_LENGTH - 1 downto 0);  -- Data input
------ Output data -------------------
    o_data        : out std_logic_vector(DATA_LENGTH - 1 downto 0)   -- Data output
);
end entity sync_ram;

architecture rtl of sync_ram is
------ Arrays --------------------
    type ram_t is array (integer(2 ** ADD_LENGTH - 1) downto 0) of std_logic_vector(i_data'range);
------ Function ------------------
    impure function init_ram(ram_file_name : in string) return ram_t is
        file ramfile : text;
        variable line_read : line;
        variable ram_to_return : ram_t;
        variable index : integer := 0;
        begin
            file_open(ramfile, ram_file_name, read_mode);

            for i in ram_t'reverse_range loop
                ram_to_return(i) := (others => '0');
            end loop;

            while not endfile(ramfile) loop
                readline(ramfile, line_read);
                hread(line_read, ram_to_return(index));
                index := index + 1;
            end loop;

            file_close(ramfile);
        return ram_to_return;
    end function;
------ Signals -------------------
    signal ram : ram_t := init_ram("./src/ram_2nd_prog.data");
    --signal ram : ram_t := init_ram("H:\Documents\2A\Proco\Proco 8bit\proco-8-bits-src\src\ram_2nd_prog.data");
    signal read_address : std_logic_vector(i_address'range) := (others => '0');
begin

    -- RAM Process
    ram_proc: process(clk) is
    begin
        if falling_edge(clk) then
            if ce = '1' and i_load = '1' then
                if i_rw_mode = '1' then -- Write mode
                    ram(to_integer(unsigned(i_address))) <= i_data;
                end if;
                read_address <= i_address;
            end if;
        end if;
    end process ram_proc;

    -- Permanent 
    o_data <= ram(to_integer(unsigned(read_address)));
end architecture rtl;