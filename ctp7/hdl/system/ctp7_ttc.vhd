-------------------------------------------------------------------------------
--                                                                            
--       Unit Name: ctp7_ttc                                           
--                                                                            
--     Description: 
--
--                                                                            
-------------------------------------------------------------------------------
--                                                                            
--           Notes:                                                           
--                                                                            
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

library UNISIM;
use UNISIM.VComponents.all;

use work.ctp7_utils_pkg.all;
use work.ttc_pkg.all;

--============================================================================
--                                                          Entity declaration
--============================================================================

entity ctp7_ttc is
  port(

    clk_40_ttc_p_i : in std_logic;      -- TTC backplane clock signals
    clk_40_ttc_n_i : in std_logic;

    ttc_data_p_i : in std_logic;        -- TTC protocol backplane signals
    ttc_data_n_i : in std_logic;

    ttc_clks_o : out t_ttc_clks;

    ttc_cmds_o : out t_ttc_cmds;

    ttc_ctrl_i : in  t_ttc_ctrl;
    ttc_stat_o : out t_ttc_stat;

    ttc_mmcm_ps_clk_i : in  std_logic;
    ttc_mmcm_ctrl_i   : in  t_ttc_mmcm_ctrl;
    ttc_mmcm_stat_o   : out t_ttc_mmcm_stat;

    ttc_diag_cntrs_o : out t_ttc_diag_cntrs;
    ttc_daq_cntrs_o  : out t_ttc_daq_cntrs
    );

end ctp7_ttc;

--============================================================================
--                                                        Architecture section
--============================================================================
architecture ctp7_ttc_arch of ctp7_ttc is

--============================================================================
--                                                         Signal declarations
--============================================================================
  signal s_clk_40  : std_logic;
  signal s_clk_80  : std_logic;
  signal s_clk_160 : std_logic;
  signal s_clk_240 : std_logic;
  signal s_clk_320 : std_logic;

  signal s_ttc_cmd : std_logic_vector(7 downto 0);
  signal s_ttc_l1a : std_logic;

  signal s_l1a_cmd       : std_logic;
  signal s_bc0_cmd       : std_logic;
  signal s_ec0_cmd       : std_logic;
  signal s_resync_cmd    : std_logic;
  signal s_oc0_cmd       : std_logic;
  signal s_test_sync_cmd : std_logic;
  signal s_start_cmd     : std_logic;
  signal s_stop_cmd      : std_logic;

  constant C_NUM_OF_DECODED_TTC_CMDS : integer := 8;

  signal s_ttc_cmd_decoded     : std_logic_vector(C_NUM_OF_DECODED_TTC_CMDS-1 downto 0);
  signal s_ttc_cmd_decoded_cnt : t_slv_arr_32(C_NUM_OF_DECODED_TTC_CMDS-1 downto 0);

  signal s_l1id_cnt  : std_logic_vector(31 downto 0);
  signal s_orbit_cnt : std_logic_vector(31 downto 0);

