
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.features.desktop.connect;
in
{
  options.features.desktop.connect.enable = mkEnableOption "install kde connect";

  config = mkIf cfg.enable {
services.kdeconnect.enable = true;

  };
}
