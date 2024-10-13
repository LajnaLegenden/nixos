{pkgs, ...}: {
  imports = [
    ./wayland.nix
    ./hyprland.nix
    ./fonts.nix
    ./firefox.nix
  ];

  home.packages = with pkgs; [
    mullvad
  ];
}
