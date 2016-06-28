from rw_reg import *
NOH=4

def getTTCmain():
  values=[]
  namelist=['MMCM_LOCKED','TTC_SINGLE_ERROR_CNT','BC0_LOCKED','L1A_ID','L1A_RATE']
  displaystring=[]
  reg = getNode('GEM_AMC.TTC.STATUS.MMCM_LOCKED')
  if int(readReg(reg),16):
    displaystring.append('<span class="label label-success">YES</span>')
  else:
    displaystring.append('<span class="label label-danger">NO</span>')
  reg = getNode('GEM_AMC.TTC.STATUS.TTC_SINGLE_ERROR_CNT')
  value=int(readReg(reg),16)
  if value:
    displaystring.append('<div class="progress"><div class="progress-bar progress-bar-warning" role="progressbar" aria-valuenow="%s" aria-valuemin="0" aria-valuemax="65535" style="min-width: 3em;">%s</div></div>' % (value,value))
  else:
    displaystring.append('<div class="progress"><div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="%s" aria-valuemin="0" aria-valuemax="65535" style="min-width: 3em;">%s</div></div>' % (value,value))
  reg = getNode('GEM_AMC.TTC.STATUS.BC0.LOCKED')
  if int(readReg(reg),16):
    displaystring.append('<span class="label label-success">YES</span>')
  else:
    displaystring.append('<span class="label label-danger">NO</span>')
  reg = getNode('GEM_AMC.TTC.L1A_ID')
  value=int(readReg(reg),16)
  displaystring.append('<span class="label label-info">%s Hz</span>' % (value))
  reg = getNode('GEM_AMC.TTC.L1A_RATE')
  value=int(readReg(reg),16)
  displaystring.append('<span class="label label-info">%s Hz</span>' % (value))
  return zip(namelist,displaystring) 
 
def getTRIGGERmain():
  values=[]
  namelist=['OR_TRIGGER_RATE',]
  displaystring=[]
  reg = getNode('GEM_AMC.TRIGGER.STATUS.OR_TRIGGER_RATE')
  value=int(readReg(reg),16)
  if value>1000000:
    displaystring.append('<div class="progress"><div class="progress-bar progress-bar-warning" role="progressbar" aria-valuenow="%s" aria-valuemin="0" aria-valuemax="4294967295" style="min-width: 3em;">%s</div></div>' % (value,value))
  else:
    displaystring.append('<div class="progress"><div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="%s" aria-valuemin="0" aria-valuemax="4294967295" style="min-width: 3em;">%s</div></div>' % (value,value))
  for i in range(NOH):
    namelist.append('OH%s.TRIGGER_RATE' % (i))
    reg = getNode('GEM_AMC.TRIGGER.OH%s.TRIGGER_RATE' % (i))
    value=int(readReg(reg),16)
    if value>1000000:
      displaystring.append('<div class="progress"><div class="progress-bar progress-bar-warning" role="progressbar" aria-valuenow="%s" aria-valuemin="0" aria-valuemax="4294967295" style="min-width: 3em;">%s</div></div>' % (value,value))
    else:
      displaystring.append('<div class="progress"><div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="%s" aria-valuemin="0" aria-valuemax="4294967295" style="min-width: 3em;">%s</div></div>' % (value,value))

  return zip(namelist,displaystring) 
 
def getKILLMASKmain():
  killmask=[]
  reg = getNode('GEM_AMC.TRIGGER.CTRL.OH_KILL_MASK')
  value='{0:012b}'.format(int(readReg(reg),16))
  for v in value[::-1]:
    if int(v):
      killmask.append('disabled')
    else:
      killmask.append('success')
  return killmask

def getTRIGGEROHmain():
  displaystring=[]
  namelist=[]
  nextstr = ''
  for i in range(NOH):
    nextstr+='<td>%s</td>' % (i)
  namelist.append('Register|OH')
  displaystring.append(nextstr)
  nextstr = ''
  namelist+=['LINK0_NOT_VALID_CNT',
             'LINK1_NOT_VALID_CNT',]
  for regname in namelist[1:]:
    for i in range(NOH):
      reg=getNode('GEM_AMC.TRIGGER.OH%s.%s' %(i,regname))
      nextstr+='<td><span class="label label-info">%s</span></td>' % (int(readReg(reg),16))
    displaystring.append(nextstr)
    nextstr = ''

  return zip(namelist,displaystring) 

