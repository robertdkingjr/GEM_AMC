-------------------------------------------------------------------------------
--                                                                            
--       Unit Name: System
--                                                                            
--     Description: Responsible for many system services like clocks, GTH, some system registers, TTC
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
use work.capture_playback_pkg.all;
use work.system_package.all;
use work.axi_pkg.all;
use work.gem_pkg.all;

--============================================================================
--                                                          Entity declaration
--============================================================================
entity system is
  generic (
    C_DATE_CODE      : std_logic_vector (31 downto 0) := x"00000000";
    C_GITHASH_CODE   : std_logic_vector (31 downto 0) := x"00000000";
    C_GIT_REPO_DIRTY : std_logic                      := '0'
    );
  port (
    clk_200_diff_in_clk_p : in std_logic;
    clk_200_diff_in_clk_n : in std_logic;

    axi_c2c_v7_to_zynq_data        : out std_logic_vector (14 downto 0);
    axi_c2c_v7_to_zynq_clk         : out std_logic;
    axi_c2c_zynq_to_v7_clk         : in  std_logic;
    axi_c2c_zynq_to_v7_data        : in  std_logic_vector (14 downto 0);
    axi_c2c_v7_to_zynq_link_status : out std_logic;
    axi_c2c_zynq_to_v7_reset       : in  std_logic;

    refclk_F_0_p_i : in std_logic_vector (3 downto 0);
    refclk_F_0_n_i : in std_logic_vector (3 downto 0);
    refclk_F_1_p_i : in std_logic_vector (3 downto 0);
    refclk_F_1_n_i : in std_logic_vector (3 downto 0);

    refclk_B_0_p_i : in std_logic_vector (3 downto 1);
    refclk_B_0_n_i : in std_logic_vector (3 downto 1);
    refclk_B_1_p_i : in std_logic_vector (3 downto 1);
    refclk_B_1_n_i : in std_logic_vector (3 downto 1);

    clk_50_o       : out std_logic;
    clk_200_o      : out std_logic;
    
    ----------------- for GEM ------------------------
    axi_clk_o         : out std_logic;
    axi_reset_o       : out std_logic;
    ipb_axi_mosi_o    : out t_axi_lite_mosi;
    ipb_axi_miso_i    : in t_axi_lite_miso;

    ----------------- TTC ------------------------
    ttc_clks_i        : in t_ttc_clks;
    
    ----------------- GTH ------------------------
    clk_gth_tx_arr_o  : out std_logic_vector(g_NUM_OF_GTH_GTs-1 downto 0);
    clk_gth_rx_arr_o  : out std_logic_vector(g_NUM_OF_GTH_GTs-1 downto 0);
    gth_tx_data_arr_i : in  t_gt_8b10b_tx_data_arr(g_NUM_OF_GTH_GTs-1 downto 0);  
    gth_rx_data_arr_o : out t_gt_8b10b_rx_data_arr(g_NUM_OF_GTH_GTs-1 downto 0);
    gth_rxreset_arr_o : out std_logic_vector(g_NUM_OF_GTH_GTs-1 downto 0); 
    gth_txreset_arr_o : out std_logic_vector(g_NUM_OF_GTH_GTs-1 downto 0);
    
    ----------------- AMC13 DAQLink ------------------------
    amc13_gth_refclk_p             : in  std_logic;
    amc13_gth_refclk_n             : in  std_logic;
    amc_13_gth_rx_n                : in  std_logic;
    amc_13_gth_rx_p                : in  std_logic;
    amc13_gth_tx_n                 : out std_logic;
    amc13_gth_tx_p                 : out std_logic;
    
    daq_to_daqlink_i               : in t_daq_to_daqlink;
    daqlink_to_daq_o               : out t_daqlink_to_daq
        
    );
end system;

--============================================================================
--                                                        Architecture section
--============================================================================
architecture system_arch of system is

