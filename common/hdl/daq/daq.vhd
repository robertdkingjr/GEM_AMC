----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Evaldas Juska (Evaldas.Juska@cern.ch)
-- 
-- Create Date:    20:18:40 09/17/2015 
-- Design Name:    GLIB v2
-- Module Name:    DAQ
-- Project Name:   GLIB v2
-- Target Devices: xc6vlx130t-1ff1156
-- Tool versions:  ISE  P.20131013
-- Description:    This module buffers track data, builds events, analyses the data for consistency and ships off the events with all the needed headers and trailers to AMC13 over DAQLink
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

use work.gem_pkg.all;
use work.ttc_pkg.all;
use work.ipbus.all;
use work.registers.all;

entity daq is
generic(
    g_NUM_OF_OHs         : integer    
);
port(

    -- Reset
    reset_i                     : in std_logic;

    -- Clocks
    daq_clk_i                   : in std_logic; -- for now use 25MHz, but could try 50MHz
    daq_clk_locked_i            : in std_logic;

    -- DAQLink
    daq_to_daqlink_o            : out t_daq_to_daqlink;
    daqlink_to_daq_i            : in  t_daqlink_to_daq;
        
    -- TTC
    ttc_clks_i                  : in t_ttc_clks;
    ttc_cmds_i                  : in t_ttc_cmds;
    ttc_daq_cntrs_i             : in t_ttc_daq_cntrs;
    ttc_status_i                : in t_ttc_status;

    -- Track data
    tk_data_links_i             : in t_data_link_array(g_NUM_OF_OHs - 1 downto 0);
    
    -- IPbus
    ipb_reset_i                 : in  std_logic;
    ipb_clk_i                   : in std_logic;
	ipb_mosi_i                  : in ipb_wbus;
	ipb_miso_o                  : out ipb_rbus;
    
    -- Other
    board_sn_i                  : in std_logic_vector(15 downto 0) -- board serial ID, needed for the header to AMC13
    
);
end daq;

architecture Behavioral of daq is

    --================== COMPONENTS ==================--

    component daq_l1a_fifo is
        port (
            rst         : in  std_logic;
            wr_clk      : in  std_logic;
            rd_clk      : in  std_logic;
            din         : in  std_logic_vector(51 downto 0);
            wr_en       : in  std_logic;
            wr_ack      : out std_logic;
            rd_en       : in  std_logic;
            dout        : out std_logic_vector(51 downto 0);
            full        : out std_logic;
            overflow    : out std_logic;
            almost_full : out std_logic;
            empty       : out std_logic;
            valid       : out std_logic;
            underflow   : out std_logic;
            prog_full   : out std_logic
        );
    end component daq_l1a_fifo;  

    component daq_output_fifo
        port (
            clk       : IN  STD_LOGIC;
            rst       : IN  STD_LOGIC;
            din       : IN  STD_LOGIC_VECTOR(65 DOWNTO 0);
            wr_en     : IN  STD_LOGIC;
            rd_en     : IN  STD_LOGIC;
            dout      : OUT STD_LOGIC_VECTOR(65 DOWNTO 0);
            full      : OUT STD_LOGIC;
            empty     : OUT STD_LOGIC;
            valid     : OUT STD_LOGIC;            
            prog_full : OUT STD_LOGIC
        );
    end component;

    --================== SIGNALS ==================--

    -- Reset
    signal reset_global         : std_logic := '1';
    signal reset_daq            : std_logic := '1';
    signal reset_daqlink        : std_logic := '1'; -- should only be done once at powerup
    signal reset_pwrup          : std_logic := '1';
    signal reset_local          : std_logic := '1';
    signal reset_daqlink_ipb    : std_logic := '0';

    -- DAQlink
    signal daq_event_data       : std_logic_vector(63 downto 0) := (others => '0');
    signal daq_event_write_en   : std_logic := '0';
    signal daq_event_header     : std_logic := '0';
    signal daq_event_trailer    : std_logic := '0';
    signal daq_ready            : std_logic := '0';
    signal daq_almost_full      : std_logic := '0';
  
    signal daq_disper_err_cnt   : std_logic_vector(15 downto 0) := (others => '0');
    signal daq_notintable_err_cnt: std_logic_vector(15 downto 0) := (others => '0');

    -- DAQ Error Flags
    signal err_l1afifo_full     : std_logic := '0';
    signal err_daqfifo_full     : std_logic := '0';

    -- TTS
    signal tts_state            : std_logic_vector(3 downto 0) := "1000";
    signal tts_critical_error   : std_logic := '0'; -- critical error detected - RESYNC/RESET NEEDED
    signal tts_warning          : std_logic := '0'; -- overflow warning - STOP TRIGGERS
    signal tts_out_of_sync      : std_logic := '0'; -- out-of-sync - RESYNC NEEDED
    signal tts_busy             : std_logic := '0'; -- I'm busy - NO TRIGGERS FOR NOW, PLEASE
    signal tts_override         : std_logic_vector(3 downto 0) := x"0"; -- this can be set via IPbus and will override the TTS state if it's not x"0" (regardless of reset_daq and daq_enable)
    
    signal tts_chmb_critical    : std_logic := '0'; -- input critical error detected - RESYNC/RESET NEEDED
    signal tts_chmb_warning     : std_logic := '0'; -- input overflow warning - STOP TRIGGERS
    signal tts_chmb_out_of_sync : std_logic := '0'; -- input out-of-sync - RESYNC NEEDED

    signal tts_start_cntdwn_chmb: unsigned(7 downto 0) := x"ff";
    signal tts_start_cntdwn     : unsigned(7 downto 0) := x"ff";

    -- Error signals transfered to TTS clk domain
    signal tts_chmb_critical_tts_clk    : std_logic := '0'; -- tts_chmb_critical transfered to TTS clock domain
    signal tts_chmb_warning_tts_clk     : std_logic := '0'; -- tts_chmb_warning transfered to TTS clock domain
    signal tts_chmb_out_of_sync_tts_clk : std_logic := '0'; -- tts_chmb_out_of_sync transfered to TTS clock domain
    signal err_daqfifo_full_tts_clk     : std_logic := '0'; -- err_daqfifo_full transfered to TTS clock domain
    
    -- DAQ conf
    signal daq_enable           : std_logic := '1'; -- enable sending data to DAQLink
    signal input_mask           : std_logic_vector(23 downto 0) := x"000000";
    signal run_type             : std_logic_vector(3 downto 0) := x"0"; -- run type (set by software and included in the AMC header)
    signal run_params           : std_logic_vector(23 downto 0) := x"000000"; -- optional run parameters (set by software and included in the AMC header)
    
    -- DAQ counters
    signal cnt_sent_events      : unsigned(31 downto 0) := (others => '0');
    signal cnt_corrupted_vfat   : unsigned(31 downto 0) := (others => '0');

    -- DAQ event sending state machine
    signal daq_state            : unsigned(3 downto 0) := (others => '0');
    signal daq_curr_vfat_block  : unsigned(11 downto 0) := (others => '0');
    signal daq_curr_block_word  : integer range 0 to 2 := 0;
        
    -- IPbus registers
    type ipb_state_t is (IDLE, RSPD, RST);
    signal ipb_state                : ipb_state_t := IDLE;    
    signal ipb_reg_sel              : integer range 0 to (16 * (g_NUM_OF_OHs + 10)) + 15;  -- 16 regs for AMC evt builder and 16 regs for each chamber evt builder   
    signal ipb_read_reg_data        : t_std32_array(0 to (16 * (g_NUM_OF_OHs + 10)) + 15); -- 16 regs for AMC evt builder and 16 regs for each chamber evt builder
    signal ipb_write_reg_data       : t_std32_array(0 to (16 * (g_NUM_OF_OHs + 10)) + 15); -- 16 regs for AMC evt builder and 16 regs for each chamber evt builder
    
    -- L1A FIFO
    signal l1afifo_din          : std_logic_vector(51 downto 0) := (others => '0');
    signal l1afifo_wr_en        : std_logic := '0';
    signal l1afifo_rd_en        : std_logic := '0';
    signal l1afifo_dout         : std_logic_vector(51 downto 0);
    signal l1afifo_full         : std_logic;
    signal l1afifo_overflow     : std_logic;
    signal l1afifo_empty        : std_logic;
    signal l1afifo_valid        : std_logic;
    signal l1afifo_underflow    : std_logic;
    signal l1afifo_near_full    : std_logic;
    
    -- DAQ output FIFO
    signal daqfifo_din          : std_logic_vector(65 downto 0) := (others => '0');
    signal daqfifo_wr_en        : std_logic := '0';
    signal daqfifo_rd_en        : std_logic := '0';
    signal daqfifo_dout         : std_logic_vector(65 downto 0);
    signal daqfifo_full         : std_logic;
    signal daqfifo_empty        : std_logic;
    signal daqfifo_valid        : std_logic;
    signal daqfifo_near_full    : std_logic;
            
    -- Timeouts
    signal dav_timer            : unsigned(23 downto 0) := (others => '0'); -- TODO: probably don't need this to be so large.. (need to test)
    signal max_dav_timer        : unsigned(23 downto 0) := (others => '0'); -- TODO: probably don't need this to be so large.. (need to test)
    signal last_dav_timer       : unsigned(23 downto 0) := (others => '0'); -- TODO: probably don't need this to be so large.. (need to test)
    signal dav_timeout          : std_logic_vector(23 downto 0) := x"03d090"; -- 10ms (very large)
    signal dav_timeout_flags    : std_logic_vector(23 downto 0) := (others => '0'); -- inputs which have timed out
    
    ---=== AMC Event Builder signals ===---
    
    -- index of the input currently being processed
    signal e_input_idx                : integer range 0 to 23 := 0;
    
    -- word count of the event being sent
    signal e_word_count               : unsigned(19 downto 0) := (others => '0');

    -- bitmask indicating chambers with data for the event being sent
    signal e_dav_mask                 : std_logic_vector(23 downto 0) := (others => '0');
    -- number of chambers with data for the event being sent
    signal e_dav_count                : integer range 0 to 24;
           
    ---=== Chamber Event Builder signals ===---
    
    signal chamber_infifos      : t_chamber_infifo_rd_array(0 to g_NUM_OF_OHs - 1);
    signal chamber_evtfifos     : t_chamber_evtfifo_rd_array(0 to g_NUM_OF_OHs - 1);
    signal chmb_evtfifos_empty  : std_logic_vector(g_NUM_OF_OHs - 1 downto 0) := (others => '1'); -- you should probably just move this flag out of the t_chamber_evtfifo_rd_array struct 
    signal chmb_evtfifos_rd_en  : std_logic_vector(g_NUM_OF_OHs - 1 downto 0) := (others => '0'); -- you should probably just move this flag out of the t_chamber_evtfifo_rd_array struct 
    signal chmb_infifos_rd_en   : std_logic_vector(g_NUM_OF_OHs - 1 downto 0) := (others => '0'); -- you should probably just move this flag out of the t_chamber_evtfifo_rd_array struct 
    signal chmb_tts_states      : t_std4_array(0 to g_NUM_OF_OHs - 1);
    
    signal err_event_too_big    : std_logic;
    signal err_evtfifo_underflow: std_logic;

    --=== Input processor status and control ===--
    signal input_status_arr     : t_daq_input_status_arr(g_NUM_OF_OHs -1 downto 0);
    signal input_control_arr    : t_daq_input_control_arr(g_NUM_OF_OHs -1 downto 0);

    ------ Register signals begin (this section is generated by <gem_amc_repo_root>/scripts/generate_registers.py -- do not edit)
    signal regs_read_arr        : t_std32_array(REG_DAQ_NUM_REGS - 1 downto 0);
    signal regs_write_arr       : t_std32_array(REG_DAQ_NUM_REGS - 1 downto 0);
    signal regs_addresses       : t_std32_array(REG_DAQ_NUM_REGS - 1 downto 0);
    signal regs_defaults        : t_std32_array(REG_DAQ_NUM_REGS - 1 downto 0) := (others => (others => '0'));
    signal regs_read_pulse_arr  : std_logic_vector(REG_DAQ_NUM_REGS - 1 downto 0);
    signal regs_write_pulse_arr : std_logic_vector(REG_DAQ_NUM_REGS - 1 downto 0);
    ------ Register signals end ----------------------------------------------

    
    -- Debug flags for ChipScope
