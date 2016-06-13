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
            #print writeReg(getNode(REG_PATH+'VThreshold1'),VTHRESHOLD1)
            #print writeReg(getNode(REG_PATH+'VCal'),VCAL)
            #print writeReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.CONTROL.TRIGGER'),1)
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
            #writeReg(getNode(REG_PATH+'VThreshold1'),VTHRESHOLD1)
            #writeReg(getNode(REG_PATH+'VCal'),VCAL)
            #writeReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.CONTROL.TRIGGER'),1)
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
