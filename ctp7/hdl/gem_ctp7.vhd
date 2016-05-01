-------------------------------------------------------------------------------
--                                                                            
--       Unit Name: gem_ctp7                                            
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
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

library UNISIM;
use UNISIM.VCOMPONENTS.all;

library work;
use work.gth_pkg.all;

use work.ctp7_utils_pkg.all;
use work.ttc_pkg.all;
use work.system_package.all;
use work.gem_pkg.all;
use work.ipbus.all;
use work.axi_pkg.all;
use work.ipb_addr_decode.all;
use work.gem_board_config_package.all;

--============================================================================
--                                                          Entity declaration
--============================================================================
entity gem_ctp7 is
    generic(
        C_DATE_CODE      : std_logic_vector(31 downto 0) := x"00000000";
        C_GITHASH_CODE   : std_logic_vector(31 downto 0) := x"00000000";
        C_GIT_REPO_DIRTY : std_logic                     := '0'
    );
    port(
        clk_200_diff_in_clk_p          : in  std_logic;
        clk_200_diff_in_clk_n          : in  std_logic;

        clk_40_ttc_p_i                 : in  std_logic; -- TTC backplane clock signals
        clk_40_ttc_n_i                 : in  std_logic;
        ttc_data_p_i                   : in  std_logic;
        ttc_data_n_i                   : in  std_logic;

        LEDs                           : out std_logic_vector(1 downto 0);

        axi_c2c_v7_to_zynq_data        : out std_logic_vector(14 downto 0);
        axi_c2c_v7_to_zynq_clk         : out std_logic;
        axi_c2c_zynq_to_v7_clk         : in  std_logic;
        axi_c2c_zynq_to_v7_data        : in  std_logic_vector(14 downto 0);
        axi_c2c_v7_to_zynq_link_status : out std_logic;
        axi_c2c_zynq_to_v7_reset       : in  std_logic;

        refclk_F_0_p_i                 : in  std_logic_vector(3 downto 0);
        refclk_F_0_n_i                 : in  std_logic_vector(3 downto 0);
        refclk_F_1_p_i                 : in  std_logic_vector(3 downto 0);
        refclk_F_1_n_i                 : in  std_logic_vector(3 downto 0);

        refclk_B_0_p_i                 : in  std_logic_vector(3 downto 1);
        refclk_B_0_n_i                 : in  std_logic_vector(3 downto 1);
        refclk_B_1_p_i                 : in  std_logic_vector(3 downto 1);
        refclk_B_1_n_i                 : in  std_logic_vector(3 downto 1)
    );
end gem_ctp7;

