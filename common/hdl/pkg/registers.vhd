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

    constant REG_TTC_TTC_SPY_BUFFER_ADDR    : std_logic_vector(5 downto 0) := "01" & x"4";
    constant REG_TTC_TTC_SPY_BUFFER_MSB    : integer := 31;
    constant REG_TTC_TTC_SPY_BUFFER_LSB     : integer := 0;


    --============================================================================
    --       >>> TRIGGER Module <<<    base address: 0x00800000
    --
    -- Trigger module handles everything related to sbit cluster data (link
    -- synchronization, monitoring, local triggering, matching to L1A and
    -- reporting data to DAQ)
    --============================================================================

    constant REG_TRIGGER_NUM_REGS : integer := 49;
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

    constant REG_TRIGGER_OH_0_TRIGGER_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"100";
    constant REG_TRIGGER_OH_0_TRIGGER_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH_0_TRIGGER_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH_0_CLUSTER_SIZE_0_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"101";
    constant REG_TRIGGER_OH_0_CLUSTER_SIZE_0_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH_0_CLUSTER_SIZE_0_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH_0_CLUSTER_SIZE_1_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"102";
    constant REG_TRIGGER_OH_0_CLUSTER_SIZE_1_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH_0_CLUSTER_SIZE_1_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH_0_CLUSTER_SIZE_2_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"103";
    constant REG_TRIGGER_OH_0_CLUSTER_SIZE_2_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH_0_CLUSTER_SIZE_2_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH_0_CLUSTER_SIZE_3_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"104";
    constant REG_TRIGGER_OH_0_CLUSTER_SIZE_3_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH_0_CLUSTER_SIZE_3_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH_0_CLUSTER_SIZE_4_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"105";
    constant REG_TRIGGER_OH_0_CLUSTER_SIZE_4_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH_0_CLUSTER_SIZE_4_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH_0_CLUSTER_SIZE_5_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"106";
    constant REG_TRIGGER_OH_0_CLUSTER_SIZE_5_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH_0_CLUSTER_SIZE_5_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH_0_CLUSTER_SIZE_6_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"107";
    constant REG_TRIGGER_OH_0_CLUSTER_SIZE_6_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH_0_CLUSTER_SIZE_6_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH_0_CLUSTER_SIZE_7_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"108";
    constant REG_TRIGGER_OH_0_CLUSTER_SIZE_7_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH_0_CLUSTER_SIZE_7_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH_0_CLUSTER_SIZE_8_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"109";
    constant REG_TRIGGER_OH_0_CLUSTER_SIZE_8_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH_0_CLUSTER_SIZE_8_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH_0_LINK0_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"10a";
    constant REG_TRIGGER_OH_0_LINK0_NOT_VALID_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH_0_LINK0_NOT_VALID_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH_0_LINK1_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"10a";
    constant REG_TRIGGER_OH_0_LINK1_NOT_VALID_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH_0_LINK1_NOT_VALID_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH_0_LINK0_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"10b";
    constant REG_TRIGGER_OH_0_LINK0_MISSED_COMMA_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH_0_LINK0_MISSED_COMMA_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH_0_LINK1_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"10b";
    constant REG_TRIGGER_OH_0_LINK1_MISSED_COMMA_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH_0_LINK1_MISSED_COMMA_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH_0_LINK0_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"10c";
    constant REG_TRIGGER_OH_0_LINK0_OVERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH_0_LINK0_OVERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH_0_LINK1_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"10c";
    constant REG_TRIGGER_OH_0_LINK1_OVERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH_0_LINK1_OVERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH_0_LINK0_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"10d";
    constant REG_TRIGGER_OH_0_LINK0_UNDERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH_0_LINK0_UNDERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH_0_LINK1_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"10d";
    constant REG_TRIGGER_OH_0_LINK1_UNDERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH_0_LINK1_UNDERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH_0_LINK0_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"10e";
    constant REG_TRIGGER_OH_0_LINK0_SYNC_WORD_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH_0_LINK0_SYNC_WORD_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH_0_LINK1_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"10e";
    constant REG_TRIGGER_OH_0_LINK1_SYNC_WORD_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH_0_LINK1_SYNC_WORD_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH_0_DEBUG_LAST_CLUSTER_0_ADDR    : std_logic_vector(12 downto 0) := '0' & x"110";
    constant REG_TRIGGER_OH_0_DEBUG_LAST_CLUSTER_0_MSB    : integer := 15;
    constant REG_TRIGGER_OH_0_DEBUG_LAST_CLUSTER_0_LSB     : integer := 0;

    constant REG_TRIGGER_OH_0_DEBUG_LAST_CLUSTER_1_ADDR    : std_logic_vector(12 downto 0) := '0' & x"111";
    constant REG_TRIGGER_OH_0_DEBUG_LAST_CLUSTER_1_MSB    : integer := 15;
    constant REG_TRIGGER_OH_0_DEBUG_LAST_CLUSTER_1_LSB     : integer := 0;

    constant REG_TRIGGER_OH_0_DEBUG_LAST_CLUSTER_2_ADDR    : std_logic_vector(12 downto 0) := '0' & x"112";
    constant REG_TRIGGER_OH_0_DEBUG_LAST_CLUSTER_2_MSB    : integer := 15;
    constant REG_TRIGGER_OH_0_DEBUG_LAST_CLUSTER_2_LSB     : integer := 0;

    constant REG_TRIGGER_OH_0_DEBUG_LAST_CLUSTER_3_ADDR    : std_logic_vector(12 downto 0) := '0' & x"113";
    constant REG_TRIGGER_OH_0_DEBUG_LAST_CLUSTER_3_MSB    : integer := 15;
    constant REG_TRIGGER_OH_0_DEBUG_LAST_CLUSTER_3_LSB     : integer := 0;

    constant REG_TRIGGER_OH_0_DEBUG_LAST_CLUSTER_4_ADDR    : std_logic_vector(12 downto 0) := '0' & x"114";
    constant REG_TRIGGER_OH_0_DEBUG_LAST_CLUSTER_4_MSB    : integer := 15;
    constant REG_TRIGGER_OH_0_DEBUG_LAST_CLUSTER_4_LSB     : integer := 0;

    constant REG_TRIGGER_OH_0_DEBUG_LAST_CLUSTER_5_ADDR    : std_logic_vector(12 downto 0) := '0' & x"115";
    constant REG_TRIGGER_OH_0_DEBUG_LAST_CLUSTER_5_MSB    : integer := 15;
    constant REG_TRIGGER_OH_0_DEBUG_LAST_CLUSTER_5_LSB     : integer := 0;

    constant REG_TRIGGER_OH_0_DEBUG_LAST_CLUSTER_6_ADDR    : std_logic_vector(12 downto 0) := '0' & x"116";
    constant REG_TRIGGER_OH_0_DEBUG_LAST_CLUSTER_6_MSB    : integer := 15;
    constant REG_TRIGGER_OH_0_DEBUG_LAST_CLUSTER_6_LSB     : integer := 0;

    constant REG_TRIGGER_OH_0_DEBUG_LAST_CLUSTER_7_ADDR    : std_logic_vector(12 downto 0) := '0' & x"117";
    constant REG_TRIGGER_OH_0_DEBUG_LAST_CLUSTER_7_MSB    : integer := 15;
    constant REG_TRIGGER_OH_0_DEBUG_LAST_CLUSTER_7_LSB     : integer := 0;

    constant REG_TRIGGER_OH_1_TRIGGER_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"200";
    constant REG_TRIGGER_OH_1_TRIGGER_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH_1_TRIGGER_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH_1_CLUSTER_SIZE_0_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"201";
    constant REG_TRIGGER_OH_1_CLUSTER_SIZE_0_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH_1_CLUSTER_SIZE_0_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH_1_CLUSTER_SIZE_1_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"202";
    constant REG_TRIGGER_OH_1_CLUSTER_SIZE_1_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH_1_CLUSTER_SIZE_1_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH_1_CLUSTER_SIZE_2_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"203";
    constant REG_TRIGGER_OH_1_CLUSTER_SIZE_2_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH_1_CLUSTER_SIZE_2_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH_1_CLUSTER_SIZE_3_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"204";
    constant REG_TRIGGER_OH_1_CLUSTER_SIZE_3_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH_1_CLUSTER_SIZE_3_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH_1_CLUSTER_SIZE_4_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"205";
    constant REG_TRIGGER_OH_1_CLUSTER_SIZE_4_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH_1_CLUSTER_SIZE_4_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH_1_CLUSTER_SIZE_5_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"206";
    constant REG_TRIGGER_OH_1_CLUSTER_SIZE_5_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH_1_CLUSTER_SIZE_5_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH_1_CLUSTER_SIZE_6_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"207";
    constant REG_TRIGGER_OH_1_CLUSTER_SIZE_6_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH_1_CLUSTER_SIZE_6_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH_1_CLUSTER_SIZE_7_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"208";
    constant REG_TRIGGER_OH_1_CLUSTER_SIZE_7_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH_1_CLUSTER_SIZE_7_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH_1_CLUSTER_SIZE_8_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"209";
    constant REG_TRIGGER_OH_1_CLUSTER_SIZE_8_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH_1_CLUSTER_SIZE_8_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH_1_LINK0_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"20a";
    constant REG_TRIGGER_OH_1_LINK0_NOT_VALID_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH_1_LINK0_NOT_VALID_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH_1_LINK1_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"20a";
    constant REG_TRIGGER_OH_1_LINK1_NOT_VALID_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH_1_LINK1_NOT_VALID_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH_1_LINK0_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"20b";
    constant REG_TRIGGER_OH_1_LINK0_MISSED_COMMA_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH_1_LINK0_MISSED_COMMA_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH_1_LINK1_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"20b";
    constant REG_TRIGGER_OH_1_LINK1_MISSED_COMMA_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH_1_LINK1_MISSED_COMMA_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH_1_LINK0_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"20c";
    constant REG_TRIGGER_OH_1_LINK0_OVERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH_1_LINK0_OVERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH_1_LINK1_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"20c";
    constant REG_TRIGGER_OH_1_LINK1_OVERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH_1_LINK1_OVERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH_1_LINK0_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"20d";
    constant REG_TRIGGER_OH_1_LINK0_UNDERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH_1_LINK0_UNDERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH_1_LINK1_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"20d";
    constant REG_TRIGGER_OH_1_LINK1_UNDERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH_1_LINK1_UNDERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH_1_LINK0_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"20e";
    constant REG_TRIGGER_OH_1_LINK0_SYNC_WORD_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH_1_LINK0_SYNC_WORD_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH_1_LINK1_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"20e";
    constant REG_TRIGGER_OH_1_LINK1_SYNC_WORD_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH_1_LINK1_SYNC_WORD_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH_1_DEBUG_LAST_CLUSTER_0_ADDR    : std_logic_vector(12 downto 0) := '0' & x"210";
    constant REG_TRIGGER_OH_1_DEBUG_LAST_CLUSTER_0_MSB    : integer := 15;
    constant REG_TRIGGER_OH_1_DEBUG_LAST_CLUSTER_0_LSB     : integer := 0;

    constant REG_TRIGGER_OH_1_DEBUG_LAST_CLUSTER_1_ADDR    : std_logic_vector(12 downto 0) := '0' & x"211";
    constant REG_TRIGGER_OH_1_DEBUG_LAST_CLUSTER_1_MSB    : integer := 15;
    constant REG_TRIGGER_OH_1_DEBUG_LAST_CLUSTER_1_LSB     : integer := 0;

    constant REG_TRIGGER_OH_1_DEBUG_LAST_CLUSTER_2_ADDR    : std_logic_vector(12 downto 0) := '0' & x"212";
    constant REG_TRIGGER_OH_1_DEBUG_LAST_CLUSTER_2_MSB    : integer := 15;
    constant REG_TRIGGER_OH_1_DEBUG_LAST_CLUSTER_2_LSB     : integer := 0;

    constant REG_TRIGGER_OH_1_DEBUG_LAST_CLUSTER_3_ADDR    : std_logic_vector(12 downto 0) := '0' & x"213";
    constant REG_TRIGGER_OH_1_DEBUG_LAST_CLUSTER_3_MSB    : integer := 15;
    constant REG_TRIGGER_OH_1_DEBUG_LAST_CLUSTER_3_LSB     : integer := 0;

    constant REG_TRIGGER_OH_1_DEBUG_LAST_CLUSTER_4_ADDR    : std_logic_vector(12 downto 0) := '0' & x"214";
    constant REG_TRIGGER_OH_1_DEBUG_LAST_CLUSTER_4_MSB    : integer := 15;
    constant REG_TRIGGER_OH_1_DEBUG_LAST_CLUSTER_4_LSB     : integer := 0;

    constant REG_TRIGGER_OH_1_DEBUG_LAST_CLUSTER_5_ADDR    : std_logic_vector(12 downto 0) := '0' & x"215";
    constant REG_TRIGGER_OH_1_DEBUG_LAST_CLUSTER_5_MSB    : integer := 15;
    constant REG_TRIGGER_OH_1_DEBUG_LAST_CLUSTER_5_LSB     : integer := 0;

    constant REG_TRIGGER_OH_1_DEBUG_LAST_CLUSTER_6_ADDR    : std_logic_vector(12 downto 0) := '0' & x"216";
    constant REG_TRIGGER_OH_1_DEBUG_LAST_CLUSTER_6_MSB    : integer := 15;
    constant REG_TRIGGER_OH_1_DEBUG_LAST_CLUSTER_6_LSB     : integer := 0;

    constant REG_TRIGGER_OH_1_DEBUG_LAST_CLUSTER_7_ADDR    : std_logic_vector(12 downto 0) := '0' & x"217";
    constant REG_TRIGGER_OH_1_DEBUG_LAST_CLUSTER_7_MSB    : integer := 15;
    constant REG_TRIGGER_OH_1_DEBUG_LAST_CLUSTER_7_LSB     : integer := 0;


    --============================================================================
    --       >>> GEM_SYSTEM Module <<<    base address: 0x00900000
    --
    -- This module is controlling GEM AMC System wide settings
    --============================================================================

    constant REG_GEM_SYSTEM_NUM_REGS : integer := 3;
    constant REG_GEM_SYSTEM_ADDRESS_MSB : integer := 3;
    constant REG_GEM_SYSTEM_ADDRESS_LSB : integer := 0;
    constant REG_GEM_SYSTEM_TK_LINK_RX_POLARITY_ADDR    : std_logic_vector(3 downto 0) := x"0";
    constant REG_GEM_SYSTEM_TK_LINK_RX_POLARITY_MSB    : integer := 23;
    constant REG_GEM_SYSTEM_TK_LINK_RX_POLARITY_LSB     : integer := 0;
    constant REG_GEM_SYSTEM_TK_LINK_RX_POLARITY_DEFAULT : std_logic_vector(23 downto 0) := x"000000";

    constant REG_GEM_SYSTEM_TK_LINK_TX_POLARITY_ADDR    : std_logic_vector(3 downto 0) := x"1";
    constant REG_GEM_SYSTEM_TK_LINK_TX_POLARITY_MSB    : integer := 23;
    constant REG_GEM_SYSTEM_TK_LINK_TX_POLARITY_LSB     : integer := 0;
    constant REG_GEM_SYSTEM_TK_LINK_TX_POLARITY_DEFAULT : std_logic_vector(23 downto 0) := x"000000";

    constant REG_GEM_SYSTEM_BOARD_ID_ADDR    : std_logic_vector(3 downto 0) := x"2";
    constant REG_GEM_SYSTEM_BOARD_ID_MSB    : integer := 15;
    constant REG_GEM_SYSTEM_BOARD_ID_LSB     : integer := 0;
    constant REG_GEM_SYSTEM_BOARD_ID_DEFAULT : std_logic_vector(15 downto 0) := x"beef";


    --============================================================================
    --       >>> DAQ Module <<<    base address: 0x00700000
    --
    -- DAQ module buffers track data, builds events, analyses the data for
    -- consistency and ships off the events with all the needed headers and
    -- trailers to AMC13 over DAQLink
    --============================================================================

    constant REG_DAQ_NUM_REGS : integer := 10;
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

    constant REG_DAQ_STATUS_TTC_BC0_LOCKED_ADDR    : std_logic_vector(8 downto 0) := '0' & x"01";
    constant REG_DAQ_STATUS_TTC_BC0_LOCKED_BIT    : integer := 4;

    constant REG_DAQ_STATUS_ERR_L1A_FIFO_OVERFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"01";
    constant REG_DAQ_STATUS_ERR_L1A_FIFO_OVERFLOW_BIT    : integer := 23;

    constant REG_DAQ_STATUS_L1A_FIFO_UNDERFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"01";
    constant REG_DAQ_STATUS_L1A_FIFO_UNDERFLOW_BIT    : integer := 24;

    constant REG_DAQ_STATUS_L1A_FIFO_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"01";
    constant REG_DAQ_STATUS_L1A_FIFO_FULL_BIT    : integer := 25;

    constant REG_DAQ_STATUS_L1A_FIFO_NEAR_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"01";
    constant REG_DAQ_STATUS_L1A_FIFO_NEAR_FULL_BIT    : integer := 26;

    constant REG_DAQ_STATUS_L1A_FIFO_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"01";
    constant REG_DAQ_STATUS_L1A_FIFO_EMPTY_BIT    : integer := 27;

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

    constant REG_DAQ_EXT_CONTROL_RUN_PARAMS_ADDR    : std_logic_vector(8 downto 0) := '0' & x"0f";
    constant REG_DAQ_EXT_CONTROL_RUN_PARAMS_MSB    : integer := 23;
    constant REG_DAQ_EXT_CONTROL_RUN_PARAMS_LSB     : integer := 0;
    constant REG_DAQ_EXT_CONTROL_RUN_PARAMS_DEFAULT : std_logic_vector(23 downto 0) := x"000000";

    constant REG_DAQ_EXT_CONTROL_RUN_TYPE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"0f";
    constant REG_DAQ_EXT_CONTROL_RUN_TYPE_MSB    : integer := 27;
    constant REG_DAQ_EXT_CONTROL_RUN_TYPE_LSB     : integer := 24;
    constant REG_DAQ_EXT_CONTROL_RUN_TYPE_DEFAULT : std_logic_vector(27 downto 24) := x"0";


end registers;
