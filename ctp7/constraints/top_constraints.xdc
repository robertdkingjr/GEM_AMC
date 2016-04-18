
#---------------
set_property PACKAGE_PIN H29 [get_ports clk_200_diff_in_clk_n]

set_property IOSTANDARD LVDS [get_ports clk_200_diff_in_clk_p]
set_property IOSTANDARD LVDS [get_ports clk_200_diff_in_clk_n]

create_clock -period 5.000 [get_ports clk_200_diff_in_clk_p]

#---------------
#green
set_property PACKAGE_PIN A20 [get_ports {LEDs[0]}]
#orange
set_property PACKAGE_PIN B20 [get_ports {LEDs[1]}]

set_property IOSTANDARD LVCMOS18 [get_ports {LEDs[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {LEDs[1]}]


# ==========================================================================


set_property PACKAGE_PIN AV30 [get_ports clk_40_ttc_n_i]

set_property IOSTANDARD LVDS [get_ports clk_40_ttc_p_i]
set_property IOSTANDARD LVDS [get_ports clk_40_ttc_n_i]

## create_clock -period 24.950 -name clk_40_ttc_p_i [get_ports clk_40_ttc_p_i]

## ~40.5 MHz (over-constrained)
create_clock -period 24.691 -name clk_40_ttc_p_i [get_ports clk_40_ttc_p_i]


set_property PACKAGE_PIN J26 [get_ports ttc_data_n_i]

set_property IOSTANDARD LVDS [get_ports ttc_data_p_i]
set_property IOSTANDARD LVDS [get_ports ttc_data_n_i]



# ==========================================================================
# AXI Chip2Chip

set_property INTERNAL_VREF 0.9 [get_iobanks 16]


# AXI Chip2Chip - RX section
set_property PACKAGE_PIN BD31 [get_ports axi_c2c_v7_to_zynq_clk]
set_property PACKAGE_PIN AY32 [get_ports {axi_c2c_v7_to_zynq_data[0]}]
set_property PACKAGE_PIN BA33 [get_ports {axi_c2c_v7_to_zynq_data[1]}]
set_property PACKAGE_PIN AR31 [get_ports {axi_c2c_v7_to_zynq_data[2]}]
set_property PACKAGE_PIN AR32 [get_ports {axi_c2c_v7_to_zynq_data[3]}]
set_property PACKAGE_PIN AV32 [get_ports {axi_c2c_v7_to_zynq_data[4]}]
set_property PACKAGE_PIN AW32 [get_ports {axi_c2c_v7_to_zynq_data[5]}]
set_property PACKAGE_PIN AJ30 [get_ports {axi_c2c_v7_to_zynq_data[6]}]
set_property PACKAGE_PIN AJ31 [get_ports {axi_c2c_v7_to_zynq_data[7]}]
set_property PACKAGE_PIN AM32 [get_ports {axi_c2c_v7_to_zynq_data[8]}]
set_property PACKAGE_PIN AM33 [get_ports {axi_c2c_v7_to_zynq_data[9]}]
set_property PACKAGE_PIN BB33 [get_ports {axi_c2c_v7_to_zynq_data[10]}]
set_property PACKAGE_PIN AV33 [get_ports {axi_c2c_v7_to_zynq_data[11]}]
set_property PACKAGE_PIN AP32 [get_ports {axi_c2c_v7_to_zynq_data[12]}]
set_property PACKAGE_PIN AN32 [get_ports {axi_c2c_v7_to_zynq_data[13]}]
set_property PACKAGE_PIN BC34 [get_ports {axi_c2c_v7_to_zynq_data[14]}]

set_property IOSTANDARD HSTL_I_DCI_18 [get_ports axi_c2c_v7_to_zynq_clk]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_v7_to_zynq_data[0]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_v7_to_zynq_data[1]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_v7_to_zynq_data[2]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_v7_to_zynq_data[3]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_v7_to_zynq_data[4]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_v7_to_zynq_data[5]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_v7_to_zynq_data[6]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_v7_to_zynq_data[7]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_v7_to_zynq_data[8]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_v7_to_zynq_data[9]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_v7_to_zynq_data[10]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_v7_to_zynq_data[11]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_v7_to_zynq_data[12]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_v7_to_zynq_data[13]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_v7_to_zynq_data[14]}]

# AXI Chip2Chip - TX section
set_property PACKAGE_PIN AU33 [get_ports axi_c2c_zynq_to_v7_clk]
set_property PACKAGE_PIN AV34 [get_ports {axi_c2c_zynq_to_v7_data[0]}]
set_property PACKAGE_PIN AV35 [get_ports {axi_c2c_zynq_to_v7_data[1]}]
set_property PACKAGE_PIN AW34 [get_ports {axi_c2c_zynq_to_v7_data[2]}]
set_property PACKAGE_PIN AW35 [get_ports {axi_c2c_zynq_to_v7_data[3]}]
set_property PACKAGE_PIN AY33 [get_ports {axi_c2c_zynq_to_v7_data[4]}]
set_property PACKAGE_PIN AY34 [get_ports {axi_c2c_zynq_to_v7_data[5]}]
set_property PACKAGE_PIN BA34 [get_ports {axi_c2c_zynq_to_v7_data[6]}]
set_property PACKAGE_PIN BA35 [get_ports {axi_c2c_zynq_to_v7_data[7]}]
set_property PACKAGE_PIN BD34 [get_ports {axi_c2c_zynq_to_v7_data[8]}]
set_property PACKAGE_PIN BD35 [get_ports {axi_c2c_zynq_to_v7_data[9]}]
set_property PACKAGE_PIN BB35 [get_ports {axi_c2c_zynq_to_v7_data[10]}]
set_property PACKAGE_PIN BC35 [get_ports {axi_c2c_zynq_to_v7_data[11]}]
set_property PACKAGE_PIN BC32 [get_ports {axi_c2c_zynq_to_v7_data[12]}]
set_property PACKAGE_PIN BC33 [get_ports {axi_c2c_zynq_to_v7_data[13]}]
set_property PACKAGE_PIN BD32 [get_ports {axi_c2c_zynq_to_v7_data[14]}]

