#!/bin/sh

MODULE=$1
if [ -z "$INTERVAL" ]; then
    echo "Usage: this_script.sh <module_name>"
    echo "Available modules:"
    echo "TTC"    echo "TRIGGER"    echo "GEM_SYSTEM"    echo "DAQ"    exit
fi

if [ "$MODULE" = "TTC" ]; then
    printf 'GEM_AMC.TTC.CTRL.L1A_ENABLE                   = 0x%x\n' $(( (`mpeek 0x64c00000` & 0x00000001) >> 0 ))
    printf 'GEM_AMC.TTC.CONFIG.CMD_BC0                    = 0x%x\n' $(( (`mpeek 0x64c00004` & 0x000000ff) >> 0 ))
    printf 'GEM_AMC.TTC.CONFIG.CMD_EC0                    = 0x%x\n' $(( (`mpeek 0x64c00004` & 0x0000ff00) >> 8 ))
    printf 'GEM_AMC.TTC.CONFIG.CMD_RESYNC                 = 0x%x\n' $(( (`mpeek 0x64c00004` & 0x00ff0000) >> 16 ))
    printf 'GEM_AMC.TTC.CONFIG.CMD_OC0                    = 0x%x\n' $(( (`mpeek 0x64c00004` & 0xff000000) >> 24 ))
    printf 'GEM_AMC.TTC.CONFIG.CMD_HARD_RESET             = 0x%x\n' $(( (`mpeek 0x64c00008` & 0x000000ff) >> 0 ))
    printf 'GEM_AMC.TTC.CONFIG.CMD_CALPULSE               = 0x%x\n' $(( (`mpeek 0x64c00008` & 0x0000ff00) >> 8 ))
    printf 'GEM_AMC.TTC.CONFIG.CMD_START                  = 0x%x\n' $(( (`mpeek 0x64c00008` & 0x00ff0000) >> 16 ))
    printf 'GEM_AMC.TTC.CONFIG.CMD_STOP                   = 0x%x\n' $(( (`mpeek 0x64c00008` & 0xff000000) >> 24 ))
    printf 'GEM_AMC.TTC.CONFIG.CMD_TEST_SYNC              = 0x%x\n' $(( (`mpeek 0x64c0000c` & 0x000000ff) >> 0 ))
    printf 'GEM_AMC.TTC.STATUS.MMCM_LOCKED                = 0x%x\n' $(( (`mpeek 0x64c00010` & 0x00000001) >> 0 ))
    printf 'GEM_AMC.TTC.STATUS.TTC_SINGLE_ERROR_CNT       = 0x%x\n' $(( (`mpeek 0x64c00014` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TTC.STATUS.TTC_DOUBLE_ERROR_CNT       = 0x%x\n' $(( (`mpeek 0x64c00014` & 0xffff0000) >> 16 ))
    printf 'GEM_AMC.TTC.STATUS.BC0.LOCKED                 = 0x%x\n' $(( (`mpeek 0x64c00018` & 0x00000001) >> 0 ))
    printf 'GEM_AMC.TTC.STATUS.BC0.UNLOCK_CNT             = 0x%x\n' $(( (`mpeek 0x64c0001c` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TTC.STATUS.BC0.OVERFLOW_CNT           = 0x%x\n' $(( (`mpeek 0x64c00020` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TTC.STATUS.BC0.UNDERFLOW_CNT          = 0x%x\n' $(( (`mpeek 0x64c00020` & 0xffff0000) >> 16 ))
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
    printf 'GEM_AMC.TTC.L1A_ID                            = 0x%x\n' $(( (`mpeek 0x64c0004c` & 0x00ffffff) >> 0 ))
    printf 'GEM_AMC.TTC.TTC_SPY_BUFFER                    = 0x%x\n' `mpeek 0x64c00050` 
fi

if [ "$MODULE" = "TRIGGER" ]; then
    printf 'GEM_AMC.TRIGGER.CTRL.OH_KILL_MASK             = 0x%x\n' $(( (`mpeek 0x66000004` & 0x00ffffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.STATUS.OR_TRIGGER_RATE        = 0x%x\n' `mpeek 0x66000040` 
    printf 'GEM_AMC.TRIGGER.OH_0.TRIGGER_RATE             = 0x%x\n' `mpeek 0x66000400` 
    printf 'GEM_AMC.TRIGGER.OH_0.CLUSTER_SIZE_0_RATE      = 0x%x\n' `mpeek 0x66000404` 
    printf 'GEM_AMC.TRIGGER.OH_0.CLUSTER_SIZE_1_RATE      = 0x%x\n' `mpeek 0x66000408` 
    printf 'GEM_AMC.TRIGGER.OH_0.CLUSTER_SIZE_2_RATE      = 0x%x\n' `mpeek 0x6600040c` 
    printf 'GEM_AMC.TRIGGER.OH_0.CLUSTER_SIZE_3_RATE      = 0x%x\n' `mpeek 0x66000410` 
    printf 'GEM_AMC.TRIGGER.OH_0.CLUSTER_SIZE_4_RATE      = 0x%x\n' `mpeek 0x66000414` 
    printf 'GEM_AMC.TRIGGER.OH_0.CLUSTER_SIZE_5_RATE      = 0x%x\n' `mpeek 0x66000418` 
    printf 'GEM_AMC.TRIGGER.OH_0.CLUSTER_SIZE_6_RATE      = 0x%x\n' `mpeek 0x6600041c` 
    printf 'GEM_AMC.TRIGGER.OH_0.CLUSTER_SIZE_7_RATE      = 0x%x\n' `mpeek 0x66000420` 
    printf 'GEM_AMC.TRIGGER.OH_0.CLUSTER_SIZE_8_RATE      = 0x%x\n' `mpeek 0x66000424` 
    printf 'GEM_AMC.TRIGGER.OH_0.LINK0_NOT_VALID_CNT      = 0x%x\n' $(( (`mpeek 0x66000428` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH_0.LINK1_NOT_VALID_CNT      = 0x%x\n' $(( (`mpeek 0x66000428` & 0xffff0000) >> 16 ))
    printf 'GEM_AMC.TRIGGER.OH_0.LINK0_MISSED_COMMA_CNT   = 0x%x\n' $(( (`mpeek 0x6600042c` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH_0.LINK1_MISSED_COMMA_CNT   = 0x%x\n' $(( (`mpeek 0x6600042c` & 0xffff0000) >> 16 ))
    printf 'GEM_AMC.TRIGGER.OH_0.LINK0_OVERFLOW_CNT       = 0x%x\n' $(( (`mpeek 0x66000430` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH_0.LINK1_OVERFLOW_CNT       = 0x%x\n' $(( (`mpeek 0x66000430` & 0xffff0000) >> 16 ))
    printf 'GEM_AMC.TRIGGER.OH_0.LINK0_UNDERFLOW_CNT      = 0x%x\n' $(( (`mpeek 0x66000434` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH_0.LINK1_UNDERFLOW_CNT      = 0x%x\n' $(( (`mpeek 0x66000434` & 0xffff0000) >> 16 ))
    printf 'GEM_AMC.TRIGGER.OH_0.LINK0_SYNC_WORD_CNT      = 0x%x\n' $(( (`mpeek 0x66000438` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH_0.LINK1_SYNC_WORD_CNT      = 0x%x\n' $(( (`mpeek 0x66000438` & 0xffff0000) >> 16 ))
    printf 'GEM_AMC.TRIGGER.OH_0.DEBUG_LAST_CLUSTER_0     = 0x%x\n' $(( (`mpeek 0x66000440` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH_0.DEBUG_LAST_CLUSTER_1     = 0x%x\n' $(( (`mpeek 0x66000444` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH_0.DEBUG_LAST_CLUSTER_2     = 0x%x\n' $(( (`mpeek 0x66000448` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH_0.DEBUG_LAST_CLUSTER_3     = 0x%x\n' $(( (`mpeek 0x6600044c` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH_0.DEBUG_LAST_CLUSTER_4     = 0x%x\n' $(( (`mpeek 0x66000450` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH_0.DEBUG_LAST_CLUSTER_5     = 0x%x\n' $(( (`mpeek 0x66000454` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH_0.DEBUG_LAST_CLUSTER_6     = 0x%x\n' $(( (`mpeek 0x66000458` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH_0.DEBUG_LAST_CLUSTER_7     = 0x%x\n' $(( (`mpeek 0x6600045c` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH_1.TRIGGER_RATE             = 0x%x\n' `mpeek 0x66000800` 
    printf 'GEM_AMC.TRIGGER.OH_1.CLUSTER_SIZE_0_RATE      = 0x%x\n' `mpeek 0x66000804` 
    printf 'GEM_AMC.TRIGGER.OH_1.CLUSTER_SIZE_1_RATE      = 0x%x\n' `mpeek 0x66000808` 
    printf 'GEM_AMC.TRIGGER.OH_1.CLUSTER_SIZE_2_RATE      = 0x%x\n' `mpeek 0x6600080c` 
    printf 'GEM_AMC.TRIGGER.OH_1.CLUSTER_SIZE_3_RATE      = 0x%x\n' `mpeek 0x66000810` 
    printf 'GEM_AMC.TRIGGER.OH_1.CLUSTER_SIZE_4_RATE      = 0x%x\n' `mpeek 0x66000814` 
    printf 'GEM_AMC.TRIGGER.OH_1.CLUSTER_SIZE_5_RATE      = 0x%x\n' `mpeek 0x66000818` 
    printf 'GEM_AMC.TRIGGER.OH_1.CLUSTER_SIZE_6_RATE      = 0x%x\n' `mpeek 0x6600081c` 
    printf 'GEM_AMC.TRIGGER.OH_1.CLUSTER_SIZE_7_RATE      = 0x%x\n' `mpeek 0x66000820` 
    printf 'GEM_AMC.TRIGGER.OH_1.CLUSTER_SIZE_8_RATE      = 0x%x\n' `mpeek 0x66000824` 
    printf 'GEM_AMC.TRIGGER.OH_1.LINK0_NOT_VALID_CNT      = 0x%x\n' $(( (`mpeek 0x66000828` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH_1.LINK1_NOT_VALID_CNT      = 0x%x\n' $(( (`mpeek 0x66000828` & 0xffff0000) >> 16 ))
    printf 'GEM_AMC.TRIGGER.OH_1.LINK0_MISSED_COMMA_CNT   = 0x%x\n' $(( (`mpeek 0x6600082c` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH_1.LINK1_MISSED_COMMA_CNT   = 0x%x\n' $(( (`mpeek 0x6600082c` & 0xffff0000) >> 16 ))
    printf 'GEM_AMC.TRIGGER.OH_1.LINK0_OVERFLOW_CNT       = 0x%x\n' $(( (`mpeek 0x66000830` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH_1.LINK1_OVERFLOW_CNT       = 0x%x\n' $(( (`mpeek 0x66000830` & 0xffff0000) >> 16 ))
    printf 'GEM_AMC.TRIGGER.OH_1.LINK0_UNDERFLOW_CNT      = 0x%x\n' $(( (`mpeek 0x66000834` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH_1.LINK1_UNDERFLOW_CNT      = 0x%x\n' $(( (`mpeek 0x66000834` & 0xffff0000) >> 16 ))
    printf 'GEM_AMC.TRIGGER.OH_1.LINK0_SYNC_WORD_CNT      = 0x%x\n' $(( (`mpeek 0x66000838` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH_1.LINK1_SYNC_WORD_CNT      = 0x%x\n' $(( (`mpeek 0x66000838` & 0xffff0000) >> 16 ))
    printf 'GEM_AMC.TRIGGER.OH_1.DEBUG_LAST_CLUSTER_0     = 0x%x\n' $(( (`mpeek 0x66000840` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH_1.DEBUG_LAST_CLUSTER_1     = 0x%x\n' $(( (`mpeek 0x66000844` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH_1.DEBUG_LAST_CLUSTER_2     = 0x%x\n' $(( (`mpeek 0x66000848` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH_1.DEBUG_LAST_CLUSTER_3     = 0x%x\n' $(( (`mpeek 0x6600084c` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH_1.DEBUG_LAST_CLUSTER_4     = 0x%x\n' $(( (`mpeek 0x66000850` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH_1.DEBUG_LAST_CLUSTER_5     = 0x%x\n' $(( (`mpeek 0x66000854` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH_1.DEBUG_LAST_CLUSTER_6     = 0x%x\n' $(( (`mpeek 0x66000858` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH_1.DEBUG_LAST_CLUSTER_7     = 0x%x\n' $(( (`mpeek 0x6600085c` & 0x0000ffff) >> 0 ))
fi

if [ "$MODULE" = "GEM_SYSTEM" ]; then
    printf 'GEM_AMC.GEM_SYSTEM.TK_LINK_RX_POLARITY        = 0x%x\n' $(( (`mpeek 0x66400000` & 0x00ffffff) >> 0 ))
    printf 'GEM_AMC.GEM_SYSTEM.TK_LINK_TX_POLARITY        = 0x%x\n' $(( (`mpeek 0x66400004` & 0x00ffffff) >> 0 ))
    printf 'GEM_AMC.GEM_SYSTEM.BOARD_ID                   = 0x%x\n' $(( (`mpeek 0x66400008` & 0x0000ffff) >> 0 ))
fi

if [ "$MODULE" = "DAQ" ]; then
    printf 'GEM_AMC.DAQ.CONTROL.DAQ_ENABLE                = 0x%x\n' $(( (`mpeek 0x65c00000` & 0x00000001) >> 0 ))
    printf 'GEM_AMC.DAQ.CONTROL.DAQ_LINK_RESET            = 0x%x\n' $(( (`mpeek 0x65c00000` & 0x00000004) >> 2 ))
    printf 'GEM_AMC.DAQ.CONTROL.RESET                     = 0x%x\n' $(( (`mpeek 0x65c00000` & 0x00000008) >> 3 ))
    printf 'GEM_AMC.DAQ.CONTROL.TTS_OVERRIDE              = 0x%x\n' $(( (`mpeek 0x65c00000` & 0x000000f0) >> 4 ))
    printf 'GEM_AMC.DAQ.CONTROL.INPUT_ENABLE_MASK         = 0x%x\n' $(( (`mpeek 0x65c00000` & 0xffffff00) >> 8 ))
    printf 'GEM_AMC.DAQ.STATUS.DAQ_LINK_RDY               = 0x%x\n' $(( (`mpeek 0x65c00004` & 0x00000001) >> 0 ))
    printf 'GEM_AMC.DAQ.STATUS.DAQ_CLK_LOCKED             = 0x%x\n' $(( (`mpeek 0x65c00004` & 0x00000002) >> 1 ))
    printf 'GEM_AMC.DAQ.STATUS.TTC_RDY                    = 0x%x\n' $(( (`mpeek 0x65c00004` & 0x00000004) >> 2 ))
    printf 'GEM_AMC.DAQ.STATUS.DAQ_LINK_AFULL             = 0x%x\n' $(( (`mpeek 0x65c00004` & 0x00000008) >> 3 ))
    printf 'GEM_AMC.DAQ.STATUS.TTC_BC0_LOCKED             = 0x%x\n' $(( (`mpeek 0x65c00004` & 0x00000010) >> 4 ))
    printf 'GEM_AMC.DAQ.STATUS.ERR_L1A_FIFO_OVERFLOW      = 0x%x\n' $(( (`mpeek 0x65c00004` & 0x00800000) >> 23 ))
    printf 'GEM_AMC.DAQ.STATUS.L1A_FIFO_UNDERFLOW         = 0x%x\n' $(( (`mpeek 0x65c00004` & 0x01000000) >> 24 ))
    printf 'GEM_AMC.DAQ.STATUS.L1A_FIFO_FULL              = 0x%x\n' $(( (`mpeek 0x65c00004` & 0x02000000) >> 25 ))
    printf 'GEM_AMC.DAQ.STATUS.L1A_FIFO_NEAR_FULL         = 0x%x\n' $(( (`mpeek 0x65c00004` & 0x04000000) >> 26 ))
    printf 'GEM_AMC.DAQ.STATUS.L1A_FIFO_EMPTY             = 0x%x\n' $(( (`mpeek 0x65c00004` & 0x08000000) >> 27 ))
    printf 'GEM_AMC.DAQ.STATUS.TTS_STATE                  = 0x%x\n' $(( (`mpeek 0x65c00004` & 0xf0000000) >> 28 ))
    printf 'GEM_AMC.DAQ.EXT_STATUS.NOTINTABLE_ERR         = 0x%x\n' $(( (`mpeek 0x65c00008` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.DAQ.EXT_STATUS.DISPER_ERR             = 0x%x\n' $(( (`mpeek 0x65c0000c` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.DAQ.EXT_STATUS.L1AID                  = 0x%x\n' $(( (`mpeek 0x65c00010` & 0x00ffffff) >> 0 ))
    printf 'GEM_AMC.DAQ.EXT_STATUS.EVT_SENT               = 0x%x\n' `mpeek 0x65c00014` 
    printf 'GEM_AMC.DAQ.CONTROL.DAV_TIMEOUT               = 0x%x\n' $(( (`mpeek 0x65c00018` & 0x00ffffff) >> 0 ))
    printf 'GEM_AMC.DAQ.EXT_STATUS.MAX_DAV_TIMER          = 0x%x\n' $(( (`mpeek 0x65c0001c` & 0x00ffffff) >> 0 ))
    printf 'GEM_AMC.DAQ.EXT_STATUS.LAST_DAV_TIMER         = 0x%x\n' $(( (`mpeek 0x65c00020` & 0x00ffffff) >> 0 ))
    printf 'GEM_AMC.DAQ.EXT_CONTROL.RUN_PARAMS            = 0x%x\n' $(( (`mpeek 0x65c0003c` & 0x00ffffff) >> 0 ))
    printf 'GEM_AMC.DAQ.EXT_CONTROL.RUN_TYPE              = 0x%x\n' $(( (`mpeek 0x65c0003c` & 0x0f000000) >> 24 ))
fi

