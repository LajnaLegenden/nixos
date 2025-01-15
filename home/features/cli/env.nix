{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.features.cli.env;
in
{
  options.features.cli.env.enable = mkEnableOption "enable extended env configuration";

  config = mkIf cfg.enable {
    home.file.".npm-global".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.npm-global";

    home.sessionPath = [
      "$HOME/.npm-global/bin"
    ];

    home.sessionVariables = {
      NPM_CONFIG_PREFIX = "$HOME/.npm-global";
    };

    # Optionally, create the directory if it doesn't exist
    home.activation.createNpmGlobal = config.lib.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "$HOME/.npm-global"
    '';
  };
}
