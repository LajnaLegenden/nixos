{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.features.desktop.gammastep;
in
{
  options.features.desktop.gammastep.enable = mkEnableOption "use gammastep";

  config = mkIf cfg.enable {
  services.gammastep = {
    enable = true;
    provider = "manual";
    latitude = 55.580448;
    longitude = 13.003605;
  };
  };
}
