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
  std::vector<std::pair<int, int> > solution = buckets::Run(
      capacity_a, capacity_b, target);
  for (std::vector<std::pair<int, int> >::const_iterator it = solution.begin();
       it != solution.end(); ++it) {
    std::cout << it->first << " " << it->second << "\n";
  }
  return solution.empty() ? 1 : 0;
}
