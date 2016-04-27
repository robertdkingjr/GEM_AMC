-------------------------------------------------------------------------------
--                                                                            
--       Unit Name: gem_board_config_package
--                                                                            
--     Description: Configuration for GLIB board
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
use work.gem_pkg.all;

--============================================================================
--                                                         Package declaration
--============================================================================
package gem_board_config_package is
	constant CFG_NUM_OF_OHs		: integer := 2;
	
	constant CFG_OH_LINK_CONFIG_ARR : t_oh_link_config_arr := (
		(0, 0, 1, 1),	-- OH 0 (for now just duplicate track for gbt and trig0 for trig1 since they don't exist in the design, but change this if you add them) 
		(2, 2, 3, 3)	-- OH 1 (for now just duplicate track for gbt and trig0 for trig1 since they don't exist in the design, but change this if you add them) 
	);

end package gem_board_config_package;
--============================================================================
--                                                                 Package end 
--============================================================================

