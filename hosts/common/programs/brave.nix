{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    brave
  ];
  # Brave policies
  environment.etc."brave/policies/managed/brave_debullshitinator-policies.json" = {
    source = pkgs.fetchurl {
      url = "https://github.com/MulesGaming/brave-debullshitinator/releases/download/1.0.4/brave_debullshitinator-policies.json";
      sha256 = "sha256-cS2QCTly8PWO0xamuliJLKqg5vTRn6WPvRXUfzxtbpc="; # You'll need to replace this with the actual hash
    };
  };
}
