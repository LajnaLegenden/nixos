{ pkgs, ... }:
{
  imports = [
    ./wayland.nix
    ./office.nix
    ./hyprland.nix
    ./fonts.nix
    ./firefox.nix
    ./vesktop.nix
    ./slack.nix
    ./thunderbird.nix
    ./dunst.nix
    ./wallpaper.nix
    ./spotify.nix
    ./clickup.nix
    ./chrome.nix
    ./obsidian.nix
    ./kde-connect.nix
    ./theme.nix
    ./gammastep.nix
    ./claude.nix
  ];

  home.packages = with pkgs; [
    mullvad
    gparted
    vlc
    obs-studio
  ];
}
