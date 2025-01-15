{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.features.desktop.wallpaper;
in
{
  options.features.desktop.wallpaper.enable = mkEnableOption "install wallpaper";

  config = mkIf cfg.enable {

    home.file = {
      ".config/hypr/set-random-wallpaper.sh" = {
        source = ../../scripts/wallpaper.sh; # Path to your script file
        executable = true;
      };
    };

    # Ensure necessary packages are installed
    home.packages = with pkgs; [
      pywal
      swww
      pywalfox-native
    ];

    # Optional: Add Hyprland configuration
    wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = ''
        exec-once = ~/.config/hypr/set-random-wallpaper.sh
      '';
    };

  };
}
