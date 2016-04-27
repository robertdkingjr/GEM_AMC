-------------------------------------------------------------------------------
--                                                                            
--       Unit Name: gem_board_config_package
--                                                                            
--     Description: Configuration for CTP7 board
--
--                                                                            
-------------------------------------------------------------------------------
--                                                                            
--           Notes:                                                           
--                                                                            
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

library work;
use work.gem_pkg.t_oh_link_config_arr;

--============================================================================
--                                                         Package declaration
--============================================================================
package gem_board_config_package is
	constant CFG_NUM_OF_OHs		: integer := 2;
	
	constant CFG_OH_LINK_CONFIG_ARR : t_oh_link_config_arr := (
		(6, 6, 7, 7),	-- OH 0 (for now just duplicate track for gbt and trig0 for trig1 since they don't exist in the design, but change this if you add them) 
		(8, 8, 9, 9)	-- OH 1 (for now just duplicate track for gbt and trig0 for trig1 since they don't exist in the design, but change this if you add them) 
	);

end package gem_board_config_package;
--============================================================================
--                                                                 Package end 
--============================================================================