--============================================================================
--                                                      Component declarations
--===========================================================================

  component v7_bd is
    port (
      BRAM_CTRL_DRP_addr : out std_logic_vector (15 downto 0);
      BRAM_CTRL_DRP_clk  : out std_logic;
      BRAM_CTRL_DRP_din  : out std_logic_vector (31 downto 0);
      BRAM_CTRL_DRP_dout : in  std_logic_vector (31 downto 0);
      BRAM_CTRL_DRP_en   : out std_logic;
      BRAM_CTRL_DRP_rst  : out std_logic;
      BRAM_CTRL_DRP_we   : out std_logic_vector (3 downto 0);

      BRAM_CTRL_GTH_REG_FILE_addr : out std_logic_vector (16 downto 0);
      BRAM_CTRL_GTH_REG_FILE_clk  : out std_logic;
      BRAM_CTRL_GTH_REG_FILE_din  : out std_logic_vector (31 downto 0);
      BRAM_CTRL_GTH_REG_FILE_dout : in  std_logic_vector (31 downto 0);
      BRAM_CTRL_GTH_REG_FILE_en   : out std_logic;
      BRAM_CTRL_GTH_REG_FILE_rst  : out std_logic;
      BRAM_CTRL_GTH_REG_FILE_we   : out std_logic_vector (3 downto 0);

      axi_c2c_zynq_to_v7_clk         : in  std_logic;
      axi_c2c_zynq_to_v7_data        : in  std_logic_vector (14 downto 0);
      axi_c2c_v7_to_zynq_link_status : out std_logic;
      axi_c2c_v7_to_zynq_clk         : out std_logic;
      axi_c2c_v7_to_zynq_data        : out std_logic_vector (14 downto 0);
      axi_c2c_zynq_to_v7_reset       : in  std_logic;

      clk_200_diff_in_clk_n : in std_logic;
      clk_200_diff_in_clk_p : in std_logic;

      clk_out1_200mhz : out std_logic;
      clk_out2_50mhz  : out std_logic;
      
      axi_clk_o         : out STD_LOGIC;
      axi_reset_o       : out STD_LOGIC_VECTOR ( 0 to 0 );
      
      ipb_axi_araddr    : out STD_LOGIC_VECTOR ( 27 downto 0 );
      ipb_axi_arprot    : out STD_LOGIC_VECTOR ( 2 downto 0 );
      ipb_axi_arready   : in STD_LOGIC_VECTOR ( 0 to 0 );
      ipb_axi_arvalid   : out STD_LOGIC_VECTOR ( 0 to 0 );
      ipb_axi_awaddr    : out STD_LOGIC_VECTOR ( 27 downto 0 );
      ipb_axi_awprot    : out STD_LOGIC_VECTOR ( 2 downto 0 );
      ipb_axi_awready   : in STD_LOGIC_VECTOR ( 0 to 0 );
      ipb_axi_awvalid   : out STD_LOGIC_VECTOR ( 0 to 0 );
      ipb_axi_bready    : out STD_LOGIC_VECTOR ( 0 to 0 );
      ipb_axi_bresp     : in STD_LOGIC_VECTOR ( 1 downto 0 );
      ipb_axi_bvalid    : in STD_LOGIC_VECTOR ( 0 to 0 );
      ipb_axi_rdata     : in STD_LOGIC_VECTOR ( 31 downto 0 );
      ipb_axi_rready    : out STD_LOGIC_VECTOR ( 0 to 0 );
      ipb_axi_rresp     : in STD_LOGIC_VECTOR ( 1 downto 0 );
      ipb_axi_rvalid    : in STD_LOGIC_VECTOR ( 0 to 0 );
      ipb_axi_wdata     : out STD_LOGIC_VECTOR ( 31 downto 0 );
      ipb_axi_wready    : in STD_LOGIC_VECTOR ( 0 to 0 );
      ipb_axi_wstrb     : out STD_LOGIC_VECTOR ( 3 downto 0 );
      ipb_axi_wvalid    : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component v7_bd;

--============================================================================
--                                                         Signal declarations
--============================================================================
  signal s_pg_bx0_ext_en : std_logic;

  signal s_clk_200 : std_logic;
  signal s_clk_50  : std_logic;

  signal BRAM_CTRL_REG_FILE_en   : std_logic;
  signal BRAM_CTRL_REG_FILE_dout : std_logic_vector (31 downto 0) := x"00000000";
  signal BRAM_CTRL_REG_FILE_din  : std_logic_vector (31 downto 0);
  signal BRAM_CTRL_REG_FILE_we   : std_logic_vector (3 downto 0);
  signal BRAM_CTRL_REG_FILE_addr : std_logic_vector (16 downto 0);
  signal BRAM_CTRL_REG_FILE_clk  : std_logic;
  signal BRAM_CTRL_REG_FILE_rst  : std_logic;

  signal BRAM_CTRL_GTH_REG_FILE_en   : std_logic;
  signal BRAM_CTRL_GTH_REG_FILE_dout : std_logic_vector (31 downto 0) := x"00000000";
  signal BRAM_CTRL_GTH_REG_FILE_din  : std_logic_vector (31 downto 0);
  signal BRAM_CTRL_GTH_REG_FILE_we   : std_logic_vector (3 downto 0);
  signal BRAM_CTRL_GTH_REG_FILE_addr : std_logic_vector (16 downto 0);
  signal BRAM_CTRL_GTH_REG_FILE_clk  : std_logic;
  signal BRAM_CTRL_GTH_REG_FILE_rst  : std_logic;

  signal BRAM_CTRL_DRP_addr : std_logic_vector (15 downto 0);
  signal BRAM_CTRL_DRP_clk  : std_logic;
  signal BRAM_CTRL_DRP_din  : std_logic_vector (31 downto 0);
  signal BRAM_CTRL_DRP_dout : std_logic_vector (31 downto 0);
  signal BRAM_CTRL_DRP_en   : std_logic;
  signal BRAM_CTRL_DRP_rst  : std_logic;
  signal BRAM_CTRL_DRP_we   : std_logic_vector (3 downto 0);

------

  signal s_BD_GPIO_float : std_logic_vector (15 downto 0);

  signal clk_stable_i : std_logic := '0';

  signal s_gth_common_reset : std_logic_vector(g_NUM_OF_GTH_COMMONs-1 downto 0);
  signal s_gth_gt_txreset   : std_logic_vector(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_gth_gt_rxreset   : std_logic_vector(g_NUM_OF_GTH_GTs-1 downto 0);

  signal s_gth_common_status_arr  : t_gth_common_status_arr(g_NUM_OF_GTH_COMMONs-1 downto 0);
  signal s_gth_common_drp_in_arr  : t_gth_common_drp_in_arr(g_NUM_OF_GTH_COMMONs-1 downto 0);
  signal s_gth_common_drp_out_arr : t_gth_common_drp_out_arr(g_NUM_OF_GTH_COMMONs-1 downto 0);

  signal s_gth_gt_txreset_done : std_logic_vector(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_gth_gt_rxreset_done : std_logic_vector(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_gth_rx_serial_arr   : t_gth_rx_serial_arr(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_gth_tx_serial_arr   : t_gth_tx_serial_arr(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_gth_gt_drp_in_arr   : t_gth_gt_drp_in_arr(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_gth_gt_drp_out_arr  : t_gth_gt_drp_out_arr(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_gth_tx_ctrl_arr     : t_gth_tx_ctrl_arr(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_gth_tx_status_arr   : t_gth_tx_status_arr(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_gth_rx_ctrl_arr     : t_gth_rx_ctrl_arr(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_gth_rx_ctrl_2_arr   : t_gth_rx_ctrl_2_arr(g_NUM_OF_GTH_GTs-1 downto 0);

  signal s_gth_rx_status_arr   : t_gth_rx_status_arr(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_gth_misc_ctrl_arr   : t_gth_misc_ctrl_arr(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_gth_misc_status_arr : t_gth_misc_status_arr(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_gth_tx_data_arr     : t_gt_8b10b_tx_data_arr(g_NUM_OF_GTH_GTs-1 downto 0);

  signal s_gth_rx_data_arr     : t_gt_8b10b_rx_data_arr(g_NUM_OF_GTH_GTs-1 downto 0);


  signal s_clk_gth_tx_usrclk_arr : std_logic_vector(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_clk_gth_rx_usrclk_arr : std_logic_vector(g_NUM_OF_GTH_GTs-1 downto 0);
  signal s_gth_cpll_status_arr   : t_gth_cpll_status_arr(g_NUM_OF_GTH_GTs-1 downto 0);

----
  signal s_DRP_MMCM_clk   : std_logic;
  signal s_DRP_MMCM_daddr : std_logic_vector (6 downto 0);
  signal s_DRP_MMCM_den   : std_logic;
  signal s_DRP_MMCM_di    : std_logic_vector (15 downto 0);
  signal s_DRP_MMCM_do    : std_logic_vector (15 downto 0);
  signal s_DRP_MMCM_drdy  : std_logic;
  signal s_DRP_MMCM_dwe   : std_logic;

  -------------------------- IPbus AXI ------------------------------
  signal axi_clk           : std_logic;
  signal axi_reset         : std_logic_vector(0 downto 0);
  signal ipb_axi_araddr    : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ipb_axi_arprot    : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ipb_axi_arvalid   : STD_LOGIC_VECTOR ( 0 downto 0 );
  signal ipb_axi_rready    : STD_LOGIC_VECTOR ( 0 downto 0 );
  signal ipb_axi_awaddr    : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ipb_axi_awprot    : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ipb_axi_awvalid   : STD_LOGIC_VECTOR ( 0 downto 0 );
  signal ipb_axi_wdata     : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ipb_axi_wstrb     : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ipb_axi_wvalid    : STD_LOGIC_VECTOR ( 0 downto 0 );      
  signal ipb_axi_bready    : STD_LOGIC_VECTOR ( 0 downto 0 );
  signal ipb_axi_arready   : STD_LOGIC_VECTOR ( 0 downto 0 );
  signal ipb_axi_rdata     : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ipb_axi_rresp     : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ipb_axi_rvalid    : STD_LOGIC_VECTOR ( 0 downto 0 );
  signal ipb_axi_awready   : STD_LOGIC_VECTOR ( 0 downto 0 );
  signal ipb_axi_wready    : STD_LOGIC_VECTOR ( 0 downto 0 );
  signal ipb_axi_bresp     : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ipb_axi_bvalid    : STD_LOGIC_VECTOR ( 0 downto 0 );  
  
  -------------------------- DEBUG ----------------------------------
--  attribute mark_debug : string;
--  attribute mark_debug of s_gth_rx_data_arr: signal is "true";
--  attribute mark_debug of s_gth_tx_data_arr: signal is "true";

--============================================================================
--                                                          Architecture begin
--============================================================================

begin

  -- I/O
  clk_gth_tx_arr_o  <= s_clk_gth_tx_usrclk_arr;
  clk_gth_rx_arr_o  <= s_clk_gth_rx_usrclk_arr;
  gth_rxreset_arr_o <= s_gth_gt_rxreset;
  gth_txreset_arr_o <= s_gth_gt_txreset;
  gth_rx_data_arr_o <= s_gth_rx_data_arr;
  s_gth_tx_data_arr <= gth_tx_data_arr_i;
  
  axi_clk_o                <= axi_clk;
  axi_reset_o              <= axi_reset(0);
  ipb_axi_mosi_o.araddr    <= ipb_axi_araddr;
  ipb_axi_mosi_o.arprot    <= ipb_axi_arprot;
  ipb_axi_mosi_o.arvalid   <= ipb_axi_arvalid(0);
  ipb_axi_mosi_o.rready    <= ipb_axi_rready(0);
  ipb_axi_mosi_o.awaddr    <= ipb_axi_awaddr;
  ipb_axi_mosi_o.awprot    <= ipb_axi_awprot;
  ipb_axi_mosi_o.awvalid   <= ipb_axi_awvalid(0);
  ipb_axi_mosi_o.wdata     <= ipb_axi_wdata;
  ipb_axi_mosi_o.wstrb     <= ipb_axi_wstrb;
  ipb_axi_mosi_o.wvalid    <= ipb_axi_wvalid(0);
  ipb_axi_mosi_o.bready    <= ipb_axi_bready(0);
  ipb_axi_arready(0)       <= ipb_axi_miso_i.arready;
  ipb_axi_rdata            <= ipb_axi_miso_i.rdata;
  ipb_axi_rresp            <= ipb_axi_miso_i.rresp;
  ipb_axi_rvalid(0)        <= ipb_axi_miso_i.rvalid;
  ipb_axi_awready(0)       <= ipb_axi_miso_i.awready;
  ipb_axi_wready(0)        <= ipb_axi_miso_i.wready;
  ipb_axi_bresp            <= ipb_axi_miso_i.bresp;
  ipb_axi_bvalid(0)        <= ipb_axi_miso_i.bvalid;
  
  clk_50_o  <= s_clk_50;
  clk_200_o <= s_clk_200;
  
  i_v7_bd : v7_bd
    port map (

      BRAM_CTRL_DRP_addr(15 downto 0) => BRAM_CTRL_DRP_addr(15 downto 0),
      BRAM_CTRL_DRP_clk               => BRAM_CTRL_DRP_clk,
      BRAM_CTRL_DRP_din(31 downto 0)  => BRAM_CTRL_DRP_din(31 downto 0),
      BRAM_CTRL_DRP_dout(31 downto 0) => BRAM_CTRL_DRP_dout(31 downto 0),
      BRAM_CTRL_DRP_en                => BRAM_CTRL_DRP_en,
      BRAM_CTRL_DRP_rst               => BRAM_CTRL_DRP_rst,
      BRAM_CTRL_DRP_we(3 downto 0)    => BRAM_CTRL_DRP_we(3 downto 0),

      BRAM_CTRL_GTH_REG_FILE_addr(16 downto 0) => BRAM_CTRL_GTH_REG_FILE_addr(16 downto 0),
      BRAM_CTRL_GTH_REG_FILE_clk               => BRAM_CTRL_GTH_REG_FILE_clk,
      BRAM_CTRL_GTH_REG_FILE_din(31 downto 0)  => BRAM_CTRL_GTH_REG_FILE_din(31 downto 0),
      BRAM_CTRL_GTH_REG_FILE_dout(31 downto 0) => BRAM_CTRL_GTH_REG_FILE_dout(31 downto 0),
      BRAM_CTRL_GTH_REG_FILE_en                => BRAM_CTRL_GTH_REG_FILE_en,
      BRAM_CTRL_GTH_REG_FILE_rst               => BRAM_CTRL_GTH_REG_FILE_rst,
      BRAM_CTRL_GTH_REG_FILE_we(3 downto 0)    => BRAM_CTRL_GTH_REG_FILE_we(3 downto 0),

      axi_c2c_v7_to_zynq_clk               => axi_c2c_v7_to_zynq_clk,
      axi_c2c_v7_to_zynq_data(14 downto 0) => axi_c2c_v7_to_zynq_data(14 downto 0),
      axi_c2c_v7_to_zynq_link_status       => axi_c2c_v7_to_zynq_link_status,
      axi_c2c_zynq_to_v7_clk               => axi_c2c_zynq_to_v7_clk,
      axi_c2c_zynq_to_v7_data(14 downto 0) => axi_c2c_zynq_to_v7_data(14 downto 0),
      axi_c2c_zynq_to_v7_reset             => axi_c2c_zynq_to_v7_reset,

      clk_200_diff_in_clk_n => clk_200_diff_in_clk_n,
      clk_200_diff_in_clk_p => clk_200_diff_in_clk_p,

      clk_out1_200mhz => s_clk_200,
      clk_out2_50mhz  => s_clk_50,

      axi_clk_o         => axi_clk,
      axi_reset_o       => axi_reset,
      
      ipb_axi_araddr    => ipb_axi_araddr(27 downto 0),
      ipb_axi_arprot    => ipb_axi_arprot,
      ipb_axi_arready   => ipb_axi_arready,
      ipb_axi_arvalid   => ipb_axi_arvalid,
      ipb_axi_awaddr    => ipb_axi_awaddr(27 downto 0),
      ipb_axi_awprot    => ipb_axi_awprot,
      ipb_axi_awready   => ipb_axi_awready,
      ipb_axi_awvalid   => ipb_axi_awvalid,
      ipb_axi_bready    => ipb_axi_bready,
      ipb_axi_bresp     => ipb_axi_bresp,
      ipb_axi_bvalid    => ipb_axi_bvalid,
      ipb_axi_rdata     => ipb_axi_rdata,
      ipb_axi_rready    => ipb_axi_rready,
      ipb_axi_rresp     => ipb_axi_rresp,
      ipb_axi_rvalid    => ipb_axi_rvalid,
      ipb_axi_wdata     => ipb_axi_wdata,
      ipb_axi_wready    => ipb_axi_wready,
      ipb_axi_wstrb     => ipb_axi_wstrb,
      ipb_axi_wvalid    => ipb_axi_wvalid
    );

  i_gth_register_file : entity work.gth_register_file
    generic map
    (
      g_NUM_OF_GTH_GTs     => g_NUM_OF_GTH_GTs,
      g_NUM_OF_GTH_COMMONs => g_NUM_OF_GTH_COMMONs
      )
    port map (
      BRAM_CTRL_GTH_REG_FILE_addr(16 downto 0) => BRAM_CTRL_GTH_REG_FILE_addr(16 downto 0),
      BRAM_CTRL_GTH_REG_FILE_clk               => BRAM_CTRL_GTH_REG_FILE_clk,
      BRAM_CTRL_GTH_REG_FILE_din(31 downto 0)  => BRAM_CTRL_GTH_REG_FILE_din(31 downto 0),
      BRAM_CTRL_GTH_REG_FILE_dout(31 downto 0) => BRAM_CTRL_GTH_REG_FILE_dout(31 downto 0),
      BRAM_CTRL_GTH_REG_FILE_en                => BRAM_CTRL_GTH_REG_FILE_en,
      BRAM_CTRL_GTH_REG_FILE_rst               => BRAM_CTRL_GTH_REG_FILE_rst,
      BRAM_CTRL_GTH_REG_FILE_we(3 downto 0)    => BRAM_CTRL_GTH_REG_FILE_we(3 downto 0),

      gth_common_reset_o      => s_gth_common_reset,
      gth_common_status_arr_i => s_gth_common_status_arr,
      gth_cpll_status_arr_i   => s_gth_cpll_status_arr,
      gth_gt_txreset_o        => s_gth_gt_txreset,
      gth_gt_rxreset_o        => s_gth_gt_rxreset,
      gth_gt_txreset_done_i   => s_gth_gt_txreset_done,
      gth_gt_rxreset_done_i   => s_gth_gt_rxreset_done,
      gth_tx_ctrl_arr_o       => s_gth_tx_ctrl_arr,
      gth_tx_status_arr_i     => s_gth_tx_status_arr,
      gth_rx_ctrl_arr_o       => s_gth_rx_ctrl_arr,
      gth_rx_status_arr_i     => s_gth_rx_status_arr,
      gth_misc_ctrl_arr_o     => s_gth_misc_ctrl_arr,
      gth_misc_status_arr_i   => s_gth_misc_status_arr,

      clk_gth_tx_usrclk_arr_i => s_clk_gth_tx_usrclk_arr,
      clk_gth_rx_usrclk_arr_i => s_clk_gth_rx_usrclk_arr
      );

  i_drp_controller : entity work.drp_controller

    generic map
    (
      g_NUM_OF_GTH_GTs     => g_NUM_OF_GTH_GTs,
      g_NUM_OF_GTH_COMMONs => g_NUM_OF_GTH_COMMONs
      )
    port map (
      BRAM_CTRL_DRP_en     => BRAM_CTRL_DRP_en,
      BRAM_CTRL_DRP_dout   => BRAM_CTRL_DRP_dout,
      BRAM_CTRL_DRP_din    => BRAM_CTRL_DRP_din,
      BRAM_CTRL_DRP_we     => BRAM_CTRL_DRP_we,
      BRAM_CTRL_DRP_addr   => BRAM_CTRL_DRP_addr,
      BRAM_CTRL_DRP_clk    => BRAM_CTRL_DRP_clk,
      BRAM_CTRL_DRP_rst    => BRAM_CTRL_DRP_rst,
      gth_common_drp_arr_o => s_gth_common_drp_in_arr,
      gth_common_drp_arr_i => s_gth_common_drp_out_arr,
      gth_gt_drp_arr_o     => s_gth_gt_drp_in_arr,
      gth_gt_drp_arr_i     => s_gth_gt_drp_out_arr
      );

--  i_io_link_4p8g_demo_ctrl : io_link_4p8g_demo_ctrl
--    port map(

--      clk_gth_tx_usrclk_i => s_clk_gth_tx_usrclk_arr(35 downto 12),
--      clk_gth_rx_usrclk_i => s_clk_gth_rx_usrclk_arr(35 downto 12),

--      gth_tx_data_o       => s_gth_tx_data_arr(35 downto 12),
--      gth_rx_data_i       => s_gth_rx_data_arr(35 downto 12),
--      gth_rx_ctrl_2_arr_i => s_gth_rx_ctrl_2_arr(35 downto 12)

--      );

  i_gth_wrapper : entity work.gth_wrapper
    generic map
    (
      g_EXAMPLE_SIMULATION     => 0,
      g_STABLE_CLOCK_PERIOD    => 20,
      g_NUM_OF_GTH_GTs         => g_NUM_OF_GTH_GTs,
      g_NUM_OF_GTH_COMMONs     => g_NUM_OF_GTH_COMMONs,
      g_GT_SIM_GTRESET_SPEEDUP => "FALSE"

      )
    port map (
      clk_stable_i => s_clk_50,

      clk_gth_tx_usrclk_arr_o => s_clk_gth_tx_usrclk_arr,
      clk_gth_rx_usrclk_arr_o => s_clk_gth_rx_usrclk_arr,
      gth_cpll_status_arr_o   => s_gth_cpll_status_arr,

      refclk_F_0_p_i          => refclk_F_0_p_i,
      refclk_F_0_n_i          => refclk_F_0_n_i,
      refclk_F_1_p_i          => refclk_F_1_p_i,
      refclk_F_1_n_i          => refclk_F_1_n_i,
      refclk_B_0_p_i          => refclk_B_0_p_i,
      refclk_B_0_n_i          => refclk_B_0_n_i,
      refclk_B_1_p_i          => refclk_B_1_p_i,
      refclk_B_1_n_i          => refclk_B_1_n_i,
      gth_common_reset_i      => s_gth_common_reset,
      gth_common_status_arr_o => s_gth_common_status_arr,
      gth_common_drp_arr_i    => s_gth_common_drp_in_arr,
      gth_common_drp_arr_o    => s_gth_common_drp_out_arr,
      gth_gt_txreset_i        => s_gth_gt_txreset,
      gth_gt_rxreset_i        => s_gth_gt_rxreset,
      gth_gt_txreset_done_o   => s_gth_gt_txreset_done,
      gth_gt_rxreset_done_o   => s_gth_gt_rxreset_done,
      gth_gt_drp_arr_i        => s_gth_gt_drp_in_arr,
      gth_gt_drp_arr_o        => s_gth_gt_drp_out_arr,
      gth_tx_ctrl_arr_i       => s_gth_tx_ctrl_arr,
      gth_tx_status_arr_o     => s_gth_tx_status_arr,
      gth_rx_ctrl_arr_i       => s_gth_rx_ctrl_arr,
      gth_rx_ctrl_2_arr_i     => s_gth_rx_ctrl_2_arr,

      gth_rx_status_arr_o   => s_gth_rx_status_arr,
      gth_misc_ctrl_arr_i   => s_gth_misc_ctrl_arr,
      gth_misc_status_arr_o => s_gth_misc_status_arr,
      gth_tx_data_arr_i     => s_gth_tx_data_arr,
      gth_rx_data_arr_o     => s_gth_rx_data_arr,
      gth_tx_serial_arr_o   => s_gth_tx_serial_arr,
      gth_rx_serial_arr_i   => s_gth_rx_serial_arr
      );

  gen_gth_serial : for i in 0 to g_NUM_OF_GTH_GTs-1 generate
    s_gth_rx_serial_arr(i).gthrxn <= '0';
    s_gth_rx_serial_arr(i).gthrxp <= '1';
  end generate;

  i_daqlink : entity work.daqlink_wrapper
      port map(
          daq_to_daqlink => daq_to_daqlink_i,
          daqlink_to_daq => daqlink_to_daq_o,
          clk_50_i       => s_clk_50,
          GTX_REFCLK_p   => amc13_gth_refclk_p,
          GTX_REFCLK_n   => amc13_gth_refclk_n,
          GTX_RXN        => amc_13_gth_rx_n,
          GTX_RXP        => amc_13_gth_rx_p,
          GTX_TXN        => amc13_gth_tx_n,
          GTX_TXP        => amc13_gth_tx_p
      );

end system_arch;

--============================================================================
--                                                            Architecture end
--============================================================================
