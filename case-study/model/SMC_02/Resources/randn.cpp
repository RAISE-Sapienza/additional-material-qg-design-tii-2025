#include <cmath>
#include <random>
#include <cassert>
#include <fstream>
#include <iostream>

#include "randn.h"

//std::default_random_engine generator((unsigned int)time(NULL));
unsigned int generator_created = 0;
//std::default_random_engine generator;
std::mt19937 generator;
std::normal_distribution<double> distribution(0.0,1.0);


void rand_seed_from_file()
{
  unsigned int seed = 0;
  int seed_read = 1;
  std::fstream seed_file("random_seed.txt", std::ios_base::in);
  //assert(seed_file);
  if(!(seed_file >> seed)){
    seed_read = 0;
  //  assert(0);
  }

  if(seed_read == 0){
    seed = (unsigned int)time(NULL);
  } 
  generator.seed(seed);
  generator_created = 1;
}

double randn01()
{
  if(generator_created == 0){
    rand_seed_from_file();
  }
  return distribution(generator);
}
