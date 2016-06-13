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
      print "Register %s value %s" %(reg.name,readReg(reg))
      valuelist.append(readReg(reg))
      rowcolors.append("info")
    except: 
      print reg
  ziplist = zip(list(reg.name for reg in reglist),valuelist,rowcolors)
  print ziplist
  return render(request,'module.html',{'module':module,'ziplist':ziplist})
