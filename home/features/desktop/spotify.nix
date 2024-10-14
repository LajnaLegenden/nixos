{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.spotify;
in {
  options.features.desktop.spotify.enable =
    mkEnableOption "install spotify";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
     spicetify-cli
    ];
  };
}
