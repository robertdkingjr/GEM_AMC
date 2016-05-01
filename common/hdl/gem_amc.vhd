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

entity gem_amc is
    generic(
        g_NUM_OF_OHs         : integer              := CFG_NUM_OF_OHs;
        g_OH_LINK_CONFIG_ARR : t_oh_link_config_arr := CFG_OH_LINK_CONFIG_ARR;
        g_NUM_IPB_SLAVES     : integer              := C_NUM_IPB_SLAVES
    );
    port(
        reset_i         : in  std_logic;

        -- TTC
        clk_40_ttc_p_i  : in std_logic;      -- TTC backplane clock signals
        clk_40_ttc_n_i  : in std_logic;
        ttc_data_p_i    : in std_logic;      -- TTC protocol backplane signals
        ttc_data_n_i    : in std_logic;
        ttc_clocks_o    : out t_ttc_clks;
        
        -- 8b10b DAQ + Control GTX / GTH links (3.2Gbs, 16bit @ 160MHz w/ 8b10b encoding)
        gt_8b10b_rx_clk_arr_i : in  std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
        gt_8b10b_tx_clk_arr_i : in  std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
        gt_8b10b_rx_data_i    : in  t_gt_8b10b_rx_data_arr(g_NUM_OF_OHs - 1 downto 0);
        gt_8b10b_tx_data_o    : out t_gt_8b10b_tx_data_arr(g_NUM_OF_OHs - 1 downto 0);

        -- Trigger RX GTX / GTH links (3.2Gbs, 16bit @ 160MHz w/ 8b10b encoding)
        gt_trig0_rx_clk_arr_i : in  std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
        gt_trig0_rx_data_i    : in  t_gt_8b10b_rx_data_arr(g_NUM_OF_OHs - 1 downto 0);
        gt_trig1_rx_clk_arr_i : in  std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
        gt_trig1_rx_data_i    : in  t_gt_8b10b_rx_data_arr(g_NUM_OF_OHs - 1 downto 0);
        
        -- IPbus
        ipb_reset_i     : in  std_logic;
        ipb_clk_i       : in  std_logic;
        ipb_miso_arr_o  : out ipb_rbus_array(g_NUM_IPB_SLAVES - 1 downto 0);
        ipb_mosi_arr_i  : in  ipb_wbus_array(g_NUM_IPB_SLAVES - 1 downto 0)
    );
end gem_amc;

architecture gem_amc_arch of gem_amc is

    --== General ==--
    signal reset        : std_logic;

    --== GTX signals ==--
    signal gtx_tk_error : std_logic_vector(1 downto 0);
    signal gtx_tr_error : std_logic_vector(1 downto 0);
    signal gtx_evt_rcvd : std_logic_vector(1 downto 0);
    signal vfat2_t1     : t_t1;

    --== TTC signals ==--
    signal ttc_clocks   : t_ttc_clks;
    signal ttc_cmd      : t_ttc_cmds;
    signal ttc_counters : t_ttc_daq_cntrs;

    --== DAQ signals ==--    
    signal tk_data_links   : t_data_link_array(0 to g_NUM_OF_OHs - 1);
    signal trig_data_links : t_trig_link_array(0 to g_NUM_OF_OHs - 1);
    
    --== Other ==--
    signal ipb_miso_arr    : ipb_rbus_array(g_NUM_IPB_SLAVES - 1 downto 0) := (others => (ipb_rdata => (others => '0'), ipb_ack => '0', ipb_err => '0'));

--    signal sbit_rate : unsigned(31 downto 0) := (others => '0');

