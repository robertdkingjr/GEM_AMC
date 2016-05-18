library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.gem_board_config_package.CFG_NUM_OF_OHs;

package gem_pkg is

    --========================--
    --==  Firmware version  ==--
    --========================-- 

    constant C_FIRMWARE_DATE    : std_logic_vector(31 downto 0) := x"20160517";
    constant C_FIRMWARE_MAJOR   : integer range 0 to 255        := 1;
    constant C_FIRMWARE_MINOR   : integer range 0 to 255        := 3;
    constant C_FIRMWARE_BUILD   : integer range 0 to 255        := 4;

    --======================--
    --==      General     ==--
    --======================-- 
        
    constant C_LED_PULSE_LENGTH_TTC_CLK : std_logic_vector(20 downto 0) := std_logic_vector(to_unsigned(1_600_000, 21));

    function count_ones(s : std_logic_vector) return integer;

    --======================--
    --== Config Constants ==--
    --======================-- 
    
    -- DAQ
    constant C_DAQ_FORMAT_VERSION     : std_logic_vector(3 downto 0)  := x"0";

    --============--
    --== Common ==--
    --============--   
    
    type t_std_array is array(integer range <>) of std_logic;
    
    type t_std32_array is array(integer range <>) of std_logic_vector(31 downto 0);
        
    type t_std16_array is array(integer range <>) of std_logic_vector(15 downto 0);

    type t_std4_array is array(integer range <>) of std_logic_vector(3 downto 0);

    --========================--
    --== GTH/GTX link types ==--
    --========================--

    type t_gt_8b10b_tx_data is record
        txdata         : std_logic_vector(31 downto 0);
        txcharisk      : std_logic_vector(3 downto 0);
        txchardispmode : std_logic_vector(3 downto 0);
        txchardispval  : std_logic_vector(3 downto 0);
    end record;

    type t_gt_8b10b_rx_data is record
        rxdata          : std_logic_vector(31 downto 0);
        rxbyteisaligned : std_logic;
        rxbyterealign   : std_logic;
        rxcommadet      : std_logic;
        rxdisperr       : std_logic_vector(3 downto 0);
        rxnotintable    : std_logic_vector(3 downto 0);
        rxchariscomma   : std_logic_vector(3 downto 0);
        rxcharisk       : std_logic_vector(3 downto 0);
    end record;

    type t_gt_8b10b_tx_data_arr is array(integer range <>) of t_gt_8b10b_tx_data;
    type t_gt_8b10b_rx_data_arr is array(integer range <>) of t_gt_8b10b_rx_data;

    --========================--
    --== SBit cluster data  ==--
    --========================--

    type t_sbit_cluster is record
        size        : std_logic_vector(2 downto 0);
        address     : std_logic_vector(10 downto 0);
    end record;

    type t_oh_sbits is array(7 downto 0) of t_sbit_cluster;
    type t_oh_sbits_arr is array(integer range <>) of t_oh_sbits;

    type t_sbit_link_status is record
        valid           : std_logic;
        sync_word       : std_logic;
        missed_comma    : std_logic;
        underflow       : std_logic;
        overflow        : std_logic;
    end record;

    type t_oh_sbit_links is array(1 downto 0) of t_sbit_link_status;    
    type t_oh_sbit_links_arr is array(integer range <>) of t_oh_sbit_links;

    --====================--
    --==     DAQLink    ==--
    --====================--

    type t_daq_to_daqlink is record
        reset           : std_logic;
        ttc_clk         : std_logic;
        ttc_bc0         : std_logic;
        trig            : std_logic_vector(7 downto 0);
        tts_clk         : std_logic;
        tts_state       : std_logic_vector(3 downto 0);
        resync          : std_logic;
        event_clk       : std_logic;
        event_valid     : std_logic;
        event_header    : std_logic;
        event_trailer   : std_logic;
        event_data      : std_logic_vector(63 downto 0);
    end record;

    type t_daqlink_to_daq is record
        ready           : std_logic;
        almost_full     : std_logic;
    end record;

    --====================--
    --== DAQ data input ==--
    --====================--
    
    type t_data_link is record
        clk        : std_logic;
        data_en    : std_logic;
        data       : std_logic_vector(15 downto 0);
    end record;
    
    type t_data_link_array is array(integer range <>) of t_data_link;    

    --=====================================--
    --==   DAQ input status and control  ==--
    --=====================================--
    
    type t_daq_input_status is record
        evtfifo_empty           : std_logic;
        evtfifo_near_full       : std_logic;
        evtfifo_full            : std_logic;
        evtfifo_underflow       : std_logic;
        infifo_empty            : std_logic;
        infifo_near_full        : std_logic;
        infifo_full             : std_logic;
        infifo_underflow        : std_logic;
        tts_state               : std_logic_vector(3 downto 0);
        err_event_too_big       : std_logic;
        err_evtfifo_full        : std_logic;
        err_infifo_underflow    : std_logic;
        err_infifo_full         : std_logic;
        err_corrupted_vfat_data : std_logic;
        err_vfat_block_too_big  : std_logic;
        err_vfat_block_too_small: std_logic;
        err_event_bigger_than_24: std_logic;
        err_mixed_oh_bc         : std_logic;
        err_mixed_vfat_bc       : std_logic;
        err_mixed_vfat_ec       : std_logic;
        cnt_corrupted_vfat      : std_logic_vector(31 downto 0);
        eb_event_num            : std_logic_vector(23 downto 0);
        eb_max_timer            : std_logic_vector(23 downto 0);
        eb_last_timer           : std_logic_vector(23 downto 0);
        ep_vfat_block_data      : t_std32_array(6 downto 0);
    end record;

    type t_daq_input_status_arr is array(integer range <>) of t_daq_input_status;

    type t_daq_input_control is record
        eb_timeout_delay        : std_logic_vector(23 downto 0);
    end record;
    
    type t_daq_input_control_arr is array(integer range <>) of t_daq_input_control;

    --====================--
    --==   DAQ other    ==--
    --====================--

    type t_chamber_infifo_rd is record
        dout          : std_logic_vector(191 downto 0);
        rd_en         : std_logic;
        empty         : std_logic;
        valid         : std_logic;
        underflow     : std_logic;
    end record;

    type t_chamber_infifo_rd_array is array(integer range <>) of t_chamber_infifo_rd;

    type t_chamber_evtfifo_rd is record
        dout          : std_logic_vector(59 downto 0);
        rd_en         : std_logic;
        empty         : std_logic;
        valid         : std_logic;
        underflow     : std_logic;
    end record;

    type t_chamber_evtfifo_rd_array is array(integer range <>) of t_chamber_evtfifo_rd;

    --====================--
    --==     OH Link    ==--
    --====================--

    type t_sync_fifo_status is record
        ovf         : std_logic;
        unf         : std_logic;
    end record;
    
    type t_gt_status is record
        not_in_table    : std_logic;
        disperr         : std_logic;
    end record;

    type t_oh_link_status is record
        tk_error            : std_logic;
        evt_rcvd            : std_logic;
        tk_tx_sync_status   : t_sync_fifo_status;      
        tk_rx_sync_status   : t_sync_fifo_status;      
        tr0_rx_sync_status  : t_sync_fifo_status;      
        tr1_rx_sync_status  : t_sync_fifo_status;
        tk_rx_gt_status     : t_gt_status;     
        tr0_rx_gt_status    : t_gt_status;     
        tr1_rx_gt_status    : t_gt_status;     
    end record;
    
    type t_oh_link_status_arr is array(integer range <>) of t_oh_link_status;    
        
    --================--
    --== T1 command ==--
    --================--
    
    type t_t1 is record
        lv1a        : std_logic;
        calpulse    : std_logic;
        resync      : std_logic;
        bc0         : std_logic;
    end record;
    
    type t_t1_array is array(integer range <>) of t_t1;
	
end gem_pkg;
   
package body gem_pkg is

    function count_ones(s : std_logic_vector) return integer is
        variable temp : natural := 0;
    begin
        for i in s'range loop
            if s(i) = '1' then
                temp := temp + 1;
            end if;
        end loop;

        return temp;
    end function count_ones;
    
end gem_pkg;