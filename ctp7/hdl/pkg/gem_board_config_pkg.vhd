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

--============================================================================
--                                                         Package declaration
--============================================================================
package gem_board_config_package is

    --constant CFG_NUM_OF_OHs     : integer := 2;
    constant CFG_NUM_OF_OHs     : integer := 4;


    --========================--
    --== Link configuration ==--
    --========================--

    -- defines the GT index for each type of OH link
    type t_oh_link_config is record
        track_link      : integer range 0 to 79;
        gbt_link        : integer range 0 to 79;
        trig0_rx_link   : integer range 0 to 79;
        trig1_rx_link   : integer range 0 to 79;
    end record t_oh_link_config;
    
    type t_oh_link_config_arr is array (0 to CFG_NUM_OF_OHs - 1) of t_oh_link_config;
	
	constant CFG_OH_LINK_CONFIG_ARR : t_oh_link_config_arr := (
        --(6, 6, 7, 8),   -- OH 0 (for now just duplicate track for gbt since they don't exist in the design, but change this if you add them) 
        --(9, 9, 10, 11)  -- OH 1 (for now just duplicate track for gbt since they don't exist in the design, but change this if you add them) 
        (0, 0, 1, 2), 
        (3, 3, 4, 5), 
        (6, 6, 7, 8), 
        (9, 9, 10, 11)

        --(12, 12, 13, 14), 
        --(15, 15, 16, 17), 
        --(18, 18, 19, 20), 
        --(21, 21, 22, 23), 

        --(24, 24, 25, 26), 
        --(27, 27, 28, 29), 
        --(30, 30, 31, 32), 
        --(33, 33, 34, 35) 
	);

end package gem_board_config_package;
--============================================================================
--                                                                 Package end 
--============================================================================