begin

    reset <= reset_i; -- TODO: Add a global reset from IPbus
    ttc_clocks_o <= ttc_clocks; 
    ipb_miso_arr_o <= ipb_miso_arr;
    
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
            ipb_reset_i     => ipb_reset_i,
            ipb_clk_i       => ipb_clk_i,
            ipb_mosi_i      => ipb_mosi_arr_i(C_IPB_SLV.ttc),
            ipb_miso_o      => ipb_miso_arr(C_IPB_SLV.ttc)
        );

    --================================--
    -- TTC signal handling 	
    --================================--

    --    ttc_inst : entity work.ttc_wrapper
    --    port map(
    --        reset_i         => reset_i,
    --        ref_clk_i       => user_clk125_i,
    --        ttc_clk_p_i     => xpoint1_clk3_p,
    --        ttc_clk_n_i     => xpoint1_clk3_n,
    --        ttc_data_p_i    => amc_port_rx_p(3),
    --        ttc_data_n_i    => amc_port_rx_n(3),
    --        ttc_clk_o       => ttc_clk,
    --        ttc_ready_o     => ttc_ready,
    --        l1a_o           => ttc_l1a,
    --        bc0_o           => ttc_bc0,
    --        ec0_o           => ttc_ec0,
    --        oc0_o           => open,
    --        calpulse_o      => ttc_calpulse,
    --        start_o         => open,
    --        stop_o          => open,
    --        resync_o        => ttc_resync,
    --        hard_reset_o    => open,
    --        single_err_o    => open,
    --        double_err_o    => open,
    --        led_l1a_o       => user_v6_led_o(2),
    --        led_clk_bc0_o   => open, --user_v6_led_o(1),
    --        bx_id_o         => ttc_bx_id,
    --        orbit_id_o      => ttc_orbit_id,
    --        l1a_id_o        => ttc_l1a_id,
    --
    --        -- IPbus
    --        ipb_clk_i       => ipb_clk_i,
    --        ipb_mosi_i      => ipb_mosi_i(ipb_ttc),
    --        ipb_miso_o      => ipb_miso(ipb_ttc)
    --        
    --    );    
    --    
    --    vfat2_t1.lv1a <= ttc_l1a;
    --    --vfat2_t1.resync <= ttc_resync;
    --    vfat2_t1.bc0 <= ttc_bc0;
    --    vfat2_t1.calpulse <= ttc_calpulse;
    --    
    --    fpga_clkout_o <= ttc_clk;

    --==========--
    --    DAQ   --
    --==========--

    --    daq : entity work.daq
    --    port map
    --    (
    --        -- Reset
    --        reset_i                     => reset_i,
    --        resync_i                    => ttc_resync,
    --        
    --        -- Clocks
    --        mgt_ref_clk125_i            => clk125_2_i,
    --        clk125_i                    => user_clk125_i,
    --        ipb_clk_i                   => ipb_clk_i,
    --
    --        -- Pins
    --        daq_gtx_tx_pin_p            => amc_port_tx_p(1),
    --        daq_gtx_tx_pin_n            => amc_port_tx_n(1),
    --        daq_gtx_rx_pin_p            => amc_port_rx_p(1),
    --        daq_gtx_rx_pin_n            => amc_port_rx_n(1),
    --
    --        -- TTC
    --        ttc_ready_i                 => ttc_ready,
    --        ttc_clk_i                   => ttc_clk,
    --        ttc_l1a_i                   => ttc_l1a,
    --        ttc_bc0_i                   => ttc_bc0,
    --        ttc_ec0_i                   => ttc_ec0,
    --        ttc_bx_id_i                 => ttc_bx_id,
    --        ttc_orbit_id_i              => ttc_orbit_id,
    --        ttc_l1a_id_i                => ttc_l1a_id,
    --
    --        -- Track data
    --        tk_data_links_i             => tk_data_links,
    --        trig_data_links_i           => trig_data_links,
    --        sbit_rate_i                 => sbit_rate,
    --        
    --        -- IPbus
    --        ipb_mosi_i                  => ipb_mosi_i(ipb_daq),
    --        ipb_miso_o                  => ipb_miso(ipb_daq), 
    --
    --        -- Other
    --        board_sn_i                  => sn
    --    );

    --    trigger: entity work.trigger
    --    port map
    --    (
    --        -- resets
    --        reset_i                     => reset_i,
    --        
    --        -- inputs
    --        trig_data_links_i           => trig_data_links,
    --
    --        -- TTC
    --        ttc_clk_i                   => ttc_clk,
    --        ttc_l1a_i                   => ttc_l1a,
    --
    --        -- Outputs
    --        trig_led_o                  => user_v6_led_o(1),
    --        
    --        -- IPbus
    --        ipb_clk_i                   => ipb_clk_i,
    --        ipb_mosi_i                  => ipb_mosi_i(ipb_trigger),
    --        ipb_miso_o                  => ipb_miso(ipb_trigger)
    --    );

    -- blink an LED whenever we have at least one valid SBit cluster
    -- also count the rate of the sbits
    --    process(tk_data_links(0).clk)
    --        variable sbit_led_countdown  : integer := 0;
    --        variable sbit_rate_countdown : integer := 0;
    --        variable valid_sbit : std_logic;
    --    begin
    --        if (rising_edge(tk_data_links(0).clk)) then
    --            
    --            -- find valid sbit signal
    --            if ((trig_data_links(0).data_en = '1') or (trig_data_links(1).data_en = '1')) then
    --                valid_sbit := (not (trig_data_links(0).data(9) and trig_data_links(0).data(10) and trig_data_links(0).data(23) and trig_data_links(0).data(24) and trig_data_links(0).data(37) and trig_data_links(0).data(38) and trig_data_links(0).data(51) and trig_data_links(0).data(52)))
    --                           or (not (trig_data_links(1).data(9) and trig_data_links(1).data(10) and trig_data_links(1).data(23) and trig_data_links(1).data(24) and trig_data_links(1).data(37) and trig_data_links(1).data(38) and trig_data_links(1).data(51) and trig_data_links(1).data(52)));
    --            else
    --                valid_sbit := '0';
    --            end if;
    --            
    --            -- LED countdown
    --            if (valid_sbit = '1') then
    --                sbit_led_countdown := 1_600_000;
    --            elsif (sbit_led_countdown > 0) then
    --                sbit_led_countdown := sbit_led_countdown - 1;
    --            else
    --                sbit_led_countdown := 0;
    --            end if;
    --            
    --            -- calculate the rate
    --            if (sbit_rate_countdown > 0) then
    --                if (valid_sbit = '1') then
    --                    sbit_rate <= sbit_rate + 1;
    --                end if;
    --                sbit_rate_countdown := sbit_rate_countdown - 1;
    --            else
    --                sbit_rate <= (others => '0');
    --                sbit_rate_countdown := 1_600_000_000;
    --            end if;
    --            
    --            -- led state
    --            if (sbit_led_countdown > 0) then
    --                user_v6_led_o(1) <= '1';
    --            else
    --                user_v6_led_o(1) <= '0';
    --            end if;            
    --            
    --        end if;
    --    end process;

    --==========--
    -- Counters --
    --==========--

--    ipbus_counters_inst : entity work.ipbus_counters
--        port map(
--            ipb_clk_i      => ipb_clk_i,
--            gtx_clk_i      => gtx_usr_clk,
--            ttc_clk_i      => ttc_clk,
--            reset_i        => reset_i,
--            ipb_mosi_i     => ipb_mosi_i(ipb_counters),
--            ipb_miso_o     => ipb_miso(ipb_counters),
--            ipb_i          => ipb_mosi_i,
--            ipb_o          => ipb_miso,
--            vfat2_t1_i     => vfat2_t1,
--            gtx_tk_error_i => gtx_tk_error,
--            gtx_tr_error_i => gtx_tr_error,
--            gtx_evt_rcvd_i => gtx_evt_rcvd
--        );

end gem_amc_arch;
