import sys, os, subprocess, time
from ctypes import *
import uhal
from rw_reg import *

def main():

    # print 'Loading shared library: /mnt/persistent/texas/shared_libs/librwreg.so'
    # lib = CDLL("/mnt/persistent/texas/shared_libs/librwreg.so")
    # rReg = lib.getReg
    # rReg.restype = c_uint
    # rReg.argtypes=[c_uint]
    # wReg = lib.putReg
    # wReg.argtypes=[c_uint,c_uint]

    CTP7 = parseCTP7()
    GLIB = parseGLIB()


    ctp7_reg = "GEM_AMC.GEM_SYSTEM.BOARD_ID"
    oh_reg = ""
    glib_reg = "GEM_AMC.GEM_SYSTEM.BOARD_ID"

    # t = time.time()
    # for i in range(1000):
    #     rReg(ctp7_reg)
    # t = time.time() - t
    
    # print "Time to read 1000 CTP7 registers: %f seconds"%t

    for i in range(5):
        t = time.time()
        for i in range(1000):
            value = CTP7.getNode(glib_reg).read()
            CTP7.dispatch()
        t = time.time() - t
        
        print "Time to read 1000 GLIB registers: %f seconds"%t


    for i in range(5):
        t = time.time()
        for i in range(1000):
            value = GLIB.getNode(glib_reg).read()
            GLIB.dispatch()
        t = time.time() - t
        
        print "Time to read 1000 GLIB registers: %f seconds"%t
    


if __name__ == '__main__':
    main()
