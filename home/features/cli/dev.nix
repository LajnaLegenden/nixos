{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  cfg = config.features.cli.dev;
in
{
  options.features.cli.dev = {
    enable = mkEnableOption "enable extended dev configuration";
    isWorkMachine = mkOption {
      type = types.bool;
      default = false;
      description = "Whether this is a work machine";
    };
  };
  config = mkIf cfg.enable (mkMerge [
    {
      home.sessionPath = [
        "$HOME/bin"
        "$HOME/.npm-global"
      ]; # Common configurations for all machines

      # Session variables
      home.sessionVariables = {
        NIX_PKGS_ALLOW_UNFREE = 1;
      };

      home.packages = with pkgs; [
        neovim
        # Version Control
        git
        git-lfs
        # Build tools
        gcc
        gnumake
        cmake
        # Node.js and TypeScript
        nodejs_20
        nodePackages.typescript
        nodePackages.ts-node
        node-gyp
        nodePackages.node-gyp-build
        # Bun
        bun
        # Package managers
        corepack
        # Linters and formatters
        eslint
        nodePackages.prettier
        # Debugging tools
        gdb
        # System tools
        htop
        ncdu
        # Network tools
        curl
        wget
        # Documentation
        man-pages
        gh
        tmux
        bison
        flex
        graphviz
        stylua
        lazygit
        unzip
        go
        lua
        cargo
        luarocks
        python3
        python3Packages.pip
        python312Packages.distutils
        nil
        zeal
        gitkraken
        clang-tools
        clangStdenv
        jetbrains.clion
        eslint_d
        nixfmt-rfc-style
        statix
        code-cursor
        mongodb-compass
        httpie-desktop
        delta
        lua-language-server
        vscode-langservers-extracted
        emmet-language-server
	vtsls
        go
        gopls
      ];
      programs.git = {
        enable = true;
        extraConfig = {
          core.pager = "delta";
          interactive.diffFilter = "delta --color-only";
          delta = {
            navigate = true;
            dark = true;
          };
          merge.conflictstyle = "zdiff3";
        };
      };
    }

    (mkIf cfg.isWorkMachine {
      # Work laptop specific configurations
      programs.git = {
        userName = "Linus Jansson"; # Replace with actual work name
        userEmail = "linus.jansson@mediatool.com"; # Replace with actual work email
        extraConfig = {
          core.editor = "nano";
        };
      };
    })

    (mkIf (!cfg.isWorkMachine) {
      # Default configurations for other machines
      programs.git = {
        userName = "LajnaLegenden";
        userEmail = "34426335+LajnaLegenden@users.noreply.github.com";
        extraConfig = {
          core.editor = "nano";
        };
      };
    })
  ]);
}
