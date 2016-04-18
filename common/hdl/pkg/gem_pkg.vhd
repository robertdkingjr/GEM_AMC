library ieee;
use ieee.std_logic_1164.all;
 
package gem_pkg is

    --=== system options ========--
    
    constant sys_eth_p1_enable          : boolean  := false;   
    constant sys_pcie_enable            : boolean  := false;      
    
    --=== i2c master components ==--
    
    constant i2c_master_enable			    : boolean  := true;
    constant auto_eeprom_read_enable    : boolean  := true;    
    
    --=== wishbone slaves ========--
    
    constant number_of_wb_slaves		    : positive := 1;
    
    constant user_wb_regs               : integer  := 0;
    
    --=== ipb slaves =============--
    
    constant number_of_ipb_slaves		    : positive := 8;

    constant ipb_gtx_forward_0          : integer  := 0;
    constant ipb_gtx_forward_1          : integer  := 1;
    constant ipb_evt_data_0             : integer  := 2;
    constant ipb_evt_data_1             : integer  := 3;
    constant ipb_counters               : integer  := 4;
    constant ipb_daq                    : integer  := 5;
    constant ipb_trigger                : integer  := 6;
    constant ipb_ttc                    : integer  := 7;

    --=== gtx links =============--
    
    constant number_of_optohybrids      : integer  := 2;    
    
    --=== gtx links =============--

    constant daq_format_version         : std_logic_vector(3 downto 0)  := x"0";

    --============--
    --== Common ==--
    --============--   
    
    type std_array_t is array(integer range <>) of std_logic;
    
    type std32_array_t is array(integer range <>) of std_logic_vector(31 downto 0);
        
    type std16_array_t is array(integer range <>) of std_logic_vector(15 downto 0);

    type std4_array_t is array(integer range <>) of std_logic_vector(3 downto 0);

    --========================--
    --== Register requests  ==-- -- TODO this is temporary!
    --========================--
    type t_reg_request is record
        axi_reg_clk             : std_logic;
        addr                    : std_logic_vector(31 downto 0);
        en                      : std_logic;
        data                    : std_logic_vector(31 downto 0);
        we                      : std_logic;
    end record;    
    
    type t_reg_response is record
        data                    : std_logic_vector(31 downto 0);
        en                      : std_logic;
    end record;

    type t_reg_request_arr is array(integer range <>) of t_reg_request;
    type t_reg_response_arr is array(integer range <>) of t_reg_response;

    --========================--
    --== Trigger data input ==--
    --========================--

    type trig_link_t is record
        clk         : std_logic;
        data        : std_logic_vector(55 downto 0);
        data_en     : std_logic;
    end record;

    type trig_link_array_t is array(integer range <>) of trig_link_t;    

    --====================--
    --== DAQ data input ==--
    --====================--
    
    type data_link_t is record
        clk        : std_logic;
        data_en    : std_logic;
        data       : std_logic_vector(15 downto 0);
    end record;
    
    type data_link_array_t is array(integer range <>) of data_link_t;    

    --====================--
    --==   DAQ other    ==--
    --====================--
    
    type chamber_err_glags_t is record
        infifo_full             : std_logic;
        infifo_underflow        : std_logic;
        evtfifo_full            : std_logic;
        evtfifo_underflow       : std_logic;
        event_too_big           : std_logic;
        vfat_block_too_small    : std_logic;
        vfat_block_too_big      : std_logic;
    end record;

    type chamber_err_glags_array_t is array(integer range <>) of chamber_err_glags_t;
    
    type chamber_infifo_rd_t is record
        dout          : std_logic_vector(191 downto 0);
        rd_en         : std_logic;
        empty         : std_logic;
        valid         : std_logic;
        underflow     : std_logic;
    end record;

    type chamber_infifo_rd_array_t is array(integer range <>) of chamber_infifo_rd_t;

    type chamber_evtfifo_rd_t is record
        dout          : std_logic_vector(59 downto 0);
        rd_en         : std_logic;
        empty         : std_logic;
        valid         : std_logic;
        underflow     : std_logic;
    end record;

    type chamber_evtfifo_rd_array_t is array(integer range <>) of chamber_evtfifo_rd_t;
    
    --================--
    --== T1 command ==--
    --================--
    
    type t1_t is record
        lv1a        : std_logic;
        calpulse    : std_logic;
        resync      : std_logic;
        bc0         : std_logic;
    end record;
    
    type t1_array_t is array(integer range <>) of t1_t;
	
end gem_pkg;
   
package body gem_pkg is
end gem_pkg;