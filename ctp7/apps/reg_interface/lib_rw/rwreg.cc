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

DLLEXPORT unsigned int getReg(unsigned int address) {
  memsvc_handle_t memHandle;
  if(memsvc_open(&memHandle) != 0) {
    perror("Memory service connect failed");
    printf("Error here, exiting to 1")
    exit(1);
  }
  unsigned int readBuffer;
  if(memsvc_read(memHandle, address, 1, &readBuffer) != 0) {
#ifdef EMBED
    printf("Memory access failed: %s\n",memsvc_get_last_error(memHandle));
#endif
    return 0;
  }
   
  if(memsvc_close(&memHandle) != 0) {
    perror("Memory service close failed");
  }
  return readBuffer;
}

DLLEXPORT unsigned int putReg(unsigned int address, unsigned int value) {
  memsvc_handle_t memHandle;
  if(memsvc_open(&memHandle) != 0) {
    perror("Memory service connect failed");
    exit(1);
  }
  unsigned int writeBuffer = value;
  if(memsvc_write(memHandle, address, 1, &writeBuffer) != 0) {
#ifdef EMBED
    printf("Memory access failed: %s\n",memsvc_get_last_error(memHandle));
#endif
    return 0;
  }
   
  if(memsvc_close(&memHandle) != 0) {
    perror("Memory service close failed");
  }
  return 1;
}