--============================================================================
--                                                        Architecture section
--============================================================================
architecture gem_ctp7_arch of gem_ctp7 is

    --============================================================================
    --                                                      Component declarations
    --===========================================================================
    component system is
        generic(
            C_DATE_CODE      : std_logic_vector(31 downto 0) := x"00000000";
            C_GITHASH_CODE   : std_logic_vector(31 downto 0) := x"00000000";
            C_GIT_REPO_DIRTY : std_logic                     := '0'
        );
        port(
            clk_200_diff_in_clk_p          : in  std_logic;
            clk_200_diff_in_clk_n          : in  std_logic;

            axi_c2c_v7_to_zynq_data        : out std_logic_vector(14 downto 0);
            axi_c2c_v7_to_zynq_clk         : out std_logic;
            axi_c2c_zynq_to_v7_clk         : in  std_logic;
            axi_c2c_zynq_to_v7_data        : in  std_logic_vector(14 downto 0);
            axi_c2c_v7_to_zynq_link_status : out std_logic;
            axi_c2c_zynq_to_v7_reset       : in  std_logic;

            refclk_F_0_p_i                 : in  std_logic_vector(3 downto 0);
            refclk_F_0_n_i                 : in  std_logic_vector(3 downto 0);
            refclk_F_1_p_i                 : in  std_logic_vector(3 downto 0);
            refclk_F_1_n_i                 : in  std_logic_vector(3 downto 0);

            refclk_B_0_p_i                 : in  std_logic_vector(3 downto 1);
            refclk_B_0_n_i                 : in  std_logic_vector(3 downto 1);
            refclk_B_1_p_i                 : in  std_logic_vector(3 downto 1);
            refclk_B_1_n_i                 : in  std_logic_vector(3 downto 1);

            ----------------- for GEM ------------------------
            axi_clk_o                      : out std_logic;
            axi_reset_o                    : out std_logic;
            ipb_axi_mosi_o                 : out t_axi_lite_mosi;
            ipb_axi_miso_i                 : in  t_axi_lite_miso;

            ----------------- TTC ------------------------
            ttc_clks_i                     : in  t_ttc_clks;

            ----------------- GTH ------------------------
            clk_gth_tx_arr_o               : out std_logic_vector(g_NUM_OF_GTH_GTs - 1 downto 0);
            clk_gth_rx_arr_o               : out std_logic_vector(g_NUM_OF_GTH_GTs - 1 downto 0);
            gth_tx_data_arr_i              : in  t_gt_8b10b_tx_data_arr(g_NUM_OF_GTH_GTs - 1 downto 0);
            gth_rx_data_arr_o              : out t_gt_8b10b_rx_data_arr(g_NUM_OF_GTH_GTs - 1 downto 0);
            gth_rxreset_arr_o              : out std_logic_vector(g_NUM_OF_GTH_GTs - 1 downto 0);
            gth_txreset_arr_o              : out std_logic_vector(g_NUM_OF_GTH_GTs - 1 downto 0)
        );
    end component system;

    --============================================================================
    --                                                         Signal declarations
    --============================================================================

    -------------------------- AXI-IPbus bridge ---------------------------------
    --AXI
    signal axi_clk      : std_logic;
    signal axi_reset    : std_logic;
    signal ipb_axi_mosi : t_axi_lite_mosi;
    signal ipb_axi_miso : t_axi_lite_miso;
    --IPbus
    signal ipb_reset    : std_logic;
    signal ipb_clk      : std_logic;
    signal ipb_miso_arr : ipb_rbus_array(C_NUM_IPB_SLAVES - 1 downto 0) := (others => (ipb_rdata => (others => '0'), ipb_ack => '0', ipb_err => '0'));
    signal ipb_mosi_arr : ipb_wbus_array(C_NUM_IPB_SLAVES - 1 downto 0);

    -------------------------- TTC ---------------------------------
    signal ttc_clocks : t_ttc_clks;

    -------------------------- GTH ---------------------------------
    signal clk_gth_tx_arr  : std_logic_vector(g_NUM_OF_GTH_GTs - 1 downto 0);
    signal clk_gth_rx_arr  : std_logic_vector(g_NUM_OF_GTH_GTs - 1 downto 0);
    signal gth_tx_data_arr : t_gt_8b10b_tx_data_arr(g_NUM_OF_GTH_GTs - 1 downto 0);
    signal gth_rx_data_arr : t_gt_8b10b_rx_data_arr(g_NUM_OF_GTH_GTs - 1 downto 0);
    signal gth_rxreset_arr : std_logic_vector(g_NUM_OF_GTH_GTs - 1 downto 0);
    signal gth_txreset_arr : std_logic_vector(g_NUM_OF_GTH_GTs - 1 downto 0);

    
    -------------------- GTHs mapped to GEM links ---------------------------------
    
    -- 8b10b DAQ + Control GTX / GTH links (3.2Gbs, 16bit @ 160MHz w/ 8b10b encoding)
    signal gt_8b10b_rx_clk_arr : std_logic_vector(CFG_NUM_OF_OHs - 1 downto 0);
    signal gt_8b10b_tx_clk_arr : std_logic_vector(CFG_NUM_OF_OHs - 1 downto 0);
    signal gt_8b10b_rx_data    : t_gt_8b10b_rx_data_arr(CFG_NUM_OF_OHs - 1 downto 0);
    signal gt_8b10b_tx_data    : t_gt_8b10b_tx_data_arr(CFG_NUM_OF_OHs - 1 downto 0);

    -- Trigger RX GTX / GTH links (3.2Gbs, 16bit @ 160MHz w/ 8b10b encoding)
    signal gt_trig0_rx_clk_arr : std_logic_vector(CFG_NUM_OF_OHs - 1 downto 0);
    signal gt_trig0_rx_data    : t_gt_8b10b_rx_data_arr(CFG_NUM_OF_OHs - 1 downto 0);
    signal gt_trig1_rx_clk_arr : std_logic_vector(CFG_NUM_OF_OHs - 1 downto 0);
    signal gt_trig1_rx_data    : t_gt_8b10b_rx_data_arr(CFG_NUM_OF_OHs - 1 downto 0);

    -------------------------- DEBUG ----------------------------------
    signal debug_gth_rx_data : t_gt_8b10b_rx_data;
    signal debug_gth_tx_data : t_gt_8b10b_tx_data;

