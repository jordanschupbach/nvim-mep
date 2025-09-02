#include <iostream>

void printHelloWorld(int times) {
  std::string text = "Hello World";
  for (int i = 0; i < times; ++i) {
    std::cout << text << std::endl;
  }
}

int main() {
  const int repetitions = 5;
  printHelloWorld(repetitions);
  return 0;
}

// vim: set ft=cpp:
