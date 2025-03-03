{
  pkgs,
  config,
  libs,
  ...
}:

{
  imports = [
    ./thunar.nix
    ./docker.nix
    ./tailscale.nix
    ./zsa.nix
    ./lmstudio.nix
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