--    attribute mark_debug : string;
--    attribute mark_debug of debug_gth_tx_data : signal is "true";
--    attribute mark_debug of debug_gth_rx_data : signal is "true";

--  attribute mark_debug of gth_rx_data_arr: signal is "true";
--  attribute mark_debug of gth_tx_data_arr: signal is "true";

--============================================================================
--                                                          Architecture begin
--============================================================================

begin

    -------------------------- DEBUG ---------------------------------
    debug_gth_rx_data <= gth_rx_data_arr(6);
    debug_gth_tx_data <= gth_tx_data_arr(6);

    -------------------------- I/O ---------------------------------

    LEDs(1) <= '1';
    LEDs(0) <= '1';

    -------------------------- SYSTEM ---------------------------------

    i_system : component system
        --    generic map(
        --      C_DATE_CODE      => C_DATE_CODE,
        --      C_GITHASH_CODE   => C_GITHASH_CODE,
        --      C_GIT_REPO_DIRTY => C_GIT_REPO_DIRTY
        --    )
        port map(
            clk_200_diff_in_clk_p          => clk_200_diff_in_clk_p,
            clk_200_diff_in_clk_n          => clk_200_diff_in_clk_n,
            
            axi_c2c_v7_to_zynq_data        => axi_c2c_v7_to_zynq_data,
            axi_c2c_v7_to_zynq_clk         => axi_c2c_v7_to_zynq_clk,
            axi_c2c_zynq_to_v7_clk         => axi_c2c_zynq_to_v7_clk,
            axi_c2c_zynq_to_v7_data        => axi_c2c_zynq_to_v7_data,
            axi_c2c_v7_to_zynq_link_status => axi_c2c_v7_to_zynq_link_status,
            axi_c2c_zynq_to_v7_reset       => axi_c2c_zynq_to_v7_reset,
            
            refclk_F_0_p_i                 => refclk_F_0_p_i,
            refclk_F_0_n_i                 => refclk_F_0_n_i,
            refclk_F_1_p_i                 => refclk_F_1_p_i,
            refclk_F_1_n_i                 => refclk_F_1_n_i,
            refclk_B_0_p_i                 => refclk_B_0_p_i,
            refclk_B_0_n_i                 => refclk_B_0_n_i,
            refclk_B_1_p_i                 => refclk_B_1_p_i,
            refclk_B_1_n_i                 => refclk_B_1_n_i,
            
            axi_clk_o                      => axi_clk,
            axi_reset_o                    => axi_reset,
            ipb_axi_mosi_o                 => ipb_axi_mosi,
            ipb_axi_miso_i                 => ipb_axi_miso,
            
            ttc_clks_i                     => ttc_clocks,
            
            clk_gth_tx_arr_o               => clk_gth_tx_arr,
            clk_gth_rx_arr_o               => clk_gth_rx_arr,
            gth_tx_data_arr_i              => gth_tx_data_arr,
            gth_rx_data_arr_o              => gth_rx_data_arr,
            gth_rxreset_arr_o              => gth_rxreset_arr,
            gth_txreset_arr_o              => gth_txreset_arr
        );

    -------------------------- IPBus ---------------------------------

    i_axi_ipbus_bridge : entity work.axi_ipbus_bridge
        generic map(
            C_NUM_IPB_SLAVES   => C_NUM_IPB_SLAVES,
            C_S_AXI_DATA_WIDTH => 32,
            C_S_AXI_ADDR_WIDTH => C_IPB_AXI_ADDR_WIDTH
        )
        port map(
            ipb_reset_o   => ipb_reset,
            ipb_clk_o     => ipb_clk,
            ipb_miso_i    => ipb_miso_arr,
            ipb_mosi_o    => ipb_mosi_arr,
            S_AXI_ACLK    => axi_clk,
            S_AXI_ARESETN => axi_reset,
            S_AXI_AWADDR  => ipb_axi_mosi.awaddr(C_IPB_AXI_ADDR_WIDTH - 1 downto 0),
            S_AXI_AWPROT  => ipb_axi_mosi.awprot,
            S_AXI_AWVALID => ipb_axi_mosi.awvalid,
            S_AXI_AWREADY => ipb_axi_miso.awready,
            S_AXI_WDATA   => ipb_axi_mosi.wdata,
            S_AXI_WSTRB   => ipb_axi_mosi.wstrb,
            S_AXI_WVALID  => ipb_axi_mosi.wvalid,
            S_AXI_WREADY  => ipb_axi_miso.wready,
            S_AXI_BRESP   => ipb_axi_miso.bresp,
            S_AXI_BVALID  => ipb_axi_miso.bvalid,
            S_AXI_BREADY  => ipb_axi_mosi.bready,
            S_AXI_ARADDR  => ipb_axi_mosi.araddr(C_IPB_AXI_ADDR_WIDTH - 1 downto 0),
            S_AXI_ARPROT  => ipb_axi_mosi.arprot,
            S_AXI_ARVALID => ipb_axi_mosi.arvalid,
            S_AXI_ARREADY => ipb_axi_miso.arready,
            S_AXI_RDATA   => ipb_axi_miso.rdata,
            S_AXI_RRESP   => ipb_axi_miso.rresp,
            S_AXI_RVALID  => ipb_axi_miso.rvalid,
            S_AXI_RREADY  => ipb_axi_mosi.rready
        );

    -------------------------- GEM logic ---------------------------------
    
    i_gem : entity work.gem_amc
        generic map(
            g_NUM_OF_OHs         => CFG_NUM_OF_OHs,
            g_OH_LINK_CONFIG_ARR => CFG_OH_LINK_CONFIG_ARR,
            g_NUM_IPB_SLAVES     => C_NUM_IPB_SLAVES
        )
        port map(
            reset_i                 => '0',
            
            clk_40_ttc_p_i          => clk_40_ttc_p_i,
            clk_40_ttc_n_i          => clk_40_ttc_n_i,
            ttc_data_p_i            => ttc_data_p_i,
            ttc_data_n_i            => ttc_data_n_i,
            ttc_clocks_o            => ttc_clocks,
            
            gt_8b10b_rx_clk_arr_i   => gt_8b10b_rx_clk_arr,
            gt_8b10b_tx_clk_arr_i   => gt_8b10b_tx_clk_arr,
            gt_8b10b_rx_data_i      => gt_8b10b_rx_data,
            gt_8b10b_tx_data_o      => gt_8b10b_tx_data,
            gt_trig0_rx_clk_arr_i   => gt_trig0_rx_clk_arr,
            gt_trig0_rx_data_i      => gt_trig0_rx_data,
            gt_trig1_rx_clk_arr_i   => gt_trig1_rx_clk_arr,
            gt_trig1_rx_data_i      => gt_trig1_rx_data,
            
            ipb_reset_i             => ipb_reset,
            ipb_clk_i               => ipb_clk,
            ipb_miso_arr_o          => ipb_miso_arr,
            ipb_mosi_arr_i          => ipb_mosi_arr
        );

    -- GTH mapping to GEM links
    g_gem_links : for i in 0 to CFG_NUM_OF_OHs - 1 generate
        gt_8b10b_rx_clk_arr(i) <= clk_gth_rx_arr(CFG_OH_LINK_CONFIG_ARR(i).track_link);
        gt_8b10b_tx_clk_arr(i) <= clk_gth_tx_arr(CFG_OH_LINK_CONFIG_ARR(i).track_link);
        gt_8b10b_rx_data(i)    <= gth_rx_data_arr(CFG_OH_LINK_CONFIG_ARR(i).track_link);
        gt_8b10b_tx_data(i)    <= gth_tx_data_arr(CFG_OH_LINK_CONFIG_ARR(i).track_link);
        
        gt_trig0_rx_clk_arr(i) <= clk_gth_rx_arr(CFG_OH_LINK_CONFIG_ARR(i).trig0_rx_link);
        gt_trig0_rx_data(i)    <= gth_rx_data_arr(CFG_OH_LINK_CONFIG_ARR(i).trig0_rx_link);
        gt_trig1_rx_clk_arr(i) <= clk_gth_rx_arr(CFG_OH_LINK_CONFIG_ARR(i).trig1_rx_link);
        gt_trig1_rx_data(i)    <= gth_rx_data_arr(CFG_OH_LINK_CONFIG_ARR(i).trig1_rx_link);
    end generate; 

    -------------------------- OptoHybrids --------------------------------- TODO: *** remove ***

