#include <stdio.h>      /* printf */
#include <time.h>
#include <librwreg.so>

using namespace std;

int main()
{
  clock_t t;
  string ctp7_reg = "GEM_AMC.GEM_SYSTEM.BOARD_ID";
  string oh_reg = "";
  string glib_reg = "GEM_AMC.GEM_SYSTEM.BOARD_ID";

  t = clock();
  for (i = 0;i<1000;i++) {
    getReg(ctp7_reg);
  }
  t = clock() - t;

  printf("Time to read 1000 registers: %d clicks, %f seconds\n",t,((float)t/CLOCKS_PER_SEC));




}


