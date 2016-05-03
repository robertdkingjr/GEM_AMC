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

entity gt_tx_link_ila_wrapper is
  port (
      
      clk_i   : in std_logic;
      tx_i    : in t_gt_8b10b_tx_data
  );
end gt_tx_link_ila_wrapper;

architecture Behavioral of gt_tx_link_ila_wrapper is
    
    component gt_tx_link_ila is
        PORT(
            clk    : IN STD_LOGIC;
            probe0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            probe1 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            probe2 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            probe3 : IN STD_LOGIC_VECTOR(3 DOWNTO 0));
    end component gt_tx_link_ila;
        
begin

    i_gt_tx_link_ila : component gt_tx_link_ila
        port map(
            clk    => clk_i,
            probe0 => tx_i.txdata,
            probe1 => tx_i.txcharisk,
            probe2 => tx_i.txchardispmode,
            probe3 => tx_i.txchardispval
        );
        
end Behavioral;
