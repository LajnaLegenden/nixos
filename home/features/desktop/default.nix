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
  ];

  home.packages = with pkgs; [
    mullvad
    gparted
  ];
}
