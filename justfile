build:
  nix build

run args:
  nix run . -- {{args}}

try:
  nix run . -- ./README.md # --repair 

cpp:
  nix develop --command cmake -S ./playground/cpp/ -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
  nix develop --command cmake --build build
  build/simpleProgram
