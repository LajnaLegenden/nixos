{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.features.desktop.wayland;
in
{
  options.features.desktop.wayland.enable = mkEnableOption "wayland extra tools and config";

  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;
    };

    gtk.enable = true;

    home.packages = with pkgs; [
      grim
      hyprlock
      qt6.qtwayland
      slurp
      waypipe
      wf-recorder
      wl-mirror
      wl-clipboard
      cliphist
      wlogout
      wtype
      ydotool
      wttrbar
      hypridle
      ulauncher
      albert
      dunst
      rofi
      pywal
      matugen
      glib
      playerctl
    ];
  };
}