--    attribute MARK_DEBUG : string;
--    attribute MARK_DEBUG of reset_daq           : signal is "TRUE";
--    attribute MARK_DEBUG of daq_clk_i           : signal is "TRUE";
--
--    attribute MARK_DEBUG of dav_timer           : signal is "TRUE";
--    attribute MARK_DEBUG of max_dav_timer       : signal is "TRUE";
--    attribute MARK_DEBUG of last_dav_timer      : signal is "TRUE";
--    attribute MARK_DEBUG of dav_timeout         : signal is "TRUE";
--    attribute MARK_DEBUG of dav_timeout_flags   : signal is "TRUE";
--
--    attribute MARK_DEBUG of daq_state           : signal is "TRUE";
--    attribute MARK_DEBUG of daq_curr_vfat_block : signal is "TRUE";
--    attribute MARK_DEBUG of daq_curr_block_word : signal is "TRUE";
--
--    attribute MARK_DEBUG of daq_event_data      : signal is "TRUE";
--    attribute MARK_DEBUG of daq_event_write_en  : signal is "TRUE";
--    attribute MARK_DEBUG of daq_event_header    : signal is "TRUE";
--    attribute MARK_DEBUG of daq_event_trailer   : signal is "TRUE";
--    attribute MARK_DEBUG of daq_ready           : signal is "TRUE";
--    attribute MARK_DEBUG of daq_almost_full     : signal is "TRUE";
--    
--    attribute MARK_DEBUG of input_mask          : signal is "TRUE";
--    attribute MARK_DEBUG of e_input_idx         : signal is "TRUE";
--    attribute MARK_DEBUG of e_word_count        : signal is "TRUE";
--    attribute MARK_DEBUG of e_dav_mask          : signal is "TRUE";
--    attribute MARK_DEBUG of e_dav_count         : signal is "TRUE";
--    
--    attribute MARK_DEBUG of l1afifo_dout        : signal is "TRUE";
--    attribute MARK_DEBUG of l1afifo_rd_en       : signal is "TRUE";
--    attribute MARK_DEBUG of l1afifo_empty       : signal is "TRUE";
--    
--    attribute MARK_DEBUG of chmb_evtfifos_empty : signal is "TRUE";
--    attribute MARK_DEBUG of chmb_evtfifos_rd_en : signal is "TRUE";
--    attribute MARK_DEBUG of chmb_infifos_rd_en  : signal is "TRUE";
    
