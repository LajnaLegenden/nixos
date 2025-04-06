{
  config,
  lib,
  ...
}:

{
  home.packages = with pkgs; [
    
    inputs.claude-desktop.packages.${system}.claude-desktop-with-fhs
  ];
}

