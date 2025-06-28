# NVim-MEP

NVim-MiseEnPlace (MEP) is my personal Neovim configuration.
This repo started using `kickstart-nix.nvim` as a template and
then had all of my neovim configurations added to it.

## :bicyclist: Test drive

If you have Nix installed (with [flakes](https://wiki.nixos.org/wiki/Flakes) enabled),
you can test drive this by running:

```console
nix run "github:jordanschupbach/nvim-mep"
```

## :zap: Installation

### :snowflake: NixOS (with flakes)

1. Add your flake to you NixOS flake inputs.
1. Add the overlay provided by this flake.

```nix
nixpkgs.overlays = [
  # replace <nvim-mep> with the name you chose
  <nvim-mep>.overlays.default
];
```

You can then add the overlay's output(s) to the `systemPackages`:

```nix
environment.systemPackages = with pkgs; [
  nvim-pkg
];
```

### :penguin: Non-NixOS

With Nix installed (flakes enabled), from the repo root:

```console
nix profile install .#nvim
```