--============================================================================
--                                                          Architecture begin
--============================================================================
begin

  i_ctp7_ttc_clocks : entity work.ctp7_ttc_clocks
    port map(
      clk_40_ttc_p_i       => clk_40_ttc_p_i,
      clk_40_ttc_n_i       => clk_40_ttc_n_i,
      mmcm_rst_i           => ttc_mmcm_ctrl_i.reset,
      mmcm_locked_o        => ttc_mmcm_stat_o.locked,
      ttc_mmcm_ps_clk_i    => ttc_mmcm_ps_clk_i,
      ttc_mmcm_ps_clk_en_i => ttc_mmcm_ctrl_i.phase_shift,
      clk_40_bufg_o        => s_clk_40,
      clk_80_bufg_o        => s_clk_80,
      clk_160_bufg_o       => s_clk_160,
      clk_240_bufg_o       => s_clk_240,
      clk_320_bufg_o       => s_clk_320
      );

  i_ttc_cmd : entity work.ttc_cmd
    port map(
      clk_40_i             => s_clk_40,
      ttc_data_p_i         => ttc_data_p_i,
      ttc_data_n_i         => ttc_data_n_i,
      ttc_cmd_o            => s_ttc_cmd,
      ttc_l1a_o            => s_ttc_l1a,
      tcc_err_cnt_rst_i    => ttc_ctrl_i.stat_reset,
      ttc_err_single_cnt_o => ttc_stat_o.single_err,
      ttc_err_double_cnt_o => ttc_stat_o.double_err
      );

  process(s_clk_40) is
  begin
    if (rising_edge(s_clk_40)) then

      if (s_ttc_cmd = ttc_ctrl_i.bc0_cmd) then s_bc0_cmd             <= '1'; else s_bc0_cmd <= '0'; end if;
      if (s_ttc_cmd = ttc_ctrl_i.ec0_cmd) then s_ec0_cmd             <= '1'; else s_ec0_cmd <= '0'; end if;
      if (s_ttc_cmd = ttc_ctrl_i.resync_cmd) then s_resync_cmd       <= '1'; else s_resync_cmd <= '0'; end if;
      if (s_ttc_cmd = ttc_ctrl_i.oc0_cmd) then s_oc0_cmd             <= '1'; else s_oc0_cmd <= '0'; end if;
      if (s_ttc_cmd = ttc_ctrl_i.test_sync_cmd) then s_test_sync_cmd <= '1'; else s_test_sync_cmd <= '0'; end if;
      if (s_ttc_cmd = ttc_ctrl_i.start_cmd) then s_start_cmd         <= '1'; else s_start_cmd <= '0'; end if;
      if (s_ttc_cmd = ttc_ctrl_i.stop_cmd) then s_stop_cmd           <= '1'; else s_stop_cmd <= '0'; end if;

      s_l1a_cmd <= s_ttc_l1a and ttc_ctrl_i.l1a_enable;

    end if;
  end process;


  process(s_clk_40) is
  begin
    if (rising_edge(s_clk_40)) then

      if (s_oc0_cmd = '1') then
        s_orbit_cnt <= (others => '0');
      elsif (s_bc0_cmd = '1') then
        s_orbit_cnt <= std_logic_vector(unsigned(s_orbit_cnt) + 1);
      end if;

    end if;
  end process;

  process(s_clk_40) is
  begin
    if (rising_edge(s_clk_40)) then

      if (s_ec0_cmd = '1') then
        s_l1id_cnt <= (others => '0');
      elsif (s_l1a_cmd = '1') then
        s_l1id_cnt <= std_logic_vector(unsigned(s_l1id_cnt) + 1);
      end if;

    end if;
  end process;

  ttc_daq_cntrs_o.orbit <= s_orbit_cnt;
  ttc_daq_cntrs_o.L1ID  <= s_l1id_cnt;

  s_ttc_cmd_decoded(0) <= s_l1a_cmd;
  s_ttc_cmd_decoded(1) <= s_bc0_cmd;
  s_ttc_cmd_decoded(2) <= s_ec0_cmd;
  s_ttc_cmd_decoded(3) <= s_resync_cmd;
  s_ttc_cmd_decoded(4) <= s_oc0_cmd;
  s_ttc_cmd_decoded(5) <= s_test_sync_cmd;
  s_ttc_cmd_decoded(6) <= s_start_cmd;
  s_ttc_cmd_decoded(7) <= s_stop_cmd;

  ttc_diag_cntrs_o.l1a       <= s_ttc_cmd_decoded_cnt(0);
  ttc_diag_cntrs_o.bc0       <= s_ttc_cmd_decoded_cnt(1);
  ttc_diag_cntrs_o.ec0       <= s_ttc_cmd_decoded_cnt(2);
  ttc_diag_cntrs_o.resync    <= s_ttc_cmd_decoded_cnt(3);
  ttc_diag_cntrs_o.oc0       <= s_ttc_cmd_decoded_cnt(4);
  ttc_diag_cntrs_o.test_sync <= s_ttc_cmd_decoded_cnt(5);
  ttc_diag_cntrs_o.start     <= s_ttc_cmd_decoded_cnt(6);
  ttc_diag_cntrs_o.stop      <= s_ttc_cmd_decoded_cnt(7);

  gen_ttc_cmd_cnt : for i in 0 to C_NUM_OF_DECODED_TTC_CMDS-1 generate
    process(s_clk_40) is
    begin
      if (rising_edge(s_clk_40)) then

        if (ttc_ctrl_i.stat_reset = '1') then
          s_ttc_cmd_decoded_cnt(i) <= (others => '0');
        elsif (s_ttc_cmd_decoded(i) = '1') then
          s_ttc_cmd_decoded_cnt(i) <= std_logic_vector(unsigned(s_ttc_cmd_decoded_cnt(i)) + 1);
        end if;
      end if;
    end process;
  end generate;

  ttc_cmds_o.bc0       <= s_bc0_cmd;
  ttc_cmds_o.resync    <= s_resync_cmd;
  ttc_cmds_o.start     <= s_start_cmd;
  ttc_cmds_o.stop      <= s_stop_cmd;
  ttc_cmds_o.ec0       <= s_ec0_cmd;
  ttc_cmds_o.test_sync <= s_test_sync_cmd;
  ttc_cmds_o.l1a       <= s_l1a_cmd;

  ttc_clks_o.clk_40  <= s_clk_40;
  ttc_clks_o.clk_80  <= s_clk_80;
  ttc_clks_o.clk_160 <= s_clk_160;
  ttc_clks_o.clk_240 <= s_clk_240;
  ttc_clks_o.clk_320 <= s_clk_320;

end ctp7_ttc_arch;
--============================================================================
--                                                            Architecture end
--============================================================================