set_property IOSTANDARD HSTL_I_DCI_18 [get_ports axi_c2c_zynq_to_v7_clk]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_zynq_to_v7_data[0]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_zynq_to_v7_data[1]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_zynq_to_v7_data[2]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_zynq_to_v7_data[3]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_zynq_to_v7_data[4]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_zynq_to_v7_data[5]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_zynq_to_v7_data[6]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_zynq_to_v7_data[7]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_zynq_to_v7_data[8]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_zynq_to_v7_data[9]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_zynq_to_v7_data[10]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_zynq_to_v7_data[11]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_zynq_to_v7_data[12]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_zynq_to_v7_data[13]}]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports {axi_c2c_zynq_to_v7_data[14]}]


# AXI Chip2Chip - Status/Control section
set_property PACKAGE_PIN BB31 [get_ports axi_c2c_zynq_to_v7_reset]
set_property PACKAGE_PIN BB32 [get_ports axi_c2c_v7_to_zynq_link_status]

set_property IOSTANDARD HSTL_I_DCI_18 [get_ports axi_c2c_zynq_to_v7_reset]
set_property IOSTANDARD HSTL_I_DCI_18 [get_ports axi_c2c_v7_to_zynq_link_status]
# ==========================================================================

## This constraint is embedded in AXI C2C IP module
##create_clock -period 5.000 -name axi_c2c_zynq_to_v7_clk [get_ports axi_c2c_zynq_to_v7_clk]


create_generated_clock -name axi_c2c_v7_to_zynq_clk -source [get_pins system_inst/i_v7_bd/axi_chip2chip_0/inst/slave_fpga_gen.axi_chip2chip_slave_phy_inst/slave_sio_phy.axi_chip2chip_sio_output_inst/gen_oddr.oddr_clk_out_inst/C] -divide_by 1 [get_ports axi_c2c_v7_to_zynq_clk]



####################### GT reference clock constraints #########################

create_clock -period 6.250 [get_ports {refclk_F_0_p_i[0]}]
create_clock -period 6.250 [get_ports {refclk_F_0_p_i[1]}]
create_clock -period 6.250 [get_ports {refclk_F_0_p_i[2]}]
create_clock -period 6.250 [get_ports {refclk_F_0_p_i[3]}]

create_clock -period 6.250 [get_ports {refclk_F_1_p_i[0]}]
create_clock -period 6.250 [get_ports {refclk_F_1_p_i[1]}]
create_clock -period 6.250 [get_ports {refclk_F_1_p_i[2]}]
create_clock -period 6.250 [get_ports {refclk_F_1_p_i[3]}]

#create_clock -period 6.250 [get_ports {refclk_B_0_p_i[0]}]
create_clock -period 6.250 [get_ports {refclk_B_0_p_i[1]}]
create_clock -period 6.250 [get_ports {refclk_B_0_p_i[2]}]
create_clock -period 6.250 [get_ports {refclk_B_0_p_i[3]}]

#create_clock -period 6.250 [get_ports {refclk_B_1_p_i[0]}]
create_clock -period 6.250 [get_ports {refclk_B_1_p_i[1]}]
create_clock -period 6.250 [get_ports {refclk_B_1_p_i[2]}]
create_clock -period 6.250 [get_ports {refclk_B_1_p_i[3]}]

################################ RefClk Location constraints #####################

set_property PACKAGE_PIN E10 [get_ports {refclk_F_0_p_i[0]}]
set_property PACKAGE_PIN N10 [get_ports {refclk_F_0_p_i[1]}]
set_property PACKAGE_PIN AF8 [get_ports {refclk_F_0_p_i[2]}]
set_property PACKAGE_PIN AR10 [get_ports {refclk_F_0_p_i[3]}]

set_property PACKAGE_PIN G10 [get_ports {refclk_F_1_p_i[0]}]
set_property PACKAGE_PIN R10 [get_ports {refclk_F_1_p_i[1]}]
set_property PACKAGE_PIN AH8 [get_ports {refclk_F_1_p_i[2]}]
set_property PACKAGE_PIN AT8 [get_ports {refclk_F_1_p_i[3]}]

#set_property PACKAGE_PIN AR35 [get_ports  {refclk_B_0_p_i[0]}]
set_property PACKAGE_PIN AF37 [get_ports {refclk_B_0_p_i[1]}]
set_property PACKAGE_PIN N35 [get_ports {refclk_B_0_p_i[2]}]
set_property PACKAGE_PIN E35 [get_ports {refclk_B_0_p_i[3]}]

#set_property PACKAGE_PIN AT37 [get_ports  {refclk_B_1_p_i[0]}]
set_property PACKAGE_PIN AH37 [get_ports {refclk_B_1_p_i[1]}]
set_property PACKAGE_PIN R35 [get_ports {refclk_B_1_p_i[2]}]
set_property PACKAGE_PIN G35 [get_ports {refclk_B_1_p_i[3]}]

################################ GTH2_CHANNEL Location constraints  #####################

set_property LOC GTHE2_CHANNEL_X1Y0 [get_cells {system_inst/i_gth_wrapper/gen_gth_single[0].gen_gth_*/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y1 [get_cells {system_inst/i_gth_wrapper/gen_gth_single[1].gen_gth_*/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y2 [get_cells {system_inst/i_gth_wrapper/gen_gth_single[2].gen_gth_*/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y3 [get_cells {system_inst/i_gth_wrapper/gen_gth_single[3].gen_gth_*/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y4 [get_cells {system_inst/i_gth_wrapper/gen_gth_single[4].gen_gth_*/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y5 [get_cells {system_inst/i_gth_wrapper/gen_gth_single[5].gen_gth_*/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y6 [get_cells {system_inst/i_gth_wrapper/gen_gth_single[6].gen_gth_*/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y7 [get_cells {system_inst/i_gth_wrapper/gen_gth_single[7].gen_gth_*/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y8 [get_cells {system_inst/i_gth_wrapper/gen_gth_single[8].gen_gth_*/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y9 [get_cells {system_inst/i_gth_wrapper/gen_gth_single[9].gen_gth_*/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y10 [get_cells {system_inst/i_gth_wrapper/gen_gth_single[10].gen_gth_*/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y11 [get_cells {system_inst/i_gth_wrapper/gen_gth_single[11].gen_gth_*/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y12 [get_cells {system_inst/i_gth_wrapper/gen_gth_single[12].gen_gth_*/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y13 [get_cells {system_inst/i_gth_wrapper/gen_gth_single[13].gen_gth_*/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y14 [get_cells {system_inst/i_gth_wrapper/gen_gth_single[14].gen_gth_*/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y15 [get_cells {system_inst/i_gth_wrapper/gen_gth_single[15].gen_gth_*/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y16 [get_cells {system_inst/i_gth_wrapper/gen_gth_single[16].gen_gth_*/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y17 [get_cells {system_inst/i_gth_wrapper/gen_gth_single[17].gen_gth_*/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y18 [get_cells {system_inst/i_gth_wrapper/gen_gth_single[18].gen_gth_*/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y19 [get_cells {system_inst/i_gth_wrapper/gen_gth_single[19].gen_gth_*/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y20 [get_cells {system_inst/i_gth_wrapper/gen_gth_single[20].gen_gth_*/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y21 [get_cells {system_inst/i_gth_wrapper/gen_gth_single[21].gen_gth_*/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y22 [get_cells {system_inst/i_gth_wrapper/gen_gth_single[22].gen_gth_*/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y23 [get_cells {system_inst/i_gth_wrapper/gen_gth_single[23].gen_gth_*/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y24 [get_cells {system_inst/i_gth_wrapper/gen_gth_single[24].gen_gth_*/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y25 [get_cells {system_inst/i_gth_wrapper/gen_gth_single[25].gen_gth_*/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y26 [get_cells {system_inst/i_gth_wrapper/gen_gth_single[26].gen_gth_*/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y27 [get_cells {system_inst/i_gth_wrapper/gen_gth_single[27].gen_gth_*/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y28 [get_cells {system_inst/i_gth_wrapper/gen_gth_single[28].gen_gth_*/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y29 [get_cells {system_inst/i_gth_wrapper/gen_gth_single[29].gen_gth_*/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y30 [get_cells {system_inst/i_gth_wrapper/gen_gth_single[30].gen_gth_*/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y31 [get_cells {system_inst/i_gth_wrapper/gen_gth_single[31].gen_gth_*/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y32 [get_cells {system_inst/i_gth_wrapper/gen_gth_single[32].gen_gth_*/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y33 [get_cells {system_inst/i_gth_wrapper/gen_gth_single[33].gen_gth_*/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y34 [get_cells {system_inst/i_gth_wrapper/gen_gth_single[34].gen_gth_*/i_gthe2}]
set_property LOC GTHE2_CHANNEL_X1Y35 [get_cells {system_inst/i_gth_wrapper/gen_gth_single[35].gen_gth_*/i_gthe2}]


set_property LOC XADC_X0Y0 [get_cells system_inst/i_v7_bd/xadc_wiz_0/U0/AXI_XADC_CORE_I/XADC_INST]


set_false_path -to [get_cells -hierarchical -filter {NAME =~ *sync*/data_sync_reg1}]
set_false_path -to [get_cells -hierarchical -filter {NAME =~ *sync*/data_sync_reg1}]
set_false_path -to [get_cells -hierarchical -filter {NAME =~ *sync*/data_sync_reg1}]
set_false_path -to [get_cells -hierarchical -filter {NAME =~ *sync*/data_sync_reg1}]


#set_false_path -from [get_clocks -include_generated_clocks -of_objects [get_ports SYSCLK_IN]] -to [get_clocks -include_generated_clocks -of_objects [get_pins -hier -filter {name=~*gt0_gth_single_i*gthe2_i*TXOUTCLK}]]
#set_false_path -from [get_clocks -include_generated_clocks -of_objects [get_pins -hier -filter {name=~*gt0_gth_single_i*gthe2_i*TXOUTCLK}]] -to [get_clocks -include_generated_clocks -of_objects [get_ports SYSCLK_IN]]

#set_false_path -from [get_clocks -include_generated_clocks -of_objects [get_ports SYSCLK_IN]] -to [get_clocks -include_generated_clocks -of_objects [get_pins -hier -filter {name=~*gt0_gth_single_i*gthe2_i*RXOUTCLK}]]
#set_false_path -from [get_clocks -include_generated_clocks -of_objects [get_pins -hier -filter {name=~*gt0_gth_single_i*gthe2_i*RXOUTCLK}]] -to [get_clocks -include_generated_clocks -of_objects [get_ports SYSCLK_IN]]


############# Channel [0] - 3.2 Gbps TX, 3.2 Gbps RX #############
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[0].gen_gth_*/i_gthe2*TXOUTCLK}]
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[0].gen_gth_*/i_gthe2*RXOUTCLK}]

############# Channel [1] - 3.2 Gbps TX, 3.2 Gbps RX #############
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[1].gen_gth_*/i_gthe2*TXOUTCLK}]
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[1].gen_gth_*/i_gthe2*RXOUTCLK}]

############# Channel [2] - 3.2 Gbps TX, 3.2 Gbps RX #############
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[2].gen_gth_*/i_gthe2*TXOUTCLK}]
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[2].gen_gth_*/i_gthe2*RXOUTCLK}]

############# Channel [3] - 3.2 Gbps TX, 3.2 Gbps RX #############
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[3].gen_gth_*/i_gthe2*TXOUTCLK}]
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[3].gen_gth_*/i_gthe2*RXOUTCLK}]

############# Channel [4] - 3.2 Gbps TX, 3.2 Gbps RX #############
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[4].gen_gth_*/i_gthe2*TXOUTCLK}]
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[4].gen_gth_*/i_gthe2*RXOUTCLK}]

############# Channel [5] - 3.2 Gbps TX, 3.2 Gbps RX #############
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[5].gen_gth_*/i_gthe2*TXOUTCLK}]
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[5].gen_gth_*/i_gthe2*RXOUTCLK}]

############# Channel [6] - 3.2 Gbps TX, 3.2 Gbps RX #############
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[6].gen_gth_*/i_gthe2*TXOUTCLK}]
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[6].gen_gth_*/i_gthe2*RXOUTCLK}]

############# Channel [7] - 3.2 Gbps TX, 3.2 Gbps RX #############
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[7].gen_gth_*/i_gthe2*TXOUTCLK}]
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[7].gen_gth_*/i_gthe2*RXOUTCLK}]

############# Channel [8] - 3.2 Gbps TX, 3.2 Gbps RX #############
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[8].gen_gth_*/i_gthe2*TXOUTCLK}]
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[8].gen_gth_*/i_gthe2*RXOUTCLK}]

############# Channel [9] - 3.2 Gbps TX, 3.2 Gbps RX #############
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[9].gen_gth_*/i_gthe2*TXOUTCLK}]
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[9].gen_gth_*/i_gthe2*RXOUTCLK}]

############# Channel [10] - 3.2 Gbps TX, 3.2 Gbps RX #############
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[10].gen_gth_*/i_gthe2*TXOUTCLK}]
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[10].gen_gth_*/i_gthe2*RXOUTCLK}]

############# Channel [11] - 3.2 Gbps TX, 3.2 Gbps RX #############
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[11].gen_gth_*/i_gthe2*TXOUTCLK}]
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[11].gen_gth_*/i_gthe2*RXOUTCLK}]







############# Channel [12] - 4.8 Gbps TX, 4.8 Gbps RX #############
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[12].gen_gth_*/i_gthe2*TXOUTCLK}]
create_clock -period 4.166 [get_pins -hier -filter {name=~*gen_gth_single[12].gen_gth_*/i_gthe2*RXOUTCLK}]

############# Channel [12] - 4.8 Gbps TX, 4.8 Gbps RX #############
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[13].gen_gth_*/i_gthe2*TXOUTCLK}]
create_clock -period 4.166 [get_pins -hier -filter {name=~*gen_gth_single[13].gen_gth_*/i_gthe2*RXOUTCLK}]

############# Channel [12] - 4.8 Gbps TX, 4.8 Gbps RX #############
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[14].gen_gth_*/i_gthe2*TXOUTCLK}]
create_clock -period 4.166 [get_pins -hier -filter {name=~*gen_gth_single[14].gen_gth_*/i_gthe2*RXOUTCLK}]

############# Channel [12] - 4.8 Gbps TX, 4.8 Gbps RX #############
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[15].gen_gth_*/i_gthe2*TXOUTCLK}]
create_clock -period 4.166 [get_pins -hier -filter {name=~*gen_gth_single[15].gen_gth_*/i_gthe2*RXOUTCLK}]

############# Channel [12] - 4.8 Gbps TX, 4.8 Gbps RX #############
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[16].gen_gth_*/i_gthe2*TXOUTCLK}]
create_clock -period 4.166 [get_pins -hier -filter {name=~*gen_gth_single[16].gen_gth_*/i_gthe2*RXOUTCLK}]

############# Channel [12] - 4.8 Gbps TX, 4.8 Gbps RX #############
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[17].gen_gth_*/i_gthe2*TXOUTCLK}]
create_clock -period 4.166 [get_pins -hier -filter {name=~*gen_gth_single[17].gen_gth_*/i_gthe2*RXOUTCLK}]

############# Channel [12] - 4.8 Gbps TX, 4.8 Gbps RX #############
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[18].gen_gth_*/i_gthe2*TXOUTCLK}]
create_clock -period 4.166 [get_pins -hier -filter {name=~*gen_gth_single[18].gen_gth_*/i_gthe2*RXOUTCLK}]

############# Channel [12] - 4.8 Gbps TX, 4.8 Gbps RX #############
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[19].gen_gth_*/i_gthe2*TXOUTCLK}]
create_clock -period 4.166 [get_pins -hier -filter {name=~*gen_gth_single[19].gen_gth_*/i_gthe2*RXOUTCLK}]

############# Channel [12] - 4.8 Gbps TX, 4.8 Gbps RX #############
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[20].gen_gth_*/i_gthe2*TXOUTCLK}]
create_clock -period 4.166 [get_pins -hier -filter {name=~*gen_gth_single[20].gen_gth_*/i_gthe2*RXOUTCLK}]

############# Channel [12] - 4.8 Gbps TX, 4.8 Gbps RX #############
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[21].gen_gth_*/i_gthe2*TXOUTCLK}]
create_clock -period 4.166 [get_pins -hier -filter {name=~*gen_gth_single[21].gen_gth_*/i_gthe2*RXOUTCLK}]