--  optohybrids : for i in 0 to 15 generate
--    
--    real_oh : if (i = 6) generate
--      optohybrid_single_inst : entity work.optohybrid_single
--        port map(
--          reset_i                 => gth_rxreset_arr(6),
--          ttc_clk_i               => ttc_clks,
--          ttc_cmds_i              => ttc_cmds,
--          gth_rx_usrclk_i         => clk_gth_rx_arr(6),
--          gth_tx_usrclk_i         => clk_gth_tx_arr(6),
--          gth_rx_data_i           => gth_rx_data_arr(6),
--          gth_tx_data_o           => gth_tx_data_arr(6),
--          ipb_clk_i               => ipb_clk,
--          ipb_reg_miso_o          => ipb_miso_arr(C_IPB_SLV.oh_reg(6)),
--          ipb_reg_mosi_i          => ipb_mosi_arr(C_IPB_SLV.oh_reg(6))
--        );
--    end generate;
--    
--    unconnected_ohs : if (i /= 6) generate
--      gth_tx_data_arr(i) <= (txdata => (others => '0'), txcharisk => (others => '0'), txchardispmode => (others => '0'), txchardispval => (others => '0')); 
--      ipb_miso_arr(C_IPB_SLV.oh_reg(i)) <= (ipb_rdata => (others => '0'), ipb_ack => '0', ipb_err => '0');
--      ipb_miso_arr(C_IPB_SLV.oh_evt(i)) <= (ipb_rdata => (others => '0'), ipb_ack => '0', ipb_err => '0');
--    end generate;
--    
--  end generate;
--
--  -- pull down the unconnected IPBs
--  ipb_miso_arr(C_IPB_SLV.ttc) <= (ipb_rdata => (others => '0'), ipb_ack => '0', ipb_err => '0');
--  ipb_miso_arr(C_IPB_SLV.counters) <= (ipb_rdata => (others => '0'), ipb_ack => '0', ipb_err => '0');
--  ipb_miso_arr(C_IPB_SLV.daq) <= (ipb_rdata => (others => '0'), ipb_ack => '0', ipb_err => '0');
--  ipb_miso_arr(C_IPB_SLV.trigger) <= (ipb_rdata => (others => '0'), ipb_ack => '0', ipb_err => '0');
--
--  -- pull down unconnected TXs
--  unconnected_txs : for i in 16 to g_NUM_OF_GTH_GTs-1 generate
--    gth_tx_data_arr(i) <= (txdata => (others => '0'), txcharisk => (others => '0'), txchardispmode => (others => '0'), txchardispval => (others => '0')); 
--  end generate;

end gem_ctp7_arch;

--============================================================================
--                                                            Architecture end
--============================================================================

