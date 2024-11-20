{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.chrome;
in {
  options.features.desktop.chrome.enable =
    mkEnableOption "install chrome and its addons";

  config = mkIf cfg.enable {

  programs.chromium = {
      enable = true;
    };
  };
}
