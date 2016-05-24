from rw_reg import *
from time import *

QUICKTEST = True
SINGLEVFAT = True

SBitMaskAddress = 0x6502c010
NUM_STRIPS = 128
NUM_PADS = 8
OH_NUM = 0

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

OUTPUT_FILE='./results.txt'

pulses = 1

class Colors:
    WHITE   = '\033[97m'
    CYAN    = '\033[96m'
    MAGENTA = '\033[95m'
    BLUE    = '\033[94m'
    YELLOW  = '\033[93m'
    GREEN   = '\033[92m'
    RED     = '\033[91m'
    ENDC    = '\033[0m'

def main():
    resultFileName = raw_input('Enter result filename (default = ' + OUTPUT_FILE + '): ') or OUTPUT_FILE

    f = open(resultFileName, 'w')

    if not SINGLEVFAT:
        for vfat in range(0, 24):
            scan_vfat(vfat, f)
    else:
        vfat_slot = raw_input('Enter VFAT slot: ')
        try:
            if int(vfat_slot) > 23 or int(vfat_slot) < 0:
                print 'Invalid VFAT slot!'
                return
        except:
            print 'Invalid input!'
            return
        scan_vfat(vfat_slot, f)
    f.close()

def scan_vfat(vfat_slot, outfile):
    try:
        if int(vfat_slot) > 23 or int(vfat_slot) < 0:
            print 'Invalid VFAT slot!'
            return
    except:
        print 'Invalid input!'
        return
   
    REG_PATH = 'GEM_AMC.OH.OH'+str(OH_NUM)+'.GEB.VFATS.VFAT'+str(vfat_slot)+'.'

    subheading('Parsing address table.')
    parseXML()
    heading('Beginning SBit Scan')

    # Mask VFATs
    heading('MASK VFATS')
    SBitMask = getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.CONTROL.VFAT.SBIT_MASK')
    print 'Unmasking VFAT',vfat_slot
    vmask = (0xffffffff) ^ (0x1 << int(vfat_slot))
    print writeReg(SBitMask,vmask)


    # Set default VFAT values & Threshold,VCal,RunMode
    heading('SET VFAT SETTINGS')
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


    # Reset Trigger Counters
    heading('Reset trigger counters')
    TCReset = getNode('GEM_AMC.TRIGGER.CTRL.CNT_RESET')
    if TCReset is None:
        print 'Error finding GEM_AMC.TRIGGER.CTRL.CNT_RESET Register!'
        return
    print writeReg(TCReset,1)
    print writeReg(TCReset,0)


    # Verify Reset
    subheading('Verifying...')
    sleep(0.1)
    nSbits = readReg(getNode('GEM_AMC.TRIGGER.OH'+str(OH_NUM)+'.TRIGGER_CNT'))
    try: parseInt(nSbits)
    except:
        print 'SBits:',nSbits
        return
    if parseInt(str(nSbits)) != 0: #Hot channels?
        print Colors.RED,'Trigger Counter Reset did not clear Trigger Counts!',Colors.ENDC
        print 'SBits:',nSbits,'=',parseInt(nSbits),'\n'

        for reg in getNodesContaining('TRIGGER.OH'+str(OH_NUM)+'.CLUSTER'):
            if 'r' in str(reg.permission):
                print displayReg(reg),'=',parseInt(str(readReg(reg)))
        print '\n'
        for reg in getNodesContaining('TRIGGER.OH'+str(OH_NUM)+'.DEBUG_LAST_CLUSTER'):
            if 'r' in str(reg.permission):
                print displayReg(reg,'hexbin')
        # for reg in getNodesContaining('OH'+str(OH_NUM)+'.GEB.VFATS.VFAT'+vfat_slot):
        #     if 'r' in str(reg.permission):
        #         actual_value = 0x000000ff & parseInt(readReg(reg))
        #         print displayReg(reg),'=',parseInt(actual_value)
        return
    else: print 'Trigger Counts clear.'


    # Configure T1 Controller
    heading('Setting T1 Controller')
    print writeReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.MODE'), 0)
    print writeReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.TYPE'), 1)
    print writeReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.INTERVAL'), 1000)
    print writeReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.NUMBER'), pulses)



    # LOOP
    heading('LOOPING OVER CHANNELS')
    triggerResults = []
    pads = range(1,2*NUM_PADS+1)
    strips = [8*i for i in pads] #8,16,24,...,128
    previousStrip = 0

    # Clear all channels
    subheading('Clearing all channels...')
    for strip in range(1,129):
        writeReg(getNode(REG_PATH+'VFATChannels.ChanReg'+str(strip)),0)


    try:
        for strip in strips:
            subheading('Strip '+str(strip))

            if previousStrip<1 or previousStrip>128: previousStrip=1
            print writeReg(getNode(REG_PATH+'VFATChannels.ChanReg'+str(strip)),64)
            previousStrip = strip

            subheading('Resetting Trigger Counters...')
            print writeReg(TCReset,1)
            print writeReg(TCReset,0)


            subheading('Verifying...')
            sleep(0.01)
            # Read Number of SBits to verify reset
            nSbits = readReg(getNode('GEM_AMC.TRIGGER.OH'+str(OH_NUM)+'.TRIGGER_CNT'))
            try: parseInt(nSbits)
            except:
                print 'SBits:',nSbits
                return
            if parseInt(str(nSbits)) != 0: 
                print 'Trigger Counter Reset did not clear Trigger Counts!'
                print 'SBits:',nSbits,'=',parseInt(nSbits),'\n'
                return
            else: print 'Trigger Counts clear.'


            subheading('Sending Calpulses')
            # Send CalPulses
            print writeReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.TOGGLE'),0xffffffff)
            sleep(0.1)
            # Verify Triggers
            nSbits = readReg(getNode('GEM_AMC.TRIGGER.OH'+str(OH_NUM)+'.TRIGGER_CNT'))
            try: 
                parseInt(nSbits)
                print 'SBits:',nSbits,'=',parseInt(nSbits)
            except:
                print 'SBits:',nSbits
                nSbits = -1
                
            triggerResults.append([strip,parseInt(nSbits)])
            printCyan( 'Strip '+str(strip)+'   Expected:'+str(pulses)+'\t'+'Received:'+str(parseInt(nSbits)) )
    
            # Map Cluster
            if not QUICKTEST:
                subheading('Cluster Info')
                for reg in getNodesContaining('TRIGGER.OH'+str(OH_NUM)+'.CLUSTER'):
                    if 'r' in str(reg.permission):
                        print displayReg(reg),'=',parseInt(str(readReg(reg)))
                for reg in getNodesContaining('TRIGGER.OH'+str(OH_NUM)+'.DEBUG_LAST_CLUSTER'):
                    if 'r' in str(reg.permission):
                        print displayReg(reg),'=',parseInt(str(readReg(reg)))

            # subheading('VFAT'+vfat_slot+' Registers')
            # for reg in getNodesContaining('OH'+str(OH_NUM)+'.GEB.VFATS.VFAT'+vfat_slot):
            #     if 'r' in str(reg.permission):
            #         actual_value = 0x000000ff & parseInt(readReg(reg))
            #         print displayReg(reg),'=',parseInt(actual_value)


            print writeReg(getNode(REG_PATH + 'VFATChannels.ChanReg' + str(strip)), 0)

    except:
        print 'Unknown Error'
        print writeReg(getNode(REG_PATH + 'VFATChannels.ChanReg' + str(strip)), 0)

    finally:
        heading('Summary')
        subheading('VFAT Slot '+str(vfat_slot))
        outfile.write('VFAT Slot '+str(vfat_slot) + '\n')
        for result in range(len(triggerResults)):
            if triggerResults[result][1] != 4*pulses:
                print Colors.RED+'Strip',triggerResults[result][0],'\t','Expected:',pulses,'Received:',triggerResults[result][1],Colors.ENDC
            else:
                print 'Strip',triggerResults[result][0],'\t','Expected:',pulses,'Received:',triggerResults[result][1]
            outfile.write('%s%03d%s%s%s %s%s\n' % ('Strip',triggerResults[result][0],'\t','Expected:',pulses,'Received:',triggerResults[result][1]))
        print '\n\n'
        outfile.write('\n\n')

def heading(string):
    print Colors.BLUE
    print '\n>>>>>>> '+str(string).upper()+' <<<<<<<'
    print Colors.ENDC

def subheading(string):
    print Colors.YELLOW
    print '---- '+str(string)+' ----',Colors.ENDC

def printCyan(string):
    print Colors.CYAN
    print string
    print Colors.ENDC

if __name__ == '__main__':
    main()
