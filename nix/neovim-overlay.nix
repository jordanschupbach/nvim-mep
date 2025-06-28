
# This overlay, when applied to nixpkgs, adds the final neovim derivation to nixpkgs.
{inputs}: final: prev:
with final.pkgs.lib; let
  pkgs = final;

  # Use this to create a plugin from a flake input
  mkNvimPlugin = src: pname:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.lastModifiedDate;
    };

  # Make sure we use the pinned nixpkgs instance for wrapNeovimUnstable,
  # otherwise it could have an incompatible signature when applying this overlay.
  pkgs-locked = inputs.nixpkgs.legacyPackages.${pkgs.system};

  # This is the helper function that builds the Neovim derivation.

  mkNeovim = pkgs.callPackage ./mkNeovim.nix {
      inherit (pkgs-locked) wrapNeovimUnstable neovimUtils;
    };

  # A plugin can either be a package or an attrset, such as
  # { plugin = <plugin>; # the package, e.g. pkgs.vimPlugins.nvim-cmp
  #   config = <config>; # String; a config that will be loaded with the plugin
  #   # Boolean; Whether to automatically load the plugin as a 'start' plugin,
  #   # or as an 'opt' plugin, that can be loaded with `:packadd!`
  #   optional = <true|false>; # Default: false
  #   ...
  # }



  all-plugins = with pkgs.vimPlugins; [

    # plugins from nixpkgs go in here.
    # https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=vimPlugins


    # eyeliner-nvim # Highlights unique characters for f/F and t/T motions | https://github.com/jinh0/eyeliner.nvim
    # lualine-nvim # Status line | https://github.com/nvim-lualine/lualine.nvim/
    # nvim-cmp (autocompletion) and extensions
    # nvim-unception # Prevent nested neovim sessions | nvim-unception

    lsp-progress-nvim # https://github.com/linrongbin16/lsp-progress.nvim
    heirline-nvim # https://github.com/rebelot/heirline.nvim/
    copilot-vim # https://github.com/github/copilot.vim/
    aerial-nvim # https://github.com/stevearc/aerial.nvim
    cmp-buffer # current buffer as completion source | https://github.com/hrsh7th/cmp-buffer/
    cmp-cmdline # cmp command line suggestions
    cmp-cmdline-history # cmp command line history suggestions
    cmp-nvim-lsp # LSP as completion source | https://github.com/hrsh7th/cmp-nvim-lsp/
    cmp-nvim-lsp-signature-help # https://github.com/hrsh7th/cmp-nvim-lsp-signature-help/
    cmp-nvim-lua # neovim lua API as completion source | https://github.com/hrsh7th/cmp-nvim-lua/
    cmp-path # file paths as completion source | https://github.com/hrsh7th/cmp-path/
    cmp_luasnip # snippets autocompletion extension for nvim-cmp | https://github.com/saadparwaiz1/cmp_luasnip/
    dashboard-nvim # https://github.com/nvimdev/dashboard-nvim/
    diffview-nvim # https://github.com/sindrets/diffview.nvim/
    gitsigns-nvim # https://github.com/lewis6991/gitsigns.nvim/
    lspkind-nvim # vscode-like LSP pictograms | https://github.com/onsails/lspkind.nvim/
    luasnip # snippets | https://github.com/l3mon4d3/luasnip/
    oil-nvim # https://github.com/stevearc/oil.nvim
    kanagawa-nvim # https://github.com/rebelot/kanagawa.nvim
    melange-nvim # https://github.com/savq/melange-nvim
    text-case-nvim # https://github.com/johmsalas/text-case.nvim
    neogit # https://github.com/TimUntersberger/neogit/
    nerdtree #
    focus-nvim # https://github.com/nvim-focus/focus.nvim
    nvim-cmp # https://github.com/hrsh7th/nvim-cmp
    nvim-navic # Add LSP location to lualine | https://github.com/SmiteshP/nvim-navic
    nvim-surround # https://github.com/kylechui/nvim-surround/
    nvim-tree-lua #
    nvim-treesitter-context # nvim-treesitter-context
    nvim-treesitter-textobjects # https://github.com/nvim-treesitter/nvim-treesitter-textobjects/
    nvim-treesitter.withAllGrammars
    nvim-ts-context-commentstring # https://github.com/joosepalviste/nvim-ts-context-commentstring/
    nvim-web-devicons
    plenary-nvim
    smart-splits-nvim #
    sqlite-lua
    statuscol-nvim # Status column | https://github.com/luukvbaal/statuscol.nvim/
    telescope-fzy-native-nvim # https://github.com/nvim-telescope/telescope-fzy-native.nvim
    telescope-nvim # https://github.com/nvim-telescope/telescope.nvim/
    telescope-project-nvim
    tokyonight-nvim
    vim-fugitive # https://github.com/tpope/vim-fugitive/
    vim-repeat
    vim-slime
    vim-unimpaired # predefined ] and [ navigation keymaps | https://github.com/tpope/vim-unimpaired/
    which-key-nvim
    zen-mode-nvim

    flash-nvim
    nvim-luadev
    focus-nvim
    todo-comments-nvim
    asyncrun-vim
    # # neorg
    friendly-snippets
    nvim-bqf


  ];

  extraPackages = with pkgs; [
    # language servers, etc.
    lua-language-server
    libclang
    cmake
    gnumake
    git
    gcc
    gfortran
    nil # nix LSP
    libxml2
    R
    nnn
    nerd-fonts.ubuntu
    nerd-fonts.ubuntu-mono
    rPackages.callr
    rPackages.languageserver

  ];
in {
  # This is the neovim derivation
  # returned by the overlay
  nvim-pkg = mkNeovim {
    plugins = all-plugins;
    inherit extraPackages;
  };

  # This is meant to be used within a devshell.
  # Instead of loading the lua Neovim configuration from
  # the Nix store, it is loaded from $XDG_CONFIG_HOME/nvim-dev
  nvim-dev = mkNeovim {
    plugins = all-plugins;
    inherit extraPackages;
    appName = "nvim-dev";
    wrapRc = false;
  };

  # This can be symlinked in the devShell's shellHook
  nvim-luarc-json = final.mk-luarc-json {
    plugins = all-plugins;
  };

  # You can add as many derivations as you like.
  # Use `ignoreConfigRegexes` to filter out config
  # files you would not like to include.
  #
  # For example:
  #
  # nvim-pkg-no-telescope = mkNeovim {
  #   plugins = [];
  #   ignoreConfigRegexes = [
  #     "^plugin/telescope.lua"
  #     "^ftplugin/.*.lua"
  #   ];
  #   inherit extraPackages;
  # };
}
