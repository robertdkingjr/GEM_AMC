#!/bin/sh

MODULE=$1
if [ -z "$INTERVAL" ]; then
    echo "Usage: this_script.sh <module_name>"
    echo "Available modules:"
    echo "TTC"    exit
fi

if [ "$MODULE" = "TTC" ]; then
    printf 'GEM_AMC.TTC.CTRL.L1A_ENABLE                   = 0x%x\n' $(( `mpeek 0x64c00000` & 0x00000001 ))
    printf 'GEM_AMC.TTC.CONFIG.CMD_BC0                    = 0x%x\n' $(( `mpeek 0x64c00004` & 0x000000ff ))
    printf 'GEM_AMC.TTC.CONFIG.CMD_EC0                    = 0x%x\n' $(( `mpeek 0x64c00004` & 0x0000ff00 ))
    printf 'GEM_AMC.TTC.CONFIG.CMD_RESYNC                 = 0x%x\n' $(( `mpeek 0x64c00004` & 0x00ff0000 ))
    printf 'GEM_AMC.TTC.CONFIG.CMD_OC0                    = 0x%x\n' $(( `mpeek 0x64c00004` & 0xff000000 ))
    printf 'GEM_AMC.TTC.CONFIG.CMD_HARD_RESET             = 0x%x\n' $(( `mpeek 0x64c00008` & 0x000000ff ))
    printf 'GEM_AMC.TTC.CONFIG.CMD_CALPULSE               = 0x%x\n' $(( `mpeek 0x64c00008` & 0x0000ff00 ))
    printf 'GEM_AMC.TTC.CONFIG.CMD_START                  = 0x%x\n' $(( `mpeek 0x64c00008` & 0x00ff0000 ))
    printf 'GEM_AMC.TTC.CONFIG.CMD_STOP                   = 0x%x\n' $(( `mpeek 0x64c00008` & 0xff000000 ))
    printf 'GEM_AMC.TTC.CONFIG.CMD_TEST_SYNC              = 0x%x\n' $(( `mpeek 0x64c0000c` & 0x000000ff ))
    printf 'GEM_AMC.TTC.STATUS.MMCM_LOCKED                = 0x%x\n' $(( `mpeek 0x64c00010` & 0x00000001 ))
    printf 'GEM_AMC.TTC.STATUS.TTC_SINGLE_ERROR_CNT       = 0x%x\n' $(( `mpeek 0x64c00014` & 0x0000ffff ))
    printf 'GEM_AMC.TTC.STATUS.TTC_DOUBLE_ERROR_CNT       = 0x%x\n' $(( `mpeek 0x64c00014` & 0xffff0000 ))
    printf 'GEM_AMC.TTC.STATUS.BC0.LOCKED                 = 0x%x\n' $(( `mpeek 0x64c00018` & 0x00000001 ))
    printf 'GEM_AMC.TTC.STATUS.BC0.UNLOCK_CNT             = 0x%x\n' $(( `mpeek 0x64c0001c` & 0x0000ffff ))
    printf 'GEM_AMC.TTC.STATUS.BC0.OVERFLOW_CNT           = 0x%x\n' $(( `mpeek 0x64c00020` & 0x0000ffff ))
    printf 'GEM_AMC.TTC.STATUS.BC0.UNDERFLOW_CNT          = 0x%x\n' $(( `mpeek 0x64c00020` & 0xffff0000 ))
    printf 'GEM_AMC.TTC.CMD_COUNTERS.L1A                  = 0x%x\n' `mpeek 0x64c00024` 
    printf 'GEM_AMC.TTC.CMD_COUNTERS.BC0                  = 0x%x\n' `mpeek 0x64c00028` 
    printf 'GEM_AMC.TTC.CMD_COUNTERS.EC0                  = 0x%x\n' `mpeek 0x64c0002c` 
    printf 'GEM_AMC.TTC.CMD_COUNTERS.RESYNC               = 0x%x\n' `mpeek 0x64c00030` 
    printf 'GEM_AMC.TTC.CMD_COUNTERS.OC0                  = 0x%x\n' `mpeek 0x64c00034` 
    printf 'GEM_AMC.TTC.CMD_COUNTERS.HARD_RESET           = 0x%x\n' `mpeek 0x64c00038` 
    printf 'GEM_AMC.TTC.CMD_COUNTERS.CALPULSE             = 0x%x\n' `mpeek 0x64c0003c` 
    printf 'GEM_AMC.TTC.CMD_COUNTERS.START                = 0x%x\n' `mpeek 0x64c00040` 
    printf 'GEM_AMC.TTC.CMD_COUNTERS.STOP                 = 0x%x\n' `mpeek 0x64c00044` 
    printf 'GEM_AMC.TTC.CMD_COUNTERS.TEST_SYNC            = 0x%x\n' `mpeek 0x64c00048` 
    printf 'GEM_AMC.TTC.L1A_ID                            = 0x%x\n' $(( `mpeek 0x64c0004c` & 0x00ffffff ))
    printf 'GEM_AMC.TTC.TTC_SPY_BUFFER                    = 0x%x\n' `mpeek 0x64c00050` 
fi

