{ config, lib, pkgs, ... }:

with lib; let
  cfg = config.features.cli.dev;
in {
  options.features.cli.dev = {
    enable = mkEnableOption "enable extended dev configuration";
  };

  config = mkIf cfg.enable {
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
      pnpm
      
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

    ];

    programs.git = {
      enable = true;
      userName = "LajnaLegenden";
      userEmail = "34426335+LajnaLegenden@users.noreply.github.com";
      extraConfig = {
        core = {
          editor = "nano";  # Using nano as a simple default editor
        };
      };
    };
  };
}