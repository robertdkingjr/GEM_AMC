------------------------------------------------------------------------------------------------------------------------------------------------------
-- Company: TAMU
-- Engineer: Evaldas Juska (evaldas.juska@cern.ch, evka85@gmail.com)
-- 
-- Create Date:    23:45:21 2016-04-20
-- Module Name:    GEM_AMC 
-- Description:    This is the top module of all the common GEM AMC logic. It is board-agnostic and can be used in different FPGA / board designs 
------------------------------------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

use work.gem_pkg.all;
use work.gem_board_config_package.all;
use work.ipb_addr_decode.all;
use work.ipbus.all;
use work.ttc_pkg.all;
use work.vendor_specific_gbt_bank_package.all;

entity gem_amc is
    generic(
        g_NUM_OF_OHs         : integer;
        g_USE_GBT            : boolean := true;  -- if this is true, GBT links will be used for communicationa with OH, if false 3.2Gbs 8b10b links will be used instead (remember to instanciate the correct links!)
        g_USE_3x_GBTs        : boolean := false; -- if this is true, each OH will use 3 GBT links - this will be default in the future with OH v3, but for now it's a good test
        g_USE_TRIG_LINKS     : boolean := true;  -- this should be TRUE by default, but could be set to false for tests or quicker compilation if not needed
        
        g_NUM_IPB_SLAVES     : integer;
        g_DAQ_CLK_FREQ       : integer
    );
    port(
        reset_i                 : in   std_logic;
        reset_pwrup_o           : out  std_logic;

        -- TTC
        clk_40_ttc_p_i          : in  std_logic;      -- TTC backplane clock signals
        clk_40_ttc_n_i          : in  std_logic;
        ttc_data_p_i            : in  std_logic;      -- TTC protocol backplane signals
        ttc_data_n_i            : in  std_logic;
        ttc_clocks_o            : out t_ttc_clks;
        
        -- 8b10b DAQ + Control GTX / GTH links (3.2Gbs, 16bit @ 160MHz w/ 8b10b encoding)
        gt_8b10b_rx_clk_arr_i   : in  std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
        gt_8b10b_tx_clk_arr_i   : in  std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
        gt_8b10b_rx_data_arr_i  : in  t_gt_8b10b_rx_data_arr(g_NUM_OF_OHs - 1 downto 0);
        gt_8b10b_tx_data_arr_o  : out t_gt_8b10b_tx_data_arr(g_NUM_OF_OHs - 1 downto 0);

        -- Trigger RX GTX / GTH links (3.2Gbs, 16bit @ 160MHz w/ 8b10b encoding)
        gt_trig0_rx_clk_arr_i   : in  std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
        gt_trig0_rx_data_arr_i  : in  t_gt_8b10b_rx_data_arr(g_NUM_OF_OHs - 1 downto 0);
        gt_trig1_rx_clk_arr_i   : in  std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
        gt_trig1_rx_data_arr_i  : in  t_gt_8b10b_rx_data_arr(g_NUM_OF_OHs - 1 downto 0);

        -- GBT DAQ + Control GTX / GTH links (4.8Gbs, 40bit @ 120MHz without 8b10b encoding)
        gt_gbt_rx_common_clk_i  : in  std_logic;
        gt_gbt_rx_links_arr_i   : in  t_gbt_mgt_rx_links_arr(g_NUM_OF_OHs - 1 downto 0);
        gt_gbt_tx_links_arr_o   : out t_gbt_mgt_tx_links_arr(g_NUM_OF_OHs - 1 downto 0);
        gt_gbt_tx0_clk_arr_i    : in  std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
        gt_gbt_tx1_clk_arr_i    : in  std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
        gt_gbt_tx2_clk_arr_i    : in  std_logic_vector(g_NUM_OF_OHs - 1 downto 0);

        -- IPbus
        ipb_reset_i             : in  std_logic;
        ipb_clk_i               : in  std_logic;
        ipb_miso_arr_o          : out ipb_rbus_array(g_NUM_IPB_SLAVES - 1 downto 0);
        ipb_mosi_arr_i          : in  ipb_wbus_array(g_NUM_IPB_SLAVES - 1 downto 0);
        
        -- LEDs
        led_l1a_o               : out std_logic;
        led_trigger_o           : out std_logic;
        
        -- DAQLink
        daq_data_clk_i          : in  std_logic;
        daq_data_clk_locked_i   : in  std_logic;
        daq_to_daqlink_o        : out t_daq_to_daqlink;
        daqlink_to_daq_i        : in  t_daqlink_to_daq;
        
        -- Board serial number
        board_id_i              : in std_logic_vector(15 downto 0)
        
    );
end gem_amc;

architecture gem_amc_arch of gem_amc is

    --================================--
    -- Components  
    --================================--

    component ila_gbt
        port(
            clk     : IN STD_LOGIC;
            probe0  : IN STD_LOGIC_VECTOR(83 DOWNTO 0);
            probe1  : IN STD_LOGIC_VECTOR(83 DOWNTO 0);
            probe2  : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            probe3  : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            probe4  : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            probe5  : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            probe6  : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            probe7  : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            probe8  : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            probe9  : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            probe10 : IN STD_LOGIC_VECTOR(5 DOWNTO 0)
        );
    end component;

    --================================--
    -- Signals
    --================================--

    --== General ==--
    signal reset            : std_logic;
    signal reset_pwrup      : std_logic;
    signal ipb_reset        : std_logic;

    --== TTC signals ==--
    signal ttc_clocks       : t_ttc_clks;
    signal ttc_cmd          : t_ttc_cmds;
    signal ttc_counters     : t_ttc_daq_cntrs;
    signal ttc_status       : t_ttc_status;

    --== DAQ signals ==--    
    signal tk_data_links    : t_data_link_array(g_NUM_OF_OHs - 1 downto 0);
    
    --== Trigger signals ==--    
    signal sbit_clusters_arr        : t_oh_sbits_arr(g_NUM_OF_OHs - 1 downto 0);
    signal sbit_links_status_arr    : t_oh_sbit_links_arr(g_NUM_OF_OHs - 1 downto 0);
    
    signal gt_trig0_rx_clk_arr      : std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
    signal gt_trig0_rx_data_arr     : t_gt_8b10b_rx_data_arr(g_NUM_OF_OHs - 1 downto 0);
    signal gt_trig1_rx_clk_arr      : std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
    signal gt_trig1_rx_data_arr     : t_gt_8b10b_rx_data_arr(g_NUM_OF_OHs - 1 downto 0);
    
    --== OH link status ==--
    signal oh_link_status_arr       : t_oh_link_status_arr(g_NUM_OF_OHs - 1 downto 0);    

    --== GBT ==--
    signal gbt_tx_we_arr                : std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
    signal gbt_tx_data_arr              : t_gbt_frame_array(g_NUM_OF_OHs - 1 downto 0);
    signal gbt_tx_gearbox_aligned_arr   : std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
    signal gbt_tx_gearbox_align_done_arr: std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
    signal gbt_mgt_tx_data_arr          : t_gt_gbt_tx_data_arr(g_NUM_OF_OHs - 1 downto 0);
    signal gbt_mgt_tx_clk_arr           : std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
    signal gbt_rx_sync_done_arr         : std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
            
    signal gbt_rx_valid_arr             : std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
    signal gbt_rx_data_arr              : t_gbt_frame_array(g_NUM_OF_OHs - 1 downto 0);
    signal gbt_rx_header                : std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
    signal gbt_rx_header_locked         : std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
    signal gbt_rx_ready                 : std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
    signal gbt_rx_frame_clk_ready       : std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
    signal gbt_rx_word_clk_ready        : std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
    signal gbt_rx_bitslip_nbr           : rxBitSlipNbr_mxnbit_A(g_NUM_OF_OHs - 1 downto 0);
    signal gbt_mgt_rx_data_arr          : t_gt_gbt_rx_data_arr(g_NUM_OF_OHs - 1 downto 0);
    signal gbt_mgt_rx_ready_arr         : std_logic_vector(g_NUM_OF_OHs - 1 downto 0);    
    signal gbt_mgt_rx_clk_arr           : std_logic_vector(g_NUM_OF_OHs - 1 downto 0);

    -- GBT communication settings
    signal gbt_tx_sync_pattern          : std_logic_vector(15 downto 0);
    signal gbt_rx_sync_pattern          : std_logic_vector(31 downto 0);
    signal gbt_rx_sync_count_req        : std_logic_vector(7 downto 0);


    --== GBT fake links ==--
    signal gbt_fake_tx_data_arr              : t_gbt_frame_array((g_NUM_OF_OHs * 2) - 1 downto 0);
    signal gbt_fake_mgt_tx_data_arr          : t_gt_gbt_tx_data_arr((g_NUM_OF_OHs * 2) - 1 downto 0);
    signal gbt_fake_mgt_tx_clk_arr           : std_logic_vector((g_NUM_OF_OHs * 2) - 1 downto 0);
            
    signal gbt_fake_rx_valid_arr             : std_logic_vector((g_NUM_OF_OHs * 2) - 1 downto 0);
    signal gbt_fake_rx_data_arr              : t_gbt_frame_array((g_NUM_OF_OHs * 2) - 1 downto 0);
    signal gbt_fake_mgt_rx_data_arr          : t_gt_gbt_rx_data_arr((g_NUM_OF_OHs * 2) - 1 downto 0);
    signal gbt_fake_mgt_rx_clk_arr           : std_logic_vector((g_NUM_OF_OHs * 2) - 1 downto 0);


    -- test
    signal gbt_rx_mismatch_cnt          : t_std16_array(g_NUM_OF_OHs - 1 downto 0);
    signal gbt_counter_pattern          : unsigned(7 downto 0) := (others => '0');

    --== Other ==--
    signal ipb_miso_arr     : ipb_rbus_array(g_NUM_IPB_SLAVES - 1 downto 0) := (others => (ipb_rdata => (others => '0'), ipb_ack => '0', ipb_err => '0'));

    signal debug_clk_reset  : std_logic;
    signal debug_clk_cnt_arr: t_std32_array(g_NUM_OF_OHs - 1 downto 0);

