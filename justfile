build:
  nix build

run args:
  nix run . -- {{args}}

try:
  nix run . -- ./README.md # --repair 
