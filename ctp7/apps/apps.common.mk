CFLAGS= -fomit-frame-pointer -pipe -fno-common -fno-builtin \
	-Wall \
	-march=armv7-a -mfpu=neon -mfloat-abi=softfp \
	-mthumb-interwork -mtune=cortex-a9 \
	-DEMBED -Dlinux -D__linux__ -Dunix -fPIC \
	-I$(PETA_STAGE)/usr/include \
	-I$(PETA_STAGE)/include

LDLIBS= -L$(PETA_STAGE)/lib \
	-L$(PETA_STAGE)/usr/lib

LDFLAGS= -L$(PETA_STAGE)/lib \
	-L$(PETA_STAGE)/usr/lib

CXX=arm-xilinx-linux-gnueabi-g++
CC=arm-xilinx-linux-gnueabi-gcc


