from rw_reg import *
from vfat_config import *
from time import *

QUICKTEST = True
SINGLEVFAT = False
SINGLEOH = False
V2ATEST = False

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

# Calpulsing Settings
VTHRESHOLD1=50
VCAL=190
INTERVAL = 10 #BX
NUM_PULSES = 1
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

    if not SINGLEOH:
        for oh in range(0,12):
            f.write('OptoHybrid:',oh,'\n')
            f_errors.write('OptoHybrid:',oh,'\n')
            if not SINGLEVFAT:
                for vfat in range(0, 24):
                    scan_vfat(oh, vfat, f, f_errors)
                    map_vfat_sbits(oh, vfat, f, f_errors)
            else:
                vfat_slot = raw_input('Enter VFAT slot: ')
                try:
                    if int(vfat_slot) > 23 or int(vfat_slot) < 0:
                        print 'Invalid VFAT slot!'
                        return
                except:
                    print 'Invalid input!'
                    return
                scan_vfat(vfat_slot, f, f_errors)
                map_vfat_sbits(vfat_slot, f, f_errors)
            f.close()
            f_errors.close()
    else:
        if not SINGLEVFAT:
            for vfat in range(0, 24):
                scan_vfat(OH_NUM, vfat, f, f_errors)
                map_vfat_sbits(OH_NUM, vfat, f, f_errors)
        else:
            vfat_slot = raw_input('Enter VFAT slot: ')
            try:
                if int(vfat_slot) > 23 or int(vfat_slot) < 0:
                    print 'Invalid VFAT slot!'
                    return
            except:
                print 'Invalid input!'
                return
            scan_vfat(OH_NUM, vfat_slot, f, f_errors)
            map_vfat_sbits(OH_NUM, vfat_slot, f, f_errors)
        f.close()
        f_errors.close()
    

