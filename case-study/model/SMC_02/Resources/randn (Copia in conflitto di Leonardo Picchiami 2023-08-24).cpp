#include <cmath>
#include <random>
#include <cassert>

#include "randn.h"

//std::default_random_engine generator((unsigned int)time(NULL));
std::default_random_engine generator = NULL;
std::normal_distribution<double> distribution(0.0,1.0);


void rand_setseed(unsigned int seed)
{
  if(seed == 0){
    seed = (unsigned int)time(NULL);
  } 
  generator = generator(seed);
}

double randn01()
{
  assert(generator != NULL);
  return distribution(generator);
}
