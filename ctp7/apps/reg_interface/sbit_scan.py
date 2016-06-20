from rw_reg import *
from time import *

QUICKTEST = True
SINGLEVFAT = False

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

# Calpulsing Settings
VTHRESHOLD1=50
VCAL=190
INTERVAL = 10 #BX
NUM_PULSES = 100

OUTPUT_FILENAME='results'

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
    resultFileName = raw_input('Enter result filename (no extention or path) (default = ' + OUTPUT_FILENAME + '): ') or OUTPUT_FILENAME
    resultFilePath = './'+resultFileName+'.txt'
    errorsFilePath = './'+resultFileName+'-errors.txt'
    f = open(resultFilePath, 'w')
    f_errors = open(errorsFilePath, 'w')
    
    parseXML()

    if not SINGLEVFAT:
        for vfat in range(0, 24):
            scan_vfat(vfat, f, f_errors)
            map_vfat_sbits(vfat, f, f_errors)
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


def map_vfat_sbits(vfat_slot, outfile, errfile):

    try:
        if int(vfat_slot) > 23 or int(vfat_slot) < 0:
            print 'Invalid VFAT slot!'
            return
    except:
        print 'Invalid input!'
        return

   
    REG_PATH = 'GEM_AMC.OH.OH'+str(OH_NUM)+'.GEB.VFATS.VFAT'+str(vfat_slot)+'.'


    # Check for correct OH, good connection
    try:
        oh_fw = parseInt(readReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.STATUS.FW')))
        print 'OH FW: ',hex(oh_fw)
        if oh_fw < 1: 
            print 'Error: OH FW: ',oh_fw
            return
    except ValueError as e:
        printRed('Error connecting to OH'+str(OH_NUM))
        outfile.write('Error connecting to OH '+str(OH_NUM)+'\n')
        errfile.write('Error connecting to OH '+str(OH_NUM)+'\n')
        return


    # Check for VFAT present
    vfat_id1 = 0x000000ff & parseInt(readReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.GEB.VFATS.VFAT'+str(vfat_slot)+'.ChipID1')))
    vfat_id2 = 0x000000ff & parseInt(readReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.GEB.VFATS.VFAT'+str(vfat_slot)+'.ChipID0')))
    vfat_id = (vfat_id1 << 8) + vfat_id2
    subheading('VFATID: '+hex(vfat_id))
    if vfat_id == 0:
        print Colors.RED
        print 'No VFAT chip detected at this slot!'
        print Colors.ENDC
        return


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


    # Configure T1 Controller
    heading('Setting T1 Controller')
    subheading('Mode: Infinite CalPulses - 10 BX apart')
    print writeReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.MODE'), 0)
    print writeReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.TYPE'), 1) #CalPulse
    print writeReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.INTERVAL'), INTERVAL)
    print writeReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.NUMBER'), 0)  #Infinite pulsing


    # LOOP
    heading('LOOPING OVER CHANNELS')
    strips = [16*i for i in range(1,9)] #16,32,...,128

    # Clear all channels
    subheading('Clearing all channels...')
    for strip in range(1,129):
        writeReg(getNode(REG_PATH+'VFATChannels.ChanReg'+str(strip)),0)

    subheading('Starting Calpulses (nonstop)')

    # Begin CalPulsing
    T1On()
         

   # try:
    for strip in strips:
        subheading('Strip '+str(strip))
        print writeReg(getNode(REG_PATH+'VFATChannels.ChanReg'+str(strip)),64)
        sleep(0.1)
        # Identify SBit
        subheading('Cluster Info')
        cluster_reg = getNode('GEM_AMC.TRIGGER.OH'+str(OH_NUM)+'.DEBUG_LAST_CLUSTER_0')
        print readReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.MONITOR'))
        good_cluster_count = 0
        for i in range(100):
            value = parseInt(str(readReg(cluster_reg)))
            if value != 2047:
                encodedSlot = cluster_to_vfat(value)
                encodedSBit = cluster_to_vfat2_sbit(value)
                encodedSize = cluster_to_size(value)
                goodCluster = False
                if encodedSlot == vfat_slot and encodedSBit == (strip-1)//16 and encodedSize == 6: 
                    good_cluster_count+=1
                    goodCluster = True


                print Colors.CYAN,value, ' = ', '{0:#010x}'.format(value),' = ', '{0:#032b}'.format(value),Colors.ENDC
                if goodCluster: print 'VFAT:',cluster_to_vfat(value),'\t VFAT2 SBit:',cluster_to_vfat2_sbit(value),'\t Size:', cluster_to_size(value),'\n'
                else: printRed('VFAT:'+str(encodedSlot)+'\t VFAT2 SBit:'+str(encodedSBit)+'\t Size:'+str(encodedSize)+'\n')
                outfile.write('%s%03d%s%d\n' % ('Strip',strip,'\t Cluster: ',value))
                outfile.write('%d%s%s%s%s\n' % (value, ' = ', '{0:#010x}'.format(value),' = ', '{0:#032b}'.format(value)))
                outfile.write('%s%d%s%d%s%d%s\n' % ('VFAT:',cluster_to_vfat(value),'\t VFAT2 SBit:',cluster_to_vfat2_sbit(value),'\t Size:', cluster_to_size(value),'\n'))
        if good_cluster_count==0:
            printRed('VFAT:'+str(vfat_slot)+'\t Strip:'+str(strip)+'\t No good clusters!')
            errfile.write('%s %s\t%s %s\t%s\n' % ('VFAT:',str(vfat_slot),'Strip:',str(strip),'No good clusters!'))
        outfile.write('\n')
        # Mask Channel
        print writeReg(getNode(REG_PATH + 'VFATChannels.ChanReg' + str(strip)), 0)
    
    # Stop CalPulses
    T1Off()
 

def scan_vfat(vfat_slot, outfile, errfile):
    try:
        if int(vfat_slot) > 23 or int(vfat_slot) < 0:
            print 'Invalid VFAT slot!'
            return
    except:
        print 'Invalid input!'
        return
   
    REG_PATH = 'GEM_AMC.OH.OH'+str(OH_NUM)+'.GEB.VFATS.VFAT'+str(vfat_slot)+'.'


    heading('Beginning SBit Scan')

    # Check for correct OH, good connection
    try:
        oh_fw = parseInt(readReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.STATUS.FW')))
        print 'OH FW: ',hex(oh_fw)
        if oh_fw < 1: 
            print 'Error: OH FW: ',oh_fw
            return
    except ValueError as e:
        printRed('Error connecting to OH'+str(OH_NUM))
        outfile.write('Error connecting to OH '+str(OH_NUM)+'\n')
        errfile.write('Error connecting to OH '+str(OH_NUM)+'\n')
        return

    # Check for VFAT present
    vfat_id1 = 0x000000ff & parseInt(readReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.GEB.VFATS.VFAT'+str(vfat_slot)+'.ChipID1')))
    vfat_id2 = 0x000000ff & parseInt(readReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.GEB.VFATS.VFAT'+str(vfat_slot)+'.ChipID0')))
    vfat_id = (vfat_id1 << 8) + vfat_id2
    subheading('VFATID: '+hex(vfat_id))
    if vfat_id == 0:
        print Colors.RED
        print 'No VFAT chip detected at this slot!'
        print Colors.ENDC
        return


    # Mask VFATs
    heading('MASK VFATS')
    SBitMask = getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.CONTROL.VFAT.SBIT_MASK')
    print 'Unmasking VFAT',vfat_slot
    vmask = (0xffffffff) ^ (0x1 << int(vfat_slot))
    print writeReg(SBitMask,vmask)

    
    # Clear all channels
    subheading('Clearing all channels...')
    for strip in range(1,129):
        writeReg(getNode(REG_PATH+'VFATChannels.ChanReg'+str(strip)),0)


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


    # Configure T1 Controller
    heading('Setting T1 Controller')
    print writeReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.MODE'), 0)
    print writeReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.TYPE'), 1)
    print writeReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.INTERVAL'), INTERVAL)
    print writeReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.NUMBER'), NUM_PULSES)

    # Make sure T1 Controller is OFF
    T1Off()
    print 'T1 Monitor: ',readReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.MONITOR'))
    

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
        print Colors.RED
        print 'Trigger Counter Reset did not clear Trigger Counts!',Colors.ENDC
        print 'Triggers:',nSbits,'=',parseInt(nSbits),'\n'
        outfile.write('Trigger Counter Reset did not clear Trigger Counts!\n')
        outfile.write('%s%s = %d' % ('Triggers: ',nSbits,parseInt(nSbits)))
        errfile.write('Trigger Counter Reset did not clear Trigger Counts!\n')
        errfile.write('%s%s = %d\n' % ('Triggers: ',nSbits,parseInt(nSbits)))
        if not QUICKTEST:
            for reg in getNodesContaining('TRIGGER.OH'+str(OH_NUM)+'.CLUSTER'):
                if 'r' in str(reg.permission):
                    print displayReg(reg),'=',parseInt(str(readReg(reg)))
            print '\n'
            for reg in getNodesContaining('TRIGGER.OH'+str(OH_NUM)+'.DEBUG_LAST_CLUSTER'):
                if 'r' in str(reg.permission):
                    print displayReg(reg,'hexbin')
        return
    else: print 'Trigger Counts clear.'
                      


    # LOOP
    heading('LOOPING OVER CHANNELS')
    triggerAmounts = []          #2D array: [strip, num_triggers]
    triggerLocations = []        #2D array: [strip, encoded-sbit]
    pads = range(1,2*NUM_PADS+1)
    strips = [8*i for i in pads] #8,16,24,...,128

    try:
        for strip in strips:
            subheading('Strip '+str(strip))

            print writeReg(getNode(REG_PATH+'VFATChannels.ChanReg'+str(strip)),64)

            subheading('Resetting Trigger Counters...')
            print writeReg(TCReset,1)
            print writeReg(TCReset,0)


            subheading('Verifying...')
            sleep(0.1)
            # Read Number of SBits to verify reset
            nSbits = readReg(getNode('GEM_AMC.TRIGGER.OH'+str(OH_NUM)+'.TRIGGER_CNT'))
            try: parseInt(nSbits)
            except:
                print 'SBits:',nSbits
                return

            if parseInt(str(nSbits)) != 0: #Hot channels?
                print Colors.RED
                print 'Trigger Counter Reset did not clear Trigger Counts!',Colors.ENDC
                print 'Triggers:',nSbits,'=',parseInt(nSbits),'\n'
                if not QUICKTEST:
                    for reg in getNodesContaining('TRIGGER.OH'+str(OH_NUM)+'.CLUSTER'):
                        if 'r' in str(reg.permission):
                            print displayReg(reg),'=',parseInt(str(readReg(reg)))
                    print '\n'
                    for reg in getNodesContaining('TRIGGER.OH'+str(OH_NUM)+'.DEBUG_LAST_CLUSTER'):
                        if 'r' in str(reg.permission):
                            print displayReg(reg,'hexbin')
                return
            else: print 'Trigger Counts clear.'


            subheading('Sending Calpulses')
            # Send CalPulses
            T1On()
                            

            sleep(0.1)
            # Verify Triggers
            nSbits = readReg(getNode('GEM_AMC.TRIGGER.OH'+str(OH_NUM)+'.TRIGGER_CNT'))
            try: 
                parseInt(nSbits)
                print 'SBits:',nSbits,'=',parseInt(nSbits)
            except: # bus error
                print 'SBits:',nSbits
                nSbits = -1
                
            triggerAmounts.append([strip,parseInt(nSbits)])
            
            if parseInt(nSbits) != 4*NUM_PULSES: # Not sure why quadrupled
                printRed( 'Strip '+str(strip)+'\t Expected:'+str(NUM_PULSES)+'\t Received:'+str(parseInt(nSbits)) )
            else:
                printCyan('Strip '+str(strip)+'\t Expected:'+str(NUM_PULSES)+'\t Received:'+str(parseInt(nSbits)) )
    
            # Map Cluster
            if not QUICKTEST:
                subheading('Cluster Info')
                for reg in getNodesContaining('TRIGGER.OH'+str(OH_NUM)+'.CLUSTER'):
                    if 'r' in str(reg.permission):
                        print displayReg(reg),'=',parseInt(str(readReg(reg)))
                for reg in getNodesContaining('TRIGGER.OH'+str(OH_NUM)+'.DEBUG_LAST_CLUSTER'):
                    if 'r' in str(reg.permission):
                        print displayReg(reg),'=',parseInt(str(readReg(reg)))

            print writeReg(getNode(REG_PATH + 'VFATChannels.ChanReg' + str(strip)), 0)

    except:
        print 'Unknown Error'
        print writeReg(getNode(REG_PATH + 'VFATChannels.ChanReg' + str(strip)), 0)

    finally:
        heading('Summary')
        subheading('VFAT Slot '+str(vfat_slot)+' ID '+hex(vfat_id))
        outfile.write('VFAT Slot '+str(vfat_slot) + '\n')
        for result in range(len(triggerAmounts)):
            if triggerAmounts[result][1] != 4*NUM_PULSES:
                print Colors.RED+'Strip',triggerAmounts[result][0],'\t','Expected:',NUM_PULSES,'Received:',triggerAmounts[result][1],Colors.ENDC
            else:
                print 'Strip',triggerAmounts[result][0],'\t','Expected:',NUM_PULSES,'Received:',triggerAmounts[result][1]
            outfile.write('%s%03d%s%s%s %s%s\n' % ('Strip',triggerAmounts[result][0],'\t','Expected:',NUM_PULSES,'Received:',triggerAmounts[result][1]))
        print '\n\n'
        outfile.write('\n\n')


#Toggle T1 Controller to ON/OFF
def T1Off():
    prevent_infiteloop = 0
    while parseInt(readReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.MONITOR'))) != 0:
        print 'MONITOR:',readReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.MONITOR'))
        prevent_infiteloop += 1
        print writeReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.TOGGLE'),0xffffffff)
        if prevent_infiteloop > 10: 
            printRed('T1Controller Error - Will not toggle T1Controller Monitor')
            return False
    return True
def T1On():
    prevent_infiteloop = 0
    while parseInt(readReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.MONITOR'))) != 1:
        print 'MONITOR:',readReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.MONITOR'))
        sleep(0.1)
        prevent_infiteloop += 1
        print writeReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.TOGGLE'),0xffffffff)
        if prevent_infiteloop > 10: 
            printRed('T1Controller Error - Will not toggle T1Controller Monitor')
            return False
    return True



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
