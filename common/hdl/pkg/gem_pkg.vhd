library ieee;
use ieee.std_logic_1164.all;

library work;
use work.gem_board_config_package.CFG_NUM_OF_OHs;

package gem_pkg is

    --======================--
    --== Config Constants ==--
    --======================-- 
    
    -- DAQ
    constant DAQ_FORMAT_VERSION         : std_logic_vector(3 downto 0)  := x"0";

    --============--
    --== Common ==--
    --============--   
    
    type t_std_array is array(integer range <>) of std_logic;
    
    type t_std32_array is array(integer range <>) of std_logic_vector(31 downto 0);
        
    type t_std16_array is array(integer range <>) of std_logic_vector(15 downto 0);

    type t_std4_array is array(integer range <>) of std_logic_vector(3 downto 0);

    --========================--
    --== Link configuration ==--
    --========================--

	-- defines the GT index for each type of OH link
	type t_oh_link_config is record
		track_link		: integer range 0 to 79;
		gbt_link		: integer range 0 to 79;
		trig0_rx_link	: integer range 0 to 79;
		trig1_rx_link	: integer range 0 to 79;
	end record t_oh_link_config;
	
	type t_oh_link_config_arr is array (0 to NUM_OF_OHs-1) of t_oh_link_config;

    --========================--
    --== Trigger data input ==--
    --========================--

    type t_trig_link is record
        clk         : std_logic;
        data        : std_logic_vector(55 downto 0);
        data_en     : std_logic;
    end record;

    type t_trig_link_array is array(integer range <>) of t_trig_link;    

    --====================--
    --==       TTC      ==--
    --====================--

    type t_gem_ttc_cmd is record
        l1a         : std_logic;
        bc0         : std_logic;
        ec0         : std_logic;
        oc0         : std_logic;
        calpulse    : std_logic;
        start       : std_logic;
        stop        : std_logic;
        resync      : std_logic;
        hard_reset  : std_logic;
    end record;

    type t_gem_ttc_cnt is record
        bx_id       : std_logic_vector(11 downto 0); -- BX counter (reset with BC0)
        orbit_id    : std_logic_vector(15 downto 0); -- Orbit counter (wraps around and is reset with EC0)
        l1a_id      : std_logic_vector(23 downto 0);  -- L1A counter (reset with EC0)
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

    --====================--
    --==   DAQ other    ==--
    --====================--
    
    type t_chamber_err_flags is record
        infifo_full             : std_logic;
        infifo_underflow        : std_logic;
        evtfifo_full            : std_logic;
        evtfifo_underflow       : std_logic;
        event_too_big           : std_logic;
        vfat_block_too_small    : std_logic;
        vfat_block_too_big      : std_logic;
    end record;

    type t_chamber_err_flags_array is array(integer range <>) of chamber_err_flags_t;
    
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
end gem_pkg;