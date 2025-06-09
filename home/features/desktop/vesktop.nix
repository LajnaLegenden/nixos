{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.features.desktop.vesktop;
in
{
  options.features.desktop.vesktop.enable = mkEnableOption "install vesktop";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      vesktop
      discord
    ];
  };
}
