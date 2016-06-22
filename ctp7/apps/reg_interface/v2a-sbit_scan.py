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
    parseXML()

    clearAllChannels()
    scanAllStrips(4, f)

    return


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


def map_vfat(vfat_slot, outfile):
    try:
        if int(vfat_slot) > 23 or int(vfat_slot) < 0:
            print 'Invalid VFAT slot!'
            return
    except:
        print 'Invalid input!'
        return

   
    REG_PATH = 'GEM_AMC.OH.OH'+str(OH_NUM)+'.GEB.VFATS.VFAT'+str(vfat_slot)+'.'


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


    # NO VFAT MASKING ON V2A


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
    print writeReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.INTERVAL'), 4)
    print writeReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.NUMBER'), 0)  #Infinite pulsing

    #ON
    print writeReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.TOGGLE'),0xffffffff)
    t1status = readReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.MONITOR')) 
    print 'T1 Monitor:',t1status
    if parseInt(t1status) == 0:
        print writeReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.TOGGLE'),0xffffffff)
        t1status = readReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.MONITOR'))
        print 'T1 Monitor:',t1status

    # Search for SBits
    strips = [16*i for i in range(1,9)] #16,32,...,128
    # cluster_reg = []
    # for f in range(8):
    #     cluster_reg.append( getNode('GEM_AMC.TRIGGER.OH'+str(OH_NUM)+'.DEBUG_LAST_CLUSTER_'+str(f)) )

    cluster_reg = getNode('GEM_AMC.TRIGGER.OH'+str(OH_NUM)+'.DEBUG_LAST_CLUSTER_3')

    subheading('Cluster Info')
    for strip in strips:
        print 'Strip',strip
        writeReg(getNode(REG_PATH+'VFATChannels.ChanReg'+str(strip)),64)
        for i in range(2017):
            value = parseInt(str(readReg(cluster_reg)))
            if value != 2047: 
                print 'VFAT:',cluster_to_vfat(value),'\t VFAT2 SBit:',cluster_to_vfat2_sbit(value),'\t Size:', cluster_to_size(value),'\n'
                outfile.write('%s%d%s%d%s%d\n' % ('VFAT:',cluster_to_vfat(value),'\t VFAT2 SBit:',cluster_to_vfat2_sbit(value),'\t Size:', cluster_to_size(value)))
        writeReg(getNode(REG_PATH+'VFATChannels.ChanReg'+str(strip)),0)
     
    #OFF
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

    heading('Beginning SBit Scan')


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


    # # Mask VFATs
    # heading('MASK VFATS')
    # SBitMask = getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.CONTROL.VFAT.SBIT_MASK')
    # print 'Unmasking VFAT',vfat_slot
    # vmask = (0xffffffff) ^ (0x1 << int(vfat_slot))
    # print writeReg(SBitMask,vmask)


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
    print writeReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.INTERVAL'), 1000)
    print writeReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.NUMBER'), pulses)



    # Reset Trigger Counters
    heading('Reset trigger counters')
    TCReset = getNode('GEM_AMC.TRIGGER.CTRL.CNT_RESET')
    if TCReset is None:
        print 'Error finding GEM_AMC.TRIGGER.CTRL.CNT_RESET Register!'
        return
    writeReg(TCReset,1)
    writeReg(TCReset,0)


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
        outfile.write('!')
        if not QUICKTEST:
            for reg in getNodesContaining('TRIGGER.OH'+str(OH_NUM)+'.CLUSTER'):
                if 'r' in str(reg.permission):
                    print displayReg(reg),'=',parseInt(str(readReg(reg)))
            print '\n'
            for reg in getNodesContaining('TRIGGER.OH'+str(OH_NUM)+'.DEBUG_LAST_CLUSTER'):
                if 'r' in str(reg.permission):
                    print displayReg(reg,'hexbin')
        #return
    else: print 'Trigger Counts clear.'



    # LOOP
    heading('LOOPING OVER CHANNELS')
    triggerResults = []
    pads = range(1,2*NUM_PADS+1)
    strips = [8*i for i in pads] #8,16,24,...,128


    # Clear all channels
    if not QUICKTEST:
        subheading('Clearing all channels...')
        for strip in range(1,129):
            writeReg(getNode(REG_PATH+'VFATChannels.ChanReg'+str(strip)),0)


    try:
        for strip in strips:
            subheading('Strip '+str(strip))

            print writeReg(getNode(REG_PATH+'VFATChannels.ChanReg'+str(strip)),64)
            
            subheading('Resetting Trigger Counters...')
            writeReg(TCReset,1)
            writeReg(TCReset,0)


            #subheading('Verifying...')
            sleep(0.01)
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
                #return
            #else: print 'Trigger Counts clear.'


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
            
            if parseInt(nSbits) != 4*pulses:
                printRed( 'Strip '+str(strip)+'   Expected:'+str(4*pulses)+'\t'+'Received:'+str(parseInt(nSbits)) )
            else:
                printCyan( 'Strip '+str(strip)+'   Expected:'+str(4*pulses)+'\t'+'Received:'+str(parseInt(nSbits)) )
    
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
        for result in range(len(triggerResults)):
            if triggerResults[result][1] != 4*pulses:
                print Colors.RED+'Strip',triggerResults[result][0],'\t','Expected:',pulses,'Received:',triggerResults[result][1],Colors.ENDC
            else:
                print 'Strip',triggerResults[result][0],'\t','Expected:',pulses,'Received:',triggerResults[result][1]
            outfile.write('%s%03d%s%s%s %s%s\n' % ('Strip',triggerResults[result][0],'\t','Expected:',pulses,'Received:',triggerResults[result][1]))
        print '\n\n'
        outfile.write('\n\n')


