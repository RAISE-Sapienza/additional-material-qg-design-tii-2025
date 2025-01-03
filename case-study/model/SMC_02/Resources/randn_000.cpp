#include <cmath>
#include <random>

#include "randn.h"

std::default_random_engine generator;
std::normal_distribution<double> distribution(0.0,1.0);

double randn01()
{
  return distribution(generator);
}

void set_seed()
{

}
