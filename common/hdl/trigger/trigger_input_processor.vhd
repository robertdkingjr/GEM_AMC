------------------------------------------------------------------------------------------------------------------------------------------------------
-- Company: TAMU
-- Engineer: Evaldas Juska (evaldas.juska@cern.ch, evka85@gmail.com)
-- 
-- Create Date:    14:15 2016-05-10
-- Module Name:    trigger_input_processor
-- Description:    This module handles trigger data from one OH (monitoring, rate counting, etc)  
------------------------------------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

use work.gem_pkg.all;

entity trigger_input_processor is
port(
    reset_i             : in std_logic;
    reset_cnt_i         : in std_logic;
    clk_i               : in std_logic;
    sbit_clusters_i     : in t_oh_sbits;
    link_status_i       : in t_oh_sbit_links;
    masked_i            : in std_logic;
    
    -- this flag is asserted whenever there are any valid sbit clusters
    trigger_o           : out std_logic;
    
    -- counters
    not_valid_cnt_o     : out std_logic_vector(31 downto 0);
    missed_comma_cnt_o  : out std_logic_vector(31 downto 0);
    link_overflow_cnt_o : out std_logic_vector(31 downto 0);
    link_underflow_cnt_o: out std_logic_vector(31 downto 0);
    sync_word_cnt_o     : out std_logic_vector(31 downto 0);
    cluster_cnt_rate_o  : out t_std32_array(8 downto 0);
    trigger_rate        : out std_logic_vector(31 downto 0)
    
);
end trigger_input_processor;

architecture trigger_input_processor_arch of trigger_input_processor is
    
    signal valid_clusters   : std_logic_vector(7 downto 0);
    signal trigger          : std_logic;
    signal cluster_cnt_strb : std_logic_vector(8 downto 0);

begin

    trigger_o <= trigger;

    g_valid_clusters:
    for i in 0 to 7 generate
        valid_clusters(i) <= '0' when sbit_clusters_i(i).address(10 downto 9) = "11" else '1';
    end generate;

    p_trigger:
    process (clk_i)
    begin
        if (rising_edge(clk_i)) then
            trigger <= or_reduce(valid_clusters) and not masked_i;
        end if;
    end process;
    
    p_cluster_size_strb:
    process (clk_i)
        variable cluster_cnt : integer range 0 to 8;
    begin
        if (rising_edge(clk_i)) then
            cluster_cnt := count_ones(valid_clusters);
            cluster_cnt_strb <= (cluster_cnt => '1', others => '0');
        end if;    
    end process;
    
    g_cluster_size_rate_cnt:
    for i in 0 to 8 generate
        i_cluster_size_rate: entity work.rate_counter
        generic map(
            g_CLK_FREQUENCY => C_TTC_CLK_FREQUENCY_SLV,
            g_COUNTER_WIDTH => 32
        )
        port map(
            clk_i   => clk_i,
            reset_i => reset_i or reset_cnt_i,
            en_i    => cluster_cnt_strb(i),
            rate_o  => cluster_cnt_rate_o(i)
        );
    end generate;
    
    i_trigger_rate_cnt: entity work.rate_counter
    generic map(
        g_CLK_FREQUENCY => C_TTC_CLK_FREQUENCY_SLV,
        g_COUNTER_WIDTH => 32
    )
    port map(
        clk_i   => clk_i,
        reset_i => reset_i or reset_cnt_i,
        en_i    => trigger,
        rate_o  => trigger_rate
    );
    
    g_link_status_counters:
    for i in 0 to 1 generate
    
        i_not_valid_cnt: entity work.counter
        generic map(
            g_COUNTER_WIDTH => 16            
        )
        port map(
            ref_clk_i => clk_i,
            reset_i   => reset_i or reset_cnt_i,
            en_i      => not link_status_i(i).valid,
            count_o    => not_valid_cnt_o(((i + 1) * 16) - 1 downto i * 16) 
        );
            
        i_missed_comma_cnt: entity work.counter
        generic map(
            g_COUNTER_WIDTH => 16            
        )
        port map(
            ref_clk_i => clk_i,
            reset_i   => reset_i or reset_cnt_i,
            en_i      => link_status_i(i).missed_comma,
            count_o    => missed_comma_cnt_o(((i + 1) * 16) - 1 downto i * 16)
        );
            
        i_link_ovf_cnt: entity work.counter
        generic map(
            g_COUNTER_WIDTH => 16            
        )
        port map(
            ref_clk_i => clk_i,
            reset_i   => reset_i or reset_cnt_i,
            en_i      => link_status_i(i).overflow,
            count_o    => link_overflow_cnt_o(((i + 1) * 16) - 1 downto i * 16)
        );
            
        i_link_unf_cnt: entity work.counter
        generic map(
            g_COUNTER_WIDTH => 16            
        )
        port map(
            ref_clk_i => clk_i,
            reset_i   => reset_i or reset_cnt_i,
            en_i      => link_status_i(i).underflow,
            count_o    => link_underflow_cnt_o(((i + 1) * 16) - 1 downto i * 16)
        );
            
        i_sync_word_cnt: entity work.counter
        generic map(
            g_COUNTER_WIDTH => 16            
        )
        port map(
            ref_clk_i => clk_i,
            reset_i   => reset_i or reset_cnt_i,
            en_i      => link_status_i(i).sync_word,
            count_o    => sync_word_cnt_o(((i + 1) * 16) - 1 downto i * 16)
        );
            
    end generate;
    
end trigger_input_processor_arch;

