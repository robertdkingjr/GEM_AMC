GEM AMC Firmware Project
========================

This repository contains sources for common GEM AMC firmware logic as well as board specific implementations for GLIB (Virtex 6) and CTP7 (Virtex 7).
Note that this repository excludes ISE / Vivado project directories entirely to avoid generated files, although XISE / XPR files are included in directories called work_dir. Those XISE / XPR files are referencing the source code outside work_dir and once opened will generate an ISE / Vivado project in the work_dir. PLEASE DO NOT COMMIT ANY FILES FROM THE WORK_DIR OTHER THAN XISE / XPR!!! 

In scripts directory you'll find a python application which takes an address_table (provided) and inserts the necessary VHDL code to expose those registers in the firmware as well as uHAL address table, documentation and some bash scripts for quick CTP7 testing.

CTP7 Notes
==========

To run chipscope follow these steps:
   * SSH into CTP7 and run: xvc \<ip_of_the_machine_directly_talking_to_ctp7\>
   * If running Vivado on a machine that's not directly connected to the MCH, open a tunnel like so: ssh -L 2542:eagle34:2542 \<host_connected_to_ctp7\>
   * Open Vivado Hardware Manager, click Auto Connect
   * In TCL console run: open_hw_target -xvc_url localhost:2542 (if not using tunnel, just replace localhost with CTP7 IP or hostname)
   * Once you see the FPGA, click refresh device to get all the Chipscope cores in your design

CTP7 doesn't natively support IPbus, but it can be emulated. In this firmware the GEM_AMC IPbus registers are mapped to AXI address space 0x64000000-0x67ffffff using an AXI-IPbus bridge. IPbus address width is 24 bits wide and it's shifted left by two bits in AXI address space (in AXI the bottom 2 bits are used to refer to individual bytes, so they're not usable for 32bit word size). So to access a give IPbus register from Zynq, you should do: mpeek (0x64000000 + (\<ip_bus_reg_address\> \<\< 2)) for reading and mpoke (0x64000000 + (\<ip_bus_reg_address\> \<\< 2)) for writing.

WU has developed an application that can be run on Zynq linux and emulates IPBus master. Compiled binary is included in scripts directory here, the source repository is here: https://github.com/uwcms/uw-appnotes/

