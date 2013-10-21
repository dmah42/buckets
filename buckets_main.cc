#include <cstdlib>
#include <iostream>

#include "buckets.h"

int main(int argc, const char* argv[]) {
  if (argc != 4) {
    std::cerr << "Usage: " << argv[0] << " <capacity-a> <capacity-b> <target>";
    return 1;
  }

  int capacity_a = strtoul(argv[1], NULL, 10);
  int capacity_b = strtoul(argv[2], NULL, 10);
  int target = strtoul(argv[3], NULL, 10);
  return buckets::Run(capacity_a, capacity_b, target) ? 0 : 1;
}
