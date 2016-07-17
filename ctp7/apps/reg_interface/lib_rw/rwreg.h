#include <sys/socket.h>
#include <sys/un.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#include <iostream>
#include <iomanip>

using namespace std;

#include "CTP7.hh"
//#include "librwreg.hh"

#define DLLEXPORT extern "C"


bool getData(memsvc_handle_t memHandle,
             unsigned int address,
             unsigned int numberOfValues,
             unsigned int *buffer);


DLLEXPORT unsigned long getReg(unsigned int address);


DLLEXPORT unsigned int putReg(unsigned int address, unsigned int value);
