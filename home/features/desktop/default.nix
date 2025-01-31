{ pkgs, ... }:
{
  imports = [
    ./kde-connect.nix
    ./wayland.nix
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
    ./kdeconnect.nix
    ./theme.nix
  ];

  home.packages = with pkgs; [
    mullvad
    gparted
    vlc
    obs-studio
  ];
}
