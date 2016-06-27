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

    constant REG_TTC_NUM_REGS : integer := 22;
    constant REG_TTC_ADDRESS_MSB : integer := 5;
    constant REG_TTC_ADDRESS_LSB : integer := 0;
    constant REG_TTC_CTRL_L1A_ENABLE_ADDR    : std_logic_vector(5 downto 0) := "00" & x"0";
    constant REG_TTC_CTRL_L1A_ENABLE_BIT    : integer := 0;
    constant REG_TTC_CTRL_L1A_ENABLE_DEFAULT : std_logic := '1';

    constant REG_TTC_CTRL_MMCM_PHASE_SHIFT_ADDR    : std_logic_vector(5 downto 0) := "00" & x"0";
    constant REG_TTC_CTRL_MMCM_PHASE_SHIFT_BIT    : integer := 28;

    constant REG_TTC_CTRL_CNT_RESET_ADDR    : std_logic_vector(5 downto 0) := "00" & x"0";
    constant REG_TTC_CTRL_CNT_RESET_BIT    : integer := 29;

    constant REG_TTC_CTRL_MMCM_RESET_ADDR    : std_logic_vector(5 downto 0) := "00" & x"0";
    constant REG_TTC_CTRL_MMCM_RESET_BIT    : integer := 30;

    constant REG_TTC_CTRL_MODULE_RESET_ADDR    : std_logic_vector(5 downto 0) := "00" & x"0";
    constant REG_TTC_CTRL_MODULE_RESET_BIT    : integer := 31;

    constant REG_TTC_CONFIG_CMD_BC0_ADDR    : std_logic_vector(5 downto 0) := "00" & x"1";
    constant REG_TTC_CONFIG_CMD_BC0_MSB    : integer := 7;
    constant REG_TTC_CONFIG_CMD_BC0_LSB     : integer := 0;
    constant REG_TTC_CONFIG_CMD_BC0_DEFAULT : std_logic_vector(7 downto 0) := x"01";

    constant REG_TTC_CONFIG_CMD_EC0_ADDR    : std_logic_vector(5 downto 0) := "00" & x"1";
    constant REG_TTC_CONFIG_CMD_EC0_MSB    : integer := 15;
    constant REG_TTC_CONFIG_CMD_EC0_LSB     : integer := 8;
    constant REG_TTC_CONFIG_CMD_EC0_DEFAULT : std_logic_vector(15 downto 8) := x"02";

    constant REG_TTC_CONFIG_CMD_RESYNC_ADDR    : std_logic_vector(5 downto 0) := "00" & x"1";
    constant REG_TTC_CONFIG_CMD_RESYNC_MSB    : integer := 23;
    constant REG_TTC_CONFIG_CMD_RESYNC_LSB     : integer := 16;
    constant REG_TTC_CONFIG_CMD_RESYNC_DEFAULT : std_logic_vector(23 downto 16) := x"04";

    constant REG_TTC_CONFIG_CMD_OC0_ADDR    : std_logic_vector(5 downto 0) := "00" & x"1";
    constant REG_TTC_CONFIG_CMD_OC0_MSB    : integer := 31;
    constant REG_TTC_CONFIG_CMD_OC0_LSB     : integer := 24;
    constant REG_TTC_CONFIG_CMD_OC0_DEFAULT : std_logic_vector(31 downto 24) := x"08";

    constant REG_TTC_CONFIG_CMD_HARD_RESET_ADDR    : std_logic_vector(5 downto 0) := "00" & x"2";
    constant REG_TTC_CONFIG_CMD_HARD_RESET_MSB    : integer := 7;
    constant REG_TTC_CONFIG_CMD_HARD_RESET_LSB     : integer := 0;
    constant REG_TTC_CONFIG_CMD_HARD_RESET_DEFAULT : std_logic_vector(7 downto 0) := x"10";

    constant REG_TTC_CONFIG_CMD_CALPULSE_ADDR    : std_logic_vector(5 downto 0) := "00" & x"2";
    constant REG_TTC_CONFIG_CMD_CALPULSE_MSB    : integer := 15;
    constant REG_TTC_CONFIG_CMD_CALPULSE_LSB     : integer := 8;
    constant REG_TTC_CONFIG_CMD_CALPULSE_DEFAULT : std_logic_vector(15 downto 8) := x"14";

    constant REG_TTC_CONFIG_CMD_START_ADDR    : std_logic_vector(5 downto 0) := "00" & x"2";
    constant REG_TTC_CONFIG_CMD_START_MSB    : integer := 23;
    constant REG_TTC_CONFIG_CMD_START_LSB     : integer := 16;
    constant REG_TTC_CONFIG_CMD_START_DEFAULT : std_logic_vector(23 downto 16) := x"18";

    constant REG_TTC_CONFIG_CMD_STOP_ADDR    : std_logic_vector(5 downto 0) := "00" & x"2";
    constant REG_TTC_CONFIG_CMD_STOP_MSB    : integer := 31;
    constant REG_TTC_CONFIG_CMD_STOP_LSB     : integer := 24;
    constant REG_TTC_CONFIG_CMD_STOP_DEFAULT : std_logic_vector(31 downto 24) := x"1c";

    constant REG_TTC_CONFIG_CMD_TEST_SYNC_ADDR    : std_logic_vector(5 downto 0) := "00" & x"3";
    constant REG_TTC_CONFIG_CMD_TEST_SYNC_MSB    : integer := 7;
    constant REG_TTC_CONFIG_CMD_TEST_SYNC_LSB     : integer := 0;
    constant REG_TTC_CONFIG_CMD_TEST_SYNC_DEFAULT : std_logic_vector(7 downto 0) := x"20";

    constant REG_TTC_STATUS_MMCM_LOCKED_ADDR    : std_logic_vector(5 downto 0) := "00" & x"4";
    constant REG_TTC_STATUS_MMCM_LOCKED_BIT    : integer := 0;

    constant REG_TTC_STATUS_TTC_SINGLE_ERROR_CNT_ADDR    : std_logic_vector(5 downto 0) := "00" & x"5";
    constant REG_TTC_STATUS_TTC_SINGLE_ERROR_CNT_MSB    : integer := 15;
    constant REG_TTC_STATUS_TTC_SINGLE_ERROR_CNT_LSB     : integer := 0;

    constant REG_TTC_STATUS_TTC_DOUBLE_ERROR_CNT_ADDR    : std_logic_vector(5 downto 0) := "00" & x"5";
    constant REG_TTC_STATUS_TTC_DOUBLE_ERROR_CNT_MSB    : integer := 31;
    constant REG_TTC_STATUS_TTC_DOUBLE_ERROR_CNT_LSB     : integer := 16;

    constant REG_TTC_STATUS_BC0_LOCKED_ADDR    : std_logic_vector(5 downto 0) := "00" & x"6";
    constant REG_TTC_STATUS_BC0_LOCKED_BIT    : integer := 0;

    constant REG_TTC_STATUS_BC0_UNLOCK_CNT_ADDR    : std_logic_vector(5 downto 0) := "00" & x"7";
    constant REG_TTC_STATUS_BC0_UNLOCK_CNT_MSB    : integer := 15;
    constant REG_TTC_STATUS_BC0_UNLOCK_CNT_LSB     : integer := 0;

    constant REG_TTC_STATUS_BC0_OVERFLOW_CNT_ADDR    : std_logic_vector(5 downto 0) := "00" & x"8";
    constant REG_TTC_STATUS_BC0_OVERFLOW_CNT_MSB    : integer := 15;
    constant REG_TTC_STATUS_BC0_OVERFLOW_CNT_LSB     : integer := 0;

    constant REG_TTC_STATUS_BC0_UNDERFLOW_CNT_ADDR    : std_logic_vector(5 downto 0) := "00" & x"8";
    constant REG_TTC_STATUS_BC0_UNDERFLOW_CNT_MSB    : integer := 31;
    constant REG_TTC_STATUS_BC0_UNDERFLOW_CNT_LSB     : integer := 16;

    constant REG_TTC_CMD_COUNTERS_L1A_ADDR    : std_logic_vector(5 downto 0) := "00" & x"9";
    constant REG_TTC_CMD_COUNTERS_L1A_MSB    : integer := 31;
    constant REG_TTC_CMD_COUNTERS_L1A_LSB     : integer := 0;

    constant REG_TTC_CMD_COUNTERS_BC0_ADDR    : std_logic_vector(5 downto 0) := "00" & x"a";
    constant REG_TTC_CMD_COUNTERS_BC0_MSB    : integer := 31;
    constant REG_TTC_CMD_COUNTERS_BC0_LSB     : integer := 0;

    constant REG_TTC_CMD_COUNTERS_EC0_ADDR    : std_logic_vector(5 downto 0) := "00" & x"b";
    constant REG_TTC_CMD_COUNTERS_EC0_MSB    : integer := 31;
    constant REG_TTC_CMD_COUNTERS_EC0_LSB     : integer := 0;

    constant REG_TTC_CMD_COUNTERS_RESYNC_ADDR    : std_logic_vector(5 downto 0) := "00" & x"c";
    constant REG_TTC_CMD_COUNTERS_RESYNC_MSB    : integer := 31;
    constant REG_TTC_CMD_COUNTERS_RESYNC_LSB     : integer := 0;

    constant REG_TTC_CMD_COUNTERS_OC0_ADDR    : std_logic_vector(5 downto 0) := "00" & x"d";
    constant REG_TTC_CMD_COUNTERS_OC0_MSB    : integer := 31;
    constant REG_TTC_CMD_COUNTERS_OC0_LSB     : integer := 0;

    constant REG_TTC_CMD_COUNTERS_HARD_RESET_ADDR    : std_logic_vector(5 downto 0) := "00" & x"e";
    constant REG_TTC_CMD_COUNTERS_HARD_RESET_MSB    : integer := 31;
    constant REG_TTC_CMD_COUNTERS_HARD_RESET_LSB     : integer := 0;

    constant REG_TTC_CMD_COUNTERS_CALPULSE_ADDR    : std_logic_vector(5 downto 0) := "00" & x"f";
    constant REG_TTC_CMD_COUNTERS_CALPULSE_MSB    : integer := 31;
    constant REG_TTC_CMD_COUNTERS_CALPULSE_LSB     : integer := 0;

    constant REG_TTC_CMD_COUNTERS_START_ADDR    : std_logic_vector(5 downto 0) := "01" & x"0";
    constant REG_TTC_CMD_COUNTERS_START_MSB    : integer := 31;
    constant REG_TTC_CMD_COUNTERS_START_LSB     : integer := 0;

    constant REG_TTC_CMD_COUNTERS_STOP_ADDR    : std_logic_vector(5 downto 0) := "01" & x"1";
    constant REG_TTC_CMD_COUNTERS_STOP_MSB    : integer := 31;
    constant REG_TTC_CMD_COUNTERS_STOP_LSB     : integer := 0;

    constant REG_TTC_CMD_COUNTERS_TEST_SYNC_ADDR    : std_logic_vector(5 downto 0) := "01" & x"2";
    constant REG_TTC_CMD_COUNTERS_TEST_SYNC_MSB    : integer := 31;
    constant REG_TTC_CMD_COUNTERS_TEST_SYNC_LSB     : integer := 0;

    constant REG_TTC_L1A_ID_ADDR    : std_logic_vector(5 downto 0) := "01" & x"3";
    constant REG_TTC_L1A_ID_MSB    : integer := 23;
    constant REG_TTC_L1A_ID_LSB     : integer := 0;

    constant REG_TTC_L1A_RATE_ADDR    : std_logic_vector(5 downto 0) := "01" & x"4";
    constant REG_TTC_L1A_RATE_MSB    : integer := 31;
    constant REG_TTC_L1A_RATE_LSB     : integer := 0;

    constant REG_TTC_TTC_SPY_BUFFER_ADDR    : std_logic_vector(5 downto 0) := "01" & x"5";
    constant REG_TTC_TTC_SPY_BUFFER_MSB    : integer := 31;
    constant REG_TTC_TTC_SPY_BUFFER_LSB     : integer := 0;


    --============================================================================
    --       >>> TRIGGER Module <<<    base address: 0x00800000
    --
    -- Trigger module handles everything related to sbit cluster data (link
    -- synchronization, monitoring, local triggering, matching to L1A and
    -- reporting data to DAQ)
    --============================================================================

    constant REG_TRIGGER_NUM_REGS : integer := 70;
    constant REG_TRIGGER_ADDRESS_MSB : integer := 12;
    constant REG_TRIGGER_ADDRESS_LSB : integer := 0;
    constant REG_TRIGGER_CTRL_CNT_RESET_ADDR    : std_logic_vector(12 downto 0) := '0' & x"000";
    constant REG_TRIGGER_CTRL_CNT_RESET_BIT    : integer := 30;

    constant REG_TRIGGER_CTRL_MODULE_RESET_ADDR    : std_logic_vector(12 downto 0) := '0' & x"000";
    constant REG_TRIGGER_CTRL_MODULE_RESET_BIT    : integer := 31;

    constant REG_TRIGGER_CTRL_OH_KILL_MASK_ADDR    : std_logic_vector(12 downto 0) := '0' & x"001";
    constant REG_TRIGGER_CTRL_OH_KILL_MASK_MSB    : integer := 23;
    constant REG_TRIGGER_CTRL_OH_KILL_MASK_LSB     : integer := 0;
    constant REG_TRIGGER_CTRL_OH_KILL_MASK_DEFAULT : std_logic_vector(23 downto 0) := x"000000";

    constant REG_TRIGGER_STATUS_OR_TRIGGER_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"010";
    constant REG_TRIGGER_STATUS_OR_TRIGGER_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_STATUS_OR_TRIGGER_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_STATUS_OR_TRIGGER_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"011";
    constant REG_TRIGGER_STATUS_OR_TRIGGER_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_STATUS_OR_TRIGGER_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_TRIGGER_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"100";
    constant REG_TRIGGER_OH0_TRIGGER_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_TRIGGER_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_TRIGGER_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"101";
    constant REG_TRIGGER_OH0_TRIGGER_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_TRIGGER_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_0_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"110";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_0_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_0_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_1_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"111";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_1_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_1_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_2_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"112";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_2_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_2_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_3_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"113";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_3_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_3_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_4_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"114";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_4_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_4_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_5_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"115";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_5_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_5_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_6_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"116";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_6_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_6_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_7_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"117";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_7_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_7_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_8_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"118";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_8_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_8_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_0_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"120";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_0_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_0_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_1_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"121";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_1_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_1_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_2_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"122";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_2_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_2_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_3_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"123";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_3_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_3_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_4_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"124";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_4_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_4_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_5_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"125";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_5_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_5_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_6_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"126";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_6_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_6_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_7_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"127";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_7_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_7_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_8_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"128";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_8_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_8_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_LINK0_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1a0";
    constant REG_TRIGGER_OH0_LINK0_NOT_VALID_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH0_LINK0_NOT_VALID_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_LINK1_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1a0";
    constant REG_TRIGGER_OH0_LINK1_NOT_VALID_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_LINK1_NOT_VALID_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH0_LINK0_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1a1";
    constant REG_TRIGGER_OH0_LINK0_MISSED_COMMA_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH0_LINK0_MISSED_COMMA_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_LINK1_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1a1";
    constant REG_TRIGGER_OH0_LINK1_MISSED_COMMA_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_LINK1_MISSED_COMMA_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH0_LINK0_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1a2";
    constant REG_TRIGGER_OH0_LINK0_OVERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH0_LINK0_OVERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_LINK1_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1a2";
    constant REG_TRIGGER_OH0_LINK1_OVERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_LINK1_OVERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH0_LINK0_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1a3";
    constant REG_TRIGGER_OH0_LINK0_UNDERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH0_LINK0_UNDERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_LINK1_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1a3";
    constant REG_TRIGGER_OH0_LINK1_UNDERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_LINK1_UNDERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH0_LINK0_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1a4";
    constant REG_TRIGGER_OH0_LINK0_SYNC_WORD_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH0_LINK0_SYNC_WORD_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_LINK1_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1a4";
    constant REG_TRIGGER_OH0_LINK1_SYNC_WORD_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_LINK1_SYNC_WORD_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_0_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1f0";
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_0_MSB    : integer := 15;
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_0_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_1_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1f1";
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_1_MSB    : integer := 15;
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_1_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_2_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1f2";
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_2_MSB    : integer := 15;
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_2_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_3_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1f3";
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_3_MSB    : integer := 15;
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_3_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_4_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1f4";
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_4_MSB    : integer := 15;
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_4_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_5_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1f5";
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_5_MSB    : integer := 15;
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_5_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_6_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1f6";
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_6_MSB    : integer := 15;
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_6_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_7_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1f7";
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_7_MSB    : integer := 15;
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_7_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_TRIGGER_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"200";
    constant REG_TRIGGER_OH1_TRIGGER_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_TRIGGER_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_TRIGGER_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"201";
    constant REG_TRIGGER_OH1_TRIGGER_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_TRIGGER_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_0_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"210";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_0_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_0_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_1_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"211";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_1_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_1_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_2_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"212";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_2_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_2_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_3_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"213";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_3_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_3_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_4_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"214";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_4_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_4_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_5_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"215";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_5_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_5_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_6_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"216";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_6_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_6_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_7_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"217";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_7_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_7_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_8_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"218";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_8_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_8_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_0_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"220";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_0_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_0_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_1_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"221";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_1_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_1_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_2_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"222";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_2_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_2_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_3_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"223";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_3_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_3_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_4_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"224";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_4_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_4_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_5_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"225";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_5_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_5_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_6_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"226";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_6_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_6_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_7_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"227";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_7_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_7_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_8_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"228";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_8_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_8_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_LINK0_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2a0";
    constant REG_TRIGGER_OH1_LINK0_NOT_VALID_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH1_LINK0_NOT_VALID_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_LINK1_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2a0";
    constant REG_TRIGGER_OH1_LINK1_NOT_VALID_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_LINK1_NOT_VALID_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH1_LINK0_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2a1";
    constant REG_TRIGGER_OH1_LINK0_MISSED_COMMA_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH1_LINK0_MISSED_COMMA_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_LINK1_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2a1";
    constant REG_TRIGGER_OH1_LINK1_MISSED_COMMA_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_LINK1_MISSED_COMMA_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH1_LINK0_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2a2";
    constant REG_TRIGGER_OH1_LINK0_OVERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH1_LINK0_OVERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_LINK1_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2a2";
    constant REG_TRIGGER_OH1_LINK1_OVERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_LINK1_OVERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH1_LINK0_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2a3";
    constant REG_TRIGGER_OH1_LINK0_UNDERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH1_LINK0_UNDERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_LINK1_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2a3";
    constant REG_TRIGGER_OH1_LINK1_UNDERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_LINK1_UNDERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH1_LINK0_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2a4";
    constant REG_TRIGGER_OH1_LINK0_SYNC_WORD_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH1_LINK0_SYNC_WORD_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_LINK1_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2a4";
    constant REG_TRIGGER_OH1_LINK1_SYNC_WORD_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_LINK1_SYNC_WORD_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_0_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2f0";
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_0_MSB    : integer := 15;
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_0_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_1_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2f1";
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_1_MSB    : integer := 15;
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_1_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_2_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2f2";
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_2_MSB    : integer := 15;
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_2_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_3_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2f3";
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_3_MSB    : integer := 15;
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_3_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_4_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2f4";
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_4_MSB    : integer := 15;
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_4_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_5_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2f5";
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_5_MSB    : integer := 15;
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_5_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_6_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2f6";
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_6_MSB    : integer := 15;
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_6_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_7_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2f7";
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_7_MSB    : integer := 15;
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_7_LSB     : integer := 0;


    --============================================================================
    --       >>> GEM_SYSTEM Module <<<    base address: 0x00900000
    --
    -- This module is controlling GEM AMC System wide settings
    --============================================================================

    constant REG_GEM_SYSTEM_NUM_REGS : integer := 12;
    constant REG_GEM_SYSTEM_ADDRESS_MSB : integer := 16;
    constant REG_GEM_SYSTEM_ADDRESS_LSB : integer := 0;
    constant REG_GEM_SYSTEM_TK_LINK_RX_POLARITY_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0000";
    constant REG_GEM_SYSTEM_TK_LINK_RX_POLARITY_MSB    : integer := 23;
    constant REG_GEM_SYSTEM_TK_LINK_RX_POLARITY_LSB     : integer := 0;
    constant REG_GEM_SYSTEM_TK_LINK_RX_POLARITY_DEFAULT : std_logic_vector(23 downto 0) := x"000000";

    constant REG_GEM_SYSTEM_TK_LINK_TX_POLARITY_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0001";
    constant REG_GEM_SYSTEM_TK_LINK_TX_POLARITY_MSB    : integer := 23;
    constant REG_GEM_SYSTEM_TK_LINK_TX_POLARITY_LSB     : integer := 0;
    constant REG_GEM_SYSTEM_TK_LINK_TX_POLARITY_DEFAULT : std_logic_vector(23 downto 0) := x"000000";

    constant REG_GEM_SYSTEM_BOARD_ID_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0002";
    constant REG_GEM_SYSTEM_BOARD_ID_MSB    : integer := 15;
    constant REG_GEM_SYSTEM_BOARD_ID_LSB     : integer := 0;
    constant REG_GEM_SYSTEM_BOARD_ID_DEFAULT : std_logic_vector(15 downto 0) := x"beef";

    constant REG_GEM_SYSTEM_BOARD_TYPE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0002";
    constant REG_GEM_SYSTEM_BOARD_TYPE_MSB    : integer := 19;
    constant REG_GEM_SYSTEM_BOARD_TYPE_LSB     : integer := 16;

    constant REG_GEM_SYSTEM_RELEASE_BUILD_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0003";
    constant REG_GEM_SYSTEM_RELEASE_BUILD_MSB    : integer := 7;
    constant REG_GEM_SYSTEM_RELEASE_BUILD_LSB     : integer := 0;

    constant REG_GEM_SYSTEM_RELEASE_MINOR_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0003";
    constant REG_GEM_SYSTEM_RELEASE_MINOR_MSB    : integer := 15;
    constant REG_GEM_SYSTEM_RELEASE_MINOR_LSB     : integer := 8;

    constant REG_GEM_SYSTEM_RELEASE_MAJOR_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0003";
    constant REG_GEM_SYSTEM_RELEASE_MAJOR_MSB    : integer := 23;
    constant REG_GEM_SYSTEM_RELEASE_MAJOR_LSB     : integer := 16;

    constant REG_GEM_SYSTEM_RELEASE_DATE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0004";
    constant REG_GEM_SYSTEM_RELEASE_DATE_MSB    : integer := 31;
    constant REG_GEM_SYSTEM_RELEASE_DATE_LSB     : integer := 0;

    constant REG_GEM_SYSTEM_CONFIG_NUM_OF_OH_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0005";
    constant REG_GEM_SYSTEM_CONFIG_NUM_OF_OH_MSB    : integer := 4;
    constant REG_GEM_SYSTEM_CONFIG_NUM_OF_OH_LSB     : integer := 0;

    constant REG_GEM_SYSTEM_CONFIG_USE_GBT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0005";
    constant REG_GEM_SYSTEM_CONFIG_USE_GBT_BIT    : integer := 8;

    constant REG_GEM_SYSTEM_CONFIG_USE_TRIG_LINKS_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0005";
    constant REG_GEM_SYSTEM_CONFIG_USE_TRIG_LINKS_BIT    : integer := 9;

    constant REG_GEM_SYSTEM_GBT_TX_SYNC_PATTERN_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0100";
    constant REG_GEM_SYSTEM_GBT_TX_SYNC_PATTERN_MSB    : integer := 15;
    constant REG_GEM_SYSTEM_GBT_TX_SYNC_PATTERN_LSB     : integer := 0;
    constant REG_GEM_SYSTEM_GBT_TX_SYNC_PATTERN_DEFAULT : std_logic_vector(15 downto 0) := x"76bc";

    constant REG_GEM_SYSTEM_CTRL_CNT_RESET_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0100";
    constant REG_GEM_SYSTEM_CTRL_CNT_RESET_BIT    : integer := 30;

    constant REG_GEM_SYSTEM_GBT_RX_SYNC_PATTERN_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0101";
    constant REG_GEM_SYSTEM_GBT_RX_SYNC_PATTERN_MSB    : integer := 31;
    constant REG_GEM_SYSTEM_GBT_RX_SYNC_PATTERN_LSB     : integer := 0;
    constant REG_GEM_SYSTEM_GBT_RX_SYNC_PATTERN_DEFAULT : std_logic_vector(31 downto 0) := x"76bc76bc";

    constant REG_GEM_SYSTEM_GBT_RX_SYNC_COUNT_REQUIRED_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0102";
    constant REG_GEM_SYSTEM_GBT_RX_SYNC_COUNT_REQUIRED_MSB    : integer := 7;
    constant REG_GEM_SYSTEM_GBT_RX_SYNC_COUNT_REQUIRED_LSB     : integer := 0;
    constant REG_GEM_SYSTEM_GBT_RX_SYNC_COUNT_REQUIRED_DEFAULT : std_logic_vector(7 downto 0) := x"03";

    constant REG_GEM_SYSTEM_LEGACY_SYSTEM_BOARD_ID_ADDR    : std_logic_vector(16 downto 0) := '1' & x"0000";
    constant REG_GEM_SYSTEM_LEGACY_SYSTEM_BOARD_ID_MSB    : integer := 31;
    constant REG_GEM_SYSTEM_LEGACY_SYSTEM_BOARD_ID_LSB     : integer := 0;

    constant REG_GEM_SYSTEM_LEGACY_SYSTEM_SYSTEM_ID_ADDR    : std_logic_vector(16 downto 0) := '1' & x"0001";
    constant REG_GEM_SYSTEM_LEGACY_SYSTEM_SYSTEM_ID_MSB    : integer := 31;
    constant REG_GEM_SYSTEM_LEGACY_SYSTEM_SYSTEM_ID_LSB     : integer := 0;

    constant REG_GEM_SYSTEM_LEGACY_SYSTEM_FIRMWARE_VERSION_ADDR    : std_logic_vector(16 downto 0) := '1' & x"0002";
    constant REG_GEM_SYSTEM_LEGACY_SYSTEM_FIRMWARE_VERSION_MSB    : integer := 31;
    constant REG_GEM_SYSTEM_LEGACY_SYSTEM_FIRMWARE_VERSION_LSB     : integer := 0;


    --============================================================================
    --       >>> DAQ Module <<<    base address: 0x00700000
    --
    -- DAQ module buffers track data, builds events, analyses the data for
    -- consistency and ships off the events with all the needed headers and
    -- trailers to AMC13 over DAQLink
    --============================================================================

    constant REG_DAQ_NUM_REGS : integer := 46;
    constant REG_DAQ_ADDRESS_MSB : integer := 8;
    constant REG_DAQ_ADDRESS_LSB : integer := 0;
    constant REG_DAQ_CONTROL_DAQ_ENABLE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"00";
    constant REG_DAQ_CONTROL_DAQ_ENABLE_BIT    : integer := 0;
    constant REG_DAQ_CONTROL_DAQ_ENABLE_DEFAULT : std_logic := '0';

    constant REG_DAQ_CONTROL_DAQ_LINK_RESET_ADDR    : std_logic_vector(8 downto 0) := '0' & x"00";
    constant REG_DAQ_CONTROL_DAQ_LINK_RESET_BIT    : integer := 2;
    constant REG_DAQ_CONTROL_DAQ_LINK_RESET_DEFAULT : std_logic := '0';

    constant REG_DAQ_CONTROL_RESET_ADDR    : std_logic_vector(8 downto 0) := '0' & x"00";
    constant REG_DAQ_CONTROL_RESET_BIT    : integer := 3;
    constant REG_DAQ_CONTROL_RESET_DEFAULT : std_logic := '0';

    constant REG_DAQ_CONTROL_TTS_OVERRIDE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"00";
    constant REG_DAQ_CONTROL_TTS_OVERRIDE_MSB    : integer := 7;
    constant REG_DAQ_CONTROL_TTS_OVERRIDE_LSB     : integer := 4;
    constant REG_DAQ_CONTROL_TTS_OVERRIDE_DEFAULT : std_logic_vector(7 downto 4) := x"0";

    constant REG_DAQ_CONTROL_INPUT_ENABLE_MASK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"00";
    constant REG_DAQ_CONTROL_INPUT_ENABLE_MASK_MSB    : integer := 31;
    constant REG_DAQ_CONTROL_INPUT_ENABLE_MASK_LSB     : integer := 8;
    constant REG_DAQ_CONTROL_INPUT_ENABLE_MASK_DEFAULT : std_logic_vector(31 downto 8) := x"000001";

    constant REG_DAQ_STATUS_DAQ_LINK_RDY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"01";
    constant REG_DAQ_STATUS_DAQ_LINK_RDY_BIT    : integer := 0;

    constant REG_DAQ_STATUS_DAQ_CLK_LOCKED_ADDR    : std_logic_vector(8 downto 0) := '0' & x"01";
    constant REG_DAQ_STATUS_DAQ_CLK_LOCKED_BIT    : integer := 1;

    constant REG_DAQ_STATUS_TTC_RDY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"01";
    constant REG_DAQ_STATUS_TTC_RDY_BIT    : integer := 2;

    constant REG_DAQ_STATUS_DAQ_LINK_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"01";
    constant REG_DAQ_STATUS_DAQ_LINK_AFULL_BIT    : integer := 3;

    constant REG_DAQ_STATUS_DAQ_OUTPUT_FIFO_HAD_OVERFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"01";
    constant REG_DAQ_STATUS_DAQ_OUTPUT_FIFO_HAD_OVERFLOW_BIT    : integer := 4;

    constant REG_DAQ_STATUS_TTC_BC0_LOCKED_ADDR    : std_logic_vector(8 downto 0) := '0' & x"01";
    constant REG_DAQ_STATUS_TTC_BC0_LOCKED_BIT    : integer := 5;

    constant REG_DAQ_STATUS_L1A_FIFO_HAD_OVERFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"01";
    constant REG_DAQ_STATUS_L1A_FIFO_HAD_OVERFLOW_BIT    : integer := 23;

    constant REG_DAQ_STATUS_L1A_FIFO_IS_UNDERFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"01";
    constant REG_DAQ_STATUS_L1A_FIFO_IS_UNDERFLOW_BIT    : integer := 24;

    constant REG_DAQ_STATUS_L1A_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"01";
    constant REG_DAQ_STATUS_L1A_FIFO_IS_FULL_BIT    : integer := 25;

    constant REG_DAQ_STATUS_L1A_FIFO_IS_NEAR_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"01";
    constant REG_DAQ_STATUS_L1A_FIFO_IS_NEAR_FULL_BIT    : integer := 26;

    constant REG_DAQ_STATUS_L1A_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"01";
    constant REG_DAQ_STATUS_L1A_FIFO_IS_EMPTY_BIT    : integer := 27;

    constant REG_DAQ_STATUS_TTS_STATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"01";
    constant REG_DAQ_STATUS_TTS_STATE_MSB    : integer := 31;
    constant REG_DAQ_STATUS_TTS_STATE_LSB     : integer := 28;

    constant REG_DAQ_EXT_STATUS_NOTINTABLE_ERR_ADDR    : std_logic_vector(8 downto 0) := '0' & x"02";
    constant REG_DAQ_EXT_STATUS_NOTINTABLE_ERR_MSB    : integer := 15;
    constant REG_DAQ_EXT_STATUS_NOTINTABLE_ERR_LSB     : integer := 0;

    constant REG_DAQ_EXT_STATUS_DISPER_ERR_ADDR    : std_logic_vector(8 downto 0) := '0' & x"03";
    constant REG_DAQ_EXT_STATUS_DISPER_ERR_MSB    : integer := 15;
    constant REG_DAQ_EXT_STATUS_DISPER_ERR_LSB     : integer := 0;

    constant REG_DAQ_EXT_STATUS_L1AID_ADDR    : std_logic_vector(8 downto 0) := '0' & x"04";
    constant REG_DAQ_EXT_STATUS_L1AID_MSB    : integer := 23;
    constant REG_DAQ_EXT_STATUS_L1AID_LSB     : integer := 0;

    constant REG_DAQ_EXT_STATUS_EVT_SENT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"05";
    constant REG_DAQ_EXT_STATUS_EVT_SENT_MSB    : integer := 31;
    constant REG_DAQ_EXT_STATUS_EVT_SENT_LSB     : integer := 0;

    constant REG_DAQ_CONTROL_DAV_TIMEOUT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"06";
    constant REG_DAQ_CONTROL_DAV_TIMEOUT_MSB    : integer := 23;
    constant REG_DAQ_CONTROL_DAV_TIMEOUT_LSB     : integer := 0;
    constant REG_DAQ_CONTROL_DAV_TIMEOUT_DEFAULT : std_logic_vector(23 downto 0) := x"03d090";

    constant REG_DAQ_EXT_STATUS_MAX_DAV_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"07";
    constant REG_DAQ_EXT_STATUS_MAX_DAV_TIMER_MSB    : integer := 23;
    constant REG_DAQ_EXT_STATUS_MAX_DAV_TIMER_LSB     : integer := 0;

    constant REG_DAQ_EXT_STATUS_LAST_DAV_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"08";
    constant REG_DAQ_EXT_STATUS_LAST_DAV_TIMER_MSB    : integer := 23;
    constant REG_DAQ_EXT_STATUS_LAST_DAV_TIMER_LSB     : integer := 0;

    constant REG_DAQ_EXT_STATUS_L1A_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"09";
    constant REG_DAQ_EXT_STATUS_L1A_FIFO_DATA_CNT_MSB    : integer := 12;
    constant REG_DAQ_EXT_STATUS_L1A_FIFO_DATA_CNT_LSB     : integer := 0;

    constant REG_DAQ_EXT_STATUS_DAQ_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"09";
    constant REG_DAQ_EXT_STATUS_DAQ_FIFO_DATA_CNT_MSB    : integer := 28;
    constant REG_DAQ_EXT_STATUS_DAQ_FIFO_DATA_CNT_LSB     : integer := 16;

    constant REG_DAQ_EXT_STATUS_L1A_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"0a";
    constant REG_DAQ_EXT_STATUS_L1A_FIFO_NEAR_FULL_CNT_MSB    : integer := 15;
    constant REG_DAQ_EXT_STATUS_L1A_FIFO_NEAR_FULL_CNT_LSB     : integer := 0;

    constant REG_DAQ_EXT_STATUS_DAQ_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"0a";
    constant REG_DAQ_EXT_STATUS_DAQ_FIFO_NEAR_FULL_CNT_MSB    : integer := 31;
    constant REG_DAQ_EXT_STATUS_DAQ_FIFO_NEAR_FULL_CNT_LSB     : integer := 16;

    constant REG_DAQ_EXT_STATUS_DAQ_ALMOST_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"0b";
    constant REG_DAQ_EXT_STATUS_DAQ_ALMOST_FULL_CNT_MSB    : integer := 15;
    constant REG_DAQ_EXT_STATUS_DAQ_ALMOST_FULL_CNT_LSB     : integer := 0;

    constant REG_DAQ_EXT_STATUS_TTS_WARN_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"0b";
    constant REG_DAQ_EXT_STATUS_TTS_WARN_CNT_MSB    : integer := 31;
    constant REG_DAQ_EXT_STATUS_TTS_WARN_CNT_LSB     : integer := 16;

    constant REG_DAQ_EXT_STATUS_DAQ_WORD_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"0c";
    constant REG_DAQ_EXT_STATUS_DAQ_WORD_RATE_MSB    : integer := 31;
    constant REG_DAQ_EXT_STATUS_DAQ_WORD_RATE_LSB     : integer := 0;

    constant REG_DAQ_EXT_CONTROL_RUN_PARAMS_ADDR    : std_logic_vector(8 downto 0) := '0' & x"0f";
    constant REG_DAQ_EXT_CONTROL_RUN_PARAMS_MSB    : integer := 23;
    constant REG_DAQ_EXT_CONTROL_RUN_PARAMS_LSB     : integer := 0;
    constant REG_DAQ_EXT_CONTROL_RUN_PARAMS_DEFAULT : std_logic_vector(23 downto 0) := x"000000";

    constant REG_DAQ_EXT_CONTROL_RUN_TYPE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"0f";
    constant REG_DAQ_EXT_CONTROL_RUN_TYPE_MSB    : integer := 27;
    constant REG_DAQ_EXT_CONTROL_RUN_TYPE_LSB     : integer := 24;
    constant REG_DAQ_EXT_CONTROL_RUN_TYPE_DEFAULT : std_logic_vector(27 downto 24) := x"0";

    constant REG_DAQ_OH0_STATUS_VFAT_MIXED_EC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"10";
    constant REG_DAQ_OH0_STATUS_VFAT_MIXED_EC_BIT    : integer := 1;

    constant REG_DAQ_OH0_STATUS_VFAT_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"10";
    constant REG_DAQ_OH0_STATUS_VFAT_MIXED_BC_BIT    : integer := 2;

    constant REG_DAQ_OH0_STATUS_OH_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"10";
    constant REG_DAQ_OH0_STATUS_OH_MIXED_BC_BIT    : integer := 3;

    constant REG_DAQ_OH0_STATUS_VFAT_TOO_MANY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"10";
    constant REG_DAQ_OH0_STATUS_VFAT_TOO_MANY_BIT    : integer := 4;

    constant REG_DAQ_OH0_STATUS_VFAT_SMALL_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"10";
    constant REG_DAQ_OH0_STATUS_VFAT_SMALL_BLOCK_BIT    : integer := 5;

    constant REG_DAQ_OH0_STATUS_VFAT_LARGE_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"10";
    constant REG_DAQ_OH0_STATUS_VFAT_LARGE_BLOCK_BIT    : integer := 6;

    constant REG_DAQ_OH0_STATUS_VFAT_NO_MARKER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"10";
    constant REG_DAQ_OH0_STATUS_VFAT_NO_MARKER_BIT    : integer := 7;

    constant REG_DAQ_OH0_STATUS_INPUT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"10";
    constant REG_DAQ_OH0_STATUS_INPUT_FIFO_HAD_OFLOW_BIT    : integer := 8;

    constant REG_DAQ_OH0_STATUS_INPUT_FIFO_HAD_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"10";
    constant REG_DAQ_OH0_STATUS_INPUT_FIFO_HAD_UFLOW_BIT    : integer := 9;

    constant REG_DAQ_OH0_STATUS_EVENT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"10";
    constant REG_DAQ_OH0_STATUS_EVENT_FIFO_HAD_OFLOW_BIT    : integer := 10;

    constant REG_DAQ_OH0_STATUS_EVT_SIZE_ERR_ADDR    : std_logic_vector(8 downto 0) := '0' & x"10";
    constant REG_DAQ_OH0_STATUS_EVT_SIZE_ERR_BIT    : integer := 11;

    constant REG_DAQ_OH0_STATUS_TTS_STATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"10";
    constant REG_DAQ_OH0_STATUS_TTS_STATE_MSB    : integer := 15;
    constant REG_DAQ_OH0_STATUS_TTS_STATE_LSB     : integer := 12;

    constant REG_DAQ_OH0_STATUS_INPUT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"10";
    constant REG_DAQ_OH0_STATUS_INPUT_FIFO_IS_UFLOW_BIT    : integer := 24;

    constant REG_DAQ_OH0_STATUS_INPUT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"10";
    constant REG_DAQ_OH0_STATUS_INPUT_FIFO_IS_FULL_BIT    : integer := 25;

    constant REG_DAQ_OH0_STATUS_INPUT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"10";
    constant REG_DAQ_OH0_STATUS_INPUT_FIFO_IS_AFULL_BIT    : integer := 26;

    constant REG_DAQ_OH0_STATUS_INPUT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"10";
    constant REG_DAQ_OH0_STATUS_INPUT_FIFO_IS_EMPTY_BIT    : integer := 27;

    constant REG_DAQ_OH0_STATUS_EVENT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"10";
    constant REG_DAQ_OH0_STATUS_EVENT_FIFO_IS_UFLOW_BIT    : integer := 28;

    constant REG_DAQ_OH0_STATUS_EVENT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"10";
    constant REG_DAQ_OH0_STATUS_EVENT_FIFO_IS_FULL_BIT    : integer := 29;

    constant REG_DAQ_OH0_STATUS_EVENT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"10";
    constant REG_DAQ_OH0_STATUS_EVENT_FIFO_IS_AFULL_BIT    : integer := 30;

    constant REG_DAQ_OH0_STATUS_EVENT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"10";
    constant REG_DAQ_OH0_STATUS_EVENT_FIFO_IS_EMPTY_BIT    : integer := 31;

    constant REG_DAQ_OH0_COUNTERS_CORRUPT_VFAT_BLK_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"11";
    constant REG_DAQ_OH0_COUNTERS_CORRUPT_VFAT_BLK_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH0_COUNTERS_CORRUPT_VFAT_BLK_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH0_COUNTERS_EVN_ADDR    : std_logic_vector(8 downto 0) := '0' & x"12";
    constant REG_DAQ_OH0_COUNTERS_EVN_MSB    : integer := 23;
    constant REG_DAQ_OH0_COUNTERS_EVN_LSB     : integer := 0;

    constant REG_DAQ_OH0_CONTROL_EOE_TIMEOUT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"13";
    constant REG_DAQ_OH0_CONTROL_EOE_TIMEOUT_MSB    : integer := 23;
    constant REG_DAQ_OH0_CONTROL_EOE_TIMEOUT_LSB     : integer := 0;
    constant REG_DAQ_OH0_CONTROL_EOE_TIMEOUT_DEFAULT : std_logic_vector(23 downto 0) := x"0030d4";

    constant REG_DAQ_OH0_COUNTERS_INPUT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"14";
    constant REG_DAQ_OH0_COUNTERS_INPUT_FIFO_DATA_CNT_MSB    : integer := 11;
    constant REG_DAQ_OH0_COUNTERS_INPUT_FIFO_DATA_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH0_COUNTERS_EVT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"14";
    constant REG_DAQ_OH0_COUNTERS_EVT_FIFO_DATA_CNT_MSB    : integer := 27;
    constant REG_DAQ_OH0_COUNTERS_EVT_FIFO_DATA_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH0_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"15";
    constant REG_DAQ_OH0_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_MSB    : integer := 15;
    constant REG_DAQ_OH0_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH0_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"15";
    constant REG_DAQ_OH0_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH0_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH0_COUNTERS_VFAT_BLOCK_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"16";
    constant REG_DAQ_OH0_COUNTERS_VFAT_BLOCK_RATE_MSB    : integer := 14;
    constant REG_DAQ_OH0_COUNTERS_VFAT_BLOCK_RATE_LSB     : integer := 0;

    constant REG_DAQ_OH0_COUNTERS_EVT_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"16";
    constant REG_DAQ_OH0_COUNTERS_EVT_RATE_MSB    : integer := 31;
    constant REG_DAQ_OH0_COUNTERS_EVT_RATE_LSB     : integer := 15;

    constant REG_DAQ_OH0_COUNTERS_MAX_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"17";
    constant REG_DAQ_OH0_COUNTERS_MAX_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH0_COUNTERS_MAX_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH0_COUNTERS_LAST_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"18";
    constant REG_DAQ_OH0_COUNTERS_LAST_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH0_COUNTERS_LAST_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH0_LASTBLOCK0_ADDR    : std_logic_vector(8 downto 0) := '0' & x"19";
    constant REG_DAQ_OH0_LASTBLOCK0_MSB    : integer := 31;
    constant REG_DAQ_OH0_LASTBLOCK0_LSB     : integer := 0;

    constant REG_DAQ_OH0_LASTBLOCK1_ADDR    : std_logic_vector(8 downto 0) := '0' & x"1a";
    constant REG_DAQ_OH0_LASTBLOCK1_MSB    : integer := 31;
    constant REG_DAQ_OH0_LASTBLOCK1_LSB     : integer := 0;

    constant REG_DAQ_OH0_LASTBLOCK2_ADDR    : std_logic_vector(8 downto 0) := '0' & x"1b";
    constant REG_DAQ_OH0_LASTBLOCK2_MSB    : integer := 31;
    constant REG_DAQ_OH0_LASTBLOCK2_LSB     : integer := 0;

    constant REG_DAQ_OH0_LASTBLOCK3_ADDR    : std_logic_vector(8 downto 0) := '0' & x"1c";
    constant REG_DAQ_OH0_LASTBLOCK3_MSB    : integer := 31;
    constant REG_DAQ_OH0_LASTBLOCK3_LSB     : integer := 0;

    constant REG_DAQ_OH0_LASTBLOCK4_ADDR    : std_logic_vector(8 downto 0) := '0' & x"1d";
    constant REG_DAQ_OH0_LASTBLOCK4_MSB    : integer := 31;
    constant REG_DAQ_OH0_LASTBLOCK4_LSB     : integer := 0;

    constant REG_DAQ_OH0_LASTBLOCK5_ADDR    : std_logic_vector(8 downto 0) := '0' & x"1e";
    constant REG_DAQ_OH0_LASTBLOCK5_MSB    : integer := 31;
    constant REG_DAQ_OH0_LASTBLOCK5_LSB     : integer := 0;

    constant REG_DAQ_OH0_LASTBLOCK6_ADDR    : std_logic_vector(8 downto 0) := '0' & x"1f";
    constant REG_DAQ_OH0_LASTBLOCK6_MSB    : integer := 31;
    constant REG_DAQ_OH0_LASTBLOCK6_LSB     : integer := 0;

    constant REG_DAQ_OH1_STATUS_VFAT_MIXED_EC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_OH1_STATUS_VFAT_MIXED_EC_BIT    : integer := 1;

    constant REG_DAQ_OH1_STATUS_VFAT_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_OH1_STATUS_VFAT_MIXED_BC_BIT    : integer := 2;

    constant REG_DAQ_OH1_STATUS_OH_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_OH1_STATUS_OH_MIXED_BC_BIT    : integer := 3;

    constant REG_DAQ_OH1_STATUS_VFAT_TOO_MANY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_OH1_STATUS_VFAT_TOO_MANY_BIT    : integer := 4;

    constant REG_DAQ_OH1_STATUS_VFAT_SMALL_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_OH1_STATUS_VFAT_SMALL_BLOCK_BIT    : integer := 5;

    constant REG_DAQ_OH1_STATUS_VFAT_LARGE_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_OH1_STATUS_VFAT_LARGE_BLOCK_BIT    : integer := 6;

    constant REG_DAQ_OH1_STATUS_VFAT_NO_MARKER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_OH1_STATUS_VFAT_NO_MARKER_BIT    : integer := 7;

    constant REG_DAQ_OH1_STATUS_INPUT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_OH1_STATUS_INPUT_FIFO_HAD_OFLOW_BIT    : integer := 8;

    constant REG_DAQ_OH1_STATUS_INPUT_FIFO_HAD_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_OH1_STATUS_INPUT_FIFO_HAD_UFLOW_BIT    : integer := 9;

    constant REG_DAQ_OH1_STATUS_EVENT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_OH1_STATUS_EVENT_FIFO_HAD_OFLOW_BIT    : integer := 10;

    constant REG_DAQ_OH1_STATUS_EVT_SIZE_ERR_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_OH1_STATUS_EVT_SIZE_ERR_BIT    : integer := 11;

    constant REG_DAQ_OH1_STATUS_TTS_STATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_OH1_STATUS_TTS_STATE_MSB    : integer := 15;
    constant REG_DAQ_OH1_STATUS_TTS_STATE_LSB     : integer := 12;

    constant REG_DAQ_OH1_STATUS_INPUT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_OH1_STATUS_INPUT_FIFO_IS_UFLOW_BIT    : integer := 24;

    constant REG_DAQ_OH1_STATUS_INPUT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_OH1_STATUS_INPUT_FIFO_IS_FULL_BIT    : integer := 25;

    constant REG_DAQ_OH1_STATUS_INPUT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_OH1_STATUS_INPUT_FIFO_IS_AFULL_BIT    : integer := 26;

    constant REG_DAQ_OH1_STATUS_INPUT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_OH1_STATUS_INPUT_FIFO_IS_EMPTY_BIT    : integer := 27;

    constant REG_DAQ_OH1_STATUS_EVENT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_OH1_STATUS_EVENT_FIFO_IS_UFLOW_BIT    : integer := 28;

    constant REG_DAQ_OH1_STATUS_EVENT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_OH1_STATUS_EVENT_FIFO_IS_FULL_BIT    : integer := 29;

    constant REG_DAQ_OH1_STATUS_EVENT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_OH1_STATUS_EVENT_FIFO_IS_AFULL_BIT    : integer := 30;

    constant REG_DAQ_OH1_STATUS_EVENT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_OH1_STATUS_EVENT_FIFO_IS_EMPTY_BIT    : integer := 31;

    constant REG_DAQ_OH1_COUNTERS_CORRUPT_VFAT_BLK_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"21";
    constant REG_DAQ_OH1_COUNTERS_CORRUPT_VFAT_BLK_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH1_COUNTERS_CORRUPT_VFAT_BLK_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH1_COUNTERS_EVN_ADDR    : std_logic_vector(8 downto 0) := '0' & x"22";
    constant REG_DAQ_OH1_COUNTERS_EVN_MSB    : integer := 23;
    constant REG_DAQ_OH1_COUNTERS_EVN_LSB     : integer := 0;

    constant REG_DAQ_OH1_CONTROL_EOE_TIMEOUT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"23";
    constant REG_DAQ_OH1_CONTROL_EOE_TIMEOUT_MSB    : integer := 23;
    constant REG_DAQ_OH1_CONTROL_EOE_TIMEOUT_LSB     : integer := 0;
    constant REG_DAQ_OH1_CONTROL_EOE_TIMEOUT_DEFAULT : std_logic_vector(23 downto 0) := x"0030d4";

    constant REG_DAQ_OH1_COUNTERS_INPUT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"24";
    constant REG_DAQ_OH1_COUNTERS_INPUT_FIFO_DATA_CNT_MSB    : integer := 11;
    constant REG_DAQ_OH1_COUNTERS_INPUT_FIFO_DATA_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH1_COUNTERS_EVT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"24";
    constant REG_DAQ_OH1_COUNTERS_EVT_FIFO_DATA_CNT_MSB    : integer := 27;
    constant REG_DAQ_OH1_COUNTERS_EVT_FIFO_DATA_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH1_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"25";
    constant REG_DAQ_OH1_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_MSB    : integer := 15;
    constant REG_DAQ_OH1_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH1_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"25";
    constant REG_DAQ_OH1_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH1_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH1_COUNTERS_VFAT_BLOCK_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"26";
    constant REG_DAQ_OH1_COUNTERS_VFAT_BLOCK_RATE_MSB    : integer := 14;
    constant REG_DAQ_OH1_COUNTERS_VFAT_BLOCK_RATE_LSB     : integer := 0;

    constant REG_DAQ_OH1_COUNTERS_EVT_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"26";
    constant REG_DAQ_OH1_COUNTERS_EVT_RATE_MSB    : integer := 31;
    constant REG_DAQ_OH1_COUNTERS_EVT_RATE_LSB     : integer := 15;

    constant REG_DAQ_OH1_COUNTERS_MAX_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"27";
    constant REG_DAQ_OH1_COUNTERS_MAX_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH1_COUNTERS_MAX_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH1_COUNTERS_LAST_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"28";
    constant REG_DAQ_OH1_COUNTERS_LAST_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH1_COUNTERS_LAST_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH1_LASTBLOCK0_ADDR    : std_logic_vector(8 downto 0) := '0' & x"29";
    constant REG_DAQ_OH1_LASTBLOCK0_MSB    : integer := 31;
    constant REG_DAQ_OH1_LASTBLOCK0_LSB     : integer := 0;

    constant REG_DAQ_OH1_LASTBLOCK1_ADDR    : std_logic_vector(8 downto 0) := '0' & x"2a";
    constant REG_DAQ_OH1_LASTBLOCK1_MSB    : integer := 31;
    constant REG_DAQ_OH1_LASTBLOCK1_LSB     : integer := 0;

    constant REG_DAQ_OH1_LASTBLOCK2_ADDR    : std_logic_vector(8 downto 0) := '0' & x"2b";
    constant REG_DAQ_OH1_LASTBLOCK2_MSB    : integer := 31;
    constant REG_DAQ_OH1_LASTBLOCK2_LSB     : integer := 0;

    constant REG_DAQ_OH1_LASTBLOCK3_ADDR    : std_logic_vector(8 downto 0) := '0' & x"2c";
    constant REG_DAQ_OH1_LASTBLOCK3_MSB    : integer := 31;
    constant REG_DAQ_OH1_LASTBLOCK3_LSB     : integer := 0;

    constant REG_DAQ_OH1_LASTBLOCK4_ADDR    : std_logic_vector(8 downto 0) := '0' & x"2d";
    constant REG_DAQ_OH1_LASTBLOCK4_MSB    : integer := 31;
    constant REG_DAQ_OH1_LASTBLOCK4_LSB     : integer := 0;

    constant REG_DAQ_OH1_LASTBLOCK5_ADDR    : std_logic_vector(8 downto 0) := '0' & x"2e";
    constant REG_DAQ_OH1_LASTBLOCK5_MSB    : integer := 31;
    constant REG_DAQ_OH1_LASTBLOCK5_LSB     : integer := 0;

    constant REG_DAQ_OH1_LASTBLOCK6_ADDR    : std_logic_vector(8 downto 0) := '0' & x"2f";
    constant REG_DAQ_OH1_LASTBLOCK6_MSB    : integer := 31;
    constant REG_DAQ_OH1_LASTBLOCK6_LSB     : integer := 0;


    --============================================================================
    --       >>> OH_LINKS Module <<<    base address: 0x00600000
    --
    -- OH Link monitoring registers
    --============================================================================

    constant REG_OH_LINKS_NUM_REGS : integer := 37;
    constant REG_OH_LINKS_ADDRESS_MSB : integer := 12;
    constant REG_OH_LINKS_ADDRESS_LSB : integer := 0;
    constant REG_OH_LINKS_CTRL_DEBUG_CLK_CNT_RESET_ADDR    : std_logic_vector(12 downto 0) := '0' & x"000";
    constant REG_OH_LINKS_CTRL_DEBUG_CLK_CNT_RESET_BIT    : integer := 30;

    constant REG_OH_LINKS_CTRL_CNT_RESET_ADDR    : std_logic_vector(12 downto 0) := '0' & x"000";
    constant REG_OH_LINKS_CTRL_CNT_RESET_BIT    : integer := 31;

    constant REG_OH_LINKS_OH0_TRACK_LINK_ERROR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"100";
    constant REG_OH_LINKS_OH0_TRACK_LINK_ERROR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRACK_LINK_ERROR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_VFAT_BLOCK_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"101";
    constant REG_OH_LINKS_OH0_VFAT_BLOCK_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_VFAT_BLOCK_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRACK_LINK_TX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"102";
    constant REG_OH_LINKS_OH0_TRACK_LINK_TX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRACK_LINK_TX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRACK_LINK_TX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"103";
    constant REG_OH_LINKS_OH0_TRACK_LINK_TX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRACK_LINK_TX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRACK_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"104";
    constant REG_OH_LINKS_OH0_TRACK_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRACK_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRACK_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"105";
    constant REG_OH_LINKS_OH0_TRACK_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRACK_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRIG0_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"106";
    constant REG_OH_LINKS_OH0_TRIG0_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRIG0_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRIG0_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"107";
    constant REG_OH_LINKS_OH0_TRIG0_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRIG0_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRIG1_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"108";
    constant REG_OH_LINKS_OH0_TRIG1_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRIG1_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRIG1_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"109";
    constant REG_OH_LINKS_OH0_TRIG1_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRIG1_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRACK_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"10a";
    constant REG_OH_LINKS_OH0_TRACK_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRACK_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRACK_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"10b";
    constant REG_OH_LINKS_OH0_TRACK_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRACK_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRIG0_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"10c";
    constant REG_OH_LINKS_OH0_TRIG0_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRIG0_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRIG0_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"10d";
    constant REG_OH_LINKS_OH0_TRIG0_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRIG0_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRIG1_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"10e";
    constant REG_OH_LINKS_OH0_TRIG1_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRIG1_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRIG1_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"10f";
    constant REG_OH_LINKS_OH0_TRIG1_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRIG1_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_GBT_LINK_SYNC_DONE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"110";
    constant REG_OH_LINKS_OH0_GBT_LINK_SYNC_DONE_BIT    : integer := 0;

    constant REG_OH_LINKS_OH0_DEBUG_CLK_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"111";
    constant REG_OH_LINKS_OH0_DEBUG_CLK_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_DEBUG_CLK_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRACK_LINK_ERROR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"200";
    constant REG_OH_LINKS_OH1_TRACK_LINK_ERROR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRACK_LINK_ERROR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_VFAT_BLOCK_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"201";
    constant REG_OH_LINKS_OH1_VFAT_BLOCK_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_VFAT_BLOCK_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRACK_LINK_TX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"202";
    constant REG_OH_LINKS_OH1_TRACK_LINK_TX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRACK_LINK_TX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRACK_LINK_TX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"203";
    constant REG_OH_LINKS_OH1_TRACK_LINK_TX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRACK_LINK_TX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRACK_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"204";
    constant REG_OH_LINKS_OH1_TRACK_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRACK_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRACK_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"205";
    constant REG_OH_LINKS_OH1_TRACK_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRACK_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRIG0_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"206";
    constant REG_OH_LINKS_OH1_TRIG0_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRIG0_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRIG0_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"207";
    constant REG_OH_LINKS_OH1_TRIG0_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRIG0_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRIG1_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"208";
    constant REG_OH_LINKS_OH1_TRIG1_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRIG1_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRIG1_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"209";
    constant REG_OH_LINKS_OH1_TRIG1_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRIG1_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRACK_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"20a";
    constant REG_OH_LINKS_OH1_TRACK_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRACK_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRACK_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"20b";
    constant REG_OH_LINKS_OH1_TRACK_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRACK_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRIG0_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"20c";
    constant REG_OH_LINKS_OH1_TRIG0_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRIG0_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRIG0_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"20d";
    constant REG_OH_LINKS_OH1_TRIG0_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRIG0_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRIG1_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"20e";
    constant REG_OH_LINKS_OH1_TRIG1_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRIG1_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRIG1_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"20f";
    constant REG_OH_LINKS_OH1_TRIG1_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRIG1_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_GBT_LINK_SYNC_DONE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"210";
    constant REG_OH_LINKS_OH1_GBT_LINK_SYNC_DONE_BIT    : integer := 0;

    constant REG_OH_LINKS_OH1_DEBUG_CLK_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"211";
    constant REG_OH_LINKS_OH1_DEBUG_CLK_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_DEBUG_CLK_CNT_LSB     : integer := 0;


end registers;