############# Channel [12] - 4.8 Gbps TX, 4.8 Gbps RX #############
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[22].gen_gth_*/i_gthe2*TXOUTCLK}]
create_clock -period 4.166 [get_pins -hier -filter {name=~*gen_gth_single[22].gen_gth_*/i_gthe2*RXOUTCLK}]

############# Channel [12] - 4.8 Gbps TX, 4.8 Gbps RX #############
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[23].gen_gth_*/i_gthe2*TXOUTCLK}]
create_clock -period 4.166 [get_pins -hier -filter {name=~*gen_gth_single[23].gen_gth_*/i_gthe2*RXOUTCLK}]

############# Channel [12] - 4.8 Gbps TX, 4.8 Gbps RX #############
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[24].gen_gth_*/i_gthe2*TXOUTCLK}]
create_clock -period 4.166 [get_pins -hier -filter {name=~*gen_gth_single[24].gen_gth_*/i_gthe2*RXOUTCLK}]

############# Channel [12] - 4.8 Gbps TX, 4.8 Gbps RX #############
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[25].gen_gth_*/i_gthe2*TXOUTCLK}]
create_clock -period 4.166 [get_pins -hier -filter {name=~*gen_gth_single[25].gen_gth_*/i_gthe2*RXOUTCLK}]

