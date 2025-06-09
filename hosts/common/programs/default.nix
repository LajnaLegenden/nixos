{
  pkgs,
  config,
  libs,
  ...
}:

{
  imports = [
    ./rustdesk.nix
    ./thunar.nix
    ./docker.nix
    ./tailscale.nix
    ./zsa.nix
    ./lmstudio.nix
    ./zip.nix
    ./brave.nix
    ./1pass.nix
    ./nix-ld.nix
  ];

  environment.systemPackages = with pkgs; [
    swww
    pywalfox-native
    libnotify
    hyprlock
    networkmanager_dmenu
    networkmanagerapplet
    power-profiles-daemon
    python2Full
  ];

}
