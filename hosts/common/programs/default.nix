{ pkgs, config, libs, ... }:

{
imports = [
  ./thunar.nix
  ./docker.nix
  ./tailscale.nix
  ./virtualbox.nix
  ./zsa.nix
];

  environment.systemPackages = with pkgs; [ 
    pywal
    swww
    pywalfox-native
    libnotify
    hyprlock
    networkmanager_dmenu
    networkmanagerapplet
    power-profiles-daemon
   ];

  

}
