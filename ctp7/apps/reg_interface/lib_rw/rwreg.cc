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
  printf("Beginning");
  memsvc_handle_t memHandle;
  bool connected = true;
  if(memsvc_open(&memHandle) != 0) {
    //printf("Memory service connect failed");
    //printf("Error here, exiting to 1");
    //exit(1);
    connected = false;
    return 0xdeadbeef;
  }
  return 0xbeefface;
  printf("Middle");
  unsigned int readBuffer;
  if(connected) {
    if(memsvc_read(memHandle, address, 1, &readBuffer) != 0) {
// #ifdef EMBED
//     printf("Memory access failed: %s\n",memsvc_get_last_error(memHandle));
// #endif
      printf("Error with memsvc_read");
      return 2;
    }
  }
  printf("Almost End");
  if(connected) {
    if(memsvc_close(&memHandle) != 0) {
    // perror("Memory service close failed");
      return 3;
    }
  }
  printf("End");
  if (connected)
    return readBuffer;
  else 
    return 0xdeaddead;
}

DLLEXPORT unsigned int putReg(unsigned int address, unsigned int value) {
  memsvc_handle_t memHandle;
  if(memsvc_open(&memHandle) != 0) {
    //perror("Memory service connect failed");
    //exit(1);
    return 4;
  }
  unsigned int writeBuffer = value;
  if(memsvc_write(memHandle, address, 1, &writeBuffer) != 0) {
#ifdef EMBED
    printf("Memory access failed: %s\n",memsvc_get_last_error(memHandle));
#endif
    return 5;
  }
   
  if(memsvc_close(&memHandle) != 0) {
    perror("Memory service close failed");
  }
  return 6;
}
