{
  pkgs,
  config,
  libs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
  peazip
  unzip
  zip
  ];
}