############# Channel [12] - 4.8 Gbps TX, 4.8 Gbps RX #############
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[26].gen_gth_*/i_gthe2*TXOUTCLK}]
create_clock -period 4.166 [get_pins -hier -filter {name=~*gen_gth_single[26].gen_gth_*/i_gthe2*RXOUTCLK}]

############# Channel [12] - 4.8 Gbps TX, 4.8 Gbps RX #############
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[27].gen_gth_*/i_gthe2*TXOUTCLK}]
create_clock -period 4.166 [get_pins -hier -filter {name=~*gen_gth_single[27].gen_gth_*/i_gthe2*RXOUTCLK}]

############# Channel [12] - 4.8 Gbps TX, 4.8 Gbps RX #############
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[28].gen_gth_*/i_gthe2*TXOUTCLK}]
create_clock -period 4.166 [get_pins -hier -filter {name=~*gen_gth_single[28].gen_gth_*/i_gthe2*RXOUTCLK}]

############# Channel [12] - 4.8 Gbps TX, 4.8 Gbps RX #############
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[29].gen_gth_*/i_gthe2*TXOUTCLK}]
create_clock -period 4.166 [get_pins -hier -filter {name=~*gen_gth_single[29].gen_gth_*/i_gthe2*RXOUTCLK}]

############# Channel [12] - 4.8 Gbps TX, 4.8 Gbps RX #############
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[30].gen_gth_*/i_gthe2*TXOUTCLK}]
create_clock -period 4.166 [get_pins -hier -filter {name=~*gen_gth_single[30].gen_gth_*/i_gthe2*RXOUTCLK}]

############# Channel [12] - 4.8 Gbps TX, 4.8 Gbps RX #############
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[31].gen_gth_*/i_gthe2*TXOUTCLK}]
create_clock -period 4.166 [get_pins -hier -filter {name=~*gen_gth_single[31].gen_gth_*/i_gthe2*RXOUTCLK}]

############# Channel [12] - 4.8 Gbps TX, 4.8 Gbps RX #############
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[32].gen_gth_*/i_gthe2*TXOUTCLK}]
create_clock -period 4.166 [get_pins -hier -filter {name=~*gen_gth_single[32].gen_gth_*/i_gthe2*RXOUTCLK}]

############# Channel [12] - 4.8 Gbps TX, 4.8 Gbps RX #############
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[33].gen_gth_*/i_gthe2*TXOUTCLK}]
create_clock -period 4.166 [get_pins -hier -filter {name=~*gen_gth_single[33].gen_gth_*/i_gthe2*RXOUTCLK}]

############# Channel [12] - 4.8 Gbps TX, 4.8 Gbps RX #############
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[34].gen_gth_*/i_gthe2*TXOUTCLK}]
create_clock -period 4.166 [get_pins -hier -filter {name=~*gen_gth_single[34].gen_gth_*/i_gthe2*RXOUTCLK}]

############# Channel [12] - 4.8 Gbps TX, 4.8 Gbps RX #############
create_clock -period 6.250 [get_pins -hier -filter {name=~*gen_gth_single[35].gen_gth_*/i_gthe2*TXOUTCLK}]
create_clock -period 4.166 [get_pins -hier -filter {name=~*gen_gth_single[35].gen_gth_*/i_gthe2*RXOUTCLK}]

############# ############# ############# ############# ############# ############# #############
############# ############# False Path Constraints ############# ############# #############

set_clock_groups -asynchronous -group [get_clocks s_clk_40] -group [get_clocks clk_out2_v7_bd_clk_wiz_0_0]
set_clock_groups -asynchronous -group [get_clocks s_clk_160] -group [get_clocks clk_out2_v7_bd_clk_wiz_0_0]
#set_clock_groups -asynchronous -group [get_clocks clk_40_ttc_p_i] -group [get_clocks clk_out2_v7_bd_clk_wiz_0_0]

set_clock_groups -asynchronous -group [get_clocks {system_inst/i_gth_wrapper/gen_gth_single[*].*/i_gthe2/?XOUTCLK}] -group [get_clocks clk_out2_v7_bd_clk_wiz_0_0]
set_clock_groups -asynchronous -group [get_clocks {system_inst/i_gth_wrapper/gen_gth_single[*].*/i_gthe2/?XOUTCLK}] -group [get_clocks s_clk_160]
set_clock_groups -asynchronous -group [get_clocks {system_inst/i_gth_wrapper/gen_gth_single[*].*/i_gthe2/?XOUTCLK}] -group [get_clocks s_clk_160]

set_clock_groups -asynchronous -group [get_clocks clk_out2_v7_bd_clk_wiz_0_0] -group [get_clocks clkout0]


connect_debug_port u_ila_0/clk [get_nets [list {system_inst/i_gth_wrapper/i_gth_clk_bufs/clk_gth_tx_arr_o[0]}]]

