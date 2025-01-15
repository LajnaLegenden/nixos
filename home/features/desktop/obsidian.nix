{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.features.desktop.obsidian;
in
{
  options.features.desktop.obsidian.enable = mkEnableOption "install obsidian and its addons";

  config = mkIf cfg.enable {
    home.packages = [ pkgs.obsidian ];
  };

}
