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
             unsigned int *buffer) {
  int wordsToGo = numberOfValues;
  int wordsDone = 0;
  unsigned int readBuffer;

  while(wordsToGo > 0) {
    int words = 1;
    if(memsvc_read(memHandle, address+wordsDone*4, words, &readBuffer) != 0) {
      return false;
    }

    buffer[wordsDone] = readBuffer;
    wordsToGo -= words;
    wordsDone += words;
  }
  return true;
}

DLLEXPORT unsigned long getReg(unsigned int address) {
  memsvc_handle_t memHandle;
  if(memsvc_open(&memHandle) != 0) {
    printf("Error 1: %s\t",memsvc_get_last_error(memHandle));
    return 0xfefe;
  }
  unsigned int buffer;
  if(getData(memHandle, address, 1, &buffer)) {
    if(memsvc_close(&memHandle) != 0) {
      printf("Error 2: %s\t",memsvc_get_last_error(memHandle));
      return 0xcafe;
    }
    return buffer;
  }
  else {
    if(memsvc_close(&memHandle) != 0) {
      printf("Error 3: %s\t",memsvc_get_last_error(memHandle));
      return 0xcafe;
    }

    // Return on Bus Error...?
    return 0xdeddead;
  }
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
