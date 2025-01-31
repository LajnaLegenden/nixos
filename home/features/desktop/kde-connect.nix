
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
home-manager.users.username.services.kdeconnect.enable = true;

networking.firewall = rec {
  allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
  allowedUDPPortRanges = allowedTCPPortRanges;
};
  };
}