def map_vfat_sbits(optohybrid,vfat_slot, outfile, errfile):

    try:
        if int(vfat_slot) > 23 or int(vfat_slot) < 0:
            print 'Invalid VFAT slot!'
            return
    except:
        print 'Invalid input!'
        return

   
    REG_PATH = 'GEM_AMC.OH.OH'+str(optohybrid)+'.GEB.VFATS.VFAT'+str(vfat_slot)+'.'


    # Check for correct OH, good connection
    try:
        oh_fw = parseInt(readReg(getNode('GEM_AMC.OH.OH'+str(optohybrid)+'.STATUS.FW')))
        print 'OH FW: ',hex(oh_fw)
        if oh_fw < 1: 
            print 'Error: OH FW: ',oh_fw
            return
    except ValueError as e:
        printRed('Error connecting to OH'+str(optohybrid))
        outfile.write('Error connecting to OH '+str(optohybrid)+'\n')
        errfile.write('Error connecting to OH '+str(optohybrid)+'\n')
        return


    # Check for VFAT present
    vfat_hexID = getVFATID(optohybrid,vfat_slot)
    if vfat_hexID == 0 or vfat_hexID == 0xdead:
        printRed('No VFAT detected at this slot! '+str(hex(vfat_hexID)))
        return

    # Clear all channels on all VFATs for V2A testing (no VFAT masking)
    if V2ATEST:
        print 'Clearing all channels on all VFATs'
        clearAllVFATChannels(optohybrid)

    # Mask VFATs (masking not enabled in v2a FW)
    if not V2ATEST:
        heading('MASK VFATS')
        unmaskVFAT(optohybrid,vfat_slot)
    
    # Set default VFAT values & Threshold,VCal,RunMode
    heading('SET VFAT SETTINGS')
    vfatWritten = setVFATRunMode(optohybrid,vfat_slot)
    if not vfatWritten: printRed("Error Setting Default VFAT Values!")


    # Configure T1 Controller
    heading('Setting T1 Controller')
    subheading('Mode: Infinite CalPulses - 10 BX apart')
    configureT1(optohybrid,0,1,10,0)


    # LOOP
    heading('LOOPING OVER CHANNELS')
    strips = [16*i for i in range(1,9)] #16,32,...,128

    # Clear all channels
    subheading('Clearing all channels...')
    clearAllChannels(optohybrid,vfat_slot)


    subheading('Starting Calpulses (nonstop)')

    # Begin CalPulsing
    T1On(optohybrid)
         

   # try:
    for strip in strips:
        subheading('Strip '+str(strip))
        activateChannel(optohybrid,vfat_slot,strip)
        sleep(0.1)
        # Identify SBit
        subheading('Cluster Info')
        cluster_reg = getNode('GEM_AMC.TRIGGER.OH'+str(optohybrid)+'.DEBUG_LAST_CLUSTER_0')
        print readReg(getNode('GEM_AMC.OH.OH'+str(optohybrid)+'.T1Controller.MONITOR'))
        good_cluster_count = 0
        goodCluster = False
        for i in range(100):
            value = parseInt(str(readReg(cluster_reg)))
            if value != 2047:
                encodedSlot = cluster_to_vfat(value)
                encodedSBit = cluster_to_vfat2_sbit(value)
                encodedSize = cluster_to_size(value)
                goodCluster = False
                if parseInt(encodedSlot) == parseInt(vfat_slot) and parseInt(encodedSBit) == parseInt((strip-1)//16) and parseInt(encodedSize) == 6: 
                    good_cluster_count+=1
                    goodCluster = True

                print Colors.CYAN,value, ' = ', '{0:#010x}'.format(value),' = ', '{0:#032b}'.format(value),Colors.ENDC
                if goodCluster: print 'VFAT:',encodedSlot,'\t VFAT2 SBit:',encodedSBit,'\t Size:', encodedSize,'\n'
                else: printRed('VFAT: '+str(encodedSlot)+'\t VFAT2 SBit: '+str(encodedSBit)+'\t Size: '+str(encodedSize)+'\n')
                outfile.write('%s%03d%s%d\n' % ('Strip',strip,'\t Cluster: ',value))
                outfile.write('%d%s%s%s%s\n' % (value, ' = ', '{0:#010x}'.format(value),' = ', '{0:#032b}'.format(value)))
                outfile.write('%s%d%s%d%s%d%s\n' % ('VFAT:',encodedSlot,'\t VFAT2 SBit:',encodedSBit,'\t Size:',encodedSize,'\n'))
        if good_cluster_count==0:
            printRed('VFAT:'+str(vfat_slot)+'\t Strip:'+str(strip)+'\t No good clusters!')
            errfile.write('%s %s\t%s %s\t%s\n' % ('VFAT:',str(vfat_slot),'Strip:',str(strip),'No good clusters!'))
        outfile.write('\n')
        # Mask Channel
        print writeReg(getNode(REG_PATH + 'VFATChannels.ChanReg' + str(strip)), 0)
    
    # Stop CalPulses
    T1Off(optohybrid)
 

def scan_vfat(optohybrid, vfat_slot, outfile, errfile):
    try:
        if int(vfat_slot) > 23 or int(vfat_slot) < 0:
            print 'Invalid VFAT slot!'
            return
    except:
        print 'Invalid input!'
        return
   
    REG_PATH = 'GEM_AMC.OH.OH'+str(optohybrid)+'.GEB.VFATS.VFAT'+str(vfat_slot)+'.'

    # Check for correct OH, good connection
    try:
        oh_fw = parseInt(readReg(getNode('GEM_AMC.OH.OH'+str(optohybrid)+'.STATUS.FW')))
        print 'OH FW: ',hex(oh_fw)
        if oh_fw < 1: 
            print 'Error: OH FW: ',oh_fw
            return
    except ValueError as e:
        printRed('Error connecting to OH'+str(optohybrid))
        outfile.write('Error connecting to OH '+str(optohybrid)+'\n')
        errfile.write('Error connecting to OH '+str(optohybrid)+'\n')
        return

    # Check for VFAT present
    vfat_hexID = getVFATID(optohybrid,vfat_slot)
    if vfat_hexID == 0 or vfat_hexID == 0xdead:
        printRed('No VFAT detected at this slot! '+str(hex(vfat_hexID)))
        return
    print 'VFAT ID:',hex(vfat_hexID)

    # Clear all channels on all VFATs for V2A testing (no VFAT masking)
    if V2ATEST:
        print 'Clearing all channels on all VFATs'
        clearAllVFATChannels(optohybrid)

    # Mask VFATs (masking not enabled in v2a FW)
    if not V2ATEST:
        heading('MASK VFATS')
        unmaskVFAT(optohybrid,vfat_slot)

    # Set default VFAT values & Threshold,VCal,RunMode
    heading('SET VFAT SETTINGS')
    isSet = setVFATRunMode(optohybrid,vfat_slot)
    if not isSet: return

    # Make sure T1 Controller is OFF
    T1Off(optohybrid)
    print 'T1 Monitor: ',readReg(getNode('GEM_AMC.OH.OH'+str(optohybrid)+'.T1Controller.MONITOR'))
    

    # Reset Trigger Counters
    heading('Reset trigger counters')
    resetTriggerCounters()

    # Verify Reset
    subheading('Verifying...')
    sleep(0.1)
    isReset,nSbits = verifyTCReset(optohybrid)
    if not isReset: 
        print 'Trigger Counter not reset! (%s)'%str(nSbits)
        outfile.write('Trigger Counter Reset did not clear Trigger Counts!\n')
        outfile.write('%s%s = %d' % ('Triggers: ',nSbits,parseInt(nSbits)))
        errfile.write('Trigger Counter Reset did not clear Trigger Counts!\n')
        errfile.write('%s%s = %d\n' % ('Triggers: ',nSbits,parseInt(nSbits)))


    # Configure T1 Controller
    heading('Setting T1 Controller')
    configureT1(optohybrid,0,1,INTERVAL,NUM_PULSES)


    # LOOP
    heading('LOOPING OVER CHANNELS')
    ScanResults = []          #2D array: [strip, num_triggers]
    triggerLocations = []        #2D array: [strip, encoded-sbit]
    pads = range(1,2*NUM_PADS+1)
    strips = [8*i for i in pads] #8,16,24,...,128

    # Clear all channels
    subheading('Clearing all channels...')
    clearAllChannels(optohybrid,vfat_slot)

    try:
        for strip in strips:
            subheading('Strip '+str(strip))

            activateChannel(optohybrid,vfat_slot,strip)

            subheading('Resetting Trigger Counters...')
            resetTriggerCounters()

            subheading('Verifying...')
            sleep(0.01)
            isReset,nSbits = verifyTCReset(optohybrid)
            if not isReset: print 'Trigger Counter not reset! (%s)'%str(nSbits)

            subheading('Sending Calpulses')
            # Send CalPulses
            print writeReg(getNode('GEM_AMC.OH.OH'+str(optohybrid)+'.T1Controller.TOGGLE'),0xffffffff)
                            

            sleep(0.1)
            # Verify Triggers
            nSbits = readReg(getNode('GEM_AMC.TRIGGER.OH'+str(optohybrid)+'.TRIGGER_CNT'))
            try: 
                parseInt(nSbits)
                print 'SBits:',nSbits,'=',parseInt(nSbits)
            except: # bus error
                print 'SBits:',nSbits
                nSbits = -1
                
            ScanResults.append([strip,parseInt(nSbits)])

            if parseInt(nSbits) != 4*NUM_PULSES: # Not sure why quadrupled
                printRed( 'Strip '+str(strip)+'\t Expected:'+str(NUM_PULSES)+'\t Received:'+str(parseInt(nSbits)) )
            else:
                printCyan('Strip '+str(strip)+'\t Expected:'+str(NUM_PULSES)+'\t Received:'+str(parseInt(nSbits)) )

    
            # Map Cluster
            if not QUICKTEST:
                subheading('Cluster Info')
                printClusters(optohybrid)

            clearChannel(optohybrid,vfat_slot,strip)

    except:
        print 'Unknown Error'
        clearChannel(optohybrid,vfat_slot,strip)

    finally:
        heading('Summary')
        subheading('VFAT Slot '+str(vfat_slot)+' ID '+hex(vfat_hexID))
        outfile.write('VFAT Slot '+str(vfat_slot) + '\n')
        for result in range(len(ScanResults)):
            if ScanResults[result][1] != 4*NUM_PULSES:
                print Colors.RED+'Strip',ScanResults[result][0],'\t','Expected:',NUM_PULSES,'Received:',ScanResults[result][1],Colors.ENDC
            else:
                print 'Strip',ScanResults[result][0],'\t','Expected:',NUM_PULSES,'Received:',ScanResults[result][1]
            outfile.write('%s%03d%s%s%s %s%s\n' % ('Strip',ScanResults[result][0],'\t','Expected:',NUM_PULSES,'Received:',ScanResults[result][1]))
        print '\n\n'
        outfile.write('\n\n')



# def cluster_to_vfat (cluster): 
#     vfat_mapping =  [ 0, 8, 16, 1, 9, 17, 2, 10, 18, 3, 11, 19, 4, 12, 20, 5, 13, 21, 6, 14, 22, 7, 15, 23]
#     address = cluster & 0x7ff
#     if (address > 1535): 
#         vfat_id = -1
#     else: 
#         natural_fat_id = (address)//64
#         vfat_id = vfat_mapping[natural_fat_id]
#     return vfat_id

# def cluster_to_vfat2_sbit (cluster):
#     address = cluster & 0x7ff
#     if (address > 1535): 
#         vfat2_sbit = -1
#     else: 
#         vfat3_sbit = (cluster&0x3f)
#         vfat2_sbit = vfat3_sbit//8
#     return vfat2_sbit

# def cluster_to_size (cluster): 
#     address = cluster & 0x7ff
#     if (address > 1535): 
#         size = -1
#     else: 
#         size = (cluster>>11)&0x7; 
#     return size






def heading(string):
    print Colors.BLUE
    print '\n>>>>>>> '+str(string).upper()+' <<<<<<<'
    print Colors.ENDC

def subheading(string):
    print Colors.YELLOW
    print '---- '+str(string)+' ----',Colors.ENDC

def printCyan(string):
    print Colors.CYAN
    print string, Colors.ENDC

def printRed(string):
    print Colors.RED
    print string, Colors.ENDC

if __name__ == '__main__':
    main()
