
{
  description = "MEP Neovim derivation";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    gen-luarc.url = "github:mrcjkb/nix-gen-luarc-json";

    # Add bleeding-edge plugins here.
    # They can be updated with `nix flake update` (make sure to commit the generated flake.lock)
    # wf-nvim = {
    #   url = "github:Cassin01/wf.nvim";
    #   flake = false;
    # };

  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    flake-utils,
    ...
  }: let

    systems = builtins.attrNames nixpkgs.legacyPackages;

    # This is where the Neovim derivation is built.
    neovim-overlay = import ./nix/neovim-overlay.nix {inherit inputs;};
  in
    flake-utils.lib.eachSystem systems (system: let
      pkgs = import nixpkgs {
        config.allowUnfree = true;
        inherit system;
        overlays = [
          # Import the overlay, so that the final Neovim derivation(s) can be accessed via pkgs.<nvim-pkg>
          neovim-overlay
          # This adds a function can be used to generate a .luarc.json
          # containing the Neovim API all plugins in the workspace directory.
          # The generated file can be symlinked in the devShell's shellHook.
          inputs.gen-luarc.overlays.default
        ];
      };

      shell = pkgs.mkShell {
        name = "nvim-devShell";
        buildInputs = with pkgs; [

          # Tools for Lua and Nix development, useful for editing files in this repo
          tree-sitter
          libxml2
          hello
          bashInteractive
          lua-language-server
          nil
          git
          stylua
          nnn
          nerd-fonts.ubuntu
          nerd-fonts.ubuntu-mono
          fish
          luajitPackages.luacheck
          nvim-dev

          # NOTE: adding here did work
          # R
          # rPackages.callr
          # rPackages.languageserver
          # rPackages.languageserversetup

        ];
        nativeBuildInputs = with pkgs; [
            tree-sitter
            pkg-config
        ];
        shellHook = ''
          # symlink the .luarc.json generated in the overlay
          ln -fs ${pkgs.nvim-luarc-json} .luarc.json
          # allow quick iteration of lua configs
          ln -Tfns $PWD/nvim ~/.config/nvim-dev
        '';
      };
    in {
      packages = rec {
        default = nvim;
        nvim = pkgs.nvim-pkg;
      };
      devShells = {
        default = shell;
        commands = [
          {
            name = "enter-shell";
            command = "exec ${pkgs.bashInteractive}/bin/bash";
          }];
      };
    })
    // {
      # You can add this overlay to your NixOS configuration
      overlays.default = neovim-overlay;
    };
}