create_debug_core u_ila_0_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0_0]
set_property port_width 1 [get_debug_ports u_ila_0_0/clk]
connect_debug_port u_ila_0_0/clk [get_nets [list {system_inst/i_gth_wrapper/i_gth_clk_bufs/clk_gth_tx_usrclk_arr_o[0]}]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0_0/probe0]
set_property port_width 32 [get_debug_ports u_ila_0_0/probe0]
connect_debug_port u_ila_0_0/probe0 [get_nets [list {debug_gth_tx_data[txdata][0]} {debug_gth_tx_data[txdata][1]} {debug_gth_tx_data[txdata][2]} {debug_gth_tx_data[txdata][3]} {debug_gth_tx_data[txdata][4]} {debug_gth_tx_data[txdata][5]} {debug_gth_tx_data[txdata][6]} {debug_gth_tx_data[txdata][7]} {debug_gth_tx_data[txdata][8]} {debug_gth_tx_data[txdata][9]} {debug_gth_tx_data[txdata][10]} {debug_gth_tx_data[txdata][11]} {debug_gth_tx_data[txdata][12]} {debug_gth_tx_data[txdata][13]} {debug_gth_tx_data[txdata][14]} {debug_gth_tx_data[txdata][15]} {debug_gth_tx_data[txdata][16]} {debug_gth_tx_data[txdata][17]} {debug_gth_tx_data[txdata][18]} {debug_gth_tx_data[txdata][19]} {debug_gth_tx_data[txdata][20]} {debug_gth_tx_data[txdata][21]} {debug_gth_tx_data[txdata][22]} {debug_gth_tx_data[txdata][23]} {debug_gth_tx_data[txdata][24]} {debug_gth_tx_data[txdata][25]} {debug_gth_tx_data[txdata][26]} {debug_gth_tx_data[txdata][27]} {debug_gth_tx_data[txdata][28]} {debug_gth_tx_data[txdata][29]} {debug_gth_tx_data[txdata][30]} {debug_gth_tx_data[txdata][31]}]]
create_debug_core u_ila_1_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_1_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_1_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_1_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_1_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_1_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_1_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_1_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_1_0]
set_property port_width 1 [get_debug_ports u_ila_1_0/clk]
connect_debug_port u_ila_1_0/clk [get_nets [list {system_inst/i_gth_wrapper/i_gth_clk_bufs/clk_gth_rx_arr_o[6]}]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1_0/probe0]
set_property port_width 4 [get_debug_ports u_ila_1_0/probe0]
connect_debug_port u_ila_1_0/probe0 [get_nets [list {debug_gth_rx_data[rxdisperr][0]} {debug_gth_rx_data[rxdisperr][1]} {debug_gth_rx_data[rxdisperr][2]} {debug_gth_rx_data[rxdisperr][3]}]]
create_debug_core u_ila_2_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_2_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_2_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_2_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_2_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_2_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_2_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_2_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_2_0]
set_property port_width 1 [get_debug_ports u_ila_2_0/clk]
connect_debug_port u_ila_2_0/clk [get_nets [list system_inst/i_v7_bd/clk_wiz_0/inst/clk_out2]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2_0/probe0]
set_property port_width 32 [get_debug_ports u_ila_2_0/probe0]
connect_debug_port u_ila_2_0/probe0 [get_nets [list {debug_oh_reg_response[data][0]} {debug_oh_reg_response[data][1]} {debug_oh_reg_response[data][2]} {debug_oh_reg_response[data][3]} {debug_oh_reg_response[data][4]} {debug_oh_reg_response[data][5]} {debug_oh_reg_response[data][6]} {debug_oh_reg_response[data][7]} {debug_oh_reg_response[data][8]} {debug_oh_reg_response[data][9]} {debug_oh_reg_response[data][10]} {debug_oh_reg_response[data][11]} {debug_oh_reg_response[data][12]} {debug_oh_reg_response[data][13]} {debug_oh_reg_response[data][14]} {debug_oh_reg_response[data][15]} {debug_oh_reg_response[data][16]} {debug_oh_reg_response[data][17]} {debug_oh_reg_response[data][18]} {debug_oh_reg_response[data][19]} {debug_oh_reg_response[data][20]} {debug_oh_reg_response[data][21]} {debug_oh_reg_response[data][22]} {debug_oh_reg_response[data][23]} {debug_oh_reg_response[data][24]} {debug_oh_reg_response[data][25]} {debug_oh_reg_response[data][26]} {debug_oh_reg_response[data][27]} {debug_oh_reg_response[data][28]} {debug_oh_reg_response[data][29]} {debug_oh_reg_response[data][30]} {debug_oh_reg_response[data][31]}]]
create_debug_port u_ila_0_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0_0/probe1]
set_property port_width 4 [get_debug_ports u_ila_0_0/probe1]
connect_debug_port u_ila_0_0/probe1 [get_nets [list {debug_gth_tx_data[txcharisk][0]} {debug_gth_tx_data[txcharisk][1]} {debug_gth_tx_data[txcharisk][2]} {debug_gth_tx_data[txcharisk][3]}]]
create_debug_port u_ila_1_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1_0/probe1]
set_property port_width 32 [get_debug_ports u_ila_1_0/probe1]
connect_debug_port u_ila_1_0/probe1 [get_nets [list {debug_gth_rx_data[rxdata][0]} {debug_gth_rx_data[rxdata][1]} {debug_gth_rx_data[rxdata][2]} {debug_gth_rx_data[rxdata][3]} {debug_gth_rx_data[rxdata][4]} {debug_gth_rx_data[rxdata][5]} {debug_gth_rx_data[rxdata][6]} {debug_gth_rx_data[rxdata][7]} {debug_gth_rx_data[rxdata][8]} {debug_gth_rx_data[rxdata][9]} {debug_gth_rx_data[rxdata][10]} {debug_gth_rx_data[rxdata][11]} {debug_gth_rx_data[rxdata][12]} {debug_gth_rx_data[rxdata][13]} {debug_gth_rx_data[rxdata][14]} {debug_gth_rx_data[rxdata][15]} {debug_gth_rx_data[rxdata][16]} {debug_gth_rx_data[rxdata][17]} {debug_gth_rx_data[rxdata][18]} {debug_gth_rx_data[rxdata][19]} {debug_gth_rx_data[rxdata][20]} {debug_gth_rx_data[rxdata][21]} {debug_gth_rx_data[rxdata][22]} {debug_gth_rx_data[rxdata][23]} {debug_gth_rx_data[rxdata][24]} {debug_gth_rx_data[rxdata][25]} {debug_gth_rx_data[rxdata][26]} {debug_gth_rx_data[rxdata][27]} {debug_gth_rx_data[rxdata][28]} {debug_gth_rx_data[rxdata][29]} {debug_gth_rx_data[rxdata][30]} {debug_gth_rx_data[rxdata][31]}]]
create_debug_port u_ila_1_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1_0/probe2]
set_property port_width 4 [get_debug_ports u_ila_1_0/probe2]
connect_debug_port u_ila_1_0/probe2 [get_nets [list {debug_gth_rx_data[rxnotintable][0]} {debug_gth_rx_data[rxnotintable][1]} {debug_gth_rx_data[rxnotintable][2]} {debug_gth_rx_data[rxnotintable][3]}]]
create_debug_port u_ila_1_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1_0/probe3]
set_property port_width 4 [get_debug_ports u_ila_1_0/probe3]
connect_debug_port u_ila_1_0/probe3 [get_nets [list {debug_gth_rx_data[rxcharisk][0]} {debug_gth_rx_data[rxcharisk][1]} {debug_gth_rx_data[rxcharisk][2]} {debug_gth_rx_data[rxcharisk][3]}]]
create_debug_port u_ila_1_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_1_0/probe4]
set_property port_width 4 [get_debug_ports u_ila_1_0/probe4]
connect_debug_port u_ila_1_0/probe4 [get_nets [list {debug_gth_rx_data[rxchariscomma][0]} {debug_gth_rx_data[rxchariscomma][1]} {debug_gth_rx_data[rxchariscomma][2]} {debug_gth_rx_data[rxchariscomma][3]}]]
create_debug_port u_ila_1_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1_0/probe5]
set_property port_width 1 [get_debug_ports u_ila_1_0/probe5]
connect_debug_port u_ila_1_0/probe5 [get_nets [list {debug_gth_rx_data[rxbyteisaligned]}]]
create_debug_port u_ila_1_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1_0/probe6]
set_property port_width 1 [get_debug_ports u_ila_1_0/probe6]
connect_debug_port u_ila_1_0/probe6 [get_nets [list {debug_gth_rx_data[rxbyterealign]}]]
create_debug_port u_ila_1_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1_0/probe7]
set_property port_width 1 [get_debug_ports u_ila_1_0/probe7]
connect_debug_port u_ila_1_0/probe7 [get_nets [list {debug_gth_rx_data[rxcommadet]}]]
create_debug_port u_ila_2_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2_0/probe1]
set_property port_width 32 [get_debug_ports u_ila_2_0/probe1]
connect_debug_port u_ila_2_0/probe1 [get_nets [list {debug_oh_reg_request[data][0]} {debug_oh_reg_request[data][1]} {debug_oh_reg_request[data][2]} {debug_oh_reg_request[data][3]} {debug_oh_reg_request[data][4]} {debug_oh_reg_request[data][5]} {debug_oh_reg_request[data][6]} {debug_oh_reg_request[data][7]} {debug_oh_reg_request[data][8]} {debug_oh_reg_request[data][9]} {debug_oh_reg_request[data][10]} {debug_oh_reg_request[data][11]} {debug_oh_reg_request[data][12]} {debug_oh_reg_request[data][13]} {debug_oh_reg_request[data][14]} {debug_oh_reg_request[data][15]} {debug_oh_reg_request[data][16]} {debug_oh_reg_request[data][17]} {debug_oh_reg_request[data][18]} {debug_oh_reg_request[data][19]} {debug_oh_reg_request[data][20]} {debug_oh_reg_request[data][21]} {debug_oh_reg_request[data][22]} {debug_oh_reg_request[data][23]} {debug_oh_reg_request[data][24]} {debug_oh_reg_request[data][25]} {debug_oh_reg_request[data][26]} {debug_oh_reg_request[data][27]} {debug_oh_reg_request[data][28]} {debug_oh_reg_request[data][29]} {debug_oh_reg_request[data][30]} {debug_oh_reg_request[data][31]}]]
create_debug_port u_ila_2_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2_0/probe2]
set_property port_width 32 [get_debug_ports u_ila_2_0/probe2]
connect_debug_port u_ila_2_0/probe2 [get_nets [list {debug_oh_reg_request[addr][0]} {debug_oh_reg_request[addr][1]} {debug_oh_reg_request[addr][2]} {debug_oh_reg_request[addr][3]} {debug_oh_reg_request[addr][4]} {debug_oh_reg_request[addr][5]} {debug_oh_reg_request[addr][6]} {debug_oh_reg_request[addr][7]} {debug_oh_reg_request[addr][8]} {debug_oh_reg_request[addr][9]} {debug_oh_reg_request[addr][10]} {debug_oh_reg_request[addr][11]} {debug_oh_reg_request[addr][12]} {debug_oh_reg_request[addr][13]} {debug_oh_reg_request[addr][14]} {debug_oh_reg_request[addr][15]} {debug_oh_reg_request[addr][16]} {debug_oh_reg_request[addr][17]} {debug_oh_reg_request[addr][18]} {debug_oh_reg_request[addr][19]} {debug_oh_reg_request[addr][20]} {debug_oh_reg_request[addr][21]} {debug_oh_reg_request[addr][22]} {debug_oh_reg_request[addr][23]} {debug_oh_reg_request[addr][24]} {debug_oh_reg_request[addr][25]} {debug_oh_reg_request[addr][26]} {debug_oh_reg_request[addr][27]} {debug_oh_reg_request[addr][28]} {debug_oh_reg_request[addr][29]} {debug_oh_reg_request[addr][30]} {debug_oh_reg_request[addr][31]}]]
create_debug_port u_ila_2_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2_0/probe3]
set_property port_width 1 [get_debug_ports u_ila_2_0/probe3]
connect_debug_port u_ila_2_0/probe3 [get_nets [list {debug_oh_reg_request[en]}]]
create_debug_port u_ila_2_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2_0/probe4]
set_property port_width 1 [get_debug_ports u_ila_2_0/probe4]
connect_debug_port u_ila_2_0/probe4 [get_nets [list {debug_oh_reg_request[we]}]]
create_debug_port u_ila_2_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2_0/probe5]
set_property port_width 1 [get_debug_ports u_ila_2_0/probe5]
connect_debug_port u_ila_2_0/probe5 [get_nets [list {debug_oh_reg_response[en]}]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_gth_tx_arr[6]]