def scanAllStrips(vfat_slot,outfile):

    try:
        if int(vfat_slot) > 23 or int(vfat_slot) < 0:
            print 'Invalid VFAT slot!'
            return
    except:
        print 'Invalid input!'
        return
    TCReset = getNode('GEM_AMC.TRIGGER.CTRL.CNT_RESET')   
    REG_PATH = 'GEM_AMC.OH.OH'+str(OH_NUM)+'.GEB.VFATS.VFAT'+str(vfat_slot)+'.'
    strips = range(1,129)    
    triggerResults = []



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
    print writeReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.INTERVAL'), 1000)
    print writeReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.T1Controller.NUMBER'), pulses)


    

    # Reset Trigger Counters
    heading('Reset trigger counters')
    TCReset = getNode('GEM_AMC.TRIGGER.CTRL.CNT_RESET')
    if TCReset is None:
        print 'Error finding GEM_AMC.TRIGGER.CTRL.CNT_RESET Register!'
        return
    writeReg(TCReset,1)
    writeReg(TCReset,0)


    # Verify Reset
    #subheading('Verifying...')
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
        if not QUICKTEST:
            for reg in getNodesContaining('TRIGGER.OH'+str(OH_NUM)+'.CLUSTER'):
                if 'r' in str(reg.permission):
                    print displayReg(reg),'=',parseInt(str(readReg(reg)))
            print '\n'
            for reg in getNodesContaining('TRIGGER.OH'+str(OH_NUM)+'.DEBUG_LAST_CLUSTER'):
                if 'r' in str(reg.permission):
                    print displayReg(reg,'hexbin')
        #return
    #else: print 'Trigger Counts clear.'





    try:
        for strip in strips:
            subheading('Strip '+str(strip))
    

            subheading('ALL CHANNELS OFF - Resetting Trigger Counters...')
            writeReg(TCReset,1)
            writeReg(TCReset,0)
    
    
            subheading('Verifying...')
            sleep(0.01)
            # Read Number of SBits to verify reset
            nSbits = readReg(getNode('GEM_AMC.TRIGGER.OH'+str(OH_NUM)+'.TRIGGER_CNT'))
            try: parseInt(nSbits)
            except:
                print 'SBits:',nSbits
                return
            hotChip = False
            if parseInt(str(nSbits)) != 0: #Hot strips?
                hotChip = True
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
                #return
            else: print 'Trigger Counts clear.'
    

            print writeReg(getNode(REG_PATH+'VFATChannels.ChanReg'+str(strip)),64)
            
            subheading('CHANNEL '+str(strip)+'UNMASKED - Resetting Trigger Counters...')
            writeReg(TCReset,1)
            writeReg(TCReset,0)
    
    
            subheading('Verifying...')
            sleep(0.01)
            # Read Number of SBits to verify reset
            nSbits = readReg(getNode('GEM_AMC.TRIGGER.OH'+str(OH_NUM)+'.TRIGGER_CNT'))
            try: parseInt(nSbits)
            except:
                print 'SBits:',nSbits
                return
            hotStrip = False
            if parseInt(str(nSbits)) != 0: #Hot strips?
                hotStrip = True
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
                #return
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
                
            triggerResults.append([strip,parseInt(nSbits),hotStrip,hotChip])
            
            if parseInt(nSbits) != 4*pulses:
                printRed( 'Strip '+str(strip)+'   Expected:'+str(4*pulses)+'\t'+'Received:'+str(parseInt(nSbits)) )
            else:
                printCyan( 'Strip '+str(strip)+'   Expected:'+str(4*pulses)+'\t'+'Received:'+str(parseInt(nSbits)) )
    
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
        writeReg(getNode(REG_PATH + 'VFATChannels.ChanReg' + str(strip)), 0)
        heading('Summary')
        subheading('VFAT Slot '+str(vfat_slot)+' ID '+hex(vfat_id))
        outfile.write('VFAT Slot '+str(vfat_slot) + '\n')
        for result in range(len(triggerResults)):
            if triggerResults[result][1] != 4*pulses:
                print Colors.RED+'Strip',triggerResults[result][0],'\t','Expected:',(pulses*4),'Received:',triggerResults[result][1],'\t Hot Strip:',triggerResults[result][2],' Hot Chip:',triggerResults[result][3],Colors.ENDC
            else:
                print 'Strip',triggerResults[result][0],'\t','Expected:',(pulses*4),'Received:',triggerResults[result][1],'\t Hot Strip:',triggerResults[result][2],' Hot Chip:',triggerResults[result][3]
            outfile.write('%s%03d%s%s%s %s%s\t%s%s %s%s\n' % ('Strip',triggerResults[result][0],'\t','Expected:',(pulses*4),'Received:',triggerResults[result][1],'Hot strip: ',triggerResults[result][2],'Hot Chip: ',triggerResults[result][3]))
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

#TODO use Broadcast
def clearAllChannels():
    print 'Clearing all Channels on all VFATs...'
    for vfat in range(0,24):
        print 'VFAT '+str(vfat)
        for strip in range(1,129):
            if parseInt(readReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.GEB.VFATS.VFAT'+str(vfat)+'.VFATChannels.ChanReg'+str(strip))))&0x000000ff != 0:
                printRed( writeReg(getNode('GEM_AMC.OH.OH'+str(OH_NUM)+'.GEB.VFATS.VFAT'+str(vfat)+'.VFATChannels.ChanReg'+str(strip)),0) )





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
