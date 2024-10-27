{ pkgs, config, libs, ... }:

{
imports = [
  ./thunar.nix
  ./stream-deck.nix
  ./docker.nix
];

  environment.systemPackages = with pkgs; [ 
    pywal
    swww
    pywalfox-native

    libnotify

    hyprlock

    networkmanager_dmenu
    networkmanagerapplet
   ];

  

}