begin

    -- TODO DAQ main tasks:
    --   * Handle OOS
    --   * Implement buffer status in the AMC header
    --   * TTS State aggregation
    --   * Check for VFAT and OH BX vs L1A bx mismatches
    --   * Resync handling
    --   * Stop building events if input fifo is full -- let it drain to some level and only then restart building (otherwise you're pointing to inexisting data). I guess it's better to loose some data than to have something that doesn't make any sense..

    --================================--
    -- DAQLink interface
    --================================--
    
    daq_to_daqlink_o.reset <= '0'; -- will need to investigate this later
    daq_to_daqlink_o.resync <= '0'; -- will need to investigate this later
    daq_to_daqlink_o.trig <= x"00";
    daq_to_daqlink_o.ttc_clk <= ttc_clks_i.clk_40;
    daq_to_daqlink_o.ttc_bc0 <= ttc_cmds_i.bc0;
    daq_to_daqlink_o.tts_clk <= ttc_clks_i.clk_40;
    daq_to_daqlink_o.tts_state <= tts_state;
    daq_to_daqlink_o.event_clk <= daq_clk_i; -- TODO: check if the TTS state is transfered to the TTC clock domain correctly, if not, maybe use a different clock
    daq_to_daqlink_o.event_data <= daqfifo_dout(63 downto 0);
    daq_to_daqlink_o.event_header <= daqfifo_dout(65);
    daq_to_daqlink_o.event_trailer <= daqfifo_dout(64);
    daq_to_daqlink_o.event_valid <= daqfifo_valid;

    daq_ready <= daqlink_to_daq_i.ready;
    daq_almost_full <= daqlink_to_daq_i.almost_full;

    --================================--
    -- Resets
    --================================--

    i_reset_sync : entity work.synchronizer
        generic map(
            N_STAGES => 3
        )
        port map(
            async_i => reset_i,
            clk_i   => ttc_clks_i.clk_40,
            sync_o  => reset_global
        );
    
    reset_daq <= reset_pwrup or reset_global or reset_local;
    reset_daqlink <= reset_pwrup or reset_global or reset_daqlink_ipb;
    
    -- Reset after powerup
    
    process(ttc_clks_i.clk_40)
        variable countdown : integer := 40_000_000; -- probably way too long, but ok for now (this is only used after powerup)
    begin
        if (rising_edge(ttc_clks_i.clk_40)) then
            if (countdown > 0) then
              reset_pwrup <= '1';
              countdown := countdown - 1;
            else
              reset_pwrup <= '0';
            end if;
        end if;
    end process;

    --================================--
    -- DAQ output FIFO
    --================================--
    
    i_daq_fifo : component daq_output_fifo
    port map(
        clk       => daq_clk_i,
        rst       => reset_daq,
        din       => daqfifo_din,
        wr_en     => daqfifo_wr_en,
        rd_en     => daqfifo_rd_en,
        dout      => daqfifo_dout,
        full      => daqfifo_full,
        empty     => daqfifo_empty,
        valid     => daqfifo_valid,
        prog_full => daqfifo_near_full
    );

    daqfifo_din <= daq_event_header & daq_event_trailer & daq_event_data;
    daqfifo_wr_en <= daq_event_write_en;
    
    -- daq fifo read logic
    process(daq_clk_i)
    begin
        if (rising_edge(daq_clk_i)) then
            if (reset_daq = '1') then
                err_daqfifo_full <= '0';
            else
                daqfifo_rd_en <= (not daq_almost_full) and (not daqfifo_empty) and daq_ready;
                if (daqfifo_full = '1') then
                    err_daqfifo_full <= '1';
                end if; 
            end if;
        end if;
    end process;

    --================================--
    -- L1A FIFO
    --================================--
    
    i_l1a_fifo : component daq_l1a_fifo
    PORT MAP (
        rst => reset_daq,
        wr_clk => ttc_clks_i.clk_40,
        rd_clk => daq_clk_i,
        din => l1afifo_din,
        wr_en => l1afifo_wr_en,
        wr_ack => open,
        rd_en => l1afifo_rd_en,
        dout => l1afifo_dout,
        full => l1afifo_full,
        overflow => l1afifo_overflow,
        almost_full => open,
        empty => l1afifo_empty,
        valid => l1afifo_valid,
        underflow => l1afifo_underflow,
        prog_full => l1afifo_near_full
    );
    
    -- fill the L1A FIFO
    process(ttc_clks_i.clk_40)
    begin
        if (rising_edge(ttc_clks_i.clk_40)) then
            if (reset_daq = '1') then
                err_l1afifo_full <= '0';
                l1afifo_wr_en <= '0';
            else
                if (ttc_cmds_i.l1a = '1') then
                    if (l1afifo_full = '0') then
                        l1afifo_din <= ttc_daq_cntrs_i.l1id & ttc_daq_cntrs_i.orbit & ttc_daq_cntrs_i.bx;
                        l1afifo_wr_en <= '1';
                    else
                        err_l1afifo_full <= '1';
                        l1afifo_wr_en <= '0';
                    end if;
                else
                    l1afifo_wr_en <= '0';
                end if;
            end if;
        end if;
    end process;
    
    --================================--
    -- Chamber Event Builders
    --================================--

    g_chamber_evt_builders : for I in 0 to (g_NUM_OF_OHs - 1) generate
    begin

        i_track_input_processor : entity work.track_input_processor
        port map
        (
            -- Reset
            reset_i                     => reset_daq,

            -- Config
            input_enable_i              => input_mask(I),

            -- FIFOs
            fifo_rd_clk_i               => daq_clk_i,
            infifo_dout_o               => chamber_infifos(I).dout,
            infifo_rd_en_i              => chamber_infifos(I).rd_en,
            infifo_empty_o              => chamber_infifos(I).empty,
            infifo_valid_o              => chamber_infifos(I).valid,
            infifo_underflow_o          => chamber_infifos(I).underflow,
            evtfifo_dout_o              => chamber_evtfifos(I).dout,
            evtfifo_rd_en_i             => chamber_evtfifos(I).rd_en,
            evtfifo_empty_o             => chamber_evtfifos(I).empty,
            evtfifo_valid_o             => chamber_evtfifos(I).valid,
            evtfifo_underflow_o         => chamber_evtfifos(I).underflow,

            -- Track data
            tk_data_link_i              => tk_data_links_i(I),
            
            -- Status and control
            status_o                    => input_status_arr(I),
            control_i                   => input_control_arr(I)
        );
    
        chmb_evtfifos_empty(I) <= chamber_evtfifos(I).empty;
        chamber_evtfifos(I).rd_en <= chmb_evtfifos_rd_en(I);
        chamber_infifos(I).rd_en <= chmb_infifos_rd_en(I);
        chmb_tts_states(I) <= input_status_arr(I).tts_state;
        
    end generate;
        
    --================================--
    -- TTS
    --================================--

    process (tk_data_links_i(0).clk)
    begin
        if (rising_edge(tk_data_links_i(0).clk)) then
            if (reset_daq = '1') then
                tts_chmb_critical <= '0';
                tts_chmb_out_of_sync <= '0';
                tts_chmb_warning <= '0';
                tts_start_cntdwn_chmb <= x"ff";
            else
                if (tts_start_cntdwn_chmb /= x"00") then
                    for I in 0 to (g_NUM_OF_OHs - 1) loop
                        tts_chmb_critical <= tts_chmb_critical or (chmb_tts_states(I)(2) and input_mask(I));
                        tts_chmb_out_of_sync <= tts_chmb_out_of_sync or (chmb_tts_states(I)(1) and input_mask(I));
                        tts_chmb_warning <= tts_chmb_warning or (chmb_tts_states(I)(0) and input_mask(I));
                    end loop;                
                else
                    tts_start_cntdwn_chmb <= tts_start_cntdwn_chmb - 1;
                end if;
            end if;
        end if;
    end process;

    i_tts_sync_chmb_error   : entity work.synchronizer generic map(N_STAGES => 2) port map(async_i => tts_chmb_critical,    clk_i => ttc_clks_i.clk_40, sync_o  => tts_chmb_critical_tts_clk);
    i_tts_sync_chmb_warn    : entity work.synchronizer generic map(N_STAGES => 2) port map(async_i => tts_chmb_warning,     clk_i => ttc_clks_i.clk_40, sync_o  => tts_chmb_warning_tts_clk);
    i_tts_sync_chmb_oos     : entity work.synchronizer generic map(N_STAGES => 2) port map(async_i => tts_chmb_out_of_sync, clk_i => ttc_clks_i.clk_40, sync_o  => tts_chmb_out_of_sync_tts_clk);
    i_tts_sync_daqfifo_full : entity work.synchronizer generic map(N_STAGES => 2) port map(async_i => err_daqfifo_full,     clk_i => ttc_clks_i.clk_40, sync_o  => err_daqfifo_full_tts_clk);

    process (ttc_clks_i.clk_40)
    begin
        if (rising_edge(ttc_clks_i.clk_40)) then
            if (reset_daq = '1') then
                tts_critical_error <= '0';
                tts_out_of_sync <= '0';
                tts_warning <= '0';
                tts_busy <= '1';
                tts_start_cntdwn <= x"ff";
            else
                if (tts_start_cntdwn /= x"00") then
                    tts_busy <= '0';
                    tts_critical_error <= err_l1afifo_full or tts_chmb_critical_tts_clk or err_daqfifo_full_tts_clk;
                    tts_out_of_sync <= tts_chmb_out_of_sync_tts_clk;
                    tts_warning <= l1afifo_near_full or tts_chmb_warning_tts_clk;
                else
                    tts_start_cntdwn <= tts_start_cntdwn - 1;
                end if;
            end if;
        end if;
    end process;

    tts_state <= tts_override when (tts_override /= x"0") else
                 x"8" when (daq_enable = '0') else
                 x"4" when (tts_busy = '1') else
                 x"c" when (tts_critical_error = '1') else
                 x"2" when (tts_out_of_sync = '1') else
                 x"1" when (tts_warning = '1') else
                 x"8"; 
     
    --================================--
    -- Event shipping to DAQLink
    --================================--
    
    process(daq_clk_i)
    
        -- event info
        variable e_l1a_id                   : std_logic_vector(23 downto 0) := (others => '0');        
        variable e_bx_id                    : std_logic_vector(11 downto 0) := (others => '0');        
        variable e_orbit_id                 : std_logic_vector(15 downto 0) := (others => '0');        

        -- event chamber info; TODO: convert these to signals (but would require additional state)
        variable e_chmb_l1a_id              : std_logic_vector(23 downto 0) := (others => '0');
        variable e_chmb_bx_id               : std_logic_vector(11 downto 0) := (others => '0');
        variable e_chmb_payload_size        : unsigned(19 downto 0) := (others => '0');
        variable e_chmb_evtfifo_afull       : std_logic := '0';
        variable e_chmb_evtfifo_full        : std_logic := '0';
        variable e_chmb_infifo_full         : std_logic := '0';
        variable e_chmb_evtfifo_near_full   : std_logic := '0';
        variable e_chmb_infifo_near_full    : std_logic := '0';
        variable e_chmb_infifo_underflow    : std_logic := '0';
        variable e_chmb_invalid_vfat_block  : std_logic := '0';
        variable e_chmb_evt_too_big         : std_logic := '0';
        variable e_chmb_evt_bigger_24       : std_logic := '0';
        variable e_chmb_mixed_oh_bc         : std_logic := '0';
        variable e_chmb_mixed_vfat_bc       : std_logic := '0';
        variable e_chmb_mixed_vfat_ec       : std_logic := '0';
              
    begin
    
        if (rising_edge(daq_clk_i)) then
        
            if (reset_daq = '1') then
                daq_state <= x"0";
                daq_event_data <= (others => '0');
                daq_event_header <= '0';
                daq_event_trailer <= '0';
                daq_event_write_en <= '0';
                chmb_evtfifos_rd_en <= (others => '0');
                l1afifo_rd_en <= '0';
                daq_curr_vfat_block <= (others => '0');
                chmb_infifos_rd_en <= (others => '0');
                daq_curr_block_word <= 0;
                cnt_sent_events <= (others => '0');
                e_word_count <= (others => '0');
                dav_timer <= (others => '0');
                max_dav_timer <= (others => '0');
                last_dav_timer <= (others => '0');
                dav_timeout_flags <= (others => '0');
            else
            
                -- state machine for sending data
                -- state 0: idle
                -- state 1: send the first AMC header
                -- state 2: send the second AMC header
                -- state 3: send the GEM Event header
                -- state 4: send the GEM Chamber header
                -- state 5: send the payload
                -- state 6: send the GEM Chamber trailer
                -- state 7: send the GEM Event trailer
                -- state 8: send the AMC trailer
                if (daq_state = x"0") then
                
                    -- zero out everything, especially the write enable :)
                    daq_event_data <= (others => '0');
                    daq_event_header <= '0';
                    daq_event_trailer <= '0';
                    daq_event_write_en <= '0';
                    e_word_count <= (others => '0');
                    e_input_idx <= 0;
                    
                    
                    -- have an L1A and data from all enabled inputs is ready (or these inputs have timed out)
                    if (l1afifo_empty = '0' and ((input_mask(g_NUM_OF_OHs - 1 downto 0) and ((not chmb_evtfifos_empty) or dav_timeout_flags(g_NUM_OF_OHs - 1 downto 0))) = input_mask(g_NUM_OF_OHs - 1 downto 0))) then
                        if (daq_ready = '1' and daqfifo_near_full = '0' and daq_enable = '1') then -- everybody ready?.... GO! :)
                            -- start the DAQ state machine
                            daq_state <= x"1";
                            
                            -- fetch the data from the L1A FIFO
                            l1afifo_rd_en <= '1';
                            
                            -- set the DAV mask
                            e_dav_mask(g_NUM_OF_OHs - 1 downto 0) <= input_mask(g_NUM_OF_OHs - 1 downto 0) and ((not chmb_evtfifos_empty) and (not dav_timeout_flags(g_NUM_OF_OHs - 1 downto 0)));
                            
                            -- save timer stats
                            dav_timer <= (others => '0');
                            last_dav_timer <= dav_timer;
                            if ((dav_timer > max_dav_timer) and (or_reduce(dav_timeout_flags) = '0')) then
                                max_dav_timer <= dav_timer;
                            end if;
                        end if;
                    -- have an L1A, but waiting for data -- start counting the time
                    elsif (l1afifo_empty = '0') then
                        dav_timer <= dav_timer + 1;
                    end if;
                    
                    -- set the timeout flags if the timer has reached the dav_timeout value
                    if (dav_timer >= unsigned(dav_timeout)) then
                        dav_timeout_flags(g_NUM_OF_OHs - 1 downto 0) <= chmb_evtfifos_empty and input_mask(g_NUM_OF_OHs - 1 downto 0);
                    end if;
                                        
                else -- lets send some data!
                
                    l1afifo_rd_en <= '0';
                    
                    ----==== send the first AMC header ====----
                    if (daq_state = x"1") then
                        
                        -- wait for the valid flag from the L1A FIFO and then populate the variables and AMC header
                        if (l1afifo_valid = '1') then
                        
                            -- fetch the L1A data
                            e_l1a_id        := l1afifo_dout(51 downto 28);
                            e_orbit_id      := l1afifo_dout(27 downto 12);
                            e_bx_id         := l1afifo_dout(11 downto 0);

                            -- send the data
                            daq_event_data <= x"00" & 
                                              e_l1a_id &   -- L1A ID
                                              e_bx_id &   -- BX ID
                                              x"fffff";
                            daq_event_header <= '1';
                            daq_event_trailer <= '0';
                            daq_event_write_en <= '1';
                            
                            -- move to the next state
                            e_word_count <= e_word_count + 1;
                            daq_state <= x"2";
                            
                        end if;
                        
                    ----==== send the second AMC header ====----
                    elsif (daq_state = x"2") then
                    
                        -- calculate the DAV count (I know it's ugly...)
                        e_dav_count <= to_integer(unsigned(e_dav_mask(0 downto 0))) + to_integer(unsigned(e_dav_mask(1 downto 1))) + to_integer(unsigned(e_dav_mask(2 downto 2))) + to_integer(unsigned(e_dav_mask(3 downto 3))) + to_integer(unsigned(e_dav_mask(4 downto 4))) + to_integer(unsigned(e_dav_mask(5 downto 5))) + to_integer(unsigned(e_dav_mask(6 downto 6))) + to_integer(unsigned(e_dav_mask(7 downto 7))) + to_integer(unsigned(e_dav_mask(8 downto 8))) + to_integer(unsigned(e_dav_mask(9 downto 9))) + to_integer(unsigned(e_dav_mask(10 downto 10))) + to_integer(unsigned(e_dav_mask(11 downto 11))) + to_integer(unsigned(e_dav_mask(12 downto 12))) + to_integer(unsigned(e_dav_mask(13 downto 13))) + to_integer(unsigned(e_dav_mask(14 downto 14))) + to_integer(unsigned(e_dav_mask(15 downto 15))) + to_integer(unsigned(e_dav_mask(16 downto 16))) + to_integer(unsigned(e_dav_mask(17 downto 17))) + to_integer(unsigned(e_dav_mask(18 downto 18))) + to_integer(unsigned(e_dav_mask(19 downto 19))) + to_integer(unsigned(e_dav_mask(20 downto 20))) + to_integer(unsigned(e_dav_mask(21 downto 21))) + to_integer(unsigned(e_dav_mask(22 downto 22))) + to_integer(unsigned(e_dav_mask(23 downto 23)));
                        
                        -- send the data
                        daq_event_data <= C_DAQ_FORMAT_VERSION &
                                          run_type &
                                          run_params &
                                          e_orbit_id & 
                                          board_sn_i;
                        daq_event_header <= '0';
                        daq_event_trailer <= '0';
                        daq_event_write_en <= '1';
                        
                        -- move to the next state
                        e_word_count <= e_word_count + 1;
                        daq_state <= x"3";
                    
                    ----==== send the GEM Event header ====----
                    elsif (daq_state = x"3") then
                        
                        -- if this input doesn't have data and we're not at the last input yet, then go to the next input
                        if ((e_input_idx < g_NUM_OF_OHs - 1) and (e_dav_mask(e_input_idx) = '0')) then 
                        
                            daq_event_write_en <= '0';
                            e_input_idx <= e_input_idx + 1;
                            
                        else

                            -- send the data
                            daq_event_data <= e_dav_mask & -- DAV mask
                                              -- buffer status (set if we've ever had a buffer overflow)
                                              x"000000" & -- TODO: implement buffer status flag
                                              --(err_event_too_big or e_chmb_evtfifo_full or e_chmb_infifo_underflow or e_chmb_infifo_full) &
                                              std_logic_vector(to_unsigned(e_dav_count, 5)) &   -- DAV count
                                              -- GLIB status
                                              "0000000" & -- Not used yet
                                              tts_state;
                            daq_event_header <= '0';
                            daq_event_trailer <= '0';
                            daq_event_write_en <= '1';
                            e_word_count <= e_word_count + 1;
                            
                            -- if we have data then read the event fifo and send the chamber data
                            if (e_dav_mask(e_input_idx) = '1') then
                            
                                -- read the first chamber event fifo
                                chmb_evtfifos_rd_en(e_input_idx) <= '1';

                                -- move to the next state
                                daq_state <= x"4";
                            
                            -- no data on this input - skip to event trailer                            
                            else
                            
                                daq_state <= x"7";
                                
                            end if;
                        
                        end if;
                    
                    ----==== send the GEM Chamber header ====----
                    elsif (daq_state = x"4") then
                    
                        -- reset the read enable
                        chmb_evtfifos_rd_en(e_input_idx) <= '0';
                        
                        -- wait for the valid flag and then fetch the chamber event data
                        if (chamber_evtfifos(e_input_idx).valid = '1') then
                        
                            e_chmb_l1a_id                       := chamber_evtfifos(e_input_idx).dout(59 downto 36);
                            e_chmb_bx_id                        := chamber_evtfifos(e_input_idx).dout(35 downto 24);
                            e_chmb_payload_size(11 downto 0)    := unsigned(chamber_evtfifos(e_input_idx).dout(23 downto 12));
                            e_chmb_evtfifo_afull                := chamber_evtfifos(e_input_idx).dout(11);
                            e_chmb_evtfifo_full                 := chamber_evtfifos(e_input_idx).dout(10);
                            e_chmb_infifo_full                  := chamber_evtfifos(e_input_idx).dout(9);
                            e_chmb_evtfifo_near_full            := chamber_evtfifos(e_input_idx).dout(8);
                            e_chmb_infifo_near_full             := chamber_evtfifos(e_input_idx).dout(7);
                            e_chmb_infifo_underflow             := chamber_evtfifos(e_input_idx).dout(6);
                            e_chmb_evt_too_big                  := chamber_evtfifos(e_input_idx).dout(5);
                            e_chmb_invalid_vfat_block           := chamber_evtfifos(e_input_idx).dout(4);
                            e_chmb_evt_bigger_24                := chamber_evtfifos(e_input_idx).dout(3);
                            e_chmb_mixed_oh_bc                  := chamber_evtfifos(e_input_idx).dout(2);
                            e_chmb_mixed_vfat_bc                := chamber_evtfifos(e_input_idx).dout(1);
                            e_chmb_mixed_vfat_ec                := chamber_evtfifos(e_input_idx).dout(0);

                            daq_curr_vfat_block <= unsigned(chamber_evtfifos(e_input_idx).dout(23 downto 12)) - 3;
                            
                            -- send the data
                            daq_event_data <= x"000000" & -- Zero suppression flags
                                              std_logic_vector(to_unsigned(e_input_idx, 5)) &    -- Input ID
                                              -- OH word count
                                              std_logic_vector(e_chmb_payload_size(11 downto 0)) &
                                              -- input status
                                              e_chmb_evtfifo_full &
                                              e_chmb_infifo_full &
                                              err_l1afifo_full &
                                              e_chmb_evt_too_big &
                                              e_chmb_evtfifo_near_full &
                                              e_chmb_infifo_near_full &
                                              l1afifo_near_full &
                                              e_chmb_evt_bigger_24 &
                                              e_chmb_invalid_vfat_block &
                                              "0" & -- OOS GLIB-VFAT
                                              "0" & -- OOS GLIB-OH
                                              "0" & -- GLIB-VFAT BX mismatch
                                              "0" & -- GLIB-OH BX mismatch
                                              x"00" & "00"; -- Not used

                            daq_event_header <= '0';
                            daq_event_trailer <= '0';
                            daq_event_write_en <= '1';
                            
                            -- move to the next state
                            e_word_count <= e_word_count + 1;
                            daq_state <= x"5";

                            -- read a block from the input fifo
                            chmb_infifos_rd_en(e_input_idx) <= '1';
                            daq_curr_block_word <= 2;
                        
                        else
                        
                            daq_event_write_en <= '0';
                            
                        end if; 

                    ----==== send the payload ====----
                    elsif (daq_state = x"5") then
                    
                        -- read the next vfat block from the infifo if we're already working with the last word, but it's not yet the last block
                        if ((daq_curr_block_word = 0) and (daq_curr_vfat_block /= x"000")) then
                            chmb_infifos_rd_en(e_input_idx) <= '1';
                            daq_curr_block_word <= 2;
                            daq_curr_vfat_block <= daq_curr_vfat_block - 3; -- this looks strange, but it's because this is not actually vfat_block but number of 64bit words of vfat data
                        -- we are done sending everything -- move on to the next state
                        elsif ((daq_curr_block_word = 0) and (daq_curr_vfat_block = x"0")) then
                            chmb_infifos_rd_en(e_input_idx) <= '0';
                            daq_state <= x"6";
                        -- we've just asserted chmb_infifos_rd_en(e_input_idx), if the valid is still 0, then just wait (make sure chmb_infifos_rd_en(e_input_idx) is 0)
                        elsif ((daq_curr_block_word = 2) and (chamber_infifos(e_input_idx).valid = '0')) then
                            chmb_infifos_rd_en(e_input_idx) <= '0';
                        -- lets move to the next vfat word
                        else
                            chmb_infifos_rd_en(e_input_idx) <= '0';
                            daq_curr_block_word <= daq_curr_block_word - 1;
                        end if;
                        
                        -- send the data!
                        if ((daq_curr_block_word < 2) or (chamber_infifos(e_input_idx).valid = '1')) then
                            daq_event_data <= chamber_infifos(e_input_idx).dout((((daq_curr_block_word + 1) * 64) - 1) downto (daq_curr_block_word * 64));
                            daq_event_header <= '0';
                            daq_event_trailer <= '0';
                            daq_event_write_en <= '1';
                            e_word_count <= e_word_count + 1;
                        else
                            daq_event_write_en <= '0';
                        end if;

                    ----==== send the GEM Chamber trailer ====----
                    elsif (daq_state = x"6") then
                        
                        -- increment the input index if it hasn't maxed out yet
                        if (e_input_idx < g_NUM_OF_OHs - 1) then
                            e_input_idx <= e_input_idx + 1;
                        end if;
                        
                        -- if we have data for the next input or if we've reached the last input
                        if ((e_input_idx >= g_NUM_OF_OHs - 1) or (e_dav_mask(e_input_idx + 1) = '1')) then
                        
                            -- send the data
                            daq_event_data <= x"0000" & -- OH CRC
                                              std_logic_vector(e_chmb_payload_size(11 downto 0)) & -- OH word count
                                              -- GEM chamber status
                                              err_evtfifo_underflow &
                                              "0" &  -- stuck data
                                              "00" & x"00000000";
                            daq_event_header <= '0';
                            daq_event_trailer <= '0';
                            daq_event_write_en <= '1';
                            e_word_count <= e_word_count + 1;
                                
                            -- if we have data for the next input then read the infifo and go to chamber data sending
                            if (e_dav_mask(e_input_idx + 1) = '1') then
                                chmb_evtfifos_rd_en(e_input_idx + 1) <= '1';
                                daq_state <= x"4";                            
                            else -- if next input doesn't have data we can only get here if we're at the last input, so move to the event trailer
                                daq_state <= x"7";
                            end if;
                         
                        else
                        
                            daq_event_write_en <= '0';
                            
                        end if;
                        
                    ----==== send the GEM Event trailer ====----
                    elsif (daq_state = x"7") then

                        daq_event_data <= dav_timeout_flags & -- Chamber timeout
                                          -- Event status (hmm)
                                          x"0" & "000" &
                                          "0" & -- GLIB OOS (different L1A IDs for different inputs)
                                          x"000000" &   -- Chamber error flag (hmm)
                                          -- GLIB status
                                          daq_almost_full &
                                          ttc_status_i.mmcm_locked & 
                                          daq_clk_locked_i & 
                                          daq_ready &
                                          ttc_status_i.bc0_status.locked &
                                          "000";         -- Reserved
                        daq_event_header <= '0';
                        daq_event_trailer <= '0';
                        daq_event_write_en <= '1';
                        e_word_count <= e_word_count + 1;
                        daq_state <= x"8";
                        
                    ----==== send the AMC trailer ====----
                    elsif (daq_state = x"8") then
                    
                        -- send the AMC trailer data
                        daq_event_data <= x"00000000" & e_l1a_id(7 downto 0) & x"0" & std_logic_vector(e_word_count + 1);
                        daq_event_header <= '0';
                        daq_event_trailer <= '1';
                        daq_event_write_en <= '1';
                        
                        -- go back to DAQ idle state
                        daq_state <= x"0";
                        
                        -- reset things
                        e_word_count <= (others => '0');
                        e_input_idx <= 0;
                        cnt_sent_events <= cnt_sent_events + 1;
                        dav_timeout_flags <= x"000000";
                        
                    -- hmm
                    else
                    
                        daq_state <= x"0";
                        
                    end if;
                    
                end if;

            end if;
        end if;        
    end process;

    --================================--
    -- Monitoring & Control
    --================================--
    
--    --== DAQ control ==--
--    ipb_read_reg_data(0)(0) <= daq_enable;
--    ipb_read_reg_data(0)(2) <= reset_daqlink_ipb;
--    ipb_read_reg_data(0)(3) <= reset_local;
--    ipb_read_reg_data(0)(7 downto 4) <= tts_override;
--    ipb_read_reg_data(0)(31 downto 8) <= input_mask;
--    
--    daq_enable <= ipb_write_reg_data(0)(0);
--    reset_daqlink_ipb <= ipb_write_reg_data(0)(2);
--    reset_local <= ipb_write_reg_data(0)(3);
--    tts_override <= ipb_write_reg_data(0)(7 downto 4);
--    input_mask <= ipb_write_reg_data(0)(31 downto 8);
--
--    --== DAQ and TTS state ==--
--    ipb_read_reg_data(1) <= tts_state &
--                            l1afifo_empty &
--                            l1afifo_near_full &
--                            l1afifo_full &
--                            l1afifo_underflow &
--                            err_l1afifo_full &
--                            x"0000" & "00" &
--                            ttc_status_i.bc0_status.locked &
--                            daq_almost_full &
--                            ttc_status_i.mmcm_locked & 
--                            daq_clk_locked_i & 
--                            daq_ready;
--
--    --== DAQLink error counters ==--
--    ipb_read_reg_data(2)(15 downto 0) <= daq_notintable_err_cnt;
--    ipb_read_reg_data(3)(15 downto 0) <= daq_disper_err_cnt;
--    
--    --== Number of received triggers (L1A ID) ==--
--    ipb_read_reg_data(4) <= x"00" & ttc_daq_cntrs_i.l1id;
--
--    --== Number of sent events ==--
--    ipb_read_reg_data(5) <= std_logic_vector(cnt_sent_events);
--    
--    --== DAV Timeout ==--
--    ipb_read_reg_data(6)(23 downto 0) <= std_logic_vector(dav_timeout);
--    dav_timeout <= ipb_write_reg_data(6)(23 downto 0);
--
--    --== DAV Timing stats ==--    
--    ipb_read_reg_data(7)(23 downto 0) <= std_logic_vector(max_dav_timer);
--    ipb_read_reg_data(8)(23 downto 0) <= std_logic_vector(last_dav_timer);
--    
--    --== Software settable run type and run parameters ==--
--    ipb_read_reg_data(15)(27 downto 24) <= run_type;
--    ipb_read_reg_data(15)(23 downto 0) <= run_params;
--
--    run_type <= ipb_write_reg_data(15)(27 downto 24);
--    run_params <= ipb_write_reg_data(15)(23 downto 0);    
--
--    --================================--
--    -- IPbus
--    --================================--
--
--    process(ipb_clk_i)       
--    begin    
--        if (rising_edge(ipb_clk_i)) then      
--            if (ipb_reset_i = '1') then    
--                ipb_miso_o <= (ipb_ack => '0', ipb_err => '0', ipb_rdata => (others => '0'));    
--                ipb_state <= IDLE;
--                ipb_reg_sel <= 0;
--                
--                ipb_write_reg_data <= (others => (others => '0'));
--                ipb_write_reg_data(0)(31 downto 8) <= x"000001"; -- enable the first input by default
--                ipb_write_reg_data(6)(23 downto 0) <= x"03d090"; -- default DAV timeout of 10ms
--                
--                for I in 0 to (g_NUM_OF_OHs - 1) loop
--                    ipb_write_reg_data((I+1)*16 + 3)(23 downto 0) <= x"000c35"; -- default DAV timeout of 10ms
--                end loop;
--            else         
--                case ipb_state is
--                    when IDLE =>                    
--                        ipb_reg_sel <= to_integer(unsigned(ipb_mosi_i.ipb_addr(8 downto 0)));
--                        if (ipb_mosi_i.ipb_strobe = '1') then
--                            ipb_state <= RSPD;
--                        end if;
--                    when RSPD =>
--                        ipb_miso_o <= (ipb_ack => '1', ipb_err => '0', ipb_rdata => ipb_read_reg_data(ipb_reg_sel));
--                        if (ipb_mosi_i.ipb_write = '1') then
--                            ipb_write_reg_data(ipb_reg_sel) <= ipb_mosi_i.ipb_wdata;
--                        end if;
--                        ipb_state <= RST;
--                    when RST =>
--                        ipb_miso_o.ipb_ack <= '0';
--                        ipb_state <= IDLE;
--                    when others => 
--                        ipb_miso_o <= (ipb_ack => '0', ipb_err => '0', ipb_rdata => (others => '0'));    
--                        ipb_state <= IDLE;
--                        ipb_reg_sel <= 0;
--                    end case;
--            end if;        
--        end if;        
--    end process;

    --===============================================================================================
    -- this section is generated by <gem_amc_repo_root>/scripts/generate_registers.py (do not edit) 
    --==== Registers begin ==========================================================================

    -- IPbus slave instanciation
    ipbus_slave_inst : entity work.ipbus_slave
        generic map(
           g_NUM_REGS             => REG_DAQ_NUM_REGS,
           g_ADDR_HIGH_BIT        => REG_DAQ_ADDRESS_MSB,
           g_ADDR_LOW_BIT         => REG_DAQ_ADDRESS_LSB,
           g_USE_INDIVIDUAL_ADDRS => "TRUE"
       )
       port map(
           ipb_reset_i            => ipb_reset_i,
           ipb_clk_i              => ipb_clk_i,
           ipb_mosi_i             => ipb_mosi_i,
           ipb_miso_o             => ipb_miso_o,
           usr_clk_i              => ipb_clk_i,
           regs_read_arr_i        => regs_read_arr,
           regs_write_arr_o       => regs_write_arr,
           read_pulse_arr_o       => regs_read_pulse_arr,
           write_pulse_arr_o      => regs_write_pulse_arr,
           individual_addrs_arr_i => regs_addresses,
           regs_defaults_arr_i    => regs_defaults
      );

    -- Addresses
    regs_addresses(0)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"00";
    regs_addresses(1)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"01";
    regs_addresses(2)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"02";
    regs_addresses(3)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"03";
    regs_addresses(4)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"04";
    regs_addresses(5)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"05";
    regs_addresses(6)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"06";
    regs_addresses(7)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"07";
    regs_addresses(8)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"08";
    regs_addresses(9)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"0f";
    regs_addresses(10)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"11";
    regs_addresses(11)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"12";
    regs_addresses(12)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"13";
    regs_addresses(13)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"17";
    regs_addresses(14)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"18";
    regs_addresses(15)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"19";
    regs_addresses(16)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"1a";
    regs_addresses(17)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"1b";
    regs_addresses(18)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"1c";
    regs_addresses(19)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"1d";
    regs_addresses(20)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"1e";
    regs_addresses(21)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"1f";
    regs_addresses(22)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"21";
    regs_addresses(23)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"22";
    regs_addresses(24)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"23";
    regs_addresses(25)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"27";
    regs_addresses(26)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"28";
    regs_addresses(27)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"29";
    regs_addresses(28)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"2a";
    regs_addresses(29)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"2b";
    regs_addresses(30)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"2c";
    regs_addresses(31)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"2d";
    regs_addresses(32)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"2e";
    regs_addresses(33)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"2f";
    regs_addresses(34)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"31";
    regs_addresses(35)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"32";
    regs_addresses(36)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"33";
    regs_addresses(37)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"37";
    regs_addresses(38)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"38";
    regs_addresses(39)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"39";
    regs_addresses(40)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"3a";
    regs_addresses(41)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"3b";
    regs_addresses(42)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"3c";
    regs_addresses(43)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"3d";
    regs_addresses(44)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"3e";
    regs_addresses(45)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"3f";
    regs_addresses(46)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"41";
    regs_addresses(47)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"42";
    regs_addresses(48)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"43";
    regs_addresses(49)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"47";
    regs_addresses(50)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"48";
    regs_addresses(51)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"49";
    regs_addresses(52)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"4a";
    regs_addresses(53)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"4b";
    regs_addresses(54)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"4c";
    regs_addresses(55)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"4d";
    regs_addresses(56)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"4e";
    regs_addresses(57)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"4f";

    -- Connect read signals
    regs_read_arr(0)(REG_DAQ_CONTROL_DAQ_ENABLE_BIT) <= daq_enable;
    regs_read_arr(0)(REG_DAQ_CONTROL_DAQ_LINK_RESET_BIT) <= reset_daqlink_ipb;
    regs_read_arr(0)(REG_DAQ_CONTROL_RESET_BIT) <= reset_local;
    regs_read_arr(0)(REG_DAQ_CONTROL_TTS_OVERRIDE_MSB downto REG_DAQ_CONTROL_TTS_OVERRIDE_LSB) <= tts_override;
    regs_read_arr(0)(REG_DAQ_CONTROL_INPUT_ENABLE_MASK_MSB downto REG_DAQ_CONTROL_INPUT_ENABLE_MASK_LSB) <= input_mask;
    regs_read_arr(1)(REG_DAQ_STATUS_DAQ_LINK_RDY_BIT) <= daq_ready;
    regs_read_arr(1)(REG_DAQ_STATUS_DAQ_CLK_LOCKED_BIT) <= daq_clk_locked_i;
    regs_read_arr(1)(REG_DAQ_STATUS_TTC_RDY_BIT) <= ttc_status_i.mmcm_locked;
    regs_read_arr(1)(REG_DAQ_STATUS_DAQ_LINK_AFULL_BIT) <= daq_almost_full;
    regs_read_arr(1)(REG_DAQ_STATUS_TTC_BC0_LOCKED_BIT) <= ttc_status_i.bc0_status.locked;
    regs_read_arr(1)(REG_DAQ_STATUS_L1A_FIFO_HAD_OVERFLOW_BIT) <= err_l1afifo_full;
    regs_read_arr(1)(REG_DAQ_STATUS_L1A_FIFO_IS_UNDERFLOW_BIT) <= l1afifo_underflow;
    regs_read_arr(1)(REG_DAQ_STATUS_L1A_FIFO_IS_FULL_BIT) <= l1afifo_full;
    regs_read_arr(1)(REG_DAQ_STATUS_L1A_FIFO_IS_NEAR_FULL_BIT) <= l1afifo_near_full;
    regs_read_arr(1)(REG_DAQ_STATUS_L1A_FIFO_IS_EMPTY_BIT) <= l1afifo_empty;
    regs_read_arr(1)(REG_DAQ_STATUS_TTS_STATE_MSB downto REG_DAQ_STATUS_TTS_STATE_LSB) <= tts_state;
    regs_read_arr(2)(REG_DAQ_EXT_STATUS_NOTINTABLE_ERR_MSB downto REG_DAQ_EXT_STATUS_NOTINTABLE_ERR_LSB) <= daq_notintable_err_cnt;
    regs_read_arr(3)(REG_DAQ_EXT_STATUS_DISPER_ERR_MSB downto REG_DAQ_EXT_STATUS_DISPER_ERR_LSB) <= daq_disper_err_cnt;
    regs_read_arr(4)(REG_DAQ_EXT_STATUS_L1AID_MSB downto REG_DAQ_EXT_STATUS_L1AID_LSB) <= ttc_daq_cntrs_i.l1id;
    regs_read_arr(5)(REG_DAQ_EXT_STATUS_EVT_SENT_MSB downto REG_DAQ_EXT_STATUS_EVT_SENT_LSB) <= std_logic_vector(cnt_sent_events);
    regs_read_arr(6)(REG_DAQ_CONTROL_DAV_TIMEOUT_MSB downto REG_DAQ_CONTROL_DAV_TIMEOUT_LSB) <= dav_timeout;
    regs_read_arr(7)(REG_DAQ_EXT_STATUS_MAX_DAV_TIMER_MSB downto REG_DAQ_EXT_STATUS_MAX_DAV_TIMER_LSB) <= std_logic_vector(max_dav_timer);
    regs_read_arr(8)(REG_DAQ_EXT_STATUS_LAST_DAV_TIMER_MSB downto REG_DAQ_EXT_STATUS_LAST_DAV_TIMER_LSB) <= std_logic_vector(last_dav_timer);
    regs_read_arr(9)(REG_DAQ_EXT_CONTROL_RUN_PARAMS_MSB downto REG_DAQ_EXT_CONTROL_RUN_PARAMS_LSB) <= run_params;
    regs_read_arr(9)(REG_DAQ_EXT_CONTROL_RUN_TYPE_MSB downto REG_DAQ_EXT_CONTROL_RUN_TYPE_LSB) <= run_type;
    regs_read_arr(10)(REG_DAQ_OH0_COUNTERS_CORRUPT_VFAT_BLK_CNT_MSB downto REG_DAQ_OH0_COUNTERS_CORRUPT_VFAT_BLK_CNT_LSB) <= input_status_arr(0).cnt_corrupted_vfat;
    regs_read_arr(11)(REG_DAQ_OH0_COUNTERS_EVN_MSB downto REG_DAQ_OH0_COUNTERS_EVN_LSB) <= input_status_arr(0).eb_event_num;
    regs_read_arr(12)(REG_DAQ_OH0_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH0_CONTROL_EOE_TIMEOUT_LSB) <= input_control_arr(0).eb_timeout_delay;
    regs_read_arr(13)(REG_DAQ_OH0_COUNTERS_MAX_EOE_TIMER_MSB downto REG_DAQ_OH0_COUNTERS_MAX_EOE_TIMER_LSB) <= input_status_arr(0).eb_max_timer;
    regs_read_arr(14)(REG_DAQ_OH0_COUNTERS_LAST_EOE_TIMER_MSB downto REG_DAQ_OH0_COUNTERS_LAST_EOE_TIMER_LSB) <= input_status_arr(0).eb_last_timer;
    regs_read_arr(15)(REG_DAQ_OH0_LASTBLOCK0_MSB downto REG_DAQ_OH0_LASTBLOCK0_LSB) <= input_status_arr(0).ep_vfat_block_data(0);
    regs_read_arr(16)(REG_DAQ_OH0_LASTBLOCK1_MSB downto REG_DAQ_OH0_LASTBLOCK1_LSB) <= input_status_arr(0).ep_vfat_block_data(1);
    regs_read_arr(17)(REG_DAQ_OH0_LASTBLOCK2_MSB downto REG_DAQ_OH0_LASTBLOCK2_LSB) <= input_status_arr(0).ep_vfat_block_data(2);
    regs_read_arr(18)(REG_DAQ_OH0_LASTBLOCK3_MSB downto REG_DAQ_OH0_LASTBLOCK3_LSB) <= input_status_arr(0).ep_vfat_block_data(3);
    regs_read_arr(19)(REG_DAQ_OH0_LASTBLOCK4_MSB downto REG_DAQ_OH0_LASTBLOCK4_LSB) <= input_status_arr(0).ep_vfat_block_data(4);
    regs_read_arr(20)(REG_DAQ_OH0_LASTBLOCK5_MSB downto REG_DAQ_OH0_LASTBLOCK5_LSB) <= input_status_arr(0).ep_vfat_block_data(5);
    regs_read_arr(21)(REG_DAQ_OH0_LASTBLOCK6_MSB downto REG_DAQ_OH0_LASTBLOCK6_LSB) <= input_status_arr(0).ep_vfat_block_data(6);
    regs_read_arr(22)(REG_DAQ_OH1_COUNTERS_CORRUPT_VFAT_BLK_CNT_MSB downto REG_DAQ_OH1_COUNTERS_CORRUPT_VFAT_BLK_CNT_LSB) <= input_status_arr(1).cnt_corrupted_vfat;
    regs_read_arr(23)(REG_DAQ_OH1_COUNTERS_EVN_MSB downto REG_DAQ_OH1_COUNTERS_EVN_LSB) <= input_status_arr(1).eb_event_num;
    regs_read_arr(24)(REG_DAQ_OH1_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH1_CONTROL_EOE_TIMEOUT_LSB) <= input_control_arr(1).eb_timeout_delay;
    regs_read_arr(25)(REG_DAQ_OH1_COUNTERS_MAX_EOE_TIMER_MSB downto REG_DAQ_OH1_COUNTERS_MAX_EOE_TIMER_LSB) <= input_status_arr(1).eb_max_timer;
    regs_read_arr(26)(REG_DAQ_OH1_COUNTERS_LAST_EOE_TIMER_MSB downto REG_DAQ_OH1_COUNTERS_LAST_EOE_TIMER_LSB) <= input_status_arr(1).eb_last_timer;
    regs_read_arr(27)(REG_DAQ_OH1_LASTBLOCK0_MSB downto REG_DAQ_OH1_LASTBLOCK0_LSB) <= input_status_arr(1).ep_vfat_block_data(0);
    regs_read_arr(28)(REG_DAQ_OH1_LASTBLOCK1_MSB downto REG_DAQ_OH1_LASTBLOCK1_LSB) <= input_status_arr(1).ep_vfat_block_data(1);
    regs_read_arr(29)(REG_DAQ_OH1_LASTBLOCK2_MSB downto REG_DAQ_OH1_LASTBLOCK2_LSB) <= input_status_arr(1).ep_vfat_block_data(2);
    regs_read_arr(30)(REG_DAQ_OH1_LASTBLOCK3_MSB downto REG_DAQ_OH1_LASTBLOCK3_LSB) <= input_status_arr(1).ep_vfat_block_data(3);
    regs_read_arr(31)(REG_DAQ_OH1_LASTBLOCK4_MSB downto REG_DAQ_OH1_LASTBLOCK4_LSB) <= input_status_arr(1).ep_vfat_block_data(4);
    regs_read_arr(32)(REG_DAQ_OH1_LASTBLOCK5_MSB downto REG_DAQ_OH1_LASTBLOCK5_LSB) <= input_status_arr(1).ep_vfat_block_data(5);
    regs_read_arr(33)(REG_DAQ_OH1_LASTBLOCK6_MSB downto REG_DAQ_OH1_LASTBLOCK6_LSB) <= input_status_arr(1).ep_vfat_block_data(6);
    regs_read_arr(34)(REG_DAQ_OH2_COUNTERS_CORRUPT_VFAT_BLK_CNT_MSB downto REG_DAQ_OH2_COUNTERS_CORRUPT_VFAT_BLK_CNT_LSB) <= input_status_arr(2).cnt_corrupted_vfat;
    regs_read_arr(35)(REG_DAQ_OH2_COUNTERS_EVN_MSB downto REG_DAQ_OH2_COUNTERS_EVN_LSB) <= input_status_arr(2).eb_event_num;
    regs_read_arr(36)(REG_DAQ_OH2_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH2_CONTROL_EOE_TIMEOUT_LSB) <= input_control_arr(2).eb_timeout_delay;
    regs_read_arr(37)(REG_DAQ_OH2_COUNTERS_MAX_EOE_TIMER_MSB downto REG_DAQ_OH2_COUNTERS_MAX_EOE_TIMER_LSB) <= input_status_arr(2).eb_max_timer;
    regs_read_arr(38)(REG_DAQ_OH2_COUNTERS_LAST_EOE_TIMER_MSB downto REG_DAQ_OH2_COUNTERS_LAST_EOE_TIMER_LSB) <= input_status_arr(2).eb_last_timer;
    regs_read_arr(39)(REG_DAQ_OH2_LASTBLOCK0_MSB downto REG_DAQ_OH2_LASTBLOCK0_LSB) <= input_status_arr(2).ep_vfat_block_data(0);
    regs_read_arr(40)(REG_DAQ_OH2_LASTBLOCK1_MSB downto REG_DAQ_OH2_LASTBLOCK1_LSB) <= input_status_arr(2).ep_vfat_block_data(1);
    regs_read_arr(41)(REG_DAQ_OH2_LASTBLOCK2_MSB downto REG_DAQ_OH2_LASTBLOCK2_LSB) <= input_status_arr(2).ep_vfat_block_data(2);
    regs_read_arr(42)(REG_DAQ_OH2_LASTBLOCK3_MSB downto REG_DAQ_OH2_LASTBLOCK3_LSB) <= input_status_arr(2).ep_vfat_block_data(3);
    regs_read_arr(43)(REG_DAQ_OH2_LASTBLOCK4_MSB downto REG_DAQ_OH2_LASTBLOCK4_LSB) <= input_status_arr(2).ep_vfat_block_data(4);
    regs_read_arr(44)(REG_DAQ_OH2_LASTBLOCK5_MSB downto REG_DAQ_OH2_LASTBLOCK5_LSB) <= input_status_arr(2).ep_vfat_block_data(5);
    regs_read_arr(45)(REG_DAQ_OH2_LASTBLOCK6_MSB downto REG_DAQ_OH2_LASTBLOCK6_LSB) <= input_status_arr(2).ep_vfat_block_data(6);
    regs_read_arr(46)(REG_DAQ_OH3_COUNTERS_CORRUPT_VFAT_BLK_CNT_MSB downto REG_DAQ_OH3_COUNTERS_CORRUPT_VFAT_BLK_CNT_LSB) <= input_status_arr(3).cnt_corrupted_vfat;
    regs_read_arr(47)(REG_DAQ_OH3_COUNTERS_EVN_MSB downto REG_DAQ_OH3_COUNTERS_EVN_LSB) <= input_status_arr(3).eb_event_num;
    regs_read_arr(48)(REG_DAQ_OH3_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH3_CONTROL_EOE_TIMEOUT_LSB) <= input_control_arr(3).eb_timeout_delay;
    regs_read_arr(49)(REG_DAQ_OH3_COUNTERS_MAX_EOE_TIMER_MSB downto REG_DAQ_OH3_COUNTERS_MAX_EOE_TIMER_LSB) <= input_status_arr(3).eb_max_timer;
    regs_read_arr(50)(REG_DAQ_OH3_COUNTERS_LAST_EOE_TIMER_MSB downto REG_DAQ_OH3_COUNTERS_LAST_EOE_TIMER_LSB) <= input_status_arr(3).eb_last_timer;
    regs_read_arr(51)(REG_DAQ_OH3_LASTBLOCK0_MSB downto REG_DAQ_OH3_LASTBLOCK0_LSB) <= input_status_arr(3).ep_vfat_block_data(0);
    regs_read_arr(52)(REG_DAQ_OH3_LASTBLOCK1_MSB downto REG_DAQ_OH3_LASTBLOCK1_LSB) <= input_status_arr(3).ep_vfat_block_data(1);
    regs_read_arr(53)(REG_DAQ_OH3_LASTBLOCK2_MSB downto REG_DAQ_OH3_LASTBLOCK2_LSB) <= input_status_arr(3).ep_vfat_block_data(2);
    regs_read_arr(54)(REG_DAQ_OH3_LASTBLOCK3_MSB downto REG_DAQ_OH3_LASTBLOCK3_LSB) <= input_status_arr(3).ep_vfat_block_data(3);
    regs_read_arr(55)(REG_DAQ_OH3_LASTBLOCK4_MSB downto REG_DAQ_OH3_LASTBLOCK4_LSB) <= input_status_arr(3).ep_vfat_block_data(4);
    regs_read_arr(56)(REG_DAQ_OH3_LASTBLOCK5_MSB downto REG_DAQ_OH3_LASTBLOCK5_LSB) <= input_status_arr(3).ep_vfat_block_data(5);
    regs_read_arr(57)(REG_DAQ_OH3_LASTBLOCK6_MSB downto REG_DAQ_OH3_LASTBLOCK6_LSB) <= input_status_arr(3).ep_vfat_block_data(6);

    -- Connect write signals
    daq_enable <= regs_write_arr(0)(REG_DAQ_CONTROL_DAQ_ENABLE_BIT);
    reset_daqlink_ipb <= regs_write_arr(0)(REG_DAQ_CONTROL_DAQ_LINK_RESET_BIT);
    reset_local <= regs_write_arr(0)(REG_DAQ_CONTROL_RESET_BIT);
    tts_override <= regs_write_arr(0)(REG_DAQ_CONTROL_TTS_OVERRIDE_MSB downto REG_DAQ_CONTROL_TTS_OVERRIDE_LSB);
    input_mask <= regs_write_arr(0)(REG_DAQ_CONTROL_INPUT_ENABLE_MASK_MSB downto REG_DAQ_CONTROL_INPUT_ENABLE_MASK_LSB);
    dav_timeout <= regs_write_arr(6)(REG_DAQ_CONTROL_DAV_TIMEOUT_MSB downto REG_DAQ_CONTROL_DAV_TIMEOUT_LSB);
    run_params <= regs_write_arr(9)(REG_DAQ_EXT_CONTROL_RUN_PARAMS_MSB downto REG_DAQ_EXT_CONTROL_RUN_PARAMS_LSB);
    run_type <= regs_write_arr(9)(REG_DAQ_EXT_CONTROL_RUN_TYPE_MSB downto REG_DAQ_EXT_CONTROL_RUN_TYPE_LSB);
    input_control_arr(0).eb_timeout_delay <= regs_write_arr(12)(REG_DAQ_OH0_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH0_CONTROL_EOE_TIMEOUT_LSB);
    input_control_arr(1).eb_timeout_delay <= regs_write_arr(24)(REG_DAQ_OH1_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH1_CONTROL_EOE_TIMEOUT_LSB);
    input_control_arr(2).eb_timeout_delay <= regs_write_arr(36)(REG_DAQ_OH2_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH2_CONTROL_EOE_TIMEOUT_LSB);
    input_control_arr(3).eb_timeout_delay <= regs_write_arr(48)(REG_DAQ_OH3_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH3_CONTROL_EOE_TIMEOUT_LSB);

    -- Defaults
    regs_defaults(0)(REG_DAQ_CONTROL_DAQ_ENABLE_BIT) <= REG_DAQ_CONTROL_DAQ_ENABLE_DEFAULT;
    regs_defaults(0)(REG_DAQ_CONTROL_DAQ_LINK_RESET_BIT) <= REG_DAQ_CONTROL_DAQ_LINK_RESET_DEFAULT;
    regs_defaults(0)(REG_DAQ_CONTROL_RESET_BIT) <= REG_DAQ_CONTROL_RESET_DEFAULT;
    regs_defaults(0)(REG_DAQ_CONTROL_TTS_OVERRIDE_MSB downto REG_DAQ_CONTROL_TTS_OVERRIDE_LSB) <= REG_DAQ_CONTROL_TTS_OVERRIDE_DEFAULT;
    regs_defaults(0)(REG_DAQ_CONTROL_INPUT_ENABLE_MASK_MSB downto REG_DAQ_CONTROL_INPUT_ENABLE_MASK_LSB) <= REG_DAQ_CONTROL_INPUT_ENABLE_MASK_DEFAULT;
    regs_defaults(6)(REG_DAQ_CONTROL_DAV_TIMEOUT_MSB downto REG_DAQ_CONTROL_DAV_TIMEOUT_LSB) <= REG_DAQ_CONTROL_DAV_TIMEOUT_DEFAULT;
    regs_defaults(9)(REG_DAQ_EXT_CONTROL_RUN_PARAMS_MSB downto REG_DAQ_EXT_CONTROL_RUN_PARAMS_LSB) <= REG_DAQ_EXT_CONTROL_RUN_PARAMS_DEFAULT;
    regs_defaults(9)(REG_DAQ_EXT_CONTROL_RUN_TYPE_MSB downto REG_DAQ_EXT_CONTROL_RUN_TYPE_LSB) <= REG_DAQ_EXT_CONTROL_RUN_TYPE_DEFAULT;
    regs_defaults(12)(REG_DAQ_OH0_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH0_CONTROL_EOE_TIMEOUT_LSB) <= REG_DAQ_OH0_CONTROL_EOE_TIMEOUT_DEFAULT;
    regs_defaults(24)(REG_DAQ_OH1_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH1_CONTROL_EOE_TIMEOUT_LSB) <= REG_DAQ_OH1_CONTROL_EOE_TIMEOUT_DEFAULT;
    regs_defaults(36)(REG_DAQ_OH2_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH2_CONTROL_EOE_TIMEOUT_LSB) <= REG_DAQ_OH2_CONTROL_EOE_TIMEOUT_DEFAULT;
    regs_defaults(48)(REG_DAQ_OH3_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH3_CONTROL_EOE_TIMEOUT_LSB) <= REG_DAQ_OH3_CONTROL_EOE_TIMEOUT_DEFAULT;

    --==== Registers end ============================================================================

    
end Behavioral;

