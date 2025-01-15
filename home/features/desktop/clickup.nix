{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.features.desktop.clickup;
in
{
  options.features.desktop.clickup.enable = mkEnableOption "install clickup";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      clickup
    ];
  };
}
