library IEEE;
use IEEE.STD_LOGIC_1164.all;

-----> !! This package is auto-generated from an address table file using <repo_root>/scripts/generate_registers.py !! <-----
package registers is

    --============================================================================
    --       >>> TTC Module <<<    base address: 0x00300000
    --
    -- TTC control and monitoring. It takes care of locking to the TTC clock
    -- coming from the backplane as well as decoding TTC commands and forwarding
    -- that to all other modules in the design. It also provides several control
    -- and monitoring registers (resets, command decoding configuration, clock and
    -- data status, bc0 status, command counters and a small spy buffer)
    --============================================================================

    constant REG_TTC_NUM_REGS : integer := 21;

    constant REG_TTC_CTRL_L1A_ENABLE_ADDR    : std_logic_vector(5 downto 0) := '00' & x"0";
    constant REG_TTC_CTRL_L1A_ENABLE_HIGH    : integer := 0;
    constant REG_TTC_CTRL_L1A_ENABLE_LOW     : integer := 0;
    constant REG_TTC_CTRL_L1A_ENABLE_DEFAULT : std_logic := '1';

    constant REG_TTC_CTRL_MMCM_PHASE_SHIFT_ADDR    : std_logic_vector(5 downto 0) := '00' & x"0";
    constant REG_TTC_CTRL_MMCM_PHASE_SHIFT_HIGH    : integer := 28;
    constant REG_TTC_CTRL_MMCM_PHASE_SHIFT_LOW     : integer := 28;

    constant REG_TTC_CTRL_CNT_RESET_ADDR    : std_logic_vector(5 downto 0) := '00' & x"0";
    constant REG_TTC_CTRL_CNT_RESET_HIGH    : integer := 29;
    constant REG_TTC_CTRL_CNT_RESET_LOW     : integer := 29;

    constant REG_TTC_CTRL_MMCM_RESET_ADDR    : std_logic_vector(5 downto 0) := '00' & x"0";
    constant REG_TTC_CTRL_MMCM_RESET_HIGH    : integer := 30;
    constant REG_TTC_CTRL_MMCM_RESET_LOW     : integer := 30;

    constant REG_TTC_CTRL_MODULE_RESET_ADDR    : std_logic_vector(5 downto 0) := '00' & x"0";
    constant REG_TTC_CTRL_MODULE_RESET_HIGH    : integer := 31;
    constant REG_TTC_CTRL_MODULE_RESET_LOW     : integer := 31;

    constant REG_TTC_CONFIG_CMD_BC0_ADDR    : std_logic_vector(5 downto 0) := '00' & x"1";
    constant REG_TTC_CONFIG_CMD_BC0_HIGH    : integer := 7;
    constant REG_TTC_CONFIG_CMD_BC0_LOW     : integer := 0;
    constant REG_TTC_CONFIG_CMD_BC0_DEFAULT : std_logic_vector(7 downto 0) := x"01";

    constant REG_TTC_CONFIG_CMD_EC0_ADDR    : std_logic_vector(5 downto 0) := '00' & x"1";
    constant REG_TTC_CONFIG_CMD_EC0_HIGH    : integer := 15;
    constant REG_TTC_CONFIG_CMD_EC0_LOW     : integer := 8;
    constant REG_TTC_CONFIG_CMD_EC0_DEFAULT : std_logic_vector(15 downto 8) := x"02";

    constant REG_TTC_CONFIG_CMD_RESYNC_ADDR    : std_logic_vector(5 downto 0) := '00' & x"1";
    constant REG_TTC_CONFIG_CMD_RESYNC_HIGH    : integer := 23;
    constant REG_TTC_CONFIG_CMD_RESYNC_LOW     : integer := 16;
    constant REG_TTC_CONFIG_CMD_RESYNC_DEFAULT : std_logic_vector(23 downto 16) := x"04";

    constant REG_TTC_CONFIG_CMD_OC0_ADDR    : std_logic_vector(5 downto 0) := '00' & x"1";
    constant REG_TTC_CONFIG_CMD_OC0_HIGH    : integer := 31;
    constant REG_TTC_CONFIG_CMD_OC0_LOW     : integer := 24;
    constant REG_TTC_CONFIG_CMD_OC0_DEFAULT : std_logic_vector(31 downto 24) := x"08";

    constant REG_TTC_CONFIG_CMD_HARD_RESET_ADDR    : std_logic_vector(5 downto 0) := '00' & x"2";
    constant REG_TTC_CONFIG_CMD_HARD_RESET_HIGH    : integer := 7;
    constant REG_TTC_CONFIG_CMD_HARD_RESET_LOW     : integer := 0;
    constant REG_TTC_CONFIG_CMD_HARD_RESET_DEFAULT : std_logic_vector(7 downto 0) := x"10";

    constant REG_TTC_CONFIG_CMD_CALPULSE_ADDR    : std_logic_vector(5 downto 0) := '00' & x"2";
    constant REG_TTC_CONFIG_CMD_CALPULSE_HIGH    : integer := 15;
    constant REG_TTC_CONFIG_CMD_CALPULSE_LOW     : integer := 8;
    constant REG_TTC_CONFIG_CMD_CALPULSE_DEFAULT : std_logic_vector(15 downto 8) := x"14";

    constant REG_TTC_CONFIG_CMD_START_ADDR    : std_logic_vector(5 downto 0) := '00' & x"2";
    constant REG_TTC_CONFIG_CMD_START_HIGH    : integer := 23;
    constant REG_TTC_CONFIG_CMD_START_LOW     : integer := 16;
    constant REG_TTC_CONFIG_CMD_START_DEFAULT : std_logic_vector(23 downto 16) := x"18";

    constant REG_TTC_CONFIG_CMD_STOP_ADDR    : std_logic_vector(5 downto 0) := '00' & x"2";
    constant REG_TTC_CONFIG_CMD_STOP_HIGH    : integer := 31;
    constant REG_TTC_CONFIG_CMD_STOP_LOW     : integer := 24;
    constant REG_TTC_CONFIG_CMD_STOP_DEFAULT : std_logic_vector(31 downto 24) := x"1c";

    constant REG_TTC_CONFIG_CMD_TEST_SYNC_ADDR    : std_logic_vector(5 downto 0) := '00' & x"3";
    constant REG_TTC_CONFIG_CMD_TEST_SYNC_HIGH    : integer := 7;
    constant REG_TTC_CONFIG_CMD_TEST_SYNC_LOW     : integer := 0;
    constant REG_TTC_CONFIG_CMD_TEST_SYNC_DEFAULT : std_logic_vector(7 downto 0) := x"20";

    constant REG_TTC_STATUS_MMCM_LOCKED_ADDR    : std_logic_vector(5 downto 0) := '00' & x"4";
    constant REG_TTC_STATUS_MMCM_LOCKED_HIGH    : integer := 0;
    constant REG_TTC_STATUS_MMCM_LOCKED_LOW     : integer := 0;

    constant REG_TTC_STATUS_TTC_SINGLE_ERROR_CNT_ADDR    : std_logic_vector(5 downto 0) := '00' & x"5";
    constant REG_TTC_STATUS_TTC_SINGLE_ERROR_CNT_HIGH    : integer := 15;
    constant REG_TTC_STATUS_TTC_SINGLE_ERROR_CNT_LOW     : integer := 0;

    constant REG_TTC_STATUS_TTC_DOUBLE_ERROR_CNT_ADDR    : std_logic_vector(5 downto 0) := '00' & x"5";
    constant REG_TTC_STATUS_TTC_DOUBLE_ERROR_CNT_HIGH    : integer := 31;
    constant REG_TTC_STATUS_TTC_DOUBLE_ERROR_CNT_LOW     : integer := 16;

    constant REG_TTC_STATUS_BC0_LOCKED_ADDR    : std_logic_vector(5 downto 0) := '00' & x"6";
    constant REG_TTC_STATUS_BC0_LOCKED_HIGH    : integer := 0;
    constant REG_TTC_STATUS_BC0_LOCKED_LOW     : integer := 0;

    constant REG_TTC_STATUS_BC0_UNLOCK_CNT_ADDR    : std_logic_vector(5 downto 0) := '00' & x"7";
    constant REG_TTC_STATUS_BC0_UNLOCK_CNT_HIGH    : integer := 15;
    constant REG_TTC_STATUS_BC0_UNLOCK_CNT_LOW     : integer := 0;

    constant REG_TTC_STATUS_BC0_OVERFLOW_CNT_ADDR    : std_logic_vector(5 downto 0) := '00' & x"8";
    constant REG_TTC_STATUS_BC0_OVERFLOW_CNT_HIGH    : integer := 15;
    constant REG_TTC_STATUS_BC0_OVERFLOW_CNT_LOW     : integer := 0;

    constant REG_TTC_STATUS_BC0_UNDERFLOW_CNT_ADDR    : std_logic_vector(5 downto 0) := '00' & x"8";
    constant REG_TTC_STATUS_BC0_UNDERFLOW_CNT_HIGH    : integer := 31;
    constant REG_TTC_STATUS_BC0_UNDERFLOW_CNT_LOW     : integer := 16;

    constant REG_TTC_CMD_COUNTERS_L1A_ADDR    : std_logic_vector(5 downto 0) := '00' & x"9";
    constant REG_TTC_CMD_COUNTERS_L1A_HIGH    : integer := 31;
    constant REG_TTC_CMD_COUNTERS_L1A_LOW     : integer := 0;

    constant REG_TTC_CMD_COUNTERS_BC0_ADDR    : std_logic_vector(5 downto 0) := '00' & x"a";
    constant REG_TTC_CMD_COUNTERS_BC0_HIGH    : integer := 31;
    constant REG_TTC_CMD_COUNTERS_BC0_LOW     : integer := 0;

    constant REG_TTC_CMD_COUNTERS_EC0_ADDR    : std_logic_vector(5 downto 0) := '00' & x"b";
    constant REG_TTC_CMD_COUNTERS_EC0_HIGH    : integer := 31;
    constant REG_TTC_CMD_COUNTERS_EC0_LOW     : integer := 0;

    constant REG_TTC_CMD_COUNTERS_RESYNC_ADDR    : std_logic_vector(5 downto 0) := '00' & x"c";
    constant REG_TTC_CMD_COUNTERS_RESYNC_HIGH    : integer := 31;
    constant REG_TTC_CMD_COUNTERS_RESYNC_LOW     : integer := 0;

    constant REG_TTC_CMD_COUNTERS_OC0_ADDR    : std_logic_vector(5 downto 0) := '00' & x"d";
    constant REG_TTC_CMD_COUNTERS_OC0_HIGH    : integer := 31;
    constant REG_TTC_CMD_COUNTERS_OC0_LOW     : integer := 0;

    constant REG_TTC_CMD_COUNTERS_HARD_RESET_ADDR    : std_logic_vector(5 downto 0) := '00' & x"e";
    constant REG_TTC_CMD_COUNTERS_HARD_RESET_HIGH    : integer := 31;
    constant REG_TTC_CMD_COUNTERS_HARD_RESET_LOW     : integer := 0;

    constant REG_TTC_CMD_COUNTERS_CALPULSE_ADDR    : std_logic_vector(5 downto 0) := '00' & x"f";
    constant REG_TTC_CMD_COUNTERS_CALPULSE_HIGH    : integer := 31;
    constant REG_TTC_CMD_COUNTERS_CALPULSE_LOW     : integer := 0;

    constant REG_TTC_CMD_COUNTERS_START_ADDR    : std_logic_vector(5 downto 0) := '01' & x"0";
    constant REG_TTC_CMD_COUNTERS_START_HIGH    : integer := 31;
    constant REG_TTC_CMD_COUNTERS_START_LOW     : integer := 0;

    constant REG_TTC_CMD_COUNTERS_STOP_ADDR    : std_logic_vector(5 downto 0) := '01' & x"1";
    constant REG_TTC_CMD_COUNTERS_STOP_HIGH    : integer := 31;
    constant REG_TTC_CMD_COUNTERS_STOP_LOW     : integer := 0;

    constant REG_TTC_CMD_COUNTERS_TEST_SYNC_ADDR    : std_logic_vector(5 downto 0) := '01' & x"2";
    constant REG_TTC_CMD_COUNTERS_TEST_SYNC_HIGH    : integer := 31;
    constant REG_TTC_CMD_COUNTERS_TEST_SYNC_LOW     : integer := 0;

    constant REG_TTC_L1A_ID_ADDR    : std_logic_vector(5 downto 0) := '01' & x"3";
    constant REG_TTC_L1A_ID_HIGH    : integer := 23;
    constant REG_TTC_L1A_ID_LOW     : integer := 0;

    constant REG_TTC_TTC_SPY_BUFFER_ADDR    : std_logic_vector(5 downto 0) := '01' & x"4";
    constant REG_TTC_TTC_SPY_BUFFER_HIGH    : integer := 31;
    constant REG_TTC_TTC_SPY_BUFFER_LOW     : integer := 0;


end registers;