def getDAQmain():
  namelist=['DAQ_ENABLE',
            'DAQ_LINK_READY',
            'DAQ_LINK_AFULL',
            'DAQ_OFIFO_HAD_OFLOW',
            'L1A_FIFO_HAD_OFLOW',]
  fullnamelist=[['GEM_AMC.DAQ.CONTROL.DAQ_ENABLE','YES','NO','success','warning'],
                ['GEM_AMC.DAQ.STATUS.DAQ_LINK_RDY','YES','NO','success','warning'],
                ['GEM_AMC.DAQ.STATUS.DAQ_LINK_AFULL','YES','NO','warning','success'],
                ['GEM_AMC.DAQ.STATUS.DAQ_OUTPUT_FIFO_HAD_OVERFLOW','YES','NO','danger','success'],
                ['GEM_AMC.DAQ.STATUS.L1A_FIFO_HAD_OVERFLOW','YES','NO','danger','success']]

  displaystring=[]
  for regname in fullnamelist:
    reg = getNode(regname[0])
    if int(readReg(reg),16):
      displaystring.append('<td><span class="label label-%s">%s</span></td>' % (regname[3],regname[1]))
    else:
      displaystring.append('<td><span class="label label-%s">%s</span></td>' % (regname[4],regname[2]))
  namelist.append('L1A_FIFO_DATA_COUNT')
  reg = getNode('GEM_AMC.DAQ.EXT_STATUS.L1A_FIFO_DATA_CNT')
  value=int(readReg(reg),16)
  displaystring.append('<td><div class="progress"><div class="progress-bar progress-bar-info" role="progressbar" aria-valuenow="%s" aria-valuemin="0" aria-valuemax="8192" style="min-width: 3em;">%s</div></div></td>' % (value,value))
  namelist.append('DAQ_FIFO_DATA_COUNT')
  reg = getNode('GEM_AMC.DAQ.EXT_STATUS.DAQ_FIFO_DATA_CNT')
  value=int(readReg(reg),16)
  displaystring.append('<td><div class="progress"><div class="progress-bar progress-bar-info" role="progressbar" aria-valuenow="%s" aria-valuemin="0" aria-valuemax="8192" style="min-width: 3em;">%s</div></div></td>' % (value,value))
  namelist.append('EVENT_SENT')
  reg = getNode('GEM_AMC.DAQ.EXT_STATUS.EVT_SENT')
  value=int(readReg(reg),16)
  displaystring.append('<td><div class="progress"><div class="progress-bar progress-bar-info" role="progressbar" aria-valuenow="%s" aria-valuemin="0" aria-valuemax="4294967295" style="min-width: 3em;">%s</div></div></td>' % (value,value))
  namelist.append('TTS_STATE')
  reg = getNode('GEM_AMC.DAQ.STATUS.TTS_STATE')
  value=int(readReg(reg),16)
  if value==8:
    displaystring.append('<td><span class="label label-success" style="min-width:5em;">READY</span></td>')
  elif value==1:
    displaystring.append('<td><span class="label label-info" style="min-width:5em;">BUSY</span></td>')
  elif value==2:
    displaystring.append('<td><span class="label label-danger" style="min-width:5em;">ERROR</span></td>')
  elif value==3:
    displaystring.append('<td><span class="label label-warning" style="min-width:5em;">WARN</span></td>')
  elif value==4:
    displaystring.append('<td><span class="label label-primary" style="min-width:5em;">OOS</span></td>')
  else:
    displaystring.append('<td><span class="label label-default" style="min-width:5em;">NDF</span></td>')

  return zip(namelist,displaystring) 

def getIEMASKmain():
  iemask=[]
  reg = getNode('GEM_AMC.DAQ.CONTROL.INPUT_ENABLE_MASK')
  value='{0:012b}'.format(int(readReg(reg),16))
  for v in value[::-1]:
    if int(v):
      iemask.append('disabled')
    else:
      iemask.append('success')
  return iemask

def getDAQOHmain():
  displaystring=[]
  namelist=[]
  nextstr = ''
  for i in range(NOH):
    nextstr+='<td>%s</td>' % (i)
  namelist.append('Register|OH')
  displaystring.append(nextstr)
  nextstr = ''
  namelist+=['EVT_SIZE_ERR',
             'EVENT_FIFO_HAD_OFLOW',
             'INPUT_FIFO_HAD_OFLOW',
             'INPUT_FIFO_HAD_UFLOW',
             'VFAT_TOO_MANY',
             'VFAT_NO_MARKER',]
  for regname in namelist[1:]:
    for i in range(NOH):
      reg=getNode('GEM_AMC.DAQ.OH%s.STATUS.%s' %(i,regname))
      if int(readReg(reg),16):
        nextstr+='<td><span class="label label-danger">Y</span></td>'
      else:
        nextstr+='<td><span class="label label-success">N</span></td>'
    displaystring.append(nextstr)
    nextstr = ''

  return zip(namelist,displaystring) 

def getOHmain():
  displaystring=[]
  namelist=[]
  nextstr = ''
  for i in range(NOH):
    nextstr+='<td>%s</td>' % (i)
  namelist.append('Register|OH')
  displaystring.append(nextstr)
  nextstr = ''
  namelist+=['FW_VERSION',
             'EVENT_COUNTER',
             'EVENT_RATE',
             'GTX.TRK_ERR',
             'GTX.TRG_ERR',
             'CORR_VFAT_BLK_CNT',]
  fullnamelist=['GEM_AMC.OH.OH%s.STATUS.FW',
                 'GEM_AMC.DAQ.OH%s.COUNTERS.EVN',
                 'GEM_AMC.DAQ.OH%s.COUNTERS.EVT_RATE',
                 'GEM_AMC.OH.OH%s.COUNTERS.GTX.TRK_ERR',
                 'GEM_AMC.OH.OH%s.COUNTERS.GTX.TRG_ERR',
                 'GEM_AMC.DAQ.OH%s.COUNTERS.CORRUPT_VFAT_BLK_CNT',]

  for regname in fullnamelist:
    for i in range(NOH):
      reg=getNode(regname % (i))
      if 'FW' in regname:
        value = readReg(reg)[2:]
      else:
      	try:
      	  value = int(readReg(reg),16)
      	except ValueError as e:
      	  value = -1
      if value==-1:
        nextstr+='<td><span class="label label-danger">%s</span></td>' % (value)
      elif not 'EVENT' in regname and value>0 and not 'FW' in regname:
        nextstr+='<td><span class="label label-warning">%s</span></td>' % (value)
      elif 'FW' in regname:
        if 'Error' in value:
          nextstr+='<td><span class="label label-danger">ERROR</span></td>' 
        else:
          nextstr+='<td><span class="label label-info">%s</span></td>' % (value)
      else:
        nextstr+='<td><span class="label label-info">%s</span></td>' % (value)
    displaystring.append(nextstr)
    nextstr = ''

  return zip(namelist,displaystring) 
