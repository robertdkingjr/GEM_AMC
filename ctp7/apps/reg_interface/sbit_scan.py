from rw_reg import *
from time import *
SBitMaskAddress = 0x6502c010
NUM_STRIPS = 128

# Experimental Registers
# 0x66400008
# GEM_AMC.GEM_SYSTEM.BOARD_ID

#DEFAULTS
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

VTHRESHOLD1=90
VCAL=190

pulses = 1000



def main():
    vfat_slot = raw_input('Enter VFAT slot: ')
    try:
        if int(vfat_slot) > 23 or int(vfat_slot) < 0:
            print 'Invalid VFAT slot!'
            return
    except:
        print 'Invalid input!'
        return
        
        


    REG_PATH = 'GEM_AMC.OH.OH0.GEB.VFATS.VFAT'+str(vfat_slot)+'.'

    subheading('Parsing address table.')
    parseXML()
    heading('Beginning SBit Scan')
    # Mask VFATs
    heading('MASK VFATS')
    SBitMask = getNode('GEM_AMC.OH.OH0.CONTROL.VFAT.SBIT_MASK')
    print 'Unmasking VFAT',vfat_slot
    
    vmask = (0xffffffff) ^ (0x1 << int(vfat_slot))

    print writeReg(SBitMask,vmask)


    heading('SET VFAT SETTINGS')
    # Set default VFAT values & Threshold,VCal,RunMode
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
    print writeReg(getNode('GEM_AMC.OH.OH0.CONTROL.TRIGGER'),1)


    heading('RESET TRIGGER COUNTERS')
    # Reset Trigger Counters
    TCReset = getNode('GEM_AMC.TRIGGER.CTRL.CNT_RESET')
    if TCReset is not None and DEBUG: pass
        #TCReset.output()
    else: print 'Error finding Trigget Counter Reset Register'
    print 'Resetting Trigger Counters...'
    print writeReg(TCReset,1)
    print writeReg(TCReset,0)
    print 'Trigger Counters reset.'
    
    print 'Verifying...'
    sleep(1)
    # Read Number of SBits
    nSbits = readReg(getNode('GEM_AMC.TRIGGER.OH0.TRIGGER_CNT'))
    if parseInt(str(nSbits)) != 0: 
        print 'Trigger Counter Reset did not clear Trigger Counts!'
        print 'SBits:',nSbits
        return
    else: print 'Trigger Counts clear'
    
    heading('LOOPING OVER CHANNELS')
    # Begin Loop
    nFailures=0

    print writeReg(getNode('GEM_AMC.OH.OH0.T1Controller.MODE'), 0) 
    print writeReg(getNode('GEM_AMC.OH.OH0.T1Controller.TYPE'), 1) 
    print writeReg(getNode('GEM_AMC.OH.OH0.T1Controller.INTERVAL'), 1000) 
    print writeReg(getNode('GEM_AMC.OH.OH0.T1Controller.NUMBER'), pulses)


    triggerResults = []

    try:
        for strip in range(1,NUM_STRIPS+1): 
            
            subheading('Strip '+str(strip))

            if strip>1: kill_strip=strip-1
            else: kill_strip=1
            print writeReg(getNode(REG_PATH+'VFATChannels.ChanReg'+str(kill_strip)),0)
            print writeReg(getNode(REG_PATH+'VFATChannels.ChanReg'+str(strip)),64)
            
            
            print 'Resetting Trigger Counters...'
            print writeReg(TCReset,1)
            print writeReg(TCReset,0)
            print 'Trigger Counters reset.'
            
            print 'Verifying...'
            sleep(0.01)
        # Read Number of SBits
            nSbits = readReg(getNode('GEM_AMC.TRIGGER.OH0.TRIGGER_CNT'))
            print 'SBits:',nSbits
            
            if parseInt(str(nSbits)) != 0: 
                print 'Trigger Counter Reset did not clear Trigger Counts!'
                print 'SBits:',nSbits
                return
            else: print 'Trigger Counts clear.'


            subheading('Sending Calpulses')
    # Send CalPulses
            print writeReg(getNode('GEM_AMC.OH.OH0.T1Controller.TOGGLE'),0xffffffff)
            sleep(5)
        # Verify Triggers
            triggers = readReg(getNode('GEM_AMC.TRIGGER.OH0.TRIGGER_CNT'))
            try: parseInt(triggers)
            except:
                print 'BUS ERROR!'
                triggers = 0
            print 'SBits:',triggers
            if parseInt(triggers) != pulses: 
                nFailures += abs(pulses-parseInt(triggers))
    
            triggerResults.append(parseInt(triggers))
            heading('Strip '+str(strip)+'   Expected:'+str(pulses)+'\t'+'Received:'+str(parseInt(triggers)))
    
    except: print 'Unknown Error'

    finally:
        print 'TOTAL FAILURES:',nFailures
        for result in range(len(triggerResults)):
            print 'Strip',result,'\t','Expected:',pulses,'Received:',triggerResults[result]


def heading(string):
    print '\n\n>>>> '+str(string).upper()+' <<<<\n\n'

def subheading(string):
	print '\n---- '+str(string)+' ----\n'

if __name__ == '__main__':
    main()

