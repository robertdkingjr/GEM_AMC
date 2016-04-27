#!/bin/bash

BASE_DIR=$1

if [ -z "$BASE_DIR" ]; then
        BASE_DIR=".."
fi

mkdir $BASE_DIR/sigasi
mkdir $BASE_DIR/sigasi/gem_ctp7

#sorry, I hardcoded my paths here, you have to change these to point to your vivado instalation and the directory where you've cloned https://github.com/sigasi/SigasiProjectCreator.git

SCRIPTS_DIR=`pwd`
cd $BASE_DIR/sigasi/gem_ctp7
source /opt/Xilinx/Vivado/2015.4/settings64.sh
#generate a list of files in CSV format
vivado -mode batch -source $HOME/programs/dev/sigasi/SigasiProjectCreator/convertVivadoProjectToCsv.tcl $SCRIPTS_DIR/../ctp7/work_dir/gem_amc.xpr

#generate the sigasi project
$HOME/programs/dev/sigasi/SigasiProjectCreator/convertCsvFileToTree.py gem_ctp7 vivado_files.csv

#remove all IP files
sed -i "/\/ip\//d" .library_mapping.xml
