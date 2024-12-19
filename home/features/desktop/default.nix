{pkgs, ...}: {
  imports = [
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
  ];

  home.packages = with pkgs; [
    mullvad
    gparted
    vlc
    obs-studio
  ];
}
