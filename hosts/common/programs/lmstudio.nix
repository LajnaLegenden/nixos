{
  pkgs,
  config,
  libs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    lmstudio
  ];
  }
