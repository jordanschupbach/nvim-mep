
{}:

{

a = 1 + 1;

b = { a.b.c = 1; };


c = let
  x = 1;
  y = 6;
in x + y;
  

d = builtins.isFloat 1.1;
e = builtins.isFloat true;

# adder = a: b: a + b;
# addOne = x: adder x 1;
# 
# fda = addOne 41;
# cdf = builtins.isInt (add 41 1)
# 
# fdsa = { a = "asdf"; b = 1; c.d = 1.0; }
# 
# builtins.isFloat fdsa.c.d
# fdsa.c.d
# 
# <nixpkgs/lib>
# 
# asdf = (x: y: x - (7 + y) + 1) 41
# 
# asdf 22
# 
# 
# let
#   pkgs = import <nixpkgs> {};
# in
#   pkgs.lib.strings.toUpper "lookup paths considered harmful"
# }
