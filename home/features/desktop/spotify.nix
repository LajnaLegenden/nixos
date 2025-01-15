{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.features.desktop.spotify;
in
{
  options.features.desktop.spotify.enable = mkEnableOption "install spotify";

  config = mkIf cfg.enable {

    home.file = {
      ".config/spicetify/config-xpui.ini".text = ''
        [Setting]
        spotify_path = /etc/profiles/per-user/lajna/spotify
      '';
    };

    home.packages = with pkgs; [
      spicetify-cli
      spotifywm
    ];
  };
}
