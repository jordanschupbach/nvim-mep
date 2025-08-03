{pkgs ? import <nixpkgs> {}}:
with pkgs;
  pkgs.mkShell {
    buildInputs = let
      # Quipper does not work with GHC 7.10 or 8.10. The versions currently supported are GHC 8.0, 8.2, 8.4, 8.6, and 8.8.
      myHaskell = pkgs.haskell.packages.ghc884.override {
        overrides = self: super: {
          # fixedprec needs random 1.1 or below
          random = pkgs.haskell.lib.overrideCabal super.random {
            version = "1.1";
            sha256 = "sha256-txikEFfiWjpx32k6sP4iY9SS51lnmzwv6m6jOxcdOlo=";
          };
          fixedprec = haskell.lib.markUnbroken super.fixedprec;
          quipper = haskell.lib.markUnbroken super.quipper;
        };
      };
    in [
      (myHaskell.ghcWithPackages (hpkgs: [
        hpkgs.quipper
      ]))
    ];
  }
