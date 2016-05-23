from django.http import HttpResponse
from django.template import Template, Context
from django.shortcuts import render
from rw_reg import *

def hello(request):
  return HttpResponse('Hello World')

def read_fw(request):
  parseXML()
  reg=getNode("GEM_AMC.GEM_SYSTEM.BOARD_ID")
  print reg
  return HttpResponse('Board ID %s'%(readReg(reg)))

def read_gem_system_module(request):
  parseXML()
  reglist = getRegsContaining("GEM_AMC.GEM_SYSTEM")
  valuelist = []
  for reg in reglist:
    try: valuelist.append(readReg(reg))
    except: print reg
  ziplist = zip(list(reg.name for reg in reglist),valuelist)
  return render(request,'module.html',{'ziplist':ziplist})
