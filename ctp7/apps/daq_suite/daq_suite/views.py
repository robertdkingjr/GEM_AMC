from django.http import HttpResponse
from django.template import Template, Context
from django.shortcuts import render
from rw_reg import *

def hello(request):
  reg=getNode("GEM_AMC.GEM_SYSTEM.BOARD_ID")
  print reg
  return HttpResponse('Board ID %s'%(readReg(reg)))

def getTTCmain():
  values=[]
  namelist=['MMCM_LOCKED','TTC_SINGLE_ERROR_CNT','BC0_LOCKED','L1A_ID','L1A_RATE']
  displaystring=[]
  reg = getNode('GEM_AMC.TTC.STATUS.MMCM_LOCKED')
  if readReg(reg):
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
  if readReg(reg):
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
  

def main(request):
  return render(request,'main.html',{'main':True,'ttclist':getTTCmain()})

def read_fw(request):
  parseXML()
  reg=getNode("GEM_AMC.GEM_SYSTEM.BOARD_ID")
  print reg
  return HttpResponse('Board ID %s'%(readReg(reg)))

def read_gem_system_module(request,module):
  if request.method=="POST":
    if "update" in request.POST:
       regname = 'GEM_AMC.'+module.upper()+'.'+request.POST['update']
       reg = getNode(regname)
       writeReg(reg,int(request.POST[request.POST['update']],16))
  module=module.upper()
  #reglist = getRegsContaining("GEM_AMC."+module)
  reglist = getRegsContaining(module)
# skip chan regs for vfats for the moment
  if "OH.OH" in module:
    reglist = list(r for r in reglist if "ChanReg" not in r.name)
    reglist = list(r for r in reglist if "VFATS.VFAT" not in r.name)
  if "VFATS.VFAT" in module:
    reglist = list(r for r in reglist if "ChanReg" not in r.name)
   
  valuelist = []
  rowcolors = []

  for reg in reglist:
    try: 
      value = readReg(reg)
      valuelist.append(value)
      try: 
        warn_min = reg.warn_min_value
      except AttributeError as ae:
        print "No attribute %s" % (ae)
        warn_min = None
      try: 
        error_min = reg.error_min_value
      except AttributeError as ae:
        print "No attribute %s" % (ae)
        error_min = None
      if (warn_min is not None) or (error_min is not None):
        #print "Error or Warn Value is not None"
        if (warn_min is not None) and (error_min is not None): 
          #print "Error and Warn Value is not None"
          try:
            ivalue = parseInt(value)
            iwarn_min = parseInt(warn_min) 
            ierror_min = parseInt(error_min) 
            if ivalue > ierror_min:
              #print "Value is DANGER"
              rowcolors.append("danger")
            elif ivalue > iwarn_min:
              #print "Value is WARNING"
              rowcolors.append("warning")
            else: 
              #print "Value is correct"
              rowcolors.append("info")
          except ValueError as ve:
            rowcolors.append("info")
            print ve
        elif (error_min is not None):
          #print "Error Value is not None"
          try:
            ivalue = parseInt(value)
            ierror_min = parseInt(error_min) 
            if ivalue > ierror_min:
              #print "Value is DANGER"
              rowcolors.append("danger")
            else: 
              #print "Value is correct"
              rowcolors.append("info")
          except ValueError as ve:
            rowcolors.append("info")
            print ve
        elif (warn_min is not None):
          #print "Warn Value is not None"
          try:
            ivalue = parseInt(value)
            iwarn_min = parseInt(warn_min) 
            if ivalue > iwarn_min:
              rowcolors.append("warning")
            else: 
              #print "Value is correct"
              rowcolors.append("info")
          except ValueError as ve:
            rowcolors.append("info")
            print ve
        else:
          print "WTF?!"
          rowcolors.append("info")
      else:
        rowcolors.append("info")
    except: 
      print "Unexpected error:", sys.exc_info()[0]
      print reg
  forename = "GEM_AMC."+module
  ziplist = zip(list(reg.name[len(forename)+1:] for reg in reglist),valuelist,rowcolors, list(reg.permission for reg in reglist))
  return render(request,'module.html',{'module':module,'ziplist':ziplist})
