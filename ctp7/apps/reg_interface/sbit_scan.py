from rw_reg import *
from vfat_config import *
from time import *

QUICKTEST = True
SINGLEVFAT = False

SBitMaskAddress = 0x6502c010
NUM_STRIPS = 128
NUM_PADS = 8
OH_NUM = 2

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

NUM_PULSES = 1

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
    parseXML()

    if not SINGLEVFAT:
        for vfat in range(0, 24):
            scan_vfat(vfat, f)
            map_vfat_sbits(vfat,f)
    else:
        vfat_slot = raw_input('Enter VFAT slot: ')
        try:
            if int(vfat_slot) > 23 or int(vfat_slot) < 0:
                print 'Invalid VFAT slot!'
                return
        except:
            print 'Invalid input!'
            return
        #scan_vfat(vfat_slot, f)
        map_vfat_sbits(vfat_slot, f)
    f.close()


def map_vfat_sbits(vfat_slot, outfile):

    try:
        if int(vfat_slot) > 23 or int(vfat_slot) < 0:
            print 'Invalid VFAT slot!'
            return
    except:
        print 'Invalid input!'
        return

   
    REG_PATH = 'GEM_AMC.OH.OH'+str(OH_NUM)+'.GEB.VFATS.VFAT'+str(vfat_slot)+'.'


    # Check for VFAT present
    vfat_hexID = getVFATID(OH_NUM,vfat_slot)
    if vfat_hexID == 0 or vfat_hexID == 0xdead:
        printRed('No VFAT detected at this slot! '+str(hex(vfat_hexID)))
        return

    # Mask VFATs
    heading('MASK VFATS')
    unmaskVFAT(OH_NUM,vfat_slot)

    # Set default VFAT values & Threshold,VCal,RunMode
    heading('SET VFAT SETTINGS')
    vfatWritten = setVFATRunMode(OH_NUM,vfat_slot)
    if not vfatWritten: printRed("Error Setting Default VFAT Values!")


    # Configure T1 Controller
    heading('Setting T1 Controller')
    subheading('Mode: Infinite CalPulses - 10 BX apart')
    configureT1(OH_NUM,0,1,10,0)

    # LOOP
    heading('LOOPING OVER CHANNELS')
    strips = [16*i for i in range(1,9)] #16,32,...,128

    # Clear all channels
    subheading('Clearing all channels...')
    clearAllChannels(OH_NUM,vfat_slot)


    subheading('Starting Calpulses (nonstop)')

    # Begin CalPulsing
    print 'T1 Monitor: ',readReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.MONITOR'))
    while parseInt(readReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.MONITOR'))) != 1:
        print writeReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.TOGGLE'),0xffffffff)
        

   # try:
    for strip in strips:
        subheading('Strip '+str(strip))
        activateChannel(OH_NUM,vfat_slot,strip)
        sleep(0.1)
        # Identify SBit
        subheading('Cluster Info')
        reg = getNode('GEM_AMC.TRIGGER.OH'+str(OH_NUM)+'.DEBUG_LAST_CLUSTER_0')
        print readReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.MONITOR'))
        for i in range(100):
            value = parseInt(str(readReg(reg)))
            if value != 2047: 
                print Colors.CYAN,value, ' = ', '{0:#010x}'.format(value),' = ', '{0:#032b}'.format(value),Colors.ENDC
                print 'VFAT:',cluster_to_vfat(value),'\t VFAT2 SBit:',cluster_to_vfat2_sbit(value),'\t Size:', cluster_to_size(value),'\n'
                outfile.write('%s%03d%s%d\n' % ('Strip',strip,'\t Cluster: ',value))
                outfile.write('%d%s%s%s%s\n' % (value, ' = ', '{0:#010x}'.format(value),' = ', '{0:#032b}'.format(value)))
                outfile.write('%s%d%s%d%s%d%s\n' % ('VFAT:',cluster_to_vfat(value),'\t VFAT2 SBit:',cluster_to_vfat2_sbit(value),'\t Size:', cluster_to_size(value),'\n'))
        outfile.write('\n')
        # Mask Channel
        print writeReg(getNode(REG_PATH + 'VFATChannels.ChanReg' + str(strip)), 0)
    
    # Stop CalPulses
    print writeReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.TOGGLE'),0xffffffff)



def scan_vfat(vfat_slot, outfile):
    try:
        if int(vfat_slot) > 23 or int(vfat_slot) < 0:
            print 'Invalid VFAT slot!'
            return
    except:
        print 'Invalid input!'
        return
   
    REG_PATH = 'GEM_AMC.OH.OH'+str(OH_NUM)+'.GEB.VFATS.VFAT'+str(vfat_slot)+'.'


    # Check for VFAT present
    vfat_hexID = getVFATID(OH_NUM,vfat_slot)
    if vfat_hexID == 0 or vfat_hexID == 0xdead:
        printRed('No VFAT detected at this slot! '+str(hex(vfat_hexID)))
        return
    

    # Mask VFATs
    heading('MASK VFATS')
    unmaskVFAT(OH_NUM,vfat_slot)

    # Set default VFAT values & Threshold,VCal,RunMode
    heading('SET VFAT SETTINGS')
    isSet = setVFATRunMode(OH_NUM,vfat_slot)
    if not isSet: return

    # Reset Trigger Counters
    heading('Reset trigger counters')
    resetTriggerCounters()

    # Verify Reset
    subheading('Verifying...')
    sleep(0.1)
    isReset,nSbits = verifyTCReset(OH_NUM)
    if not isReset: print 'Trigger Counter not reset! (%s)'%str(nSbits)

    # Configure T1 Controller
    heading('Setting T1 Controller')
    configureT1(OH_NUM,0,1,INTERVAL,NUM_PULSES)


    # LOOP
    heading('LOOPING OVER CHANNELS')
    triggerResults = []
    pads = range(1,2*NUM_PADS+1)
    strips = [8*i for i in pads] #8,16,24,...,128
    previousStrip = 0

    # Clear all channels
    subheading('Clearing all channels...')
    clearAllChannels(OH_NUM,vfat_slot)

    try:
        for strip in strips:
            subheading('Strip '+str(strip))
            
            activateChannel(OH_NUM,vfat_slot,strip)

            subheading('Resetting Trigger Counters...')
            resetTriggerCounters()

            subheading('Verifying...')
            sleep(0.01)
            isReset,nSbits = verifyTCReset(OH_NUM)
            if not isReset: print 'Trigger Counter not reset! (%s)'%str(nSbits)
        


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
            
            if parseInt(nSbits) != 4*NUM_PULSES:
                printRed( 'Strip '+str(strip)+'   Expected:'+str(NUM_PULSES)+'\t'+'Received:'+str(parseInt(nSbits)) )
            else:
                printCyan( 'Strip '+str(strip)+'   Expected:'+str(NUM_PULSES)+'\t'+'Received:'+str(parseInt(nSbits)) )
    
            # Map Cluster
            if not QUICKTEST:
                subheading('Cluster Info')
                printClusters(OH_NUM)

            clearChannel(OH_NUM,vfat_slot,strip)

    except:
        print 'Unknown Error'
        clearChannel(OH_NUM,vfat_slot,strip)

    finally:
        heading('Summary')
        subheading('VFAT Slot '+str(vfat_slot)+' ID '+hex(vfat_hexID))
        outfile.write('VFAT Slot '+str(vfat_slot) + '\n')
        for result in range(len(triggerResults)):
            if triggerResults[result][1] != 4*NUM_PULSES:
                print Colors.RED+'Strip',triggerResults[result][0],'\t','Expected:',NUM_PULSES,'Received:',triggerResults[result][1],Colors.ENDC
            else:
                print 'Strip',triggerResults[result][0],'\t','Expected:',NUM_PULSES,'Received:',triggerResults[result][1]
            outfile.write('%s%03d%s%s%s %s%s\n' % ('Strip',triggerResults[result][0],'\t','Expected:',NUM_PULSES,'Received:',triggerResults[result][1]))
        print '\n\n'
        outfile.write('\n\n')



def cluster_to_vfat (cluster): 
    vfat_mapping =  [ 0, 8, 16, 1, 9, 17, 2, 10, 18, 3, 11, 19, 4, 12, 20, 5, 13, 21, 6, 14, 22, 7, 15, 23]
    address = cluster & 0x7ff
    if (address > 1535): 
        vfat_id = -1
    else: 
        natural_fat_id = (address)//64
        vfat_id = vfat_mapping[natural_fat_id]
    return vfat_id

def cluster_to_vfat2_sbit (cluster):
    address = cluster & 0x7ff
    if (address > 1535): 
        vfat2_sbit = -1
    else: 
        vfat3_sbit = (cluster&0x3f)
        vfat2_sbit = vfat3_sbit//8
    return vfat2_sbit

def cluster_to_size (cluster): 
    address = cluster & 0x7ff
    if (address > 1535): 
        size = -1
    else: 
        size = (cluster>>11)&0x7; 
    return size






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

def printRed(string):
    print Colors.RED
    print string
    print Colors.ENDC

if __name__ == '__main__':
    main()