begin

    --================================--
    -- Power-on reset  
    --================================--
    
    reset_pwrup_o <= reset_pwrup;
    reset <= reset_i or reset_pwrup; -- TODO: Add a global reset from IPbus
    ipb_reset <= ipb_reset_i or reset_pwrup;
    ttc_clocks_o <= ttc_clocks; 
    ipb_miso_arr_o <= ipb_miso_arr;

    g_real_trig_links : if (g_USE_TRIG_LINKS) generate
        gt_trig0_rx_clk_arr <= gt_trig0_rx_clk_arr_i;
        gt_trig1_rx_clk_arr <= gt_trig1_rx_clk_arr_i;
        
        gt_trig0_rx_data_arr <= gt_trig0_rx_data_arr_i;
        gt_trig1_rx_data_arr <= gt_trig1_rx_data_arr_i;
    end generate;
    
    g_fake_trig_links : if (not g_USE_TRIG_LINKS) generate
        gt_trig0_rx_clk_arr <= (others => '0');
        gt_trig1_rx_clk_arr <= (others => '0');

        gt_trig0_rx_data_arr <= (others => (rxdata => (others => ('0')), rxcharisk => (others => '0'), rxchariscomma => (others => '0'), rxnotintable => (others => '0'), rxdisperr => (others => '0'), rxcommadet => '0', rxbyterealign => '0', rxbyteisaligned => '0'));
        gt_trig1_rx_data_arr <= (others => (rxdata => (others => ('0')), rxcharisk => (others => '0'), rxchariscomma => (others => '0'), rxnotintable => (others => '0'), rxdisperr => (others => '0'), rxcommadet => '0', rxbyterealign => '0', rxbyteisaligned => '0'));
    end generate;

    --================================--
    -- Power-on reset  
    --================================--
    
    process(ttc_clocks.clk_40) -- NOTE: using TTC clock, no nothing will work if there's no TTC clock
        variable countdown : integer := 40_000_000; -- 1s - probably way too long, but ok for now (this is only used after powerup)
    begin
        if (rising_edge(ttc_clocks.clk_40)) then
            if (countdown > 0) then
              reset_pwrup <= '1';
              countdown := countdown - 1;
            else
              reset_pwrup <= '0';
            end if;
        end if;
    end process;    
    
    --================================--
    -- TTC  
    --================================--

    i_ttc : entity work.ttc
        port map(
            reset_i         => reset,
            clk_40_ttc_p_i  => clk_40_ttc_p_i,
            clk_40_ttc_n_i  => clk_40_ttc_n_i,
            ttc_data_p_i    => ttc_data_p_i,
            ttc_data_n_i    => ttc_data_n_i,
            ttc_clks_o      => ttc_clocks,
            ttc_cmds_o      => ttc_cmd,
            ttc_daq_cntrs_o => ttc_counters,
            ttc_status_o    => ttc_status,
            l1a_led_o       => led_l1a_o,
            ipb_reset_i     => ipb_reset,
            ipb_clk_i       => ipb_clk_i,
            ipb_mosi_i      => ipb_mosi_arr_i(C_IPB_SLV.ttc),
            ipb_miso_o      => ipb_miso_arr(C_IPB_SLV.ttc)
        );

    --================================--
    -- Optohybrids  
    --================================--
    
    i_optohybrids : for i in 0 to g_NUM_OF_OHs - 1 generate

        i_optohybrid_single : entity work.optohybrid
            generic map(
                g_USE_GBT       => g_USE_GBT,
                g_DEBUG         => TRUE
            )
            port map(
                reset_i                 => reset,
                ttc_clk_i               => ttc_clocks,
                ttc_cmds_i              => ttc_cmd,

                gth_rx_usrclk_i         => gt_8b10b_rx_clk_arr_i(i),
                gth_tx_usrclk_i         => gt_8b10b_tx_clk_arr_i(i),
                gth_rx_data_i           => gt_8b10b_rx_data_arr_i(i),
                gth_tx_data_o           => gt_8b10b_tx_data_arr_o(i),

                gbt_rx_ready_i          => gbt_rx_ready(i) and gbt_rx_valid_arr(i),
                gbt_rx_data_i           => gbt_rx_data_arr(i),
                gbt_tx_data_o           => gbt_tx_data_arr(i),

                gbt_tx_sync_pattern_i   => gbt_tx_sync_pattern,
                gbt_rx_sync_pattern_i   => gbt_rx_sync_pattern,
                gbt_rx_sync_count_req_i => gbt_rx_sync_count_req,
                gbt_rx_sync_done_o      => gbt_rx_sync_done_arr(i),
                
                sbit_clusters_o         => sbit_clusters_arr(i), 
                sbit_links_status_o     => sbit_links_status_arr(i), 
                gth_rx_trig_usrclk_i    => (gt_trig0_rx_clk_arr(i), gt_trig1_rx_clk_arr(i)),
                gth_rx_trig_data_i      => (gt_trig0_rx_data_arr(i), gt_trig1_rx_data_arr(i)),

                tk_data_link_o          => tk_data_links(i),

                oh_reg_ipb_reset_i      => ipb_reset,
                oh_reg_ipb_clk_i        => ipb_clk_i,
                oh_reg_ipb_reg_miso_o   => ipb_miso_arr(C_IPB_SLV.oh_reg(i)),
                oh_reg_ipb_reg_mosi_i   => ipb_mosi_arr_i(C_IPB_SLV.oh_reg(i)),

                link_status_o           => oh_link_status_arr(i),

                debug_reset_cnt_i       => debug_clk_reset,
                debug_clk_cnt_o         => debug_clk_cnt_arr(i)

            );    
    
    end generate;

    --================================--
    -- Trigger  
    --================================--

    i_trigger : entity work.trigger
        generic map(
            g_NUM_OF_OHs => g_NUM_OF_OHs
        )
        port map(
            reset_i            => reset,
            ttc_clk_i          => ttc_clocks,
            ttc_cmds_i         => ttc_cmd,
            sbit_clusters_i    => sbit_clusters_arr,
            sbit_link_status_i => sbit_links_status_arr,
            trig_led_o         => led_trigger_o,
            ipb_reset_i        => ipb_reset,
            ipb_clk_i          => ipb_clk_i,
            ipb_miso_o         => ipb_miso_arr(C_IPB_SLV.trigger),
            ipb_mosi_i         => ipb_mosi_arr_i(C_IPB_SLV.trigger)
        );

    --================================--
    -- DAQ  
    --================================--

    i_daq : entity work.daq
        generic map(
            g_NUM_OF_OHs => g_NUM_OF_OHs,
            g_DAQ_CLK_FREQ => g_DAQ_CLK_FREQ
        )
        port map(
            reset_i          => reset,
            daq_clk_i        => daq_data_clk_i,
            daq_clk_locked_i => daq_data_clk_locked_i,
            daq_to_daqlink_o => daq_to_daqlink_o,
            daqlink_to_daq_i => daqlink_to_daq_i,
            ttc_clks_i       => ttc_clocks,
            ttc_cmds_i       => ttc_cmd,
            ttc_daq_cntrs_i  => ttc_counters,
            ttc_status_i     => ttc_status,
            tk_data_links_i  => tk_data_links,
            ipb_reset_i      => ipb_reset_i,
            ipb_clk_i        => ipb_clk_i,
            ipb_mosi_i       => ipb_mosi_arr_i(C_IPB_SLV.daq),
            ipb_miso_o       => ipb_miso_arr(C_IPB_SLV.daq),
            board_sn_i       => board_id_i
        );    

    --================================--
    -- GEM System
    --================================--

    i_gem_system : entity work.gem_system_regs
        port map(
            ttc_clks_i       => ttc_clocks,            
            reset_i          => reset,
            ipb_clk_i        => ipb_clk_i,
            ipb_reset_i      => ipb_reset_i,
            ipb_mosi_i       => ipb_mosi_arr_i(C_IPB_SLV.system),
            ipb_miso_o       => ipb_miso_arr(C_IPB_SLV.system),
            tk_rx_polarity_o => open,
            tk_tx_polarity_o => open,
            board_id_o       => open,
            gbt_tx_sync_pattern_o => gbt_tx_sync_pattern,
            gbt_rx_sync_pattern_o => gbt_rx_sync_pattern,
            gbt_rx_sync_count_req_o => gbt_rx_sync_count_req       
        );

    --==================--
    -- OH Link Counters --
    --==================--

    i_oh_link_registers : entity work.oh_link_regs
        generic map(
            g_NUM_OF_OHs => g_NUM_OF_OHs
        )
        port map(
            reset_i                => reset,
            clk_i                  => ttc_clocks.clk_160,

            oh_link_status_arr_i   => oh_link_status_arr,
            gbt_rx_sync_done_arr_i => gbt_rx_sync_done_arr,

            ipb_reset_i            => ipb_reset_i,
            ipb_clk_i              => ipb_clk_i,
            ipb_miso_o             => ipb_miso_arr(C_IPB_SLV.oh_links),
            ipb_mosi_i             => ipb_mosi_arr_i(C_IPB_SLV.oh_links),
                    
            debug_clk_cnt_arr_i    => debug_clk_cnt_arr,
            debug_clk_reset_o      => debug_clk_reset
        );
    
    --==========--
    --    GBT   --
    --==========--
    
    g_gbt : if g_USE_GBT generate
    
        i_gbt : entity work.gbt
            generic map(
                GBT_BANK_ID     => 0,
                NUM_LINKS       => g_NUM_OF_OHs,
                TX_OPTIMIZATION => 0,
                RX_OPTIMIZATION => 0,
                TX_ENCODING     => 0,
                RX_ENCODING     => 0
            )
            port map(
                reset_i                     => reset,
                tx_frame_clk_i              => ttc_clocks.clk_40,
                rx_frame_clk_i              => ttc_clocks.clk_40,
                rx_word_common_clk_i        => gt_gbt_rx_common_clk_i,
                tx_word_clk_arr_i           => gbt_mgt_tx_clk_arr,
                rx_word_clk_arr_i           => gbt_mgt_rx_clk_arr,
                tx_ready_arr_i              => (others => '1'),
                tx_we_arr_i                 => gbt_tx_we_arr,
                tx_data_arr_i               => gbt_tx_data_arr,
                tx_gearbox_aligned_arr_o    => gbt_tx_gearbox_aligned_arr,
                tx_gearbox_align_done_arr_o => gbt_tx_gearbox_align_done_arr,
                rx_frame_clk_rdy_arr_i      => gbt_rx_frame_clk_ready,
                rx_word_clk_rdy_arr_i       => gbt_rx_word_clk_ready,
                rx_rdy_arr_o                => gbt_rx_ready,
                rx_bitslip_nbr_arr_o        => gbt_rx_bitslip_nbr,
                rx_header_arr_o             => gbt_rx_header,
                rx_header_locked_arr_o      => gbt_rx_header_locked,
                rx_data_valid_arr_o         => gbt_rx_valid_arr,
                rx_data_arr_o               => gbt_rx_data_arr,
                mgt_rx_rdy_arr_i            => gbt_mgt_rx_ready_arr,
                mgt_tx_data_arr_o           => gbt_mgt_tx_data_arr,
                mgt_rx_data_arr_i           => gbt_mgt_rx_data_arr
            );
        
        -- 3x GBT test for resource utilization testing for future OH v3        
        g_3x_gbt_fake_gbt_cores : if g_USE_3x_GBTs generate
            i_gbt : entity work.gbt
                generic map(
                    GBT_BANK_ID     => 0,
                    NUM_LINKS       => g_NUM_OF_OHs * 2,
                    TX_OPTIMIZATION => 0,
                    RX_OPTIMIZATION => 0,
                    TX_ENCODING     => 0,
                    RX_ENCODING     => 0
                )
                port map(
                    reset_i                     => reset,
                    tx_frame_clk_i              => ttc_clocks.clk_40,
                    rx_frame_clk_i              => ttc_clocks.clk_40,
                    rx_word_common_clk_i        => gt_gbt_rx_common_clk_i,
                    tx_word_clk_arr_i           => gbt_fake_mgt_tx_clk_arr,
                    rx_word_clk_arr_i           => gbt_fake_mgt_rx_clk_arr,
                    tx_ready_arr_i              => (others => '1'),
                    tx_we_arr_i                 => (others => not reset),
                    tx_data_arr_i               => gbt_fake_tx_data_arr,
                    tx_gearbox_aligned_arr_o    => open,
                    tx_gearbox_align_done_arr_o => open,
                    rx_frame_clk_rdy_arr_i      => (others => '1'),
                    rx_word_clk_rdy_arr_i       => (others => '1'),
                    rx_rdy_arr_o                => open,
                    rx_bitslip_nbr_arr_o        => open,
                    rx_header_arr_o             => open,
                    rx_header_locked_arr_o      => open,
                    rx_data_valid_arr_o         => gbt_fake_rx_valid_arr,
                    rx_data_arr_o               => gbt_fake_rx_data_arr,
                    mgt_rx_rdy_arr_i            => (others => '1'),
                    mgt_tx_data_arr_o           => gbt_fake_mgt_tx_data_arr,
                    mgt_rx_data_arr_i           => gbt_fake_mgt_rx_data_arr
                );        
        end generate;
        
        
        g_gbt_tx_clks: for i in 0 to g_NUM_OF_OHs - 1 generate
            gbt_mgt_tx_clk_arr(i) <= gt_gbt_tx0_clk_arr_i(i);
            gt_gbt_tx_links_arr_o(i).tx0data <= gbt_mgt_tx_data_arr(i);
            
            gbt_mgt_rx_clk_arr(i) <= gt_gbt_rx_links_arr_i(i).rx0clk;
            gbt_mgt_rx_data_arr(i) <= gt_gbt_rx_links_arr_i(i).rx0data;
    
            -- 3x GBT test for resource utilization testing for future OH v3        
            g_3x_gbt_fake_links : if g_USE_3x_GBTs generate
                gbt_fake_tx_data_arr(i * 2)             <= gbt_fake_rx_data_arr(i * 2);
                gbt_fake_tx_data_arr((i * 2) + 1)       <= gbt_fake_rx_data_arr((i * 2) + 1);
                
                gt_gbt_tx_links_arr_o(i).tx1data        <= gbt_fake_mgt_tx_data_arr(i * 2); 
                gt_gbt_tx_links_arr_o(i).tx2data        <= gbt_fake_mgt_tx_data_arr((i * 2) + 1);
    
                gbt_fake_mgt_rx_data_arr(i * 2)         <= gt_gbt_rx_links_arr_i(i).rx1data;
                gbt_fake_mgt_rx_data_arr((i * 2) + 1)   <= gt_gbt_rx_links_arr_i(i).rx2data;
                
                gbt_fake_mgt_tx_clk_arr(i * 2)          <= gt_gbt_tx1_clk_arr_i(i);
                gbt_fake_mgt_tx_clk_arr((i * 2) + 1)    <= gt_gbt_tx2_clk_arr_i(i);
                
                gbt_fake_mgt_rx_clk_arr(i * 2)          <= gt_gbt_rx_links_arr_i(i).rx1clk;
                gbt_fake_mgt_rx_clk_arr((i * 2) + 1)    <= gt_gbt_rx_links_arr_i(i).rx2clk;
            end generate;
                    
        end generate;
        
        gbt_rx_frame_clk_ready <= (others => '1');
        gbt_rx_word_clk_ready <= (others => '1');
        gbt_mgt_rx_ready_arr <= (others => '1');
    
