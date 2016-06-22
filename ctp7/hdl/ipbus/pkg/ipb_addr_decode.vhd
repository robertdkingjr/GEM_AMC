library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use work.ipbus.all;

package ipb_addr_decode is

    type t_integer_arr is array (natural range <>) of integer;
    type t_ipb_slv is record
        oh_reg           : t_integer_arr(0 to 15);
        oh_evt         : t_integer_arr(0 to 15);
        oh_links         : integer;
        daq              : integer;
        ttc              : integer;
        trigger          : integer;
        system           : integer;
    end record;

    constant C_NUM_IPB_SLAVES : integer := 37;

    -- IPbus slave index definition
    constant C_IPB_SLV : t_ipb_slv := (oh_reg => (0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30),
        oh_evt => (1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31),
        ttc => 32,
        oh_links => 33,
        daq => 34,
        trigger => 35,
        system => 36);

    function ipb_addr_sel(signal addr : in std_logic_vector(31 downto 0)) return integer;
    
end ipb_addr_decode;

package body ipb_addr_decode is

	function ipb_addr_sel(signal addr : in std_logic_vector(31 downto 0)) return integer is
		variable sel : integer;
	begin
  
    -- The addressing below uses 24 usable bits. Note that this supports "only" up to 16 OHs and up to 12 bits of OH in-module addressing.
    -- Addressing goes like this: [23:20] - AMC module. Module 0x4 is OH reg forwarding where addressing is [19:16] - OH number, [15:12] - OH module, [11:0] - address within module
    -- AMC modules:
    --   0x3: TTC
    --   0x4: OH register access
    --   0x5: Tracking data FIFO (non related to DAQ module, just pure VFAT data as received from OH)
    --   0x6: Counters
    --   0x7: DAQ
    --   0x8: Trigger

    -- TTC
    if    std_match(addr, "--------0011000000000000000-----") then sel := C_IPB_SLV.ttc;

	  -- OH register access request forwarding (minimal change from GLIB, but limited to 16 OHs): [26:22] - OH number, [21:18] - OH module, [17:2] - address within module
	  -- One exception is the VFAT 
    elsif std_match(addr, "--------010-0000----------------") then sel := C_IPB_SLV.oh_reg(0);
    elsif std_match(addr, "--------010-0001----------------") then sel := C_IPB_SLV.oh_reg(1);
    elsif std_match(addr, "--------010-0010----------------") then sel := C_IPB_SLV.oh_reg(2);
    elsif std_match(addr, "--------010-0011----------------") then sel := C_IPB_SLV.oh_reg(3);
    elsif std_match(addr, "--------010-0100----------------") then sel := C_IPB_SLV.oh_reg(4);
    elsif std_match(addr, "--------010-0101----------------") then sel := C_IPB_SLV.oh_reg(5);
    elsif std_match(addr, "--------010-0110----------------") then sel := C_IPB_SLV.oh_reg(6);
    elsif std_match(addr, "--------010-0111----------------") then sel := C_IPB_SLV.oh_reg(7);
    elsif std_match(addr, "--------010-1000----------------") then sel := C_IPB_SLV.oh_reg(8);
    elsif std_match(addr, "--------010-1001----------------") then sel := C_IPB_SLV.oh_reg(9);
    elsif std_match(addr, "--------010-1010----------------") then sel := C_IPB_SLV.oh_reg(10);
    elsif std_match(addr, "--------010-1011----------------") then sel := C_IPB_SLV.oh_reg(11);
    elsif std_match(addr, "--------010-1100----------------") then sel := C_IPB_SLV.oh_reg(12);
    elsif std_match(addr, "--------010-1101----------------") then sel := C_IPB_SLV.oh_reg(13);
    elsif std_match(addr, "--------010-1110----------------") then sel := C_IPB_SLV.oh_reg(14);
    elsif std_match(addr, "--------010-1111----------------") then sel := C_IPB_SLV.oh_reg(15);

    -- VFAT register forwarding
    elsif std_match(addr, "--------01010000000-------------") then sel := C_IPB_SLV.oh_evt(0);
    elsif std_match(addr, "--------01010001000-------------") then sel := C_IPB_SLV.oh_evt(1);
    elsif std_match(addr, "--------01010010000-------------") then sel := C_IPB_SLV.oh_evt(2);
    elsif std_match(addr, "--------01010011000-------------") then sel := C_IPB_SLV.oh_evt(3);
    elsif std_match(addr, "--------01010100000-------------") then sel := C_IPB_SLV.oh_evt(4);
    elsif std_match(addr, "--------01010101000-------------") then sel := C_IPB_SLV.oh_evt(5);
    elsif std_match(addr, "--------01010110000-------------") then sel := C_IPB_SLV.oh_evt(6);
    elsif std_match(addr, "--------01010111000-------------") then sel := C_IPB_SLV.oh_evt(7);
    elsif std_match(addr, "--------01011000000-------------") then sel := C_IPB_SLV.oh_evt(8);
    elsif std_match(addr, "--------01011001000-------------") then sel := C_IPB_SLV.oh_evt(9);
    elsif std_match(addr, "--------01011010000-------------") then sel := C_IPB_SLV.oh_evt(10);
    elsif std_match(addr, "--------01011011000-------------") then sel := C_IPB_SLV.oh_evt(11);
    elsif std_match(addr, "--------01011100000-------------") then sel := C_IPB_SLV.oh_evt(12);
    elsif std_match(addr, "--------01011101000-------------") then sel := C_IPB_SLV.oh_evt(13);
    elsif std_match(addr, "--------01011110000-------------") then sel := C_IPB_SLV.oh_evt(14);
    elsif std_match(addr, "--------01011111000-------------") then sel := C_IPB_SLV.oh_evt(15);

    -- other AMC modules
    elsif std_match(addr, "--------01100000000-------------") then sel := C_IPB_SLV.oh_links;
    elsif std_match(addr, "--------011100000000000---------") then sel := C_IPB_SLV.daq;
    elsif std_match(addr, "--------10000000000-------------") then sel := C_IPB_SLV.trigger;
    elsif std_match(addr, "--------1001000-----------------") then sel := C_IPB_SLV.system;
    else sel := 999;
    end if;

-- GLIB old addressing:
--		if    std_match(addr, "0100----00000000----------------") then sel := C_IPB_SLV.oh_reg(0);
--		elsif std_match(addr, "0100----00010000----------------") then sel := C_IPB_SLV.oh_reg(1);
--		elsif std_match(addr, "010100000000000000000000000000--") then sel := C_IPB_SLV.oh_evt(0);
--		elsif std_match(addr, "010100000001000000000000000000--") then sel := C_IPB_SLV.oh_evt(1);
--		elsif std_match(addr, "011000000000000000000000--------") then sel := C_IPB_SLV.counters;
--		elsif std_match(addr, "01110000000000000000000---------") then sel := C_IPB_SLV.daq;
--		elsif std_match(addr, "01111000000000000000000---------") then sel := C_IPB_SLV.trigger;
--		elsif std_match(addr, "01111100000000000000000000000---") then sel := C_IPB_SLV.ttc;
--		else sel := 99;
--		end if;
		return sel;
	end ipb_addr_sel;

end ipb_addr_decode;