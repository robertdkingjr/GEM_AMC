#!/bin/bash

BASE_DIR=$1

if [ -z "$BASE_DIR" ]; then
        BASE_DIR=".."
fi

SIGASI_PRJ_CREATOR_DIR=$HOME/programs/dev/sigasi/SigasiProjectCreator # path to directory where you cloned https://github.com/sigasi/SigasiProjectCreator.git
SIGASI_PRJ_DIR=$BASE_DIR/sigasi/gem_glib

mkdir $BASE_DIR/sigasi
mkdir $SIGASI_PRJ_DIR

#sorry, I hardcoded my paths here, you have to change these to point to your vivado instalation and the directory where you've cloned https://github.com/sigasi/SigasiProjectCreator.git

SCRIPTS_DIR=`pwd`
cd $SIGASI_PRJ_DIR

python $SIGASI_PRJ_CREATOR_DIR/convertXilinxISEToSigasiProject.py gem_glib $SCRIPTS_DIR/../glib/work_dir/gem_glib.xise

#remove all IP files
sed -i "/\/ip\//d" .library_mapping.xml

#add unisim libs
echo "TODO: add Xilinx libraries"
#sed -i -e "/xmlns:com.sigasi/a"$'\\\n'"  <Mappings Location=\"Common Libraries/unisim\" Library=\"unisim\"/>"$'\n' .library_mapping.xml
#sed -i -e "/xmlns:com.sigasi/a"$'\\\n'"  <Mappings Location=\"Common Libraries/unisim/secureip\" Library=\"not mapped\"/>"$'\n' .library_mapping.xml
#sed -i -e "/xmlns:com.sigasi/a"$'\\\n'"  <Mappings Location=\"Common Libraries/unisim/primitive\" Library=\"not mapped\"/>"$'\n' .library_mapping.xml
#sed -i -e "/<linkedResources>/a"$'\\\n'"		<link>\n			<name>Common Libraries/unisim</name>\n			<type>2</type>\n			<locationURI>SIGASI_TOOLCHAIN_XILINX_VIVADO/ids_lite/ISE/vhdl/src/unisims</locationURI>\n		</link>"$'\n' .project
