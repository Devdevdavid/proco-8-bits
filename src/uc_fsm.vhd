library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc_fsm is
port (
------ Globally routed signals -------
    reset         : in    std_logic;
    clk           : in    std_logic;
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
end uc_fsm;

architecture struct of uc_fsm is
  type state_t is ( -- Define the states of the fsm
    INIT,
    FETCH_INS,
    DECODE,
    FETCH_OPERAND,
    EXEC_UAL,
    EXEC_STA,
    EXEC_JCC
  );
  signal cur_state : state_t;    		                  -- Curent state of the fsm
  signal next_state : state_t;    		                -- NeXT state of the fsm
begin

  process (reset, clk) is
  begin
    if rising_edge(clk) then                
      if reset = '1' then                     
        cur_state <= INIT;
      else
        cur_state <= next_state;
      end if;
    end if;
  end process;

  -------------------------------------
  --              FSM                --
  -------------------------------------

  process (cur_state, i_op_code) is
  begin
    case (cur_state) is
    when INIT =>
      next_state <= FETCH_INS;

    when FETCH_INS =>
      next_state <= DECODE;

    when DECODE =>
      next_state <= FETCH_OPERAND;

    when FETCH_OPERAND =>
      case (i_op_code) is
        when "00" =>
          next_state <= EXEC_UAL;
        when "01" =>
          next_state <= EXEC_UAL;
        when "10" =>
          next_state <= EXEC_STA;
        when "11" =>
          next_state <= EXEC_JCC;
        when others =>
          next_state <= INIT;
      end case ;

    when EXEC_UAL =>
      next_state <= FETCH_INS;

    when EXEC_STA =>
      next_state <= FETCH_INS;
    
    when EXEC_JCC =>
      next_state <= FETCH_INS;
    end case;
  end process;

  -------------------------------------
  --            PROCESS              --
  -------------------------------------

  process (clk) is
  begin
    if rising_edge(clk) then
      case (cur_state) is
        when INIT =>
          o_init_carry   <= '1';
          o_init_cpt_add <= '1';
          o_ld_carry     <= '0';
          o_ld_cpt_add   <= '0';
          o_ld_inst      <= '0';
          o_ld_accu      <= '0';
          o_ld_mem       <= '0';
          o_ld_mem_data  <= '0';
          o_rw_mem_mode  <= '0';
          o_en_cpt_add   <= '0';
          o_selec_mux    <= '0';
          o_selec_op     <= '0';
    
        when FETCH_INS =>
          o_init_carry   <= '0';
          o_init_cpt_add <= '0';
          o_ld_carry     <= '0';
          o_ld_cpt_add   <= '0';
          o_ld_inst      <= '1';
          o_ld_accu      <= '0';
          o_ld_mem       <= '1';
          o_ld_mem_data  <= '0';
          o_rw_mem_mode  <= '0';
          o_en_cpt_add   <= '1';
          o_selec_mux    <= '0';
          o_selec_op     <= '0';
    
        when DECODE =>
          o_init_carry   <= '0';
          o_init_cpt_add <= '0';
          o_ld_carry     <= '0';
          o_ld_cpt_add   <= '0';
          o_ld_inst      <= '0';
          o_ld_accu      <= '0';
          o_ld_mem       <= '1';
          o_ld_mem_data  <= '0';
          o_rw_mem_mode  <= '0';
          o_en_cpt_add   <= '0';
          o_selec_mux    <= '1';
          o_selec_op     <= '0';
    
        when FETCH_OPERAND =>
          o_init_carry   <= '0';
          o_init_cpt_add <= '0';
          o_ld_carry     <= '0';
          o_ld_cpt_add   <= '0';
          o_ld_inst      <= '0';
          o_ld_accu      <= '0';
          o_ld_mem       <= '0';
          o_ld_mem_data  <= '1';
          o_rw_mem_mode  <= '0';
          o_en_cpt_add   <= '0';
          o_selec_mux    <= '1';
          o_selec_op     <= '0';
    
        when EXEC_UAL =>
          o_init_carry   <= '0';
          o_init_cpt_add <= '0';
          o_ld_carry     <= i_op_code(0);
          o_ld_cpt_add   <= '0';
          o_ld_inst      <= '0';
          o_ld_accu      <= '1';
          o_ld_mem       <= '0';
          o_ld_mem_data  <= '0';
          o_rw_mem_mode  <= '0';
          o_en_cpt_add   <= '0';
          o_selec_mux    <= '1';
          o_selec_op     <= i_op_code(0);
    
        when EXEC_STA =>
          o_init_carry   <= '0';
          o_init_cpt_add <= '0';
          o_ld_carry     <= '0';
          o_ld_cpt_add   <= '0';
          o_ld_inst      <= '0';
          o_ld_accu      <= '0';
          o_ld_mem       <= '1';
          o_ld_mem_data  <= '0';
          o_rw_mem_mode  <= '1';
          o_en_cpt_add   <= '0';
          o_selec_mux    <= '1';
          o_selec_op     <= '0';
        
        when EXEC_JCC =>
          o_init_carry   <= i_carry;                  -- Init carry only if needed
          o_init_cpt_add <= '0';
          o_ld_carry     <= '0';
          o_ld_cpt_add   <= not i_carry;
          o_ld_inst      <= '0';
          o_ld_accu      <= '0';
          o_ld_mem       <= '0';
          o_ld_mem_data  <= '0';
          o_rw_mem_mode  <= '0';
          o_en_cpt_add   <= '0';
          o_selec_mux    <= '1';
          o_selec_op     <= '0';
      end case;
    end if;
  end process;

end struct;
