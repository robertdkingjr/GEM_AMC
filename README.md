GEM AMC Firmware Project
========================

This repository contains sources for common GEM AMC firmware logic as well as board specific implementations for GLIB (Virtex 6) and CTP7 (Virtex 7).
Note that this repository excludes ISE / Vivado project directories entirely to avoid generated files, although XISE / XPR files are included in directories called work_dir. Those XISE / XPR files are referencing the source code outside work_dir and once opened will generate an ISE / Vivado project in the work_dir. PLEASE DO NOT COMMIT ANY FILES FROM THE WORK_DIR OTHER THAN XISE / XPR!!! 