--        i_ila_gbt : component ila_gbt
--            port map(
--                clk     => ttc_clocks.clk_40,
--                probe0  => gbt_tx_data_arr(0),
--                probe1  => gbt_rx_data_arr(0),
--                probe2  => gbt_tx_gearbox_aligned_arr(0 downto 0),
--                probe3  => gbt_tx_gearbox_align_done_arr(0 downto 0),
--                probe4  => gbt_rx_frame_clk_ready(0 downto 0),
--                probe5  => gbt_rx_word_clk_ready(0 downto 0),
--                probe6  => gbt_rx_ready(0 downto 0),
--                probe7  => gbt_rx_header(0 downto 0),
--                probe8  => gbt_rx_header_locked(0 downto 0),
--                probe9  => gbt_rx_valid_arr(0 downto 0),
--                probe10 => gbt_rx_bitslip_nbr(0)
--            );
        
    end generate g_gbt;
          
    --=== GBT test ===--
    
--    -- 1 Hz counter
--    process (ttc_clocks.clk_40)
--        variable countdown : integer := C_TTC_CLK_FREQUENCY;
--    begin
--        if (rising_edge(ttc_clocks.clk_40)) then
--            if (countdown = 0) then
--                countdown := C_TTC_CLK_FREQUENCY;
--                gbt_counter_pattern <= gbt_counter_pattern + 1;
--            else
--                countdown := countdown - 1;
--            end if;
--        end if;
--    end process;
--    
--    g_gbt_test : for i in 0 to g_NUM_OF_OHs - 1 generate
--
--        -- loopback (comment the next two lines sending data through MGTs)
--        --gbt_mgt_rx_data_arr(i).rxdata <= gbt_mgt_tx_data_arr(i).txdata;
--        --gt_gbt_tx_data_arr_o(i).txdata <= x"BCBCBCBCBC"; -- load the MGT data input with some fake data -- TODO: remove this once you connect the GBT to the real MGTs
--        
--        -- generate test data
--        p_gbt_test_data : process(ttc_clocks.clk_40)
--            variable counter    : unsigned(19 downto 0);
--        begin
--            if (rising_edge(ttc_clocks.clk_40)) then
--                if (reset = '1') then
--                    counter := (others => '0');
--                    gbt_tx_we_arr(i) <= '0';
--                    gbt_rx_mismatch_cnt(i) <= (others => '0');
--                else
--                    counter := counter + 1;
--                    gbt_tx_we_arr(i) <= '1';
--                    gbt_tx_data_arr(i) <= x"0" & std_logic_vector(gbt_counter_pattern) & std_logic_vector(gbt_counter_pattern) &
--                                                 std_logic_vector(gbt_counter_pattern) & std_logic_vector(gbt_counter_pattern) &
--                                                 std_logic_vector(gbt_counter_pattern) & std_logic_vector(gbt_counter_pattern) &
--                                                 std_logic_vector(gbt_counter_pattern) & std_logic_vector(gbt_counter_pattern) &
--                                                 std_logic_vector(gbt_counter_pattern) & std_logic_vector(gbt_counter_pattern);
--                                                 
--                    --gbt_tx_data_arr(i) <= x"aaaa" & x"fafa" & x"ffff" & x"1111" & std_logic_vector(counter);
--                    if (gbt_rx_data_arr(i) /= gbt_rx_data_arr(0)) then
--                        gbt_rx_mismatch_cnt(i) <= std_logic_vector(unsigned(gbt_rx_mismatch_cnt(i)) + 1);
--                    end if;
--                end if;
--            end if;
--        end process;
--        
--    end generate;
    
    
end gem_amc_arch;
