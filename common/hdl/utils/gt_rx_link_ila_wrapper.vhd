------------------------------------------------------------------------------------------------------------------------------------------------------
-- Company: TAMU
-- Engineer: Evaldas Juska (evaldas.juska@cern.ch, evka85@gmail.com)
-- 
-- Create Date:    20:10:11 2016-05-02
-- Module Name:    A simple ILA wrapper for a GTH or GTX RX link 
-- Description:     
------------------------------------------------------------------------------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.gem_pkg.all;

entity gt_rx_link_ila_wrapper is
  port (
      
      clk_i   : in std_logic;
      rx_i    : in t_gt_8b10b_rx_data
  );
end gt_rx_link_ila_wrapper;

architecture Behavioral of gt_rx_link_ila_wrapper is
    
    component gt_rx_link_ila is
        PORT(
            clk    : IN STD_LOGIC;
            probe0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            probe1 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            probe2 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            probe3 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            probe4 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            probe5 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            probe6 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            probe7 : IN STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    end component gt_rx_link_ila;
        
begin

    i_gt_rx_link_ila : component gt_rx_link_ila
        port map(
            clk         => clk_i,
            probe0      => rx_i.rxdata,
            probe1(0)   => rx_i.rxbyteisaligned,
            probe2(0)   => rx_i.rxbyterealign,
            probe3(0)   => rx_i.rxcommadet,
            probe4      => rx_i.rxdisperr,
            probe5      => rx_i.rxnotintable,
            probe6      => rx_i.rxchariscomma,
            probe7      => rx_i.rxcharisk
        );
        
end Behavioral;
