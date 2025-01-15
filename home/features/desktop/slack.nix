{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.features.desktop.slack;
in
{
  options.features.desktop.slack.enable = mkEnableOption "install slack";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      slack
    ];
  };
}
