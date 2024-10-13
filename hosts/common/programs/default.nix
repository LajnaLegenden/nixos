{ pkgs, config, libs, ... }:

{
imports = [
  ./thunar.nix
  ./stream-deck.nix
];

  environment.systemPackages = with pkgs; [ 
    pywal
    swww
    pywalfox-native
   ];

}