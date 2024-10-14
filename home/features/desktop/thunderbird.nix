{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.thunderbird;
in {
  options.features.desktop.thunderbird.enable =
    mkEnableOption "install thunderbird";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
     thunderbird
    ];
  };
}
