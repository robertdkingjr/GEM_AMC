----------------------------------------------------------------------------------
-- Company: TAMU
-- Engineer: Evaldas Juska (evka85@gmail.com)
-- 
-- Create Date: 04/08/2016 10:43:39 AM
-- Design Name: 
-- Module Name: optohybrid_single - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

use work.gth_pkg.all;
use work.ttc_pkg.all;
use work.gem_pkg.all;
use work.ipbus.all;

entity optohybrid is
    generic(
        g_DEBUG         : string := "FALSE" -- if this is set to true, some chipscope cores will be inserted
    );
    port(
        -- reset
        reset_i             : in  std_logic;

        -- TTC
        ttc_clk_i           : in  t_ttc_clks;
        ttc_cmds_i          : in  t_ttc_cmds;
        
        -- Control and tracking data link 
        gth_rx_usrclk_i     : in  std_logic;
        gth_tx_usrclk_i     : in  std_logic;
        gth_rx_data_i       : in  t_gt_8b10b_rx_data;
        gth_tx_data_o       : out t_gt_8b10b_tx_data;
        
        -- Trigger links
        gth_rx_trig_usrclk_i: in  std_logic_vector(1 downto 0);
        gth_rx_trig_data_i  : in t_gt_8b10b_rx_data_arr(1 downto 0);
        sbit_clusters_o     : out t_oh_sbits;
        sbit_links_status_o : out t_oh_sbit_links;
        
        -- Tracking data link
        tk_data_link_o      : out t_data_link;
        
        -- IPbus
        ipb_reset_i         : in  std_logic;
        ipb_clk_i           : in  std_logic;
        ipb_reg_miso_o      : out ipb_rbus;
        ipb_reg_mosi_i      : in  ipb_wbus
    );
end optohybrid;

architecture Behavioral of optohybrid is
    
    signal vfat2_t1         : t_t1;
    
    signal gth_tx_data      : t_gt_8b10b_tx_data;
    
    --== GTX requests ==--
    
    signal g2o_req_en       : std_logic;
    signal g2o_req_valid    : std_logic;
    signal g2o_req_data     : std_logic_vector(64 downto 0);
    
    signal o2g_req_en       : std_logic;
    signal o2g_req_data     : std_logic_vector(31 downto 0);
    signal o2g_req_error    : std_logic;    
    
    --== Tracking data ==--
    
    signal evt_en           : std_logic;
    signal evt_data         : std_logic_vector(15 downto 0);

begin

    gth_tx_data_o <= gth_tx_data;

    tk_data_link_o.clk <= gth_rx_usrclk_i;
    tk_data_link_o.data_en <= evt_en;
    tk_data_link_o.data <= evt_data;

    -- TODO: transfer between the ttc clk and tx clk domains
    vfat2_t1.lv1a <= ttc_cmds_i.l1a;
    vfat2_t1.bc0  <= ttc_cmds_i.bc0;

    --==========================--
    --==   TX Tracking link   ==--
    --==========================--
       
    link_tx_tracking_inst : entity work.link_tx_tracking
        port map(
            gtx_clk_i   => gth_tx_usrclk_i,   
            reset_i     => reset_i,           
            vfat2_t1_i  => vfat2_t1,        
            req_en_o    => g2o_req_en,   
            req_valid_i => g2o_req_valid,   
            req_data_i  => g2o_req_data,           
            tx_kchar_o  => gth_tx_data.txcharisk(1 downto 0),   
            tx_data_o   => gth_tx_data.txdata(15 downto 0)
        );  
    
    --==========================--
    --==   RX Tracking link   ==--
    --==========================--
    
    link_rx_tracking_inst : entity work.link_rx_tracking
        port map(
            gtx_clk_i   => gth_rx_usrclk_i,   
            reset_i     => reset_i,           
            req_en_o    => o2g_req_en,   
            req_data_o  => o2g_req_data,   
            evt_en_o    => evt_en,
            evt_data_o  => evt_data,
            tk_error_o  => open,
            evt_rcvd_o  => open,
            rx_kchar_i  => gth_rx_data_i.rxcharisk(1 downto 0),   
            rx_data_i   => gth_rx_data_i.rxdata(15 downto 0)        
        );

    --=================================--
    --== Register request forwarding ==--
    --=================================--
    
    link_request_inst : entity work.link_request
        port map(
            ipb_clk_i   => ipb_clk_i,
            gtx_clk_i   => gth_rx_usrclk_i,
            reset_i     => ipb_reset_i,        
            ipb_mosi_i  => ipb_reg_mosi_i,
            ipb_miso_o  => ipb_reg_miso_o,        
            tx_en_i     => g2o_req_en,
            tx_valid_o  => g2o_req_valid,
            tx_data_o   => g2o_req_data,        
            rx_en_i     => o2g_req_en,
            rx_data_i   => o2g_req_data        
        );
     
    --=========================--
    --==   RX Trigger Link   ==--
    --=========================--
    
    link_rx_trigger0_inst : entity work.link_rx_trigger
        port map(
            ttc_clk_i           => ttc_clk_i.clk_40,
            reset_i             => reset_i,
            gt_rx_trig_usrclk_i => gth_rx_trig_usrclk_i(0),
            gt_rx_trig_data_i   => gth_rx_trig_data_i(0),
            sbit_cluster0_o     => sbit_clusters_o(0),
            sbit_cluster1_o     => sbit_clusters_o(1),
            sbit_cluster2_o     => sbit_clusters_o(2),
            sbit_cluster3_o     => sbit_clusters_o(3),
            link_status_o       => sbit_links_status_o(0)
        );
     
    link_rx_trigger1_inst : entity work.link_rx_trigger
        port map(
            ttc_clk_i           => ttc_clk_i.clk_40,
            reset_i             => reset_i,
            gt_rx_trig_usrclk_i => gth_rx_trig_usrclk_i(1),
            gt_rx_trig_data_i   => gth_rx_trig_data_i(1),
            sbit_cluster0_o     => sbit_clusters_o(4),
            sbit_cluster1_o     => sbit_clusters_o(5),
            sbit_cluster2_o     => sbit_clusters_o(6),
            sbit_cluster3_o     => sbit_clusters_o(7),
            link_status_o       => sbit_links_status_o(1)
        );

    --============================--
    --==        Debug           ==--
    --============================--
    
    debug_gen:
    if g_DEBUG = "TRUE" generate
        gt_rx_link_ila_inst : entity work.gt_rx_link_ila_wrapper
            port map(
                clk_i => gth_rx_usrclk_i,
                rx_i  => gth_rx_data_i
            );
        gt_tx_link_ila_inst : entity work.gt_tx_link_ila_wrapper
            port map(
                clk_i => gth_tx_usrclk_i,
                tx_i  => gth_tx_data
            );
    end generate;
     
     
end Behavioral;
