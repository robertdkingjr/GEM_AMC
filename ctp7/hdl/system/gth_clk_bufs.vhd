-------------------------------------------------------------------------------
--                                                                            
--       Unit Name: gth_clk_bufs                                           
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
use UNISIM.VCOMPONENTS.all;

library work;
use work.gth_pkg.all;
use work.system_package.all;

--============================================================================
--                                                          Entity declaration
--============================================================================
entity gth_clk_bufs is
  generic
    (
      g_NUM_OF_GTH_GTs : integer := 36
      );
  port (

    GTH_4p8g_TX_MMCM_reset_i  : in  std_logic;
    GTH_4p8g_TX_MMCM_locked_o : out std_logic;

    refclk_F_0_p_i : in std_logic_vector (3 downto 0);
    refclk_F_0_n_i : in std_logic_vector (3 downto 0);
    refclk_F_1_p_i : in std_logic_vector (3 downto 0);
    refclk_F_1_n_i : in std_logic_vector (3 downto 0);
    refclk_B_0_p_i : in std_logic_vector (3 downto 1);
    refclk_B_0_n_i : in std_logic_vector (3 downto 1);
    refclk_B_1_p_i : in std_logic_vector (3 downto 1);
    refclk_B_1_n_i : in std_logic_vector (3 downto 1);

    refclk_F_0_o : out std_logic_vector (3 downto 0);
    refclk_F_1_o : out std_logic_vector (3 downto 0);
    refclk_B_0_o : out std_logic_vector (3 downto 1);
    refclk_B_1_o : out std_logic_vector (3 downto 1);

    gth_gt_clk_out_arr_i : in t_gth_gt_clk_out_arr(g_NUM_OF_GTH_GTs-1 downto 0);

    clk_gth_tx_usrclk_arr_o : out std_logic_vector(g_NUM_OF_GTH_GTs-1 downto 0);
    clk_gth_rx_usrclk_arr_o : out std_logic_vector(g_NUM_OF_GTH_GTs-1 downto 0);

    clk_gth_4p8g_common_rxusrclk_o : out std_logic

    );
end gth_clk_bufs;

--============================================================================
architecture gth_clk_bufs_arch of gth_clk_bufs is

  component GTH_4P8_RAW_CLOCK_MODULE is
    generic
      (
        MULT        : real    := 2.0;
        DIVIDE      : integer := 2;
        CLK_PERIOD  : real    := 6.4;
        OUT0_DIVIDE : real    := 2.0;
        OUT1_DIVIDE : integer := 2;
        OUT2_DIVIDE : integer := 2;
        OUT3_DIVIDE : integer := 2
        );
    port
      (                                 -- Clock in ports
        CLK_IN          : in  std_logic;
        -- Clock out ports
        CLK0_OUT        : out std_logic;
        CLK1_OUT        : out std_logic;
        CLK2_OUT        : out std_logic;
        CLK3_OUT        : out std_logic;
        -- Status and control signals
        MMCM_RESET_IN   : in  std_logic;
        MMCM_LOCKED_OUT : out std_logic
        );
  end component;

--============================================================================
--                                                         Signal declarations
--============================================================================

  signal s_gth_4p8g_txusrclk        : std_logic;
  signal s_gth_4p8g_txoutclk        : std_logic;

  signal s_gth_3p2g_txusrclk        : std_logic;
  signal s_gth_3p2g_txoutclk        : std_logic;

--============================================================================
--                                                          Architecture begin
--============================================================================

begin

--============================================================================

  gen_ibufds_F_clk_gte2 : for i in 0 to 3 generate

    i_ibufds_F_0 : IBUFDS_GTE2
      port map
      (
        O     => refclk_F_0_o(i),
        ODIV2 => open,
        CEB   => '0',
        I     => refclk_F_0_p_i(i),
        IB    => refclk_F_0_n_i(i)
        );

    i_ibufds_F_1 : IBUFDS_GTE2
      port map
      (
        O     => refclk_F_1_o(i),
        ODIV2 => open,
        CEB   => '0',
        I     => refclk_F_1_p_i(i),
        IB    => refclk_F_1_n_i(i)
        );
  end generate;

  gen_ibufds_B_clk_gte2 : for i in 1 to 3 generate

    i_ibufds_B_0 : IBUFDS_GTE2
      port map
      (
        O     => refclk_B_0_o(i),
        ODIV2 => open,
        CEB   => '0',
        I     => refclk_B_0_p_i(i),
        IB    => refclk_B_0_n_i(i)
        );

    i_ibufds_B_1 : IBUFDS_GTE2
      port map
      (
        O     => refclk_B_1_o(i),
        ODIV2 => open,
        CEB   => '0',
        I     => refclk_B_1_p_i(i),
        IB    => refclk_B_1_n_i(i)
        );

  end generate;

--============================================================================

  gen_bufh_outclks : for n in 0 to g_NUM_OF_GTH_GTs-1 generate
    gen_gth_4p8g_txuserclk : if c_gth_config_arr(n).gth_link_type = gth_4p8g generate
      gen_gth_4p8g_txuserclk_master : if c_gth_config_arr(n).gth_txclk_out_master = true generate

        s_gth_4p8g_txoutclk <= gth_gt_clk_out_arr_i(n).txoutclk;

        -- Instantiate a MMCM module to divide the reference clock. Uses internal feedback
        -- for improved jitter performance, and to avoid consuming an additional BUFG
        txoutclk_mmcm0_i : gth_4p8_raw_CLOCK_MODULE
          generic map
          (
            MULT        => 9.0,
            DIVIDE      => 2,
            CLK_PERIOD  => 6.25,
            OUT0_DIVIDE => 6.0,
            OUT1_DIVIDE => 1,
            OUT2_DIVIDE => 1,
            OUT3_DIVIDE => 1
            )
          port map
          (
            CLK0_OUT        => s_gth_4p8g_txusrclk,
            CLK1_OUT        => open,
            CLK2_OUT        => open,
            CLK3_OUT        => open,
            CLK_IN          => s_gth_4p8g_txoutclk,
            MMCM_LOCKED_OUT => GTH_4p8g_TX_MMCM_locked_o,
            MMCM_RESET_IN   => GTH_4p8g_TX_MMCM_reset_i
            );

        i_bufg_4p8g_rx_common_usrclk : BUFG
            port map(
                I => gth_gt_clk_out_arr_i(n).rxoutclk,
                O => clk_gth_4p8g_common_rxusrclk_o
            );

      end generate;

      clk_gth_tx_usrclk_arr_o(n) <= s_gth_4p8g_txusrclk;

    end generate;

    gen_gth_3p2g_txuserclk : if c_gth_config_arr(n).gth_link_type = gth_3p2g generate

      gen_gth_3p2g_txuserclk_master : if c_gth_config_arr(n).gth_txclk_out_master = true generate

        s_gth_3p2g_txoutclk <= gth_gt_clk_out_arr_i(n).txoutclk;

        i_bufg_3p2g_tx_outclk : BUFG
          port map
          (
            I => s_gth_3p2g_txoutclk,
            O => s_gth_3p2g_txusrclk
            );

      end generate;

      clk_gth_tx_usrclk_arr_o(n) <= s_gth_3p2g_txusrclk;

    end generate;


    i_bufh_rx_outclk : BUFH
      port map
      (
        I => gth_gt_clk_out_arr_i(n).rxoutclk,
        O => clk_gth_rx_usrclk_arr_o(n)
        );

  end generate;

end gth_clk_bufs_arch;
--============================================================================
--                                                            Architecture end
--============================================================================

