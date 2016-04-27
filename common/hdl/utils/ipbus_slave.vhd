----------------------------------------------------------------------------------
-- Company: TAMU
-- Engineer: Evaldas Juska (evaldas.juska@cern.ch, evka85@gmail.com)
-- 
-- Create Date: 04/24/2016 04:59:35 AM
-- Module Name: ipbus_slave
-- Project Name: GEM_AMC
-- Description: A generic ipbus client for reading and writing 32bit arrays on an independent user clock (domain crossing is taken care of and data outputs are set synchronously with the user clock).
--              In addition to the read and write data arrays, it also outputs read and write pulses which can be used for various resets e.g. to clear the data on write or read 
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

use work.ipbus.all;
use work.gem_pkg.all;

entity ipbus_slave is
    generic(
        g_NUM_REGS             : integer := 32;     -- number of 32bit registers in this slave (use them wisely, don't allocate 100 times more than you need). If there are big gaps in the register addresses, please use individual address mapping.
        g_ADDR_HIGH_BIT        : integer := 5;      -- MSB of the IPbus address that will be mapped to registers
        g_ADDR_LOW_BIT         : integer := 0;      -- LSB of the IPbus address that will be mapped to registers
        g_USE_INDIVIDUAL_ADDRS : string  := "FALSE" -- when true, we will map the registers to the individual addresses provided in individual_addrs_arr_i(g_ADDR_HIGH_BIT downto g_ADDR_LOW_BIT)
    );
    port(
        ipb_reset_i            : in  std_logic;                              -- IPbus reset (will reset the register values to the provided defaults)
        ipb_clk_i              : in  std_logic;                              -- IPbus clock
        ipb_mosi_i             : in  ipb_wbus;                               -- master to slave IPbus interface
        ipb_miso_o             : out ipb_rbus;                               -- slave to master IPbus interface

        usr_clk_i              : in  std_logic;                              -- user clock used to read and write regs_write_arr_o and regs_read_arr_i 
        regs_read_arr_i        : in  t_std32_array(g_NUM_REGS - 1 downto 0); -- read registers
        regs_write_arr_o       : out t_std32_array(g_NUM_REGS - 1 downto 0); -- write registers 
        read_pulse_arr_o       : out std_logic_vector(g_NUM_REGS downto 0);  -- asserted when reading the given register (note that this is not guaranteed to only last 1 clock cycle -- it depends on the frequency relation between usr_clk_i and ipb_clk_i)
        write_pulse_arr_o      : out std_logic_vector(g_NUM_REGS downto 0);  -- asserted when writing the given register (note that this is not guaranteed to only last 1 clock cycle -- it depends on the frequency relation between usr_clk_i and ipb_clk_i)

        regs_defaults_arr_i    : in  t_std32_array(g_NUM_REGS - 1 downto 0); -- register default values - set when ipb_reset_i = '1'
        individual_addrs_arr_i : in  t_std32_array(g_NUM_REGS - 1 downto 0)  -- individual register addresses - only used when g_USE_INDIVIDUAL_ADDRS = "TRUE"
    );
end ipbus_slave;

architecture Behavioral of ipbus_slave is
    type t_ipb_state is (IDLE, RSPD, SYNC_WRITE, SYNC_READ, RST);
    signal ipb_state        : t_ipb_state := IDLE;
    signal ipb_reg_sel      : integer range 0 to g_NUM_REGS - 1 := 0;
    signal ipb_addr_valid   : std_logic := '0';

    -- data on ipbus clock domain
    signal regs_read_arr    : t_std32_array(g_NUM_REGS - 1 downto 0) := (others => '0');
    signal regs_write_arr   : t_std32_array(g_NUM_REGS - 1 downto 0) := (others => '0');
    signal regs_write_strb  : std_logic := '0';
    signal regs_write_ack   : std_logic := '0';
    signal regs_read_strb   : std_logic := '0';
    signal regs_read_ack    : std_logic := '0';
begin
    
    p_ipb_fsm:
    process(ipb_clk_i)
        variable read_data : std_logic_vector(31 downto 0);
    begin
        if (rising_edge(ipb_clk_i)) then
            if (ipb_reset_i = '1') then
                ipb_miso_o      <= (ipb_ack => '0', ipb_err => '0', ipb_rdata => (others => '0'));
                ipb_state       <= IDLE;
                ipb_reg_sel     <= 0;
                ipb_addr_valid  <= '0';
                regs_write_strb <= '0';
                regs_read_strb  <= '0';

                defaults:
                for i in 0 to g_NUM_REGS - 1 loop
                    regs_write_arr(0) <= regs_defaults_arr_i(i);
                end loop;

            else
                case ipb_state is
                    when IDLE =>
                        regs_write_strb <= '0';
                        regs_read_strb  <= '0';
                        ipb_addr_valid <= '0';
                        if (g_USE_INDIVIDUAL_ADDRS = "TRUE") then
                            -- individual address matching
                            for i in 0 to g_NUM_REGS - 1 loop
                                if (to_integer(unsigned(ipb_mosi_i.ipb_addr(g_ADDR_HIGH downto g_ADDR_LOW))) = individual_addrs_arr_i(g_ADDR_HIGH downto g_ADDR_LOW)) then
                                    ipb_reg_sel <= i;
                                    ipb_addr_valid <= '1';
                                end if;
                            end loop;
                        else
                            -- sequential address matching
                            ipb_reg_sel <= to_integer(unsigned(ipb_mosi_i.ipb_addr(g_ADDR_HIGH downto g_ADDR_LOW)));
                            if (to_integer(unsigned(ipb_mosi_i.ipb_addr(g_ADDR_HIGH downto g_ADDR_LOW))) < g_NUM_REGS) then
                                ipb_addr_valid <= '1';
                            end if;
                        end if;
                        
                        if (ipb_mosi_i.ipb_strobe = '1') then
                            ipb_state <= RSPD;
                        end if;
                    when RSPD =>
                        if (ipb_addr_valid = '1' and ipb_mosi_i.ipb_write = '1') then
                            --write
                            regs_write_arr(ipb_reg_sel) <= ipb_mosi_i.ipb_wdata;
                            regs_write_strb <= '1';
                            ipb_state <= SYNC_WRITE;
                        elsif (ipb_addr_valid = '1') then
                            --read
                            regs_read_strb <= '1';
                            ipb_state <= SYNC_READ;
                        else
                            --error
                            ipb_miso_o <= (ipb_ack => '1', ipb_err => '1', ipb_rdata => (others => '0'));
                            ipb_state <= RST;
                        end if;
                        
                        ipb_state <= SYNC_WRITE;
                    when SYNC_WRITE =>
                        if (regs_write_ack = '1') then
                            ipb_miso_o <= (ipb_ack => '1', ipb_err => '0', ipb_rdata => (others => '0'));
                            regs_write_strb <= '0';
                            ipb_state <= RST;
                        end if;
                    when SYNC_READ =>
                        if (regs_read_ack = '1') then
                            ipb_miso_o <= (ipb_ack => '1', ipb_err => '0', ipb_rdata => regs_read_arr(ipb_reg_sel));
                            regs_read_strb <= '0';
                            ipb_state <= RST;
                        end if;
                    when RST =>
                        ipb_miso_o.ipb_ack <= '0';
                        ipb_miso_o.ipb_err <= '0';
                        ipb_state          <= IDLE;
                    when others =>
                        ipb_miso_o  <= (ipb_ack => '0', ipb_err => '0', ipb_rdata => (others => '0'));
                        ipb_state   <= IDLE;
                        ipb_reg_sel <= 0;
                        regs_write_strb <= '0';
                        regs_read_strb  <= '0';
                end case;
            end if;
        end if;
    end process ipb_fsm;

    -- data transfer from the user clock domain to ipb clock domain
    p_usr_clk_write_sync:
    process (usr_clk_i) is
    begin
        if rising_edge(usr_clk_i) then            
            if (regs_write_strb = '1') then
                regs_write_arr_o(ipb_reg_sel) <= regs_write_arr(ipb_reg_sel);
                regs_write_ack <= '1';
                write_pulse_arr_o(ipb_reg_sel) <= '1';
            else
                regs_write_ack <= '0';
                write_pulse_arr_o(ipb_reg_sel) <= '0';
            end if;
        end if;
    end process p_usr_clk_write_sync;
    
    -- data transfer from the ipb clock domain to the user clock domain
    p_usr_clk_read_sync:
    process (usr_clk_i) is
    begin
        if rising_edge(clk) then            
            if (regs_read_strb = '1') then
                regs_read_arr(ipb_reg_sel) <= regs_read_arr_i(ipb_reg_sel);
                regs_read_ack <= '1';
                read_pulse_arr_o(ipb_reg_sel) <= '1';
            else
                regs_read_ack <= '0';
                write_read_arr_o(ipb_reg_sel) <= '0';
            end if;
        end if;
    end process p_usr_clk_read_sync;
    

end Behavioral;
