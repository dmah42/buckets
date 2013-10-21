#include <cstdlib>
#include <iostream>
#include <list>
#include <set>
#include <vector>

int g_capacity_a = 5;
int g_capacity_b = 3;
int g_target = 4;

struct State {
  State(int a, int b) : a(a), b(b), parent(NULL) {}

  int a;
  int b;
  const State* parent;

  bool operator<(const State& rhs) const {
    if (a == rhs.a) {
      return b < rhs.b;
    }
    return a < rhs.a;
  }
};

std::vector<State*> GetChildStates(const State& state) {
  std::vector<State*> child_states;

  // empty a
  if (state.a != 0) {
    child_states.push_back(new State(0, state.b));
  }

  // empty b
  if (state.b != 0) {
    child_states.push_back(new State(state.a, 0));
  }

  // pour a to b
  if (state.b < g_capacity_b && state.a > 0) {
    int transfer = state.a;
    int capacity = g_capacity_b - state.b;

    transfer = std::min(transfer, capacity);

    child_states.push_back(new State(state.a - transfer, state.b + transfer));
  }

  // pour b to a
  if (state.a < g_capacity_a && state.b > 0) {
    int transfer = state.b;
    int capacity = g_capacity_a - state.a;

    transfer = std::min(transfer, capacity);

    child_states.push_back(new State(state.a + transfer, state.b - transfer));
  }

  // fill a
  if (state.a < g_capacity_a) {
    child_states.push_back(new State(g_capacity_a, state.b));
  }

  // fill b
  if (state.b < g_capacity_b) {
    child_states.push_back(new State(state.a, g_capacity_b));
  }

  return child_states;
}

int main(int argc, const char* argv[]) {
  if (argc != 4) {
    std::cerr << "Usage: " << argv[0] << " <capacity-a> <capacity-b> <target>";
    return 1;
  }

  g_capacity_a = strtoul(argv[1], NULL, 10);
  g_capacity_b = strtoul(argv[2], NULL, 10);
  g_target = strtoul(argv[3], NULL, 10);

  std::vector<State*> states;
  std::set<State> visited_states;

  states.push_back(new State(0,0));
  while (states.size() > 0) {
    const State* state = states.back();
    states.pop_back();
    std::vector<State*> child_states = GetChildStates(*state);
    for (size_t i = 0; i < child_states.size(); ++i) {
      if (state->a + state->b == g_target) {
        // print path
        std::list<const State*> path;
        while (state != NULL) {
          path.push_front(state);
          state = state->parent;
        }
        for (std::list<const State*>::const_iterator path_it = path.begin();
             path_it != path.end(); ++path_it) {
          std::cout << (*path_it)->a << " " << (*path_it)->b << "\n";
        }
        return 0;
      }
      if (visited_states.count(*child_states[i]) == 0) {
        child_states[i]->parent = state;
        states.push_back(child_states[i]);
        visited_states.insert(*child_states[i]);
      }
    }
  }
  std::cout << "Failed to find a solution\n";
  return 1;
}
