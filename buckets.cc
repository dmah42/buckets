#include <algorithm>
#include <cstdlib>
#include <iostream>
#include <set>
#include <vector>

namespace buckets {
int capacity_a = 5;
int capacity_b = 3;
int target = 4;

class State {
 public:
  State(int a, int b) : state_(a, b), parent_(NULL) {}

  int a() const { return state_.first; }
  int b() const { return state_.second; }

  const State* parent() const { return parent_; }
  void set_parent(const State* parent) { parent_ = parent; }

  bool operator<(const State& rhs) const { return state_ < rhs.state_; }

 private:
  std::pair<int, int> state_;
  const State* parent_;
};

std::vector<State*> GetChildStates(const State& state) {
  std::vector<State*> child_states;

  // empty a
  if (state.a() != 0) {
    child_states.push_back(new State(0, state.b()));
  }

  // empty b
  if (state.b() != 0) {
    child_states.push_back(new State(state.a(), 0));
  }

  // pour a to b
  if (state.b() < capacity_b && state.a() > 0) {
    int transfer = state.a();
    int capacity = capacity_b - state.b();

    transfer = std::min(transfer, capacity);

    child_states.push_back(new State(state.a() - transfer,
                                     state.b() + transfer));
  }

  // pour b to a
  if (state.a() < capacity_a && state.b() > 0) {
    int transfer = state.b();
    int capacity = capacity_a - state.a();

    transfer = std::min(transfer, capacity);

    child_states.push_back(new State(state.a() + transfer,
                                     state.b() - transfer));
  }

  // fill a
  if (state.a() < capacity_a) {
    child_states.push_back(new State(capacity_a, state.b()));
  }

  // fill b
  if (state.b() < capacity_b) {
    child_states.push_back(new State(state.a(), capacity_b));
  }

  return child_states;
}

std::vector<std::pair<int, int> > Run(
    int capacity_a, int capacity_b, int target) {
  buckets::capacity_a = capacity_a;
  buckets::capacity_b = capacity_b;
  buckets::target = target;

  std::vector<State*> states;
  std::set<State> visited_states;

  states.push_back(new State(0,0));
  while (states.size() > 0) {
    const State* state = states.back();
    states.pop_back();
    std::vector<State*> child_states = GetChildStates(*state);
    for (size_t i = 0; i < child_states.size(); ++i) {
      if (state->a() + state->b() == target) {
        // print path
        std::vector<std::pair<int, int> > path;
        while (state != NULL) {
          path.push_back(std::pair<int, int>(state->a(), state->b()));
          state = state->parent();
        }
        std::reverse(path.begin(), path.end());
        return path;
      }
      if (visited_states.count(*child_states[i]) == 0) {
        child_states[i]->set_parent(state);
        states.push_back(child_states[i]);
        visited_states.insert(*child_states[i]);
      }
    }
  }
  return std::vector<std::pair<int, int> >();
}
}  // namespace buckets

