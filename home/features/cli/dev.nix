{ config, lib, pkgs, ... }:
with lib; let
  cfg = config.features.cli.dev;
 in {
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
      # Common configurations for all machines
      home.packages = with pkgs; [
        # Version Control
        git
        git-lfs
        # Build tools
        gcc
        gnumake
        cmake
        # Node.js and TypeScript
        nodejs
        nodePackages.npm
        nodePackages.typescript
        nodePackages.ts-node
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
        bison
        flex
        graphviz
        stylua
        lazygit
        unzip
        go
        lua
        luarocks
        python3
        python3Packages.pip
        tree-sitter

      ];
      programs.git.enable = true;
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