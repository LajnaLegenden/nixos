{
  pkgs,
  config,
  libs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    peazip
    file-roller
    unzip
    zip
  ];
}
