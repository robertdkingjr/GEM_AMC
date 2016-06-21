from rw_reg import *

#VFAT DEFAULTS
CONTREG0=55
CONTREG1=0
CONTREG2=48
CONTREG3=0
IPREAMPIN=168
IPREAMPFEED=80
IPREAMPOUT=150
ISHAPER=150
ISHAPERFEED=100
ICOMP=75

VTHRESHOLD1=50
VCAL=190


class Colors:
    WHITE   = '\033[97m'
    CYAN    = '\033[96m'
    MAGENTA = '\033[95m'
    BLUE    = '\033[94m'
    YELLOW  = '\033[93m'
    GREEN   = '\033[92m'
    RED     = '\033[91m'
    ENDC    = '\033[0m'



# Set default VFAT values & RunMode
# Returns True if regs written and False if not
def setVFATRunMode(OH_NUM,VFAT_SLOT,Silent=False):
    if int(OH_NUM)<0 or int(OH_NUM)>3 or int(VFAT_SLOT)<0 or int(VFAT_SLOT)>23: return False
    REG_PATH = 'GEM_AMC.OH.OH'+str(OH_NUM)+'.GEB.VFATS.VFAT'+str(VFAT_SLOT)+'.'
    try:
        if not Silent:
            print writeReg(getNode(REG_PATH+'ContReg0'),CONTREG0)
            print writeReg(getNode(REG_PATH+'ContReg1'),CONTREG1)
            print writeReg(getNode(REG_PATH+'ContReg2'),CONTREG2)
            print writeReg(getNode(REG_PATH+'ContReg3'),CONTREG3)
            print writeReg(getNode(REG_PATH+'IPreampIn'),IPREAMPIN)
            print writeReg(getNode(REG_PATH+'IPreampFeed'),IPREAMPFEED)
            print writeReg(getNode(REG_PATH+'IPreampOut'),IPREAMPOUT)
            print writeReg(getNode(REG_PATH+'IShaper'),ISHAPER)
            print writeReg(getNode(REG_PATH+'IShaperFeed'),ISHAPERFEED)
            print writeReg(getNode(REG_PATH+'IComp'),ICOMP)
            print writeReg(getNode(REG_PATH+'VThreshold1'),VTHRESHOLD1)
            print writeReg(getNode(REG_PATH+'VCal'),VCAL)
            print writeReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.CONTROL.TRIGGER'),1)
        else:
            writeReg(getNode(REG_PATH+'ContReg0'),CONTREG0)
            writeReg(getNode(REG_PATH+'ContReg1'),CONTREG1)
            writeReg(getNode(REG_PATH+'ContReg2'),CONTREG2)
            writeReg(getNode(REG_PATH+'ContReg3'),CONTREG3)
            writeReg(getNode(REG_PATH+'IPreampIn'),IPREAMPIN)
            writeReg(getNode(REG_PATH+'IPreampFeed'),IPREAMPFEED)
            writeReg(getNode(REG_PATH+'IPreampOut'),IPREAMPOUT)
            writeReg(getNode(REG_PATH+'IShaper'),ISHAPER)
            writeReg(getNode(REG_PATH+'IShaperFeed'),ISHAPERFEED)
            writeReg(getNode(REG_PATH+'IComp'),ICOMP)
            writeReg(getNode(REG_PATH+'VThreshold1'),VTHRESHOLD1)
            writeReg(getNode(REG_PATH+'VCal'),VCAL)
            writeReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.CONTROL.TRIGGER'),1)
        return True
    except:
        return False

def setAllVFATsRunMode(OH_NUM,Silent=True):
    try:
        for v in range(24):
            setVFATRunMode(OH_NUM,v,Silent)
        return True
    except:
        return False


def getVFATID(OH_NUM,vfat_slot):
#    try:
    vfat_id1 = 0x000000ff & parseInt(readReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.GEB.VFATS.VFAT'+str(vfat_slot)+'.ChipID1')))
    vfat_id2 = 0x000000ff & parseInt(readReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.GEB.VFATS.VFAT'+str(vfat_slot)+'.ChipID0')))
    vfat_id = (vfat_id1 << 8) + vfat_id2
    if vfat_id == 0: return 0
    return hex(vfat_id)
    #except:
     #   return 0xdead

def unmaskVFAT(OH_NUM,vfat_slot):
    SBitMask = getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.CONTROL.VFAT.SBIT_MASK')
    vmask = (0xffffffff) ^ (0x1 << int(vfat_slot))
    writeReg(SBitMask,vmask)
    return

def resetTriggerCounters():
    writeReg(getNode('GEM_AMC.TRIGGER.CTRL.CNT_RESET'),1)
    writeReg(getNode('GEM_AMC.TRIGGER.CTRL.CNT_RESET'),0)

#Verify trigger counters are reset
def verifyTCReset(OH_NUM):
    nSbits = readReg(getNode('GEM_AMC.TRIGGER.OH'+str(OH_NUM)+'.TRIGGER_CNT'))
    try: parseInt(nSbits)
    except: return False, nSbits

    if parseInt(nSbits) != 0: #Hot channels?
        print 'Trigger Counter Reset did not clear Trigger Counts!',Colors.ENDC
        print 'Triggers:',nSbits,'=',parseInt(nSbits),'\n'
        return False, nSbits

    else: return True, 0

def configureT1(OH_NUM,MODE,TYPE,INTERVAL,NUMBER,Silent=False):
    if not Silent:
        print writeReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.MODE'), MODE)
        print writeReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.TYPE'), TYPE)
        print writeReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.INTERVAL'), INTERVAL)
        print writeReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.NUMBER'), NUMBER)
    else:
        writeReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.MODE'), MODE)
        writeReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.TYPE'), TYPE)
        writeReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.INTERVAL'), INTERVAL)
        writeReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.NUMBER'), NUMBER)


def printClusters(OH_NUM):
    for reg in getNodesContaining('TRIGGER.OH'+str(OH_NUM)+'.CLUSTER'):
        if 'r' in str(reg.permission):
            print displayReg(reg),'=',parseInt(str(readReg(reg)))
    print '\n'
    for reg in getNodesContaining('TRIGGER.OH'+str(OH_NUM)+'.DEBUG_LAST_CLUSTER'):
        if 'r' in str(reg.permission):
            print displayReg(reg,'hexbin')

def clearChannel(OH_NUM,vfat_slot,channel):
    writeReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.GEB.VFATS.VFAT'+str(vfat_slot)+'.VFATChannels.ChanReg'+str(channel)),0)

def clearAllChannels(OH_NUM,vfat_slot):
    for chan in range(1,129):
        clearChannel(OH_NUM,vfat_slot,chan)

def clearAllVFATChannels(OH_NUM):
    for vfat in range(24):
        clearAllChannels(OH_NUM,vfat)


def activateChannel(OH_NUM,vfat_slot,channel):
    writeReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.GEB.VFATS.VFAT'+str(vfat_slot)+'.VFATChannels.ChanReg'+str(channel)),64)
