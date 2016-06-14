from django.http import HttpResponse
from django.template import Template, Context
from django.shortcuts import render
from rw_reg import *

def hello(request):
  reg=getNode("GEM_AMC.GEM_SYSTEM.BOARD_ID")
  print reg
  return HttpResponse('Board ID %s'%(readReg(reg)))

def main(request):
  parseXML()
  return render(request,'main.html')

def read_fw(request):
  parseXML()
  reg=getNode("GEM_AMC.GEM_SYSTEM.BOARD_ID")
  print reg
  return HttpResponse('Board ID %s'%(readReg(reg)))

def read_gem_system_module(request,module):
  module=module.upper()
  reglist = getRegsContaining("GEM_AMC."+module)
  valuelist = []
  rowcolors = []
  for reg in reglist:
    try: 
      value = readReg(reg)
      valuelist.append(value)
      if (reg.warn_min_value is not None) or (reg.error_min_value is not None):
        if (reg.warn_min_value is not None) and (reg.error_min_value is not None): 
          try:
            ivalue = parseInt(value)
            iwarn_min = parseInt(reg.warn_min_value) 
            ierror_min = parseInt(reg.error_min_value) 
            if ivalue > ierror_min:
              rowcolors.append("danger")
            elif ivalue > iwarn_min:
              rowcolors.append("warning")
            else: 
              rowcolors.append("info")
          except ValueError as ve:
            rowcolors.append("info")
    	    print ve
        elif (reg.error_min_value is not None):
          try:
            ivalue = parseInt(value)
            ierror_min = parseInt(reg.error_min_value) 
            if ivalue > ierror_min:
              rowcolors.append("danger")
            else: 
              rowcolors.append("info")
          except ValueError as ve:
            rowcolors.append("info")
    	    print ve
        elif (reg.warn_min_value is not None):
          try:
            ivalue = parseInt(value)
            iwarn_min = parseInt(reg.warn_min_value) 
            if ivalue > iwarn_min:
              rowcolors.append("warning")
            else: 
              rowcolors.append("info")
          except ValueError as ve:
            rowcolors.append("info")
    	    print ve
      else:
        rowcolors.append("info")
    except: 
      print reg
  ziplist = zip(list(reg.name for reg in reglist),valuelist,rowcolors)
  print ziplist
  return render(request,'module.html',{'module':module,'ziplist':ziplist})
