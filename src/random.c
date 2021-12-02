#include <time.h>
#include <stdlib.h>

int get_value()
{
   srand(time(NULL));   // Initialization, should only be called once.
   int r = rand() % 500;
   return r;
}