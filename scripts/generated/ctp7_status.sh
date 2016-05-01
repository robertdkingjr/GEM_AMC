#!/bin/bash

MODULE=$1
if [ -z "$INTERVAL" ]; then
    echo "Usage: this_script.sh <module_name>"
    echo "Available modules:"
    echo "GEM_AMC.TTC"    exit
fi

if [ "$MODULE" = "TTC" ]; then
    printf 'GEM_AMC.TTC.CTRL.L1A_ENABLE                   = %s' $(( `mpeek 0x64c00000` & 0x00000001 ))
    printf 'GEM_AMC.TTC.CONFIG.CMD_BC0                    = %s' $(( `mpeek 0x64c00004` & 0x000000ff ))
    printf 'GEM_AMC.TTC.CONFIG.CMD_EC0                    = %s' $(( `mpeek 0x64c00004` & 0x0000ff00 ))
    printf 'GEM_AMC.TTC.CONFIG.CMD_RESYNC                 = %s' $(( `mpeek 0x64c00004` & 0x00ff0000 ))
    printf 'GEM_AMC.TTC.CONFIG.CMD_OC0                    = %s' $(( `mpeek 0x64c00004` & 0xff000000 ))
    printf 'GEM_AMC.TTC.CONFIG.CMD_HARD_RESET             = %s' $(( `mpeek 0x64c00008` & 0x000000ff ))
    printf 'GEM_AMC.TTC.CONFIG.CMD_CALPULSE               = %s' $(( `mpeek 0x64c00008` & 0x0000ff00 ))
    printf 'GEM_AMC.TTC.CONFIG.CMD_START                  = %s' $(( `mpeek 0x64c00008` & 0x00ff0000 ))
    printf 'GEM_AMC.TTC.CONFIG.CMD_STOP                   = %s' $(( `mpeek 0x64c00008` & 0xff000000 ))
    printf 'GEM_AMC.TTC.CONFIG.CMD_TEST_SYNC              = %s' $(( `mpeek 0x64c0000c` & 0x000000ff ))
    printf 'GEM_AMC.TTC.STATUS.MMCM_LOCKED                = %s' $(( `mpeek 0x64c00010` & 0x00000001 ))
    printf 'GEM_AMC.TTC.STATUS.TTC_SINGLE_ERROR_CNT       = %s' $(( `mpeek 0x64c00014` & 0x0000ffff ))
    printf 'GEM_AMC.TTC.STATUS.TTC_DOUBLE_ERROR_CNT       = %s' $(( `mpeek 0x64c00014` & 0xffff0000 ))
    printf 'GEM_AMC.TTC.STATUS.BC0.LOCKED                 = %s' $(( `mpeek 0x64c00018` & 0x00000001 ))
    printf 'GEM_AMC.TTC.STATUS.BC0.UNLOCK_CNT             = %s' $(( `mpeek 0x64c0001c` & 0x0000ffff ))
    printf 'GEM_AMC.TTC.STATUS.BC0.OVERFLOW_CNT           = %s' $(( `mpeek 0x64c00020` & 0x0000ffff ))
    printf 'GEM_AMC.TTC.STATUS.BC0.UNDERFLOW_CNT          = %s' $(( `mpeek 0x64c00020` & 0xffff0000 ))
    printf 'GEM_AMC.TTC.CMD_COUNTERS.L1A                  = %s' $(( `mpeek 0x64c00024` & 0xffffffff ))
    printf 'GEM_AMC.TTC.CMD_COUNTERS.BC0                  = %s' $(( `mpeek 0x64c00028` & 0xffffffff ))
    printf 'GEM_AMC.TTC.CMD_COUNTERS.EC0                  = %s' $(( `mpeek 0x64c0002c` & 0xffffffff ))
    printf 'GEM_AMC.TTC.CMD_COUNTERS.RESYNC               = %s' $(( `mpeek 0x64c00030` & 0xffffffff ))
    printf 'GEM_AMC.TTC.CMD_COUNTERS.OC0                  = %s' $(( `mpeek 0x64c00034` & 0xffffffff ))
    printf 'GEM_AMC.TTC.CMD_COUNTERS.HARD_RESET           = %s' $(( `mpeek 0x64c00038` & 0xffffffff ))
    printf 'GEM_AMC.TTC.CMD_COUNTERS.CALPULSE             = %s' $(( `mpeek 0x64c0003c` & 0xffffffff ))
    printf 'GEM_AMC.TTC.CMD_COUNTERS.START                = %s' $(( `mpeek 0x64c00040` & 0xffffffff ))
    printf 'GEM_AMC.TTC.CMD_COUNTERS.STOP                 = %s' $(( `mpeek 0x64c00044` & 0xffffffff ))
    printf 'GEM_AMC.TTC.CMD_COUNTERS.TEST_SYNC            = %s' $(( `mpeek 0x64c00048` & 0xffffffff ))
    printf 'GEM_AMC.TTC.L1A_ID                            = %s' $(( `mpeek 0x64c0004c` & 0x00ffffff ))
    printf 'GEM_AMC.TTC.TTC_SPY_BUFFER                    = %s' $(( `mpeek 0x64c00050` & 0xffffffff ))
fi

